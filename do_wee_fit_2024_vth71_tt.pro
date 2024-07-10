pro do_wee_fit_2024_vth71_tt

  ; Refitting everything so sure of what has actually been done!
  ;
  ; Now with thick target
  ;
  ; 05-Jul-2024 IGH
  ; ----------------------------------------

  ; Want to use the older V7.1 version of CHIANTI in f_vth, to match sunkit-spex default 
  chianti_kev_common_load,contfile='chianti_cont_1_250_v71.sav',linefile='chianti_lines_1_10_v71.sav',/reload
  fit_mod='vth71+bpow'
  restgen,file='mf_fin_newel.genx',resin

  ; v_th+thick2
  ; v_th
  ; a[0] EM in 1e49 cm^-3
  ; a[1] T in keV
  ; a[2] Rel abundance => fixed 1
  ; thick2
  ; a[3] N 10e35
  ; a[4] index below break - vary
  ; a[5] break energy [keV] - fixed to max value
  ; a[6] index above the break - fixed/doesn't exist
  ; a[7] low energy cutoff [keV] - vary
  ; a[8] high energy cutoff [keV] - fixed

  nf=n_elements(resin.fpeak)

  resout_temp={fpeak:'',osx_p:fltarr(9),osx_perr:fltarr(9),$
    chisq:0.,fit_mod:fit_mod,fit_erange:fltarr(2)}
  resout=replicate(resout_temp,nf)

  tmk2kev=0.086164
  default, tolerance, 1e-4; old run 1e-4, 1e-3 is default
  default, max_iter, 50 ; old run did 50, 10 is default
  default, uncert, 0.0 ; old run did 0, 0.02 is default (more for high count rate)
  default, bk_order, 0
  default, fitstart,[1e-2,11.0*tmk2kev,1, 1e-1,  8.0, 1e3, 10.0, 10.0, 1e3]
  default, fitmin,  [1e-5,5.0*tmk2kev,1,  1e-2, 3.0, 1e0, 1.1, 7, 1e2]
  default, fitmax,  [1e2 ,30.*tmk2kev,1,  1e2, 13.0, 1e5, 20.0, 30.0, 1e7]

  for i=0,nf-1 do begin
    print,i, ' of ', nf

    btims=resin[i].bk_bf_tr
    ftims=resin[i].fpeak_tr

    set_logenv, 'OSPEX_NOINTERACTIVE', '1'
    o = ospex()
    o->set, spex_fit_manual=0, spex_fit_reverse=0, spex_fit_start_method='previous_int'
    o->set, spex_autoplot_enable=0, spex_fitcomp_plot_resid=0, spex_fit_progbar=0

    o->set, fit_function='vth+thick2'
    o-> set, fit_comp_spectrum= ['full', '']
    o-> set, fit_comp_model= ['chianti', '']

    o->set, spex_uncert=uncert
    o->set, mcurvefit_itmax=max_iter
    o->set, mcurvefit_tol=tolerance

    fname=break_time(resin[i].fpeak)
    stm=anytim(resin[i].fpeak,/ccsds,/trunc)
    yr=strmid(stm,0,4)
    mn=strmid(stm,5,2)
    outdir='fits/'+yr+'/'+mn+'/'

    o->set, spex_specfile= outdir+fname+'_spec_sum.fits'
    o->set, spex_drmfile= outdir+fname+'_srm_sum.fits'
    o->set, spex_fit_time_interval=ftims
    o->set,spex_bk_time_interval=btims
    o->set,spex_bk_order=bk_order
    o->set, fit_comp_minima=fitmin
    o->set, fit_comp_maxima=fitmax

    o->set, spex_erange=[4,8]
    o->set, fit_comp_free = [1,1,0,0,0,0,0,0,0]
    o->set, fit_comp_param=fitstart
    o->dofit

    bksub=o->getdata(class='spex_fitint',spex_units='flux')
    if datatype(bksub) eq 'STC' then nbk=n_elements(bksub.data)
    bad=30
    if datatype(bksub) eq 'STC' then $
      bad=min(where(bksub.data lt 0.0, nbad)) > 30.
    engs=o->getaxis(/ct_energy,/edges_2)
    uppereng=engs[0,bad]

    o->set, spex_erange=[9,uppereng]
    o->set, fit_comp_free=[0,0,0,1,1,0,0,1,0]
    o->dofit
    o->set, spex_erange=[4,uppereng]
    o->set, fit_comp_free=[1,1,0,1,1,0,0,1,0]
    o->dofit

    p=o-> get(/spex_summ_params)
    p[1]=p[1]/tmk2kev
    perr=o -> get(/spex_summ_sigmas)

    resout[i].fpeak=resin[i].fpeak
    resout[i].osx_p=p
    resout[i].osx_perr=perr
    resout[i].chisq=o->get(/spex_summ_chisq)
    resout[i].fit_erange=o->get(/spex_erange)

    if (i mod 50 eq 0) then savegen,file='wee_2024_vth71_tt.genx',resout
    ;    close,/all,/force
    ;    heap_gc
  endfor

  savegen,file='wee_2024_vth71_tt.genx',resout

  stop
end