pro check_nnpow_calc_loop

  ; Fitting a thick-target model with a bpow to check the parameters and the power calculation
  ;
  ; 9-Feb-2024 IGH
  ;-------------------

  ; Just use the old ones for now
  chianti_kev_common_load,contfile='chianti_cont_1_250_v52.sav',linefile='chianti_lines_1_10_v52.sav',/reload

  ; v_th+bpow
  ; v_th
  ; a[0] EM in 1e49 cm^-3
  ; a[1] T in keV
  ; a[2] Rel abundance => fixed 1
  ; bpow
  ; a[3] Norm at epivot -> powerlaw below break at 50 keV (ph/s/keV/cm^2)
  ; a[4] Negative power law index below the break => fixed 1.5
  ; a[5] break energy [keV]
  ; a[6] negative power law index above the break

  ; Based off the old ttb_multi.pro
  eres=1/3.
  ed=3.+findgen(27/eres+1)*eres
  nume=n_elements(ed)
  eed=get_edges(ed,/edges_2)
  em=get_edges(ed,/mean)

  restgen,file='srm_330',srm
  area=237.540
  eng_widths=replicate(eres,nume)
  set_logenv, 'OSPEX_NOINTERACTIVE', '1'
  o=ospex()
  o->set, spex_fit_manual=0, spex_fit_reverse=0, $
    spex_fit_start_method='previous_int'
  o->set, spex_autoplot_enable=0, spex_fitcomp_plot_resid=0,$
    spex_fit_progbar=0
  o->set, fit_function='bpow'
  o->set, spex_summ_uncert=0
  o->set, mcurvefit_itmax=100
  o->set, mcurvefit_tol=1e-5
  o -> set, spex_data_source = 'SPEX_USER_DATA'
  o -> set, spex_drmfile='srm_330.fits', spex_error_use_expected=0
  o->set, fit_comp_minima=[1e-10,1.1,2,1.5]
  o->set, fit_comp_maxima=[1e10,3.,20.,14.]
  fitstart=[1e-2,1.5,10.,5.]

  ndel=25;25
  nlc=25;20

  stc={N35:0.,del:0.,ec:0.,pow:0.,f1:0.,gam:0.,eb:0.,ipow_ec_nc:0.,ipow_dec_nc:0.}
  res=replicate(stc,ndel,nlc)

  tot_eflux=1
  delta=3+9*findgen(ndel)/(ndel-1.)
  pe_break=3200.
  delta2=delta
  lowcut=8+12*findgen(nlc)/(nlc-1.)
  highcut=pe_break

  for i=0, ndel-1 do begin

    for j=0, nlc-1 do begin

      print,delta[i],lowcut[j]

      res[i,j].del=delta[i]
      res[i,j].ec=lowcut[j]
      res[i,j].N35=tot_eflux
      N=tot_eflux*1d35
      del=delta[i]
      ec=lowcut[j]
      res[i,j].pow=1.6e-9 *N *(del-1)/(del-2)*ec

      thck_p=[tot_eflux,delta[i],pe_break,delta[i],lowcut[j],highcut]
      thick=f_thick(eed,thck_p)
      ct_thick=srm#thick*eres
      ctrate_thick=ct_thick*area*eres

      o -> set, spectrum = ctrate_thick, spex_ct_edges = eed
      o->set, spex_erange=minmax(ed)
      o->set, spex_intervals_tofit=0
      o->set, fit_comp_free=[1,0,1,1]
      o->set, fit_comp_param=fitstart
      o->dofit
      params=o -> get(/spex_summ_params)

      g2=params[3] ; or thck_p[3]-1
      eb=thck_p[4] ; use the known model Ec rather than fitted break params[2]
      f_50=params[0]
      g1=params[1]
      f_eb=f_50*(eb/50.)^(-1*g1)
      f_1=f_eb*eb^g2
      res[i,j].gam=g2
      res[i,j].eb=params[2]
      res[i,j].f1=f_1
      res[i,j].ipow_ec_nc=g2^2*(g2-1)*beta(g2-.5,1.5)*f_1*eb^(1-g2)
      g=del-1
      res[i,j].ipow_dec_nc=g^2*(g-1)*beta(g-.5,1.5)*f_1*eb^(1-g)

    endfor
  endfor
  
  savegen,file='nnpow_check',res

  stop
end
