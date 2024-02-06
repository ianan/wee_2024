pro checking_fvth_ch_files

  ; What are the properites of each of the CHIANTI files used by ospex?
  ;
  ; Also see https://github.com/ianan/fvth_stuff/blob/main/idl/make_new_ch_files_sunxspex.pro
  ;
  ; 05-Feb-2024 IGH
  ; ----------------

  ; Where main files located in sswidl
  chxdb= concat_dir(getenv('SSWDB_XRAY'),'chianti/')
  ;  ;  Default ospex ones
  ;  print,getenv('CHIANTI_CONT_FILE')
  ;  ; chianti_cont_01_250_unity_v901.geny
  ;  print,getenv('CHIANTI_LINES_FILE')
  ;  ;chianti_lines_07_12_unity_v901_t41.geny

  ;---------------------------
  ; All the lines files


  fname='../fvth_stuff/idl/chianti_lines_1_12_unity_v101_t41.geny'
  restgenx, zindex,  out, ion_info, file=fname
  print,'--------------------'
  print,fname
  print,'Size [MB]: ',(file_info(fname)).size/1028.^2
  print,out.version
  print,'logT: ', minmax(out.logt_isothermal), 'n_T: ', n_elements(out.logt_isothermal)
  print,'Wvl [A]: ', out.wvl_limits
  print,'Wvl [keV]: ', 12.398/out.wvl_limits
  print,'--------------------'

  fname=chxdb+getenv('CHIANTI_LINES_FILE')
  restgenx, zindex,  out, ion_info, file=fname
  print,'--------------------'
  print,fname
  print,'Size [MB]: ',(file_info(fname)).size/1028.^2
  print,out.version
  print,'logT: ', minmax(out.logt_isothermal), 'n_T: ', n_elements(out.logt_isothermal)
  print,'Wvl [A]: ', out.wvl_limits
  print,'Wvl [keV]: ', 12.398/out.wvl_limits
  print,'--------------------'

  fname=chxdb+'chianti_lines_1_10_v71.sav'
  restore,fname
  print,'--------------------'
  print,fname
  print,'Size [MB]: ',(file_info(fname)).size/1028.^2
  print,out.version
  print,'logT: ', minmax(out.logt_isothermal), 'n_T: ', n_elements(out.logt_isothermal)
  print,'Wvl [A]: ', out.wvl_limits
  print,'Wvl [keV]: ', 12.398/out.wvl_limits
  print,'--------------------'

  fname=chxdb+'chianti_lines_1_10_v52.sav'
  restore,fname
  print,'--------------------'
  print,fname
  print,'Size [MB]: ',(file_info(fname)).size/1028.^2
  print,out.version
  print,'logT: ', minmax(out.logt_isothermal), 'n_T: ', n_elements(out.logt_isothermal)
  print,'Wvl [A]: ', out.wvl_limits
  print,'Wvl [keV]: ', 12.398/out.wvl_limits
  print,'--------------------'

  ;---------------------------
  ; All the cont files

  fname='../fvth_stuff/idl/chianti_cont_1_250_unity_v101_t41.geny'
  restgenx, zindex, totcont, totcont_lo, $
    edge_str, ctemp, chianti_doc, file=fname
  print,'--------------------'
  print,fname
  print,'Size [MB]: ',(file_info(fname)).size/1028.^2
  print,chianti_doc.version
  print,'logT: ', minmax(alog10(ctemp)), 'n_T: ', n_elements(ctemp)
  print,'Wvl [A]: ', minmax(edge_str.wvl), 'n_W: ', n_elements(edge_str.wvl)
  print,'Wvl [keV]: ', edge_str.conversion/minmax(edge_str.wvl)
  print,'--------------------'

  fname=chxdb+getenv('CHIANTI_CONT_FILE')
  restgenx, zindex, totcont, totcont_lo, $
    edge_str, ctemp, chianti_doc, file=fname
  print,'--------------------'
  print,fname
  print,'Size [MB]: ',(file_info(fname)).size/1028.^2
  print,chianti_doc.version
  print,'logT: ', minmax(alog10(ctemp)), 'n_T: ', n_elements(ctemp)
  print,'Wvl [A]: ', minmax(edge_str.wvl), 'n_W: ', n_elements(edge_str.wvl)
  print,'Wvl [keV]: ', edge_str.conversion/minmax(edge_str.wvl)
  print,'--------------------'

  fname=chxdb+'chianti_cont_1_250_v71.sav'
  restore,fname
  print,'--------------------'
  print,fname
  print,'Size [MB]: ',(file_info(fname)).size/1028.^2
  print,chianti_doc.version
  print,'logT: ', minmax(alog10(ctemp)), 'n_T: ', n_elements(ctemp)
  print,'Wvl [A]: ', minmax(edge_str.wvl), 'n_W: ', n_elements(edge_str.wvl)
  print,'Wvl [keV]: ', edge_str.conversion/minmax(edge_str.wvl)
  print,'--------------------'

  fname=chxdb+'chianti_cont_1_250_v52.sav'
  restore,fname
  print,'--------------------'
  print,fname
  print,'Size [MB]: ',(file_info(fname)).size/1028.^2
  print,chianti_doc.version
  print,'logT: ', minmax(alog10(ctemp)), 'n_T: ', n_elements(ctemp)
  print,'Wvl [A]: ', minmax(edge_str.wvl), 'n_W: ', n_elements(edge_str.wvl)
  print,'Wvl [keV]: ', edge_str.conversion/minmax(edge_str.wvl)
  print,'--------------------'


  stop
end