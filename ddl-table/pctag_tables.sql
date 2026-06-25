-- pctag.billing definition

CREATE TABLE `billing` (
  `bl_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bl_date` datetime DEFAULT NULL,
  `bl_status` varchar(2) DEFAULT NULL,
  `bl_ctm_no` varchar(10) DEFAULT NULL,
  `bl_code` varchar(20) DEFAULT NULL,
  `bl_datefr` datetime DEFAULT NULL,
  `bl_dateto` datetime DEFAULT NULL,
  PRIMARY KEY (`bl_id`),
  KEY `billing_idx_bl_date` (`bl_date`),
  KEY `billing_idx_bl_status` (`bl_status`),
  KEY `billing_idx_bl_ctm_no` (`bl_ctm_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.checkincovid definition

CREATE TABLE `checkincovid` (
  `ccv_no` varchar(20) NOT NULL,
  `ccv_lsp_no` varchar(20) DEFAULT NULL,
  `ccv_isextraction` varchar(1) DEFAULT NULL,
  `ccv_extractiondatetime` datetime DEFAULT NULL,
  `ccv_isamplification` varchar(1) DEFAULT NULL,
  `ccv_amplificationdatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`ccv_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.config definition

CREATE TABLE `config` (
  `cf_no` varchar(1) NOT NULL,
  `cf_isautologout` varchar(1) DEFAULT NULL,
  `cf_autologoutminute` int(11) DEFAULT NULL,
  `cf_expireusers` int(11) DEFAULT NULL,
  `cf_tatwarningminute` int(11) DEFAULT NULL,
  `cf_tatwarninghour` int(11) DEFAULT NULL,
  `cf_tatwarningday` int(11) DEFAULT NULL,
  `cf_navisionurl` varchar(1000) DEFAULT NULL,
  `cf_navisionuser` varchar(100) DEFAULT NULL,
  `cf_navisionpassword` varchar(100) DEFAULT NULL,
  `cf_version` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`cf_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.critical definition

CREATE TABLE `critical` (
  `ctc_no` varchar(20) NOT NULL,
  `ctc_lrq_no` varchar(20) DEFAULT NULL,
  `ctc_ctm_no` varchar(10) DEFAULT NULL,
  `ctc_type` varchar(1) DEFAULT NULL,
  `ctc_receivename` varchar(100) DEFAULT NULL,
  `ctc_comment` varchar(1000) DEFAULT NULL,
  `ctc_reportby` varchar(10) DEFAULT NULL,
  `ctc_reportdatetime` datetime DEFAULT NULL,
  `ctc_recordcreateby` varchar(10) DEFAULT NULL,
  `ctc_recordcreatedatetime` datetime DEFAULT NULL,
  `ctc_recordupdateby` varchar(10) DEFAULT NULL,
  `ctc_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`ctc_no`),
  KEY `idx_critical_ctc_lrq_no` (`ctc_lrq_no`),
  KEY `idx_critical_ctc_ctm_no` (`ctc_ctm_no`),
  KEY `idx_critical_ctc_reportby` (`ctc_reportby`),
  KEY `idx_critical_ctc_reportdatetime` (`ctc_reportdatetime`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.customer definition

CREATE TABLE `customer` (
  `ctm_no` varchar(10) NOT NULL,
  `ctm_name` varchar(100) DEFAULT NULL,
  `ctm_engname` varchar(100) DEFAULT NULL,
  `ctm_companyname` varchar(100) DEFAULT NULL,
  `ctm_barcodename` varchar(100) DEFAULT NULL,
  `ctm_interfacecode` varchar(50) DEFAULT NULL,
  `ctm_colabcode` varchar(50) DEFAULT NULL,
  `ctm_address` varchar(1000) DEFAULT NULL,
  `ctm_phone` varchar(100) DEFAULT NULL,
  `ctm_contactname` varchar(100) DEFAULT NULL,
  `ctm_contactphone` varchar(100) DEFAULT NULL,
  `ctm_email` varchar(100) DEFAULT NULL,
  `ctm_accountday` int(11) DEFAULT NULL,
  `ctm_grouprightsname` varchar(100) DEFAULT NULL,
  `ctm_printresulttype` varchar(1) DEFAULT NULL,
  `ctm_rrs_no` varchar(10) DEFAULT NULL,
  `ctm_rrs_eng_no` varchar(10) DEFAULT NULL,
  `ctm_rrs_object_no` varchar(10) DEFAULT NULL,
  `ctm_rrs_objecteng_no` varchar(10) DEFAULT NULL,
  `ctm_rcc_hardcopy_no` varchar(10) DEFAULT NULL,
  `ctm_rcc_email_no` varchar(10) DEFAULT NULL,
  `ctm_r_no` varchar(10) DEFAULT NULL,
  `ctm_isapproveprint` varchar(1) DEFAULT NULL,
  `ctm_copiesprint` int(11) DEFAULT NULL,
  `ctm_isprintalldata` varchar(1) DEFAULT NULL,
  `ctm_issignature` varchar(1) DEFAULT NULL,
  `ctm_isrequest` varchar(1) DEFAULT NULL,
  `ctm_isd2d` varchar(1) DEFAULT NULL,
  `ctm_iswebrequest` varchar(1) DEFAULT NULL,
  `ctm_otpemail` varchar(100) DEFAULT NULL,
  `ctm_note` varchar(1000) DEFAULT NULL,
  `ctm_secretnote` varchar(1000) DEFAULT NULL,
  `ctm_recordcreateby` varchar(10) DEFAULT NULL,
  `ctm_recordcreatedatetime` datetime DEFAULT NULL,
  `ctm_recordupdateby` varchar(10) DEFAULT NULL,
  `ctm_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`ctm_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.customergroup definition

CREATE TABLE `customergroup` (
  `cg_no` varchar(10) NOT NULL,
  `cg_name` varchar(100) DEFAULT NULL,
  `cg_recordcreateby` varchar(10) DEFAULT NULL,
  `cg_recordcreatedatetime` datetime DEFAULT NULL,
  `cg_recordupdateby` varchar(10) DEFAULT NULL,
  `cg_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`cg_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.customerreport definition

CREATE TABLE `customerreport` (
  `crp_no` varchar(20) NOT NULL,
  `crp_report` varchar(100) DEFAULT NULL,
  `crp_ctm_no` varchar(10) DEFAULT NULL,
  `crp_us_no` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`crp_no`),
  KEY `idx_customerreport_crp_report` (`crp_report`),
  KEY `idx_customerreport_crp_ctm_no` (`crp_ctm_no`),
  KEY `idx_customerreport_crp_us_no` (`crp_us_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.environment definition

CREATE TABLE `environment` (
  `evr_no` varchar(10) NOT NULL,
  `evr_us_no` varchar(10) DEFAULT NULL,
  `evr_application` varchar(50) DEFAULT NULL,
  `evr_form` varchar(50) DEFAULT NULL,
  `evr_grid` varchar(50) DEFAULT NULL,
  `evr_field` varchar(50) DEFAULT NULL,
  `evr_visible` varchar(1) DEFAULT NULL,
  `evr_index` int(11) DEFAULT NULL,
  `evr_width` int(11) DEFAULT NULL,
  `evr_recordcreatedatetime` datetime DEFAULT NULL,
  `evr_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`evr_no`),
  KEY `idx_environment_evr_us_no` (`evr_us_no`),
  KEY `idx_environment_evr_application` (`evr_application`),
  KEY `idx_environment_evr_form` (`evr_form`),
  KEY `idx_environment_evr_grid` (`evr_grid`),
  KEY `idx_environment_evr_field` (`evr_field`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.exceltest1 definition

CREATE TABLE `exceltest1` (
  `ผู้รับผิดชอบ` varchar(50) DEFAULT NULL,
  `Section` varchar(50) DEFAULT NULL,
  `Test Code` varchar(50) NOT NULL,
  `Test Name PCT` varchar(255) NOT NULL,
  `Test Name 1` varchar(255) DEFAULT NULL,
  `Test Name 2` varchar(255) DEFAULT NULL,
  `Test Name 3` varchar(255) DEFAULT NULL,
  `Test Name 4` varchar(255) DEFAULT NULL,
  `Test Name 5` varchar(255) DEFAULT NULL,
  `Test Report Name` varchar(100) DEFAULT NULL,
  `Barcode Name` varchar(100) DEFAULT NULL,
  `Test Method` varchar(255) DEFAULT NULL,
  `Parameter Method` varchar(255) DEFAULT NULL,
  `Active` varchar(50) DEFAULT NULL,
  `Instrument` varchar(50) DEFAULT NULL,
  `BOI` varchar(50) DEFAULT NULL,
  `เลขกรมบัญชีกลาง` varchar(50) DEFAULT NULL,
  `ชื่อกรมบัญชีกลาง` varchar(255) DEFAULT NULL,
  `ราคากรมบัญชีกลาง` varchar(50) DEFAULT NULL,
  `TMLT` varchar(50) DEFAULT NULL,
  `LOINC` varchar(50) DEFAULT NULL,
  `Cost` double(10,3) DEFAULT NULL,
  `Price` int(11) DEFAULT NULL,
  `Routine Time` int(11) DEFAULT NULL,
  `STAT Time` int(11) DEFAULT NULL,
  `ASAP Time` int(11) DEFAULT NULL,
  `Over Time` varchar(255) DEFAULT NULL,
  `Unit Time` varchar(50) DEFAULT NULL,
  `No.` varchar(20) DEFAULT NULL,
  `Parameter` varchar(100) DEFAULT NULL,
  `Report Name` varchar(100) DEFAULT NULL,
  `Report Name1` varchar(100) DEFAULT NULL,
  `Reference range` varchar(1000) DEFAULT NULL,
  `No.1` varchar(20) DEFAULT NULL,
  `Unit` varchar(100) DEFAULT NULL,
  `No.2` varchar(20) DEFAULT NULL,
  `Container` varchar(255) DEFAULT NULL,
  `Report Name2` varchar(100) DEFAULT NULL,
  `Barcode Name1` varchar(100) DEFAULT NULL,
  `Code` varchar(50) DEFAULT NULL,
  `No.3` varchar(20) DEFAULT NULL,
  `Specimen Type` varchar(500) DEFAULT NULL,
  `Volume (ml)` varchar(100) DEFAULT NULL,
  `Lab ส่งตรวจภายนอก` varchar(100) DEFAULT NULL,
  `Storage` varchar(100) DEFAULT NULL,
  `ISO 15189` varchar(100) DEFAULT NULL,
  `Schedule` varchar(255) DEFAULT NULL,
  `การปฏิเสธสิ่งส่งตรวจ` varchar(255) DEFAULT NULL,
  `Remark` varchar(255) DEFAULT NULL,
  `ข้อตกลงพิเศษ` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Test Code`,`Test Name PCT`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.export definition

CREATE TABLE `export` (
  `ep_no` varchar(20) NOT NULL,
  `ep_lrq_no` varchar(20) DEFAULT NULL,
  `ep_isexport` varchar(1) DEFAULT NULL,
  `ep_exportdatetime` datetime DEFAULT NULL,
  `ep_errorcount` int(11) DEFAULT NULL,
  `ep_message` varchar(100) DEFAULT NULL,
  `ep_recordcreatedatetime` datetime DEFAULT NULL,
  `ep_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`ep_no`),
  KEY `idx_export_ep_lrq_no` (`ep_lrq_no`),
  KEY `idx_export_ep_exportdatetime` (`ep_exportdatetime`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.exportcheckup definition

CREATE TABLE `exportcheckup` (
  `epc_no` varchar(20) NOT NULL,
  `epc_lrq_no` varchar(20) DEFAULT NULL,
  `epc_isexport` varchar(1) DEFAULT NULL,
  `epc_exportdatetime` datetime DEFAULT NULL,
  `epc_errorcount` int(11) DEFAULT NULL,
  `epc_message` varchar(100) DEFAULT NULL,
  `epc_recordcreatedatetime` datetime DEFAULT NULL,
  `epc_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`epc_no`),
  KEY `idx_exportcheckup_epc_lrq_no` (`epc_lrq_no`),
  KEY `idx_exportcheckup_epc_exportdatetime` (`epc_exportdatetime`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.exportcolab definition

CREATE TABLE `exportcolab` (
  `epcl_no` varchar(20) NOT NULL,
  `epcl_lrq_no` varchar(20) DEFAULT NULL,
  `epcl_isexport` varchar(1) DEFAULT NULL,
  `epcl_exportdatetime` datetime DEFAULT NULL,
  `epcl_errorcount` int(11) DEFAULT NULL,
  `epcl_message` varchar(100) DEFAULT NULL,
  `epcl_recordcreatedatetime` datetime DEFAULT NULL,
  `epcl_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`epcl_no`),
  KEY `idx_exportcolab_epcl_lrq_no` (`epcl_lrq_no`),
  KEY `idx_exportcolab_epcl_exportdatetime` (`epcl_exportdatetime`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.exporthie definition

CREATE TABLE `exporthie` (
  `ehie_no` varchar(20) NOT NULL,
  `ehie_lrq_no` varchar(20) DEFAULT NULL,
  `ehie_isexport` varchar(1) DEFAULT NULL,
  `ehie_exportdatetime` datetime DEFAULT NULL,
  `ehie_errorcount` int(11) DEFAULT NULL,
  `ehie_message` varchar(100) DEFAULT NULL,
  `ehie_recordcreatedatetime` datetime DEFAULT NULL,
  `ehie_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`ehie_no`),
  KEY `idx_exporthie_ehie_lrq_no` (`ehie_lrq_no`),
  KEY `idx_exporthie_ehie_exportdatetime` (`ehie_exportdatetime`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.exportlastresult definition

CREATE TABLE `exportlastresult` (
  `elr_no` varchar(20) NOT NULL,
  `elr_lrq_no` varchar(20) DEFAULT NULL,
  `elr_isexport` varchar(1) DEFAULT NULL,
  `elr_exportdatetime` datetime DEFAULT NULL,
  `elr_errorcount` int(11) DEFAULT NULL,
  `elr_recordcreatedatetime` datetime DEFAULT NULL,
  `elr_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`elr_no`),
  KEY `idx_exportlastresult_elr_lrq_no` (`elr_lrq_no`),
  KEY `idx_exportlastresult_elr_exportdatetime` (`elr_exportdatetime`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.exportline definition

CREATE TABLE `exportline` (
  `epl_no` varchar(20) NOT NULL,
  `epl_lrq_no` varchar(20) DEFAULT NULL,
  `epl_isexport` varchar(1) DEFAULT NULL,
  `epl_exportdatetime` datetime DEFAULT NULL,
  `epl_errorcount` int(11) DEFAULT NULL,
  `epl_status` varchar(1) DEFAULT NULL,
  `epl_message` varchar(100) DEFAULT NULL,
  `epl_recordcreatedatetime` datetime DEFAULT NULL,
  `epl_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`epl_no`),
  KEY `idx_exportline_epl_lrq_no` (`epl_lrq_no`),
  KEY `idx_exportline_epl_exportdatetime` (`epl_exportdatetime`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.exportnapplus definition

CREATE TABLE `exportnapplus` (
  `epnp_no` varchar(20) NOT NULL,
  `epnp_lrq_no` varchar(20) DEFAULT NULL,
  `epnp_isexport` varchar(1) DEFAULT NULL,
  `epnp_exportdatetime` datetime DEFAULT NULL,
  `epnp_errorcount` int(11) DEFAULT NULL,
  `epnp_message` varchar(100) DEFAULT NULL,
  `epnp_recordcreatedatetime` datetime DEFAULT NULL,
  `epnp_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`epnp_no`),
  KEY `idx_exportnapplus_epnp_lrq_no` (`epnp_lrq_no`),
  KEY `idx_exportnapplus_epnp_exportdatetime` (`epnp_exportdatetime`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.exportstatus definition

CREATE TABLE `exportstatus` (
  `eps_no` varchar(20) NOT NULL,
  `eps_lrq_no` varchar(20) DEFAULT NULL,
  `eps_isexport` varchar(1) DEFAULT NULL,
  `eps_exportdatetime` datetime DEFAULT NULL,
  `eps_errorcount` int(11) DEFAULT NULL,
  `eps_recordcreatedatetime` datetime DEFAULT NULL,
  `eps_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`eps_no`),
  KEY `idx_exportstatus_eps_lrq_no` (`eps_lrq_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.fileupgrade definition

CREATE TABLE `fileupgrade` (
  `fug_no` varchar(10) NOT NULL,
  `fug_name` varchar(100) DEFAULT NULL,
  `fug_folder` varchar(100) DEFAULT NULL,
  `fug_type` varchar(5) DEFAULT NULL,
  `fug_version` varchar(30) DEFAULT NULL,
  `fug_file` longblob DEFAULT NULL,
  PRIMARY KEY (`fug_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.formula definition

CREATE TABLE `formula` (
  `fml_no` varchar(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.grade definition

CREATE TABLE `grade` (
  `g_no` varchar(10) NOT NULL,
  `g_name` varchar(100) DEFAULT NULL,
  `g_recordcreateby` varchar(10) DEFAULT NULL,
  `g_recordcreatedatetime` datetime DEFAULT NULL,
  `g_recordupdateby` varchar(10) DEFAULT NULL,
  `g_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`g_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.incident definition

CREATE TABLE `incident` (
  `icd_no` varchar(10) NOT NULL,
  `icd_name` varchar(100) DEFAULT NULL,
  `icd_sort` int(11) DEFAULT NULL,
  `icd_recordcreateby` varchar(10) DEFAULT NULL,
  `icd_recordcreatedatetime` datetime DEFAULT NULL,
  `icd_recordupdateby` varchar(10) DEFAULT NULL,
  `icd_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`icd_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.instrument definition

CREATE TABLE `instrument` (
  `itm_no` varchar(10) NOT NULL,
  `itm_name` varchar(100) DEFAULT NULL,
  `itm_dealer` varchar(100) DEFAULT NULL,
  `itm_resulttype` varchar(1) DEFAULT NULL,
  `itm_counttype` varchar(1) DEFAULT NULL,
  `itm_filebarcode` varchar(100) DEFAULT NULL,
  `itm_colabcode` varchar(50) DEFAULT NULL,
  `itm_recordcreateby` varchar(10) DEFAULT NULL,
  `itm_recordcreatedatetime` datetime DEFAULT NULL,
  `itm_recordupdateby` varchar(10) DEFAULT NULL,
  `itm_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`itm_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.instrumentdata definition

CREATE TABLE `instrumentdata` (
  `id_no` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_lrs_no` varchar(20) DEFAULT NULL,
  `id_lt_no` varchar(20) DEFAULT NULL,
  `id_lsp_no` varchar(20) DEFAULT NULL,
  `id_lrq_no` varchar(20) DEFAULT NULL,
  `id_itm_no` varchar(10) DEFAULT NULL,
  `id_barcodeno` varchar(30) DEFAULT NULL,
  `id_t_no` varchar(10) DEFAULT NULL,
  `id_prm_no` varchar(10) DEFAULT NULL,
  `id_interfacecode` varchar(50) DEFAULT NULL,
  `id_analysetype` varchar(1) DEFAULT NULL,
  `id_result` varchar(1000) DEFAULT NULL,
  `id_status` varchar(1) DEFAULT NULL,
  `id_seqno` varchar(20) DEFAULT NULL,
  `id_rackno` varchar(20) DEFAULT NULL,
  `id_position` varchar(20) DEFAULT NULL,
  `id_resultdatetime` datetime DEFAULT NULL,
  `id_recordcreatedatetime` datetime DEFAULT NULL,
  `id_recordupdateby` varchar(10) DEFAULT NULL,
  `id_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`id_no`),
  KEY `idx_instrumentdata_id_lrs_no` (`id_lrs_no`),
  KEY `idx_instrumentdata_id_lt_no` (`id_lt_no`),
  KEY `idx_instrumentdata_id_lsp_no` (`id_lsp_no`),
  KEY `idx_instrumentdata_id_lrq_no` (`id_lrq_no`),
  KEY `idx_instrumentdata_id_itm_no` (`id_itm_no`),
  KEY `idx_instrumentdata_id_barcodeno` (`id_barcodeno`),
  KEY `idx_instrumentdata_id_t_no` (`id_t_no`),
  KEY `idx_instrumentdata_id_prm_no` (`id_prm_no`),
  KEY `idx_instrumentdata_id_seqno` (`id_seqno`),
  KEY `idx_instrumentdata_id_rackno` (`id_rackno`),
  KEY `idx_instrumentdata_id_position` (`id_position`),
  KEY `idx_instrumentdata_id_resultdatetime` (`id_resultdatetime`)
) ENGINE=InnoDB AUTO_INCREMENT=24335091 DEFAULT CHARSET=tis620;


-- pctag.instrumentlabresult definition

CREATE TABLE `instrumentlabresult` (
  `ilr_no` varchar(20) NOT NULL,
  `ilr_itm_no` varchar(10) DEFAULT NULL,
  `ilr_us_no` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`ilr_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.lab definition

CREATE TABLE `lab` (
  `l_no` varchar(10) NOT NULL,
  `l_name` varchar(100) DEFAULT NULL,
  `l_reportname` varchar(100) DEFAULT NULL,
  `l_barcodename` varchar(100) DEFAULT NULL,
  `l_address` varchar(1000) DEFAULT NULL,
  `l_phone` varchar(100) DEFAULT NULL,
  `l_fax` varchar(100) DEFAULT NULL,
  `l_contactname` varchar(100) DEFAULT NULL,
  `l_contactphone` varchar(100) DEFAULT NULL,
  `l_isinlab` varchar(1) DEFAULT NULL,
  `l_rcl_no` varchar(10) DEFAULT NULL,
  `l_recordcreateby` varchar(10) DEFAULT NULL,
  `l_recordcreatedatetime` datetime DEFAULT NULL,
  `l_recordupdateby` varchar(10) DEFAULT NULL,
  `l_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`l_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.labreport definition

CREATE TABLE `labreport` (
  `lrp_no` varchar(20) NOT NULL,
  `lrp_report` varchar(100) DEFAULT NULL,
  `lrp_l_no` varchar(10) DEFAULT NULL,
  `lrp_us_no` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`lrp_no`),
  KEY `idx_labreport_lrp_report` (`lrp_report`),
  KEY `idx_labreport_lrp_l_no` (`lrp_l_no`),
  KEY `idx_labreport_lrp_us_no` (`lrp_us_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.lastresult definition

CREATE TABLE `lastresult` (
  `lrs_no` varchar(20) NOT NULL,
  `lrs_pt_no` varchar(20) DEFAULT NULL,
  `lrs_t_no` varchar(10) DEFAULT NULL,
  `lrs_prm_no` varchar(10) DEFAULT NULL,
  `lrs_lrsno1` varchar(20) DEFAULT NULL,
  `lrs_lastresult1` varchar(1000) DEFAULT NULL,
  `lrs_lastresult1datetime` varchar(30) DEFAULT NULL,
  `lrs_lrsno2` varchar(20) DEFAULT NULL,
  `lrs_lastresult2` varchar(1000) DEFAULT NULL,
  `lrs_lastresult2datetime` varchar(30) DEFAULT NULL,
  `lrs_lrsno3` varchar(20) DEFAULT NULL,
  `lrs_lastresult3` varchar(1000) DEFAULT NULL,
  `lrs_lastresult3datetime` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`lrs_no`),
  KEY `idx_lastresult_lrs_pt_no` (`lrs_pt_no`),
  KEY `idx_lastresult_lrs_t_no` (`lrs_t_no`),
  KEY `idx_lastresult_lrs_prm_no` (`lrs_prm_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.log definition

CREATE TABLE `log` (
  `l_no` bigint(20) NOT NULL AUTO_INCREMENT,
  `l_lrq_no` varchar(20) DEFAULT NULL,
  `l_event` varchar(100) DEFAULT NULL,
  `l_detail` varchar(5000) DEFAULT NULL,
  `l_comment` varchar(1000) DEFAULT NULL,
  `l_program` varchar(100) DEFAULT NULL,
  `l_location` varchar(100) DEFAULT NULL,
  `l_logby` varchar(100) DEFAULT NULL,
  `l_logdatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`l_no`),
  KEY `idx_log_l_lrq_no` (`l_lrq_no`),
  KEY `idx_log_l_logby` (`l_logby`),
  KEY `idx_log_l_logdatetime` (`l_logdatetime`)
) ENGINE=InnoDB AUTO_INCREMENT=31756425 DEFAULT CHARSET=tis620;


-- pctag.nappluslabtype definition

CREATE TABLE `nappluslabtype` (
  `nplt_no` varchar(10) NOT NULL,
  `nplt_name` varchar(100) DEFAULT NULL,
  `nplt_online` varchar(30) DEFAULT NULL,
  `nplt_isidcard` varchar(1) DEFAULT NULL,
  `nplt_isnap` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`nplt_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.objective definition

CREATE TABLE `objective` (
  `ojt_no` varchar(10) NOT NULL,
  `ojt_name` varchar(100) DEFAULT NULL,
  `ojt_colabcode` varchar(50) DEFAULT NULL,
  `ojt_recordcreateby` varchar(10) DEFAULT NULL,
  `ojt_recordcreatedatetime` datetime DEFAULT NULL,
  `ojt_recordupdateby` varchar(10) DEFAULT NULL,
  `ojt_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`ojt_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.picturepaint definition

CREATE TABLE `picturepaint` (
  `pp_no` varchar(10) NOT NULL,
  `pp_picture` longblob DEFAULT NULL,
  PRIMARY KEY (`pp_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.prefixclient definition

CREATE TABLE `prefixclient` (
  `pc_no` varchar(10) NOT NULL,
  `pc_computername` varchar(100) DEFAULT NULL,
  `pc_prefix` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`pc_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.profile definition

CREATE TABLE `profile` (
  `pf_no` varchar(10) NOT NULL,
  `pf_name` varchar(100) DEFAULT NULL,
  `pf_pricetype` varchar(1) DEFAULT NULL,
  `pf_accountcode` varchar(50) DEFAULT NULL,
  `pf_cost` decimal(12,4) DEFAULT NULL,
  `pf_price` decimal(12,4) DEFAULT NULL,
  `pf_recordcreateby` varchar(10) DEFAULT NULL,
  `pf_recordcreatedatetime` datetime DEFAULT NULL,
  `pf_recordupdateby` varchar(10) DEFAULT NULL,
  `pf_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`pf_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.reject definition

CREATE TABLE `reject` (
  `rj_no` varchar(10) NOT NULL,
  `rj_name` varchar(100) DEFAULT NULL,
  `rj_sort` int(11) DEFAULT NULL,
  `rj_recordcreateby` varchar(10) DEFAULT NULL,
  `rj_recordcreatedatetime` datetime DEFAULT NULL,
  `rj_recordupdateby` varchar(10) DEFAULT NULL,
  `rj_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`rj_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.reportbacteriasheet definition

CREATE TABLE `reportbacteriasheet` (
  `rbs_no` varchar(10) NOT NULL,
  `rbs_name` varchar(100) DEFAULT NULL,
  `rbs_recordcreateby` varchar(10) DEFAULT NULL,
  `rbs_recordcreatedatetime` datetime DEFAULT NULL,
  `rbs_recordupdateby` varchar(10) DEFAULT NULL,
  `rbs_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`rbs_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.reportcoversheetcustomer definition

CREATE TABLE `reportcoversheetcustomer` (
  `rcc_no` varchar(10) NOT NULL,
  `rcc_name` varchar(100) DEFAULT NULL,
  `rcc_recordcreateby` varchar(10) DEFAULT NULL,
  `rcc_recordcreatedatetime` datetime DEFAULT NULL,
  `rcc_recordupdateby` varchar(10) DEFAULT NULL,
  `rcc_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`rcc_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.reportcoversheetlab definition

CREATE TABLE `reportcoversheetlab` (
  `rcl_no` varchar(10) NOT NULL,
  `rcl_name` varchar(100) DEFAULT NULL,
  `rcl_recordcreateby` varchar(10) DEFAULT NULL,
  `rcl_recordcreatedatetime` datetime DEFAULT NULL,
  `rcl_recordupdateby` varchar(10) DEFAULT NULL,
  `rcl_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`rcl_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.reportoutlabsheet definition

CREATE TABLE `reportoutlabsheet` (
  `ros_no` varchar(10) NOT NULL,
  `ros_name` varchar(100) DEFAULT NULL,
  `ros_recordcreateby` varchar(10) DEFAULT NULL,
  `ros_recordcreatedatetime` datetime DEFAULT NULL,
  `ros_recordupdateby` varchar(10) DEFAULT NULL,
  `ros_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`ros_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.reportresult definition

CREATE TABLE `reportresult` (
  `rrs_no` varchar(10) NOT NULL,
  `rrs_name` varchar(100) DEFAULT NULL,
  `rrs_pagetype` varchar(1) DEFAULT NULL,
  `rrs_recordcreateby` varchar(10) DEFAULT NULL,
  `rrs_recordcreatedatetime` datetime DEFAULT NULL,
  `rrs_recordupdateby` varchar(10) DEFAULT NULL,
  `rrs_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`rrs_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.reportworksheet definition

CREATE TABLE `reportworksheet` (
  `rws_no` varchar(10) NOT NULL,
  `rws_name` varchar(100) DEFAULT NULL,
  `rws_reporttype` varchar(1) DEFAULT NULL,
  `rws_recordcreateby` varchar(10) DEFAULT NULL,
  `rws_recordcreatedatetime` datetime DEFAULT NULL,
  `rws_recordupdateby` varchar(10) DEFAULT NULL,
  `rws_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`rws_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.`result` definition

CREATE TABLE `result` (
  `rs_no` varchar(10) NOT NULL,
  `rs_name` varchar(500) DEFAULT NULL,
  `rs_recordcreateby` varchar(10) DEFAULT NULL,
  `rs_recordcreatedatetime` datetime DEFAULT NULL,
  `rs_recordupdateby` varchar(10) DEFAULT NULL,
  `rs_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`rs_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.`section` definition

CREATE TABLE `section` (
  `st_no` varchar(10) NOT NULL,
  `st_name` varchar(100) DEFAULT NULL,
  `st_reportname` varchar(100) DEFAULT NULL,
  `st_barcodename` varchar(100) DEFAULT NULL,
  `st_rrs_no` varchar(10) DEFAULT NULL,
  `st_rrs_eng_no` varchar(10) DEFAULT NULL,
  `st_rrs_object_no` varchar(10) DEFAULT NULL,
  `st_rrs_objecteng_no` varchar(10) DEFAULT NULL,
  `st_rws_no` varchar(10) DEFAULT NULL,
  `st_resultloadobject` varchar(200) DEFAULT NULL,
  `st_sort` int(11) DEFAULT NULL,
  `st_recordcreateby` varchar(10) DEFAULT NULL,
  `st_recordcreatedatetime` datetime DEFAULT NULL,
  `st_recordupdateby` varchar(10) DEFAULT NULL,
  `st_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`st_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.sectionreport definition

CREATE TABLE `sectionreport` (
  `srp_no` varchar(20) NOT NULL,
  `srp_report` varchar(100) DEFAULT NULL,
  `srp_st_no` varchar(10) DEFAULT NULL,
  `srp_us_no` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`srp_no`),
  KEY `idx_sectionreport_srp_report` (`srp_report`),
  KEY `idx_sectionreport_srp_st_no` (`srp_st_no`),
  KEY `idx_sectionreport_srp_us_no` (`srp_us_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.specimentype definition

CREATE TABLE `specimentype` (
  `spt_no` varchar(10) NOT NULL,
  `spt_name` varchar(100) DEFAULT NULL,
  `spt_reportname` varchar(100) DEFAULT NULL,
  `spt_recordcreateby` varchar(10) DEFAULT NULL,
  `spt_recordcreatedatetime` datetime DEFAULT NULL,
  `spt_recordupdateby` varchar(10) DEFAULT NULL,
  `spt_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`spt_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.staff definition

CREATE TABLE `staff` (
  `st_no` varchar(10) NOT NULL,
  `st_name` varchar(100) DEFAULT NULL,
  `st_licenceno` varchar(100) DEFAULT NULL,
  `st_position` varchar(100) DEFAULT NULL,
  `st_interfacecode` varchar(50) DEFAULT NULL,
  `st_recordcreateby` varchar(10) DEFAULT NULL,
  `st_recordcreatedatetime` datetime DEFAULT NULL,
  `st_recordupdateby` varchar(10) DEFAULT NULL,
  `st_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`st_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.systemrunno definition

CREATE TABLE `systemrunno` (
  `sr_name` varchar(50) DEFAULT NULL,
  `sr_value` varchar(50) DEFAULT NULL,
  `sr_date` datetime DEFAULT NULL,
  KEY `idx_systemrunno_sr_value` (`sr_value`),
  KEY `idx_systemrunno_sr_date` (`sr_date`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.systemvalue definition

CREATE TABLE `systemvalue` (
  `sv_no` varchar(50) NOT NULL,
  `sv_value` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`sv_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.tempholiday definition

CREATE TABLE `tempholiday` (
  `thd_date` datetime NOT NULL,
  PRIMARY KEY (`thd_date`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.templateexcel definition

CREATE TABLE `templateexcel` (
  `tec_no` varchar(10) NOT NULL,
  `tec_name` varchar(100) DEFAULT NULL,
  `tec_reportformat` varchar(1) DEFAULT NULL,
  `tec_excel` longblob DEFAULT NULL,
  `tec_recordcreateby` varchar(10) DEFAULT NULL,
  `tec_recordcreatedatetime` datetime DEFAULT NULL,
  `tec_recordupdateby` varchar(10) DEFAULT NULL,
  `tec_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`tec_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.testreport definition

CREATE TABLE `testreport` (
  `trp_no` varchar(20) NOT NULL,
  `trp_report` varchar(100) DEFAULT NULL,
  `trp_t_no` varchar(10) DEFAULT NULL,
  `trp_us_no` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`trp_no`),
  KEY `idx_testreport_trp_report` (`trp_report`),
  KEY `idx_testreport_trp_t_no` (`trp_t_no`),
  KEY `idx_testreport_trp_us_no` (`trp_us_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.unit definition

CREATE TABLE `unit` (
  `un_no` varchar(10) NOT NULL,
  `un_name` varchar(100) DEFAULT NULL,
  `un_recordcreateby` varchar(10) DEFAULT NULL,
  `un_recordcreatedatetime` datetime DEFAULT NULL,
  `un_recordupdateby` varchar(10) DEFAULT NULL,
  `un_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`un_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.userrights definition

CREATE TABLE `userrights` (
  `ur_no` varchar(10) NOT NULL,
  `ur_name` varchar(100) DEFAULT NULL,
  `ur_isconfig` varchar(1) DEFAULT NULL,
  `ur_isrequest` varchar(1) DEFAULT NULL,
  `ur_ischeckin` varchar(1) DEFAULT NULL,
  `ur_issendoutlab` varchar(1) DEFAULT NULL,
  `ur_isreceive` varchar(1) DEFAULT NULL,
  `ur_isresult` varchar(1) DEFAULT NULL,
  `ur_isreport` varchar(1) DEFAULT NULL,
  `ur_isapprove` varchar(1) DEFAULT NULL,
  `ur_ischeckout` varchar(1) DEFAULT NULL,
  `ur_isreview` varchar(1) DEFAULT NULL,
  `ur_iseditrequest` varchar(1) DEFAULT NULL,
  `ur_isunincident` varchar(1) DEFAULT NULL,
  `ur_isunreject` varchar(1) DEFAULT NULL,
  `ur_isuncheckin` varchar(1) DEFAULT NULL,
  `ur_isunreceive` varchar(1) DEFAULT NULL,
  `ur_isunreport` varchar(1) DEFAULT NULL,
  `ur_isunapprove` varchar(1) DEFAULT NULL,
  `ur_isunaccount` varchar(1) DEFAULT NULL,
  `ur_ischangecustomer` varchar(1) DEFAULT NULL,
  `ur_ischangespecimen` varchar(1) DEFAULT NULL,
  `ur_ischangelab` varchar(1) DEFAULT NULL,
  `ur_isdelete` varchar(1) DEFAULT NULL,
  `ur_isstatistic` varchar(1) DEFAULT NULL,
  `ur_iscost` varchar(1) DEFAULT NULL,
  `ur_isprice` varchar(1) DEFAULT NULL,
  `ur_isaccount` varchar(1) DEFAULT NULL,
  `ur_iswebuser` varchar(1) DEFAULT NULL,
  `ur_iswebbilling` varchar(1) DEFAULT NULL,
  `ur_issecretnote` varchar(1) DEFAULT NULL,
  `ur_recordcreateby` varchar(10) DEFAULT NULL,
  `ur_recordcreatedatetime` datetime DEFAULT NULL,
  `ur_recordupdateby` varchar(10) DEFAULT NULL,
  `ur_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`ur_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.version definition

CREATE TABLE `version` (
  `vs_no` varchar(1) NOT NULL,
  `vs_version` int(11) DEFAULT NULL,
  `vs_datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`vs_no`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.xlink_license definition

CREATE TABLE `xlink_license` (
  `li_no` int(11) NOT NULL AUTO_INCREMENT,
  `li_register_date` datetime DEFAULT NULL,
  `li_program_name` varchar(100) DEFAULT NULL,
  `li_itm_no` varchar(10) DEFAULT NULL,
  `li_computer_name` varchar(100) DEFAULT NULL,
  `li_tcpip` varchar(20) DEFAULT NULL,
  `li_referance_code` varchar(20) DEFAULT NULL,
  `li_register_key` varchar(20) DEFAULT NULL,
  `li_expire_date` datetime DEFAULT NULL,
  `li_ins_serial` varchar(50) DEFAULT NULL,
  `li_ins_models` varchar(100) DEFAULT NULL,
  `li_status` varchar(20) DEFAULT NULL,
  `li_license_key` varchar(300) DEFAULT NULL,
  `li_dll_version` varchar(20) DEFAULT NULL,
  `li_xlink_version` varchar(20) DEFAULT NULL,
  `li_dll_config` blob DEFAULT NULL,
  `li_active` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`li_no`) USING BTREE,
  KEY `li_itm_no` (`li_itm_no`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=241 DEFAULT CHARSET=tis620;


-- pctag.billdetail definition

CREATE TABLE `billdetail` (
  `bd_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bd_bl_id` int(10) unsigned DEFAULT NULL,
  `bd_lrq_no` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`bd_id`),
  KEY `fk_bd_bl_id` (`bd_bl_id`),
  KEY `billdetail_idx_bd_lrq_no` (`bd_lrq_no`),
  CONSTRAINT `fk_bd_bl_id` FOREIGN KEY (`bd_bl_id`) REFERENCES `billing` (`bl_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.commentrequest definition

CREATE TABLE `commentrequest` (
  `crq_no` varchar(10) NOT NULL,
  `crq_comment` varchar(1000) DEFAULT NULL,
  `crq_st_no` varchar(10) DEFAULT NULL,
  `crq_recordcreateby` varchar(10) DEFAULT NULL,
  `crq_recordcreatedatetime` datetime DEFAULT NULL,
  `crq_recordupdateby` varchar(10) DEFAULT NULL,
  `crq_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`crq_no`),
  KEY `idx_commentrequest_crq_st_no` (`crq_st_no`),
  CONSTRAINT `fk_commentrequest_crq_st_ no` FOREIGN KEY (`crq_st_no`) REFERENCES `section` (`st_no`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.commentresult definition

CREATE TABLE `commentresult` (
  `crs_no` varchar(10) NOT NULL,
  `crs_comment` varchar(1000) DEFAULT NULL,
  `crs_st_no` varchar(10) DEFAULT NULL,
  `crs_recordcreateby` varchar(10) DEFAULT NULL,
  `crs_recordcreatedatetime` datetime DEFAULT NULL,
  `crs_recordupdateby` varchar(10) DEFAULT NULL,
  `crs_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`crs_no`),
  KEY `idx_commentresult_crs_st_no` (`crs_st_no`),
  CONSTRAINT `fk_commentresult_crs_st_no` FOREIGN KEY (`crs_st_no`) REFERENCES `section` (`st_no`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.company definition

CREATE TABLE `company` (
  `cpn_no` varchar(10) NOT NULL,
  `cpn_name` varchar(100) DEFAULT NULL,
  `cpn_ctm_no` varchar(10) DEFAULT NULL,
  `cpn_interfacecode` varchar(50) DEFAULT NULL,
  `cpn_isdisplayrequest` varchar(1) DEFAULT NULL,
  `cpn_recordcreateby` varchar(10) DEFAULT NULL,
  `cpn_recordcreatedatetime` datetime DEFAULT NULL,
  `cpn_recordupdateby` varchar(10) DEFAULT NULL,
  `cpn_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`cpn_no`),
  KEY `idx_company_cpn_ctm_no` (`cpn_ctm_no`),
  CONSTRAINT `fk_company_cpn_ctm_no` FOREIGN KEY (`cpn_ctm_no`) REFERENCES `customer` (`ctm_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.customergroupjoincustomer definition

CREATE TABLE `customergroupjoincustomer` (
  `cjc_no` varchar(10) NOT NULL,
  `cjc_cg_no` varchar(10) DEFAULT NULL,
  `cjc_ctm_no` varchar(10) DEFAULT NULL,
  `cjc_recordcreateby` varchar(10) DEFAULT NULL,
  `cjc_recordcreatedatetime` datetime DEFAULT NULL,
  `cjc_recordupdateby` varchar(10) DEFAULT NULL,
  `cjc_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`cjc_no`),
  KEY `idx_customergroupjoincustomer_cjc_cg_no` (`cjc_cg_no`),
  KEY `idx_customergroupjoincustomer_cjc_ctm_no` (`cjc_ctm_no`),
  CONSTRAINT `fk_customergroupjoincustomer_cjc_cg_no` FOREIGN KEY (`cjc_cg_no`) REFERENCES `customergroup` (`cg_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_customergroupjoincustomer_cjc_ctm_no` FOREIGN KEY (`cjc_ctm_no`) REFERENCES `customer` (`ctm_no`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.customerjoinprofile definition

CREATE TABLE `customerjoinprofile` (
  `cjp_no` varchar(10) NOT NULL,
  `cjp_ctm_no` varchar(10) DEFAULT NULL,
  `cjp_pf_no` varchar(10) DEFAULT NULL,
  `cjp_pricetype` varchar(1) DEFAULT NULL,
  `cjp_price` decimal(12,4) DEFAULT NULL,
  `cjp_sort` int(11) DEFAULT NULL,
  `cjp_recordcreateby` varchar(10) DEFAULT NULL,
  `cjp_recordcreatedatetime` datetime DEFAULT NULL,
  `cjp_recordupdateby` varchar(10) DEFAULT NULL,
  `cjp_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`cjp_no`),
  KEY `idx_customerjoinprofile_cjp_ctm_no` (`cjp_ctm_no`),
  KEY `idx_customerjoinprofile_cjp_pf_no` (`cjp_pf_no`),
  CONSTRAINT `fk_customerjoinprofile_cjp_ctm_no` FOREIGN KEY (`cjp_ctm_no`) REFERENCES `customer` (`ctm_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_customerjoinprofile_cjp_pf_no` FOREIGN KEY (`cjp_pf_no`) REFERENCES `profile` (`pf_no`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.doctor definition

CREATE TABLE `doctor` (
  `dt_no` varchar(10) NOT NULL,
  `dt_name` varchar(100) DEFAULT NULL,
  `dt_ctm_no` varchar(10) DEFAULT NULL,
  `dt_interfacecode` varchar(50) DEFAULT NULL,
  `dt_isdisplayrequest` varchar(1) DEFAULT NULL,
  `dt_recordcreateby` varchar(10) DEFAULT NULL,
  `dt_recordcreatedatetime` datetime DEFAULT NULL,
  `dt_recordupdateby` varchar(10) DEFAULT NULL,
  `dt_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`dt_no`),
  KEY `idx_doctor_dt_ctm_no` (`dt_ctm_no`),
  CONSTRAINT `fk_doctor_dt_ctm_no` FOREIGN KEY (`dt_ctm_no`) REFERENCES `customer` (`ctm_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.nappluslabitem definition

CREATE TABLE `nappluslabitem` (
  `npli_no` varchar(10) NOT NULL,
  `npli_name` varchar(100) DEFAULT NULL,
  `npli_nplt_no` varchar(10) DEFAULT NULL,
  `npli_online` varchar(30) DEFAULT NULL,
  `npli_result` varchar(500) DEFAULT NULL,
  `npli_resulttype` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`npli_no`),
  KEY `idx_nappluslabitem_npli_nplt_no` (`npli_nplt_no`),
  CONSTRAINT `fk_nappluslabitem_npli_nplt_no` FOREIGN KEY (`npli_nplt_no`) REFERENCES `nappluslabtype` (`nplt_no`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.`parameter` definition

CREATE TABLE `parameter` (
  `prm_no` varchar(10) NOT NULL,
  `prm_name` varchar(100) DEFAULT NULL,
  `prm_reportname` varchar(100) DEFAULT NULL,
  `prm_groupreportname` varchar(100) DEFAULT NULL,
  `prm_formulaname` varchar(100) DEFAULT NULL,
  `prm_un_no` varchar(10) DEFAULT NULL,
  `prm_inputtype` varchar(1) DEFAULT NULL,
  `prm_resulttype` varchar(1) DEFAULT NULL,
  `prm_resultdefault` varchar(100) DEFAULT NULL,
  `prm_resultsetvalue` varchar(1) DEFAULT NULL,
  `prm_approvetype` varchar(1) DEFAULT NULL,
  `prm_method` varchar(100) DEFAULT NULL,
  `prm_secrettype` varchar(1) DEFAULT NULL,
  `prm_previousresultype` varchar(1) DEFAULT NULL,
  `prm_isprintresult` varchar(1) DEFAULT NULL,
  `prm_isprintresultonline` varchar(1) DEFAULT NULL,
  `prm_createtype` varchar(1) DEFAULT NULL,
  `prm_bcrablgenetype` varchar(1) DEFAULT NULL,
  `prm_tec_no` varchar(10) DEFAULT NULL,
  `prm_deltachecktype` varchar(1) DEFAULT NULL,
  `prm_deltacheckvalue` varchar(50) DEFAULT NULL,
  `prm_deltachecklasttype` varchar(1) DEFAULT NULL,
  `prm_deltachecklastvalue` varchar(50) DEFAULT NULL,
  `prm_isexportline` varchar(1) DEFAULT NULL,
  `prm_isexportcolab` varchar(1) DEFAULT NULL,
  `prm_colabresulttype` varchar(1) DEFAULT NULL,
  `prm_colabloinc` varchar(50) DEFAULT NULL,
  `prm_colabtools` varchar(50) DEFAULT NULL,
  `prm_commentreporttype` varchar(1) DEFAULT NULL,
  `prm_commentreport` varchar(1000) DEFAULT NULL,
  `prm_commentreporteng` varchar(1000) DEFAULT NULL,
  `prm_isnapplus` varchar(1) DEFAULT NULL,
  `prm_npli_no` varchar(10) DEFAULT NULL,
  `prm_isactive` varchar(1) DEFAULT NULL,
  `prm_recordcreateby` varchar(10) DEFAULT NULL,
  `prm_recordcreatedatetime` datetime DEFAULT NULL,
  `prm_recordupdateby` varchar(10) DEFAULT NULL,
  `prm_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`prm_no`),
  KEY `idx_parameter_prm_npli_no` (`prm_npli_no`),
  CONSTRAINT `fk_parameter_prm_npli_no` FOREIGN KEY (`prm_npli_no`) REFERENCES `nappluslabitem` (`npli_no`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.parameterchangeresult definition

CREATE TABLE `parameterchangeresult` (
  `pcr_no` varchar(10) NOT NULL,
  `pcr_prm_no` varchar(10) DEFAULT NULL,
  `pcr_condition` varchar(2) DEFAULT NULL,
  `pcr_value1` varchar(100) DEFAULT NULL,
  `pcr_value2` varchar(100) DEFAULT NULL,
  `pcr_reportresult` varchar(500) DEFAULT NULL,
  `pcr_reportresulteng` varchar(500) DEFAULT NULL,
  `pcr_reportcommenttype` varchar(1) DEFAULT NULL,
  `pcr_reportcomment` varchar(1000) DEFAULT NULL,
  `pcr_reportcommenteng` varchar(1000) DEFAULT NULL,
  `pcr_recordcreateby` varchar(10) DEFAULT NULL,
  `pcr_recordcreatedatetime` datetime DEFAULT NULL,
  `pcr_recordupdateby` varchar(10) DEFAULT NULL,
  `pcr_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`pcr_no`),
  KEY `idx_parameterchangeresult_pcr_prm_no` (`pcr_prm_no`),
  CONSTRAINT `fk_parameterchangeresult_pcr_prm_no` FOREIGN KEY (`pcr_prm_no`) REFERENCES `parameter` (`prm_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.parametercomment definition

CREATE TABLE `parametercomment` (
  `pcm_no` varchar(10) NOT NULL,
  `pcm_prm_no` varchar(10) DEFAULT NULL,
  `pcm_comment` varchar(1000) DEFAULT NULL,
  `pcm_recordcreateby` varchar(10) DEFAULT NULL,
  `pcm_recordcreatedatetime` datetime DEFAULT NULL,
  `pcm_recordupdateby` varchar(10) DEFAULT NULL,
  `pcm_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`pcm_no`),
  KEY `idx_parametercomment_pcm_prm_no` (`pcm_prm_no`),
  CONSTRAINT `fk_parametercomment_pcm_prm_no` FOREIGN KEY (`pcm_prm_no`) REFERENCES `parameter` (`prm_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.parameterfontcolor definition

CREATE TABLE `parameterfontcolor` (
  `pfc_no` varchar(10) NOT NULL,
  `pfc_prm_no` varchar(10) DEFAULT NULL,
  `pfc_color` varchar(50) DEFAULT NULL,
  `pfc_condition` varchar(2) DEFAULT NULL,
  `pfc_value1` varchar(100) DEFAULT NULL,
  `pfc_value2` varchar(100) DEFAULT NULL,
  `pfc_recordcreateby` varchar(10) DEFAULT NULL,
  `pfc_recordcreatedatetime` datetime DEFAULT NULL,
  `pfc_recordupdateby` varchar(10) DEFAULT NULL,
  `pfc_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`pfc_no`),
  KEY `idx_parameterfontcolor_pfc_prm_no` (`pfc_prm_no`),
  CONSTRAINT `fk_parameterfontcolor_pjc_prm_no` FOREIGN KEY (`pfc_prm_no`) REFERENCES `parameter` (`prm_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.parameterformula definition

CREATE TABLE `parameterformula` (
  `pfl_no` varchar(10) NOT NULL,
  `pfl_prm_no` varchar(10) DEFAULT NULL,
  `pfl_condition` varchar(3000) DEFAULT NULL,
  `pfl_commandtype` varchar(1) DEFAULT NULL,
  `pfl_command` varchar(3000) DEFAULT NULL,
  `pfl_resultformat` varchar(50) DEFAULT NULL,
  `pfl_recordcreateby` varchar(10) DEFAULT NULL,
  `pfl_recordcreatedatetime` datetime DEFAULT NULL,
  `pfl_recordupdateby` varchar(10) DEFAULT NULL,
  `pfl_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`pfl_no`),
  KEY `idx_parameterformula_pfl_prm_no` (`pfl_prm_no`),
  CONSTRAINT `fk_parameterformula_pfl_prm_no` FOREIGN KEY (`pfl_prm_no`) REFERENCES `parameter` (`prm_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.parameterjoinresult definition

CREATE TABLE `parameterjoinresult` (
  `pjr_no` varchar(10) NOT NULL,
  `pjr_prm_no` varchar(10) DEFAULT NULL,
  `pjr_rs_no` varchar(10) DEFAULT NULL,
  `pjr_sort` int(11) DEFAULT NULL,
  `pjr_recordcreateby` varchar(10) DEFAULT NULL,
  `pjr_recordcreatedatetime` datetime DEFAULT NULL,
  `pjr_recordupdateby` varchar(10) DEFAULT NULL,
  `pjr_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`pjr_no`),
  KEY `idx_parameterjoinresult_pjr_prm_no` (`pjr_prm_no`),
  KEY `idx_parameterjoinresult_pjr_rs_no` (`pjr_rs_no`),
  CONSTRAINT `fk_parameterjoinresult_pjr_prm_no` FOREIGN KEY (`pjr_prm_no`) REFERENCES `parameter` (`prm_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_parameterjoinresult_pjr_rs_no` FOREIGN KEY (`pjr_rs_no`) REFERENCES `result` (`rs_no`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.parameterpicture definition

CREATE TABLE `parameterpicture` (
  `ppt_no` varchar(10) NOT NULL,
  `ppt_prm_no` varchar(10) DEFAULT NULL,
  `ppt_picture` longblob DEFAULT NULL,
  `ppt_recordcreateby` varchar(10) DEFAULT NULL,
  `ppt_recordcreatedatetime` datetime DEFAULT NULL,
  `ppt_recordupdateby` varchar(10) DEFAULT NULL,
  `ppt_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`ppt_no`),
  KEY `idx_parameterpicture_ppt_prm_no` (`ppt_prm_no`),
  CONSTRAINT `fk_parameterpicture_ppt_prm_no` FOREIGN KEY (`ppt_prm_no`) REFERENCES `parameter` (`prm_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.parameterrange definition

CREATE TABLE `parameterrange` (
  `pr_no` varchar(10) NOT NULL,
  `pr_prm_no` varchar(10) DEFAULT NULL,
  `pr_rangetype` varchar(1) DEFAULT NULL,
  `pr_sextypye` varchar(1) DEFAULT NULL,
  `pr_agetype` varchar(1) DEFAULT NULL,
  `pr_agestart` int(11) DEFAULT NULL,
  `pr_ageto` int(11) DEFAULT NULL,
  `pr_condition` varchar(2) DEFAULT NULL,
  `pr_value1` varchar(100) DEFAULT NULL,
  `pr_value2` varchar(100) DEFAULT NULL,
  `pr_display` varchar(100) DEFAULT NULL,
  `pr_recordcreateby` varchar(10) DEFAULT NULL,
  `pr_recordcreatedatetime` datetime DEFAULT NULL,
  `pr_recordupdateby` varchar(10) DEFAULT NULL,
  `pr_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`pr_no`),
  KEY `idx_parameterrange_pr_prm_no` (`pr_prm_no`),
  CONSTRAINT `fk_parameterrange_pr_prm_no` FOREIGN KEY (`pr_prm_no`) REFERENCES `parameter` (`prm_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.parametersecret definition

CREATE TABLE `parametersecret` (
  `psc_no` varchar(10) NOT NULL,
  `psc_prm_no` varchar(10) DEFAULT NULL,
  `psc_us_no` varchar(10) DEFAULT NULL,
  `psc_recordcreateby` varchar(10) DEFAULT NULL,
  `psc_recordcreatedatetime` datetime DEFAULT NULL,
  `psc_recordupdateby` varchar(10) DEFAULT NULL,
  `psc_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`psc_no`),
  KEY `idx_parametersecret_psc_prm_no` (`psc_prm_no`),
  KEY `idx_parametersecret_psc_us_no` (`psc_us_no`),
  CONSTRAINT `fk_parametersecret_psc_prm_no` FOREIGN KEY (`psc_prm_no`) REFERENCES `parameter` (`prm_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.patient definition

CREATE TABLE `patient` (
  `pt_no` varchar(20) NOT NULL,
  `pt_ctm_no` varchar(10) DEFAULT NULL,
  `pt_hn` varchar(30) DEFAULT NULL,
  `pt_hn_external` varchar(30) DEFAULT NULL,
  `pt_titlename` varchar(100) DEFAULT NULL,
  `pt_firstname` varchar(100) DEFAULT NULL,
  `pt_lastname` varchar(100) DEFAULT NULL,
  `pt_name` varchar(100) DEFAULT NULL,
  `pt_sex` varchar(1) DEFAULT NULL,
  `pt_birthday` datetime DEFAULT NULL,
  `pt_idcard` varchar(30) DEFAULT NULL,
  `pt_nationality` varchar(100) DEFAULT NULL,
  `pt_race` varchar(100) DEFAULT NULL,
  `pt_phone` varchar(100) DEFAULT NULL,
  `pt_email` varchar(100) DEFAULT NULL,
  `pt_lineid` varchar(100) DEFAULT NULL,
  `pt_nap` varchar(50) DEFAULT NULL,
  `pt_language` varchar(1) DEFAULT NULL,
  `pt_isaccount` varchar(1) DEFAULT NULL,
  `pt_isreplace` varchar(1) DEFAULT NULL,
  `pt_recordcreatedatetime` datetime DEFAULT NULL,
  `pt_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`pt_no`),
  KEY `idx_patient_pt_ctm_no` (`pt_ctm_no`),
  KEY `idx_patient_pt_hn` (`pt_hn`),
  KEY `idx_patient_pt_hn_external` (`pt_hn_external`),
  KEY `idx_patient_pt_idcard` (`pt_idcard`),
  KEY `idx_patient_pt_name` (`pt_name`),
  CONSTRAINT `fk_patient_pt_ctm_no` FOREIGN KEY (`pt_ctm_no`) REFERENCES `customer` (`ctm_no`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.resultjoingrade definition

CREATE TABLE `resultjoingrade` (
  `rjg_no` varchar(10) NOT NULL,
  `rjg_pjr_no` varchar(10) DEFAULT NULL,
  `rjg_g_no` varchar(10) DEFAULT NULL,
  `rjg_type` varchar(1) DEFAULT NULL,
  `rjg_sort` int(11) DEFAULT NULL,
  `rjg_recordcreateby` varchar(10) DEFAULT NULL,
  `rjg_recordcreatedatetime` datetime DEFAULT NULL,
  `rjg_recordupdateby` varchar(10) DEFAULT NULL,
  `rjg_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`rjg_no`),
  KEY `idx_resultjoingrade_rjg_pjr_no` (`rjg_pjr_no`),
  KEY `idx_resultjoingrade_rjg_g_no` (`rjg_g_no`),
  CONSTRAINT `fk_resultjoingrade_rjg_g_no` FOREIGN KEY (`rjg_g_no`) REFERENCES `grade` (`g_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_resultjoingrade_rjg_pjr_no` FOREIGN KEY (`rjg_pjr_no`) REFERENCES `parameterjoinresult` (`pjr_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.rights definition

CREATE TABLE `rights` (
  `r_no` varchar(10) NOT NULL,
  `r_name` varchar(100) DEFAULT NULL,
  `r_groupname` varchar(100) DEFAULT NULL,
  `r_ctm_no` varchar(10) DEFAULT NULL,
  `r_interfacecode` varchar(50) DEFAULT NULL,
  `r_isdisplayrequest` varchar(1) DEFAULT NULL,
  `r_recordcreateby` varchar(10) DEFAULT NULL,
  `r_recordcreatedatetime` datetime DEFAULT NULL,
  `r_recordupdateby` varchar(10) DEFAULT NULL,
  `r_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`r_no`),
  KEY `idx_rights_r_ctm_no` (`r_ctm_no`),
  CONSTRAINT `fk_rights_r_ctm_no` FOREIGN KEY (`r_ctm_no`) REFERENCES `customer` (`ctm_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.signature definition

CREATE TABLE `signature` (
  `sng_no` varchar(10) NOT NULL,
  `sng_st_no` varchar(10) DEFAULT NULL,
  `sng_signature` longblob DEFAULT NULL,
  `sng_recordcreateby` varchar(10) DEFAULT NULL,
  `sng_recordcreatedatetime` datetime DEFAULT NULL,
  `sng_recordupdateby` varchar(10) DEFAULT NULL,
  `sng_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`sng_no`),
  KEY `idx_signature_sng_st_no` (`sng_st_no`),
  CONSTRAINT `fk_signature_sng_st_no` FOREIGN KEY (`sng_st_no`) REFERENCES `staff` (`st_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.specimen definition

CREATE TABLE `specimen` (
  `spm_no` varchar(10) NOT NULL,
  `spm_code` varchar(3) DEFAULT NULL,
  `spm_name` varchar(100) DEFAULT NULL,
  `spm_reportname` varchar(100) DEFAULT NULL,
  `spm_barcodename` varchar(100) DEFAULT NULL,
  `spm_spt_no` varchar(10) DEFAULT NULL,
  `spm_location` varchar(1) DEFAULT NULL,
  `spm_colabcode` varchar(50) DEFAULT NULL,
  `spm_volume` varchar(50) DEFAULT NULL,
  `spm_copiesbarcode` int(11) DEFAULT NULL,
  `spm_copiesbarcodereprint` int(11) DEFAULT NULL,
  `spm_recordcreateby` varchar(10) DEFAULT NULL,
  `spm_recordcreatedatetime` datetime DEFAULT NULL,
  `spm_recordupdateby` varchar(10) DEFAULT NULL,
  `spm_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`spm_no`),
  KEY `idx_specimen_spm_spt_no` (`spm_spt_no`),
  CONSTRAINT `fk_specimen_spm_spt_no` FOREIGN KEY (`spm_spt_no`) REFERENCES `specimentype` (`spt_no`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.test definition

CREATE TABLE `test` (
  `t_no` varchar(10) NOT NULL,
  `t_name` varchar(100) DEFAULT NULL,
  `t_reportname` varchar(100) DEFAULT NULL,
  `t_barcodename` varchar(100) DEFAULT NULL,
  `t_name1` varchar(250) DEFAULT NULL,
  `t_name2` varchar(250) DEFAULT NULL,
  `t_name3` varchar(250) DEFAULT NULL,
  `t_name4` varchar(250) DEFAULT NULL,
  `t_name5` varchar(250) DEFAULT NULL,
  `t_st_no` varchar(10) DEFAULT NULL,
  `t_spm_no` varchar(10) DEFAULT NULL,
  `t_resultstatus` varchar(1) DEFAULT NULL,
  `t_l_no` varchar(10) DEFAULT NULL,
  `t_method` varchar(100) DEFAULT NULL,
  `t_printresultstatus` varchar(1) DEFAULT NULL,
  `t_printresultonlinestatus` varchar(1) DEFAULT NULL,
  `t_printresulttype` varchar(1) DEFAULT NULL,
  `t_rrs_no` varchar(10) DEFAULT NULL,
  `t_rrs_eng_no` varchar(10) DEFAULT NULL,
  `t_rrs_object_no` varchar(10) DEFAULT NULL,
  `t_rrs_objecteng_no` varchar(10) DEFAULT NULL,
  `t_printworksheettype` varchar(1) DEFAULT NULL,
  `t_rws_no` varchar(10) DEFAULT NULL,
  `t_rbs_no` varchar(10) DEFAULT NULL,
  `t_ros_no` varchar(10) DEFAULT NULL,
  `t_testtype` varchar(1) DEFAULT NULL,
  `t_urgent` varchar(1) DEFAULT NULL,
  `t_group` varchar(1) DEFAULT NULL,
  `t_copiesbarcodereprint` int(11) DEFAULT NULL,
  `t_routinetime` int(11) DEFAULT NULL,
  `t_stattime` int(11) DEFAULT NULL,
  `t_asaptime` int(11) DEFAULT NULL,
  `t_overtime` int(11) DEFAULT NULL,
  `t_unittime` varchar(1) DEFAULT NULL,
  `t_isapproveafterpreview` varchar(1) DEFAULT NULL,
  `t_accountcode` varchar(50) DEFAULT NULL,
  `t_cgdcode` varchar(50) DEFAULT NULL,
  `t_cgdname` varchar(500) DEFAULT NULL,
  `t_accountprice` decimal(12,4) DEFAULT NULL,
  `t_tmltcode` varchar(50) DEFAULT NULL,
  `t_loinccode` varchar(50) DEFAULT NULL,
  `t_cost` decimal(12,4) DEFAULT NULL,
  `t_price` decimal(12,4) DEFAULT NULL,
  `t_isboi` varchar(1) DEFAULT NULL,
  `t_isexportline` varchar(1) DEFAULT NULL,
  `t_ojt_no` varchar(10) DEFAULT NULL,
  `t_instrument` varchar(100) DEFAULT NULL,
  `t_volume` varchar(100) DEFAULT NULL,
  `t_storage` varchar(500) DEFAULT NULL,
  `t_iso15189` varchar(1) DEFAULT NULL,
  `t_schedule` varchar(100) DEFAULT NULL,
  `t_rejectspecimen` varchar(500) DEFAULT NULL,
  `t_remark` varchar(500) DEFAULT NULL,
  `t_specialagreement` varchar(500) DEFAULT NULL,
  `t_isexportraxgeniuslis` varchar(1) DEFAULT NULL,
  `t_raxgeniusliscode` varchar(50) DEFAULT NULL,
  `t_isexporthie` varchar(1) DEFAULT NULL,
  `t_isactive` varchar(1) DEFAULT NULL,
  `t_sort` int(11) DEFAULT NULL,
  `t_recordcreateby` varchar(10) DEFAULT NULL,
  `t_recordcreatedatetime` datetime DEFAULT NULL,
  `t_recordupdateby` varchar(10) DEFAULT NULL,
  `t_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`t_no`),
  KEY `idx_test_t_st_no` (`t_st_no`),
  KEY `idx_test_t_spm_no` (`t_spm_no`),
  CONSTRAINT `fk_test_t_spm_no` FOREIGN KEY (`t_spm_no`) REFERENCES `specimen` (`spm_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_test_t_st_no` FOREIGN KEY (`t_st_no`) REFERENCES `section` (`st_no`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.testdiffcounter definition

CREATE TABLE `testdiffcounter` (
  `tdc_no` varchar(10) NOT NULL,
  `tdc_t_no` varchar(10) DEFAULT NULL,
  `tdc_prm_no` varchar(10) DEFAULT NULL,
  `tdc_recordcreateby` varchar(10) DEFAULT NULL,
  `tdc_recordcreatedatetime` datetime DEFAULT NULL,
  `tdc_recordupdateby` varchar(10) DEFAULT NULL,
  `tdc_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`tdc_no`),
  KEY `idx_testdiffcounter_tdc_t_no` (`tdc_t_no`),
  KEY `idx_testdiffcounter_tdc_prm_no` (`tdc_prm_no`),
  CONSTRAINT `fk_testdiffcounter_tdc_prm_no` FOREIGN KEY (`tdc_prm_no`) REFERENCES `parameter` (`prm_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_testdiffcounter_tdc_t_no` FOREIGN KEY (`tdc_t_no`) REFERENCES `test` (`t_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.testjoinlab definition

CREATE TABLE `testjoinlab` (
  `tjl_no` varchar(10) NOT NULL,
  `tjl_t_no` varchar(10) DEFAULT NULL,
  `tjl_l_no` varchar(10) DEFAULT NULL,
  `tjl_accountcode` varchar(50) DEFAULT NULL,
  `tjl_accountname` varchar(100) DEFAULT NULL,
  `tjl_cost` decimal(12,4) DEFAULT NULL,
  `tjl_price` decimal(12,4) DEFAULT NULL,
  `tjl_recordcreateby` varchar(10) DEFAULT NULL,
  `tjl_recordcreatedatetime` datetime DEFAULT NULL,
  `tjl_recordupdateby` varchar(10) DEFAULT NULL,
  `tjl_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`tjl_no`),
  KEY `idx_testjoinlab_tjl_t_no` (`tjl_t_no`),
  KEY `idx_testjoinlab_tjl_l_no` (`tjl_l_no`),
  CONSTRAINT `fk_testjoinlab_tjl_l_no` FOREIGN KEY (`tjl_l_no`) REFERENCES `lab` (`l_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_testjoinlab_tjl_t_no` FOREIGN KEY (`tjl_t_no`) REFERENCES `test` (`t_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.testjoinparameter definition

CREATE TABLE `testjoinparameter` (
  `tjp_no` varchar(10) NOT NULL,
  `tjp_t_no` varchar(10) DEFAULT NULL,
  `tjp_prm_no` varchar(10) DEFAULT NULL,
  `tjp_israxgeniuslis` varchar(1) DEFAULT NULL,
  `tjp_raxgeniusliscode` varchar(50) DEFAULT NULL,
  `tjp_isrequest` varchar(1) DEFAULT NULL,
  `tjp_sort` int(11) DEFAULT NULL,
  `tjp_recordcreateby` varchar(10) DEFAULT NULL,
  `tjp_recordcreatedatetime` datetime DEFAULT NULL,
  `tjp_recordupdateby` varchar(10) DEFAULT NULL,
  `tjp_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`tjp_no`),
  KEY `idx_testjoinparameter_tjp_t_no` (`tjp_t_no`),
  KEY `idx_testjoinparameter_tjp_prm_no` (`tjp_prm_no`),
  CONSTRAINT `fk_testjoinparameter_tjp_prm_no` FOREIGN KEY (`tjp_prm_no`) REFERENCES `parameter` (`prm_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_testjoinparameter_tjp_t_no` FOREIGN KEY (`tjp_t_no`) REFERENCES `test` (`t_no`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.users definition

CREATE TABLE `users` (
  `us_no` varchar(10) NOT NULL,
  `us_st_no` varchar(10) DEFAULT NULL,
  `us_ur_no` varchar(10) DEFAULT NULL,
  `us_username` varchar(50) DEFAULT NULL,
  `us_password` varchar(50) DEFAULT NULL,
  `us_iswinapplication` varchar(1) DEFAULT NULL,
  `us_iswebapplication` varchar(1) DEFAULT NULL,
  `us_iswebsecret` varchar(1) DEFAULT NULL,
  `us_issectionall` varchar(1) DEFAULT NULL,
  `us_iswardall` varchar(1) DEFAULT NULL,
  `us_istestall` varchar(1) DEFAULT NULL,
  `us_isactive` varchar(1) DEFAULT NULL,
  `us_expiredatetime` datetime DEFAULT NULL,
  `us_recordcreateby` varchar(10) DEFAULT NULL,
  `us_recordcreatedatetime` datetime DEFAULT NULL,
  `us_recordupdateby` varchar(10) DEFAULT NULL,
  `us_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`us_no`),
  KEY `idx_users_us_st_no` (`us_st_no`),
  KEY `idx_users_us_ur_no` (`us_ur_no`),
  CONSTRAINT `fk_users_us_st_no` FOREIGN KEY (`us_st_no`) REFERENCES `staff` (`st_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_users_us_ur_no` FOREIGN KEY (`us_ur_no`) REFERENCES `userrights` (`ur_no`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.ward definition

CREATE TABLE `ward` (
  `w_no` varchar(10) NOT NULL,
  `w_name` varchar(100) DEFAULT NULL,
  `w_ctm_no` varchar(10) DEFAULT NULL,
  `w_visittype` varchar(100) DEFAULT NULL,
  `w_interfacecode` varchar(50) DEFAULT NULL,
  `w_isdisplayrequest` varchar(1) DEFAULT NULL,
  `w_recordcreateby` varchar(10) DEFAULT NULL,
  `w_recordcreatedatetime` datetime DEFAULT NULL,
  `w_recordupdateby` varchar(10) DEFAULT NULL,
  `w_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`w_no`),
  KEY `idx_ward_w_ctm_no` (`w_ctm_no`),
  CONSTRAINT `fk_ward_w_ctm_no` FOREIGN KEY (`w_ctm_no`) REFERENCES `customer` (`ctm_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.`0_labrequest` definition

CREATE TABLE `0_labrequest` (
  `lrq_no` varchar(20) NOT NULL,
  `lrq_interfacecode` varchar(100) DEFAULT NULL,
  `lrq_ctm_no` varchar(10) DEFAULT NULL,
  `lrq_pt_no` varchar(20) DEFAULT NULL,
  `lrq_requesttype` varchar(1) DEFAULT NULL,
  `lrq_requestno` varchar(30) DEFAULT NULL,
  `lrq_requestby` varchar(10) DEFAULT NULL,
  `lrq_requestdatetime` datetime DEFAULT NULL,
  `lrq_ln` varchar(30) DEFAULT NULL,
  `lrq_an` varchar(30) DEFAULT NULL,
  `lrq_vn` varchar(30) DEFAULT NULL,
  `lrq_saqno` varchar(30) DEFAULT NULL,
  `lrq_cpn_no` varchar(10) DEFAULT NULL,
  `lrq_w_no` varchar(10) DEFAULT NULL,
  `lrq_bedno` varchar(50) DEFAULT NULL,
  `lrq_dt_no` varchar(10) DEFAULT NULL,
  `lrq_r_no` varchar(10) DEFAULT NULL,
  `lrq_ojt_no` varchar(10) DEFAULT NULL,
  `lrq_urgent` varchar(1) DEFAULT NULL,
  `lrq_diagnose` varchar(1000) DEFAULT NULL,
  `lrq_commentreport` varchar(1000) DEFAULT NULL,
  `lrq_commentinternal` varchar(1000) DEFAULT NULL,
  `lrq_age` varchar(50) DEFAULT NULL,
  `lrq_ageyear` int(11) DEFAULT NULL,
  `lrq_agemonth` int(11) DEFAULT NULL,
  `lrq_ageday` int(11) DEFAULT NULL,
  `lrq_cost` decimal(12,4) DEFAULT NULL,
  `lrq_price` decimal(12,4) DEFAULT NULL,
  `lrq_isaccount` varchar(1) DEFAULT NULL,
  `lrq_unaccountby` varchar(10) DEFAULT NULL,
  `lrq_unaccountdatetime` datetime DEFAULT NULL,
  `lrq_isstatusoutlab` varchar(1) DEFAULT NULL,
  `lrq_isstatuspending` varchar(1) DEFAULT NULL,
  `lrq_isstatusreceive` varchar(1) DEFAULT NULL,
  `lrq_isstatusanalyse` varchar(1) DEFAULT NULL,
  `lrq_isstatusrepeat` varchar(1) DEFAULT NULL,
  `lrq_isstatusresult` varchar(1) DEFAULT NULL,
  `lrq_isstatusreport` varchar(1) DEFAULT NULL,
  `lrq_isstatusapprove` varchar(1) DEFAULT NULL,
  `lrq_iscritical` varchar(1) DEFAULT NULL,
  `lrq_isobject` varchar(1) DEFAULT NULL,
  `lrq_isexcel` varchar(1) DEFAULT NULL,
  `lrq_iscolab` varchar(1) DEFAULT NULL,
  `lrq_exportnapplus` varchar(1) DEFAULT NULL,
  `lrq_issinglesection` varchar(1) DEFAULT NULL,
  `lrq_isimportraxgeniuslis` varchar(1) DEFAULT NULL,
  `lrq_importraxgeniuslisdatetime` datetime DEFAULT NULL,
  `lrq_ispopuppatientchange` varchar(1) DEFAULT NULL,
  `lrq_popuppatientchangemessage` varchar(1000) DEFAULT NULL,
  `lrq_checkindatetime` datetime DEFAULT NULL,
  `lrq_receivedatetime` datetime DEFAULT NULL,
  `lrq_expectdatetime` datetime DEFAULT NULL,
  `lrq_standardtime` varchar(1000) DEFAULT NULL,
  `lrq_approvetime` varchar(1000) DEFAULT NULL,
  `lrq_statusd2d` varchar(1) DEFAULT NULL,
  `lrq_istransfer` varchar(1) DEFAULT NULL,
  `lrq_transferdatetime` datetime DEFAULT NULL,
  `lrq_isdelete` varchar(1) DEFAULT NULL,
  `lrq_deleteby` varchar(10) DEFAULT NULL,
  `lrq_deletedatetime` datetime DEFAULT NULL,
  `lrq_quadtemp` varchar(50) DEFAULT NULL,
  `lrq_recordcreatedatetime` datetime DEFAULT NULL,
  `lrq_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`lrq_no`),
  KEY `idx_0_labrequest_lrq_ctm_no` (`lrq_ctm_no`),
  KEY `idx_0_labrequest_lrq_pt_no` (`lrq_pt_no`),
  KEY `idx_0_labrequest_lrq_requestno` (`lrq_requestno`),
  KEY `idx_0_labrequest_lrq_requestby` (`lrq_requestby`),
  KEY `idx_0_labrequest_lrq_requestdatetime` (`lrq_requestdatetime`),
  KEY `idx_0_labrequest_lrq_w_no` (`lrq_w_no`),
  KEY `idx_0_labrequest_lrq_dt_no` (`lrq_dt_no`),
  KEY `idx_0_labrequest_lrq_r_no` (`lrq_r_no`),
  KEY `idx_0_labrequest_lrq_interfacecode` (`lrq_interfacecode`),
  KEY `idx_0_labrequest_lrq_ln` (`lrq_ln`),
  KEY `idx_0_labrequest_lrq_cpn_no` (`lrq_cpn_no`),
  KEY `idx_0_labrequest_lrq_ojt_no` (`lrq_ojt_no`),
  CONSTRAINT `fk_0_labrequest_lrq_cpn_no` FOREIGN KEY (`lrq_cpn_no`) REFERENCES `company` (`cpn_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_0_labrequest_lrq_ctm_no` FOREIGN KEY (`lrq_ctm_no`) REFERENCES `customer` (`ctm_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_0_labrequest_lrq_dt_no` FOREIGN KEY (`lrq_dt_no`) REFERENCES `doctor` (`dt_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_0_labrequest_lrq_ojt_no` FOREIGN KEY (`lrq_ojt_no`) REFERENCES `objective` (`ojt_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_0_labrequest_lrq_pt_no` FOREIGN KEY (`lrq_pt_no`) REFERENCES `patient` (`pt_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_0_labrequest_lrq_r_no` FOREIGN KEY (`lrq_r_no`) REFERENCES `rights` (`r_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_0_labrequest_lrq_w_no` FOREIGN KEY (`lrq_w_no`) REFERENCES `ward` (`w_no`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.`0_labsection` definition

CREATE TABLE `0_labsection` (
  `lst_no` varchar(20) NOT NULL,
  `lst_lrq_no` varchar(20) DEFAULT NULL,
  `lst_st_no` varchar(10) DEFAULT NULL,
  `lst_isstatusoutlab` varchar(1) DEFAULT NULL,
  `lst_isstatuspending` varchar(1) DEFAULT NULL,
  `lst_isstatusreceive` varchar(1) DEFAULT NULL,
  `lst_isstatusanalyse` varchar(1) DEFAULT NULL,
  `lst_isstatusrepeat` varchar(1) DEFAULT NULL,
  `lst_isstatusresult` varchar(1) DEFAULT NULL,
  `lst_isstatusreport` varchar(1) DEFAULT NULL,
  `lst_isstatusapprove` varchar(1) DEFAULT NULL,
  `lst_iscritical` varchar(1) DEFAULT NULL,
  `lst_isobject` varchar(1) DEFAULT NULL,
  `lst_isexcel` varchar(1) DEFAULT NULL,
  `lst_iscolab` varchar(1) DEFAULT NULL,
  `lst_exportnapplus` varchar(1) DEFAULT NULL,
  `lst_receivedatetime` datetime DEFAULT NULL,
  `lst_isdelete` varchar(1) DEFAULT NULL,
  `lst_deleteby` varchar(10) DEFAULT NULL,
  `lst_deletedatetime` datetime DEFAULT NULL,
  `lst_recordcreatedatetime` datetime DEFAULT NULL,
  `lst_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`lst_no`),
  KEY `idx_0_labsection_lst_lrq_no` (`lst_lrq_no`),
  KEY `idx_0_labsection_lst_st_no` (`lst_st_no`),
  CONSTRAINT `fk_0_labsection_lst_lrq_no` FOREIGN KEY (`lst_lrq_no`) REFERENCES `0_labrequest` (`lrq_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_0_labsection_lst_st_no` FOREIGN KEY (`lst_st_no`) REFERENCES `section` (`st_no`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.`0_labspecimen` definition

CREATE TABLE `0_labspecimen` (
  `lsp_no` varchar(20) NOT NULL,
  `lsp_lrq_no` varchar(20) DEFAULT NULL,
  `lsp_spm_no` varchar(10) DEFAULT NULL,
  `lsp_spt_no` varchar(10) DEFAULT NULL,
  `lsp_collectdatetime` varchar(50) DEFAULT NULL,
  `lsp_barcodeno` varchar(30) DEFAULT NULL,
  `lsp_specimennote` varchar(500) DEFAULT NULL,
  `lsp_location` varchar(1) DEFAULT NULL,
  `lsp_iscritical` varchar(1) DEFAULT NULL,
  `lsp_isobject` varchar(1) DEFAULT NULL,
  `lsp_isexcel` varchar(1) DEFAULT NULL,
  `lsp_iscolab` varchar(1) DEFAULT NULL,
  `lsp_exportnapplus` varchar(1) DEFAULT NULL,
  `lsp_statusexportraxgeniuslis` varchar(1) DEFAULT NULL,
  `lsp_exportraxgeniuslisdatetime` datetime DEFAULT NULL,
  `lsp_ischeckin` varchar(1) DEFAULT NULL,
  `lsp_checkinby` varchar(10) DEFAULT NULL,
  `lsp_checkindatetime` datetime DEFAULT NULL,
  `lsp_isreceive` varchar(1) DEFAULT NULL,
  `lsp_receiveby` varchar(10) DEFAULT NULL,
  `lsp_receivedatetime` datetime DEFAULT NULL,
  `lsp_isincident` varchar(1) DEFAULT NULL,
  `lsp_incidentby` varchar(10) DEFAULT NULL,
  `lsp_incidentdatetime` datetime DEFAULT NULL,
  `lsp_isreject` varchar(1) DEFAULT NULL,
  `lsp_rejectby` varchar(10) DEFAULT NULL,
  `lsp_rejectdatetime` datetime DEFAULT NULL,
  `lsp_isstatusoutlab` varchar(1) DEFAULT NULL,
  `lsp_isstatuspending` varchar(1) DEFAULT NULL,
  `lsp_isstatusreceive` varchar(1) DEFAULT NULL,
  `lsp_isstatusanalyse` varchar(1) DEFAULT NULL,
  `lsp_isstatusrepeat` varchar(1) DEFAULT NULL,
  `lsp_isstatusresult` varchar(1) DEFAULT NULL,
  `lsp_isstatusreport` varchar(1) DEFAULT NULL,
  `lsp_isstatusapprove` varchar(1) DEFAULT NULL,
  `lsp_isdelete` varchar(1) DEFAULT NULL,
  `lsp_deleteby` varchar(10) DEFAULT NULL,
  `lsp_deletedatetime` datetime DEFAULT NULL,
  `lsp_recordcreatedatetime` datetime DEFAULT NULL,
  `lsp_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`lsp_no`),
  KEY `idx_0_labspecimen_lsp_lrq_no` (`lsp_lrq_no`),
  KEY `idx_0_labspecimen_lsp_spm_no` (`lsp_spm_no`),
  KEY `idx_0_labspecimen_lsp_barcodeno` (`lsp_barcodeno`),
  KEY `idx_0_labspecimen_lsp_checkinby` (`lsp_checkinby`),
  KEY `idx_0_labspecimen_lsp_checkindatetime` (`lsp_checkindatetime`),
  KEY `idx_0_labspecimen_lsp_receiveby` (`lsp_receiveby`),
  KEY `idx_0_labspecimen_lsp_receivedatetime` (`lsp_receivedatetime`),
  KEY `idx_0_labspecimen_lsp_incidentby` (`lsp_incidentby`),
  KEY `idx_0_labspecimen_lsp_incidentdatetime` (`lsp_incidentdatetime`),
  KEY `idx_0_labspecimen_lsp_rejectby` (`lsp_rejectby`),
  KEY `idx_0_labspecimen_lsp_rejectdatetime` (`lsp_rejectdatetime`),
  KEY `idx_0_labspecimen_lsp_spt_no` (`lsp_spt_no`),
  CONSTRAINT `fk_0_labspecimen_lsp_lrq_no` FOREIGN KEY (`lsp_lrq_no`) REFERENCES `0_labrequest` (`lrq_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_0_labspecimen_lsp_spm_no` FOREIGN KEY (`lsp_spm_no`) REFERENCES `specimen` (`spm_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_0_labspecimen_lsp_spt_no` FOREIGN KEY (`lsp_spt_no`) REFERENCES `specimentype` (`spt_no`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.`0_labtest` definition

CREATE TABLE `0_labtest` (
  `lt_no` varchar(20) NOT NULL,
  `lt_lsp_no` varchar(20) DEFAULT NULL,
  `lt_lrq_no` varchar(20) DEFAULT NULL,
  `lt_t_no` varchar(10) DEFAULT NULL,
  `lt_st_no` varchar(10) DEFAULT NULL,
  `lt_l_no` varchar(10) DEFAULT NULL,
  `lt_issendoutlab` varchar(1) DEFAULT NULL,
  `lt_sendoutlabby` varchar(10) DEFAULT NULL,
  `lt_sendoutlabdatetime` datetime DEFAULT NULL,
  `lt_isprofile` varchar(1) DEFAULT NULL,
  `lt_lpf_no` varchar(20) DEFAULT NULL,
  `lt_isprice` varchar(1) DEFAULT NULL,
  `lt_accountcode` varchar(50) DEFAULT NULL,
  `lt_accountname` varchar(100) DEFAULT NULL,
  `lt_cost` decimal(12,4) DEFAULT NULL,
  `lt_price` decimal(12,4) DEFAULT NULL,
  `lt_isaccount` varchar(1) DEFAULT NULL,
  `lt_unaccountby` varchar(10) DEFAULT NULL,
  `lt_unaccountdatetime` datetime DEFAULT NULL,
  `lt_outlabstatus` varchar(1) DEFAULT NULL,
  `lt_isreject` varchar(1) DEFAULT NULL,
  `lt_rejectby` varchar(10) DEFAULT NULL,
  `lt_rejectdatetime` datetime DEFAULT NULL,
  `lt_ispreview` varchar(1) DEFAULT NULL,
  `lt_isrepeat` varchar(1) DEFAULT NULL,
  `lt_repeatcount` int(11) DEFAULT NULL,
  `lt_analysedatetime` datetime DEFAULT NULL,
  `lt_resultdatetime` datetime DEFAULT NULL,
  `lt_reportdatetime` datetime DEFAULT NULL,
  `lt_approvedatetime` datetime DEFAULT NULL,
  `lt_isunapprove` varchar(1) DEFAULT NULL,
  `lt_unapprovedatetime` datetime DEFAULT NULL,
  `lt_alltime` int(11) DEFAULT NULL,
  `lt_labtime` int(11) DEFAULT NULL,
  `lt_createtype` varchar(1) DEFAULT NULL,
  `lt_issenddashboard` varchar(1) DEFAULT NULL,
  `lt_senddashboarderrorcount` int(11) DEFAULT NULL,
  `lt_isdelete` varchar(1) DEFAULT NULL,
  `lt_deleteby` varchar(10) DEFAULT NULL,
  `lt_deletedatetime` datetime DEFAULT NULL,
  `lt_recordcreatedatetime` datetime DEFAULT NULL,
  `lt_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`lt_no`),
  KEY `idx_0_labtest_lt_lsp_no` (`lt_lsp_no`),
  KEY `idx_0_labtest_lt_lrq_no` (`lt_lrq_no`),
  KEY `idx_0_labtest_lt_t_no` (`lt_t_no`),
  KEY `idx_0_labtest_lt_st_no` (`lt_st_no`),
  KEY `idx_0_labtest_lt_l_no` (`lt_l_no`),
  KEY `idx_0_labtest_lt_sendoutlabby` (`lt_sendoutlabby`),
  KEY `idx_0_labtest_lt_sendoutlabdatetime` (`lt_sendoutlabdatetime`),
  KEY `idx_0_labtest_lt_lpf_no` (`lt_lpf_no`),
  CONSTRAINT `fk_0_labtest_` FOREIGN KEY (`lt_l_no`) REFERENCES `lab` (`l_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_0_labtest_lt_lsp_no` FOREIGN KEY (`lt_lsp_no`) REFERENCES `0_labspecimen` (`lsp_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_0_labtest_lt_st_no` FOREIGN KEY (`lt_st_no`) REFERENCES `section` (`st_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_0_labtest_lt_t_no` FOREIGN KEY (`lt_t_no`) REFERENCES `test` (`t_no`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.`0_labtestreject` definition

CREATE TABLE `0_labtestreject` (
  `ltr_no` varchar(20) NOT NULL,
  `ltr_lt_no` varchar(20) DEFAULT NULL,
  `ltr_lsp_no` varchar(20) DEFAULT NULL,
  `ltr_lrq_no` varchar(20) DEFAULT NULL,
  `ltr_rj_no` varchar(10) DEFAULT NULL,
  `ltr_comment` varchar(1000) DEFAULT NULL,
  `ltr_rejectby` varchar(10) DEFAULT NULL,
  `ltr_rejectdatetime` datetime DEFAULT NULL,
  `ltr_recordcreatedatetime` datetime DEFAULT NULL,
  `ltr_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`ltr_no`),
  KEY `idx_0_labtestreject_ltr_lt_no` (`ltr_lt_no`),
  KEY `idx_0_labtestreject_ltr_lsp_no` (`ltr_lsp_no`),
  KEY `idx_0_labtestreject_ltr_lrq_no` (`ltr_lrq_no`),
  KEY `idx_0_labtestreject_ltr_rj_no` (`ltr_rj_no`),
  KEY `idx_0_labtestreject_ltr_rejectby` (`ltr_rejectby`),
  KEY `idx_0_labtestreject_ltr_rejectdatetime` (`ltr_rejectdatetime`),
  CONSTRAINT `fk_0_labtestreject_ltr_lt_no` FOREIGN KEY (`ltr_lt_no`) REFERENCES `0_labtest` (`lt_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_0_labtestreject_ltr_rj_no` FOREIGN KEY (`ltr_rj_no`) REFERENCES `reject` (`rj_no`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.customerjointest definition

CREATE TABLE `customerjointest` (
  `cjt_no` varchar(10) NOT NULL,
  `cjt_ctm_no` varchar(10) DEFAULT NULL,
  `cjt_t_no` varchar(10) DEFAULT NULL,
  `cjt_l_no` varchar(10) DEFAULT NULL,
  `cjt_pricetype` varchar(1) DEFAULT NULL,
  `cjt_pricestatus` varchar(1) DEFAULT NULL,
  `cjt_startdate` datetime DEFAULT NULL,
  `cjt_enddate` datetime DEFAULT NULL,
  `cjt_price` decimal(12,4) DEFAULT NULL,
  `cjt_interfacecode` varchar(50) DEFAULT NULL,
  `cjt_contracttype` varchar(1) DEFAULT NULL,
  `cjt_sort` int(11) DEFAULT NULL,
  `cjt_recordcreateby` varchar(10) DEFAULT NULL,
  `cjt_recordcreatedatetime` datetime DEFAULT NULL,
  `cjt_recordupdateby` varchar(10) DEFAULT NULL,
  `cjt_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`cjt_no`),
  KEY `idx_customerjointest_cjt_ctm_no` (`cjt_ctm_no`),
  KEY `idx_customerjointest_cjt_t_no` (`cjt_t_no`),
  KEY `idx_customerjointest_cjt_l_no` (`cjt_l_no`),
  CONSTRAINT `fk_customerjointest_cjt_ctm_no` FOREIGN KEY (`cjt_ctm_no`) REFERENCES `customer` (`ctm_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_customerjointest_cjt_l_no` FOREIGN KEY (`cjt_l_no`) REFERENCES `lab` (`l_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_customerjointest_cjt_t_no` FOREIGN KEY (`cjt_t_no`) REFERENCES `test` (`t_no`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.customerlabcheckin definition

CREATE TABLE `customerlabcheckin` (
  `clc_no` varchar(20) NOT NULL,
  `clc_ctm_no` varchar(10) DEFAULT NULL,
  `clc_us_no` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`clc_no`),
  KEY `idx_customerlabcheckin_clc_ctm_no` (`clc_ctm_no`),
  KEY `idx_customerlabcheckin_clc_us_no` (`clc_us_no`),
  CONSTRAINT `fk_customerlabcheckin_clc_ctm_no` FOREIGN KEY (`clc_ctm_no`) REFERENCES `customer` (`ctm_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_customerlabcheckin_clc_us_no` FOREIGN KEY (`clc_us_no`) REFERENCES `users` (`us_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.customerlabcheckout definition

CREATE TABLE `customerlabcheckout` (
  `clc_no` varchar(20) NOT NULL,
  `clc_ctm_no` varchar(10) DEFAULT NULL,
  `clc_us_no` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`clc_no`),
  KEY `idx_customerlabcheckout_clc_ctm_no` (`clc_ctm_no`),
  KEY `idx_customerlabcheckout_clc_us_no` (`clc_us_no`),
  CONSTRAINT `fk_customerlabcheckout_clc_ctm_no` FOREIGN KEY (`clc_ctm_no`) REFERENCES `customer` (`ctm_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_customerlabcheckout_clc_us_no` FOREIGN KEY (`clc_us_no`) REFERENCES `users` (`us_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.customerlabresult definition

CREATE TABLE `customerlabresult` (
  `clr_no` varchar(20) NOT NULL,
  `clr_ctm_no` varchar(10) DEFAULT NULL,
  `clr_us_no` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`clr_no`),
  KEY `idx_customerlabresult_clr_ctm_no` (`clr_ctm_no`),
  KEY `idx_customerlabresult_clr_us_no` (`clr_us_no`),
  CONSTRAINT `fk_customerlabresult_clr_ctm_no` FOREIGN KEY (`clr_ctm_no`) REFERENCES `customer` (`ctm_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_customerlabresult_clr_us_no` FOREIGN KEY (`clr_us_no`) REFERENCES `users` (`us_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.customerlabreview definition

CREATE TABLE `customerlabreview` (
  `clr_no` varchar(20) NOT NULL,
  `clr_ctm_no` varchar(10) DEFAULT NULL,
  `clr_us_no` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`clr_no`),
  KEY `idx_customerlabreview_clr_ctm_no` (`clr_ctm_no`),
  KEY `idx_customerlabreview_clr_us_no` (`clr_us_no`),
  CONSTRAINT `fk_customerlabreview_clr_ctm_no` FOREIGN KEY (`clr_ctm_no`) REFERENCES `customer` (`ctm_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_customerlabreview_clr_us_no` FOREIGN KEY (`clr_us_no`) REFERENCES `users` (`us_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.customerlabsendoutlab definition

CREATE TABLE `customerlabsendoutlab` (
  `cls_no` varchar(20) NOT NULL,
  `cls_ctm_no` varchar(10) DEFAULT NULL,
  `cls_us_no` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`cls_no`),
  KEY `idx_customerlabsendoutlab_cls_ctm_no` (`cls_ctm_no`),
  KEY `idx_customerlabsendoutlab_cls_us_no` (`cls_us_no`),
  CONSTRAINT `fk_customerlabsendoutlab_cls_ctm_no` FOREIGN KEY (`cls_ctm_no`) REFERENCES `customer` (`ctm_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_customerlabsendoutlab_cls_us_no` FOREIGN KEY (`cls_us_no`) REFERENCES `users` (`us_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.instrumentinterface definition

CREATE TABLE `instrumentinterface` (
  `ii_no` varchar(10) NOT NULL,
  `ii_itm_no` varchar(10) DEFAULT NULL,
  `ii_prm_no` varchar(10) DEFAULT NULL,
  `ii_interfacecode` varchar(50) DEFAULT NULL,
  `ii_recordcreateby` varchar(10) DEFAULT NULL,
  `ii_recordcreatedatetime` datetime DEFAULT NULL,
  `ii_recordupdateby` varchar(10) DEFAULT NULL,
  `ii_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`ii_no`),
  KEY `idx_instrumentinterface_ii_itm_no` (`ii_itm_no`),
  KEY `idx_instrumentinterface_ii_prm_no` (`ii_prm_no`),
  KEY `idx_instrumentinterface_ii_interfacecode` (`ii_interfacecode`),
  CONSTRAINT `fk_instrumentinterface_ii_itm_no` FOREIGN KEY (`ii_itm_no`) REFERENCES `instrument` (`itm_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_instrumentinterface_ii_prm_no` FOREIGN KEY (`ii_prm_no`) REFERENCES `parameter` (`prm_no`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.lablabresult definition

CREATE TABLE `lablabresult` (
  `llr_no` varchar(20) NOT NULL,
  `llr_l_no` varchar(10) DEFAULT NULL,
  `llr_us_no` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`llr_no`),
  KEY `idx_lablabresult_llr_l_no` (`llr_l_no`),
  KEY `idx_lablabresult_llr_us_no` (`llr_us_no`),
  CONSTRAINT `fk_lablabresult_llr_l_no` FOREIGN KEY (`llr_l_no`) REFERENCES `lab` (`l_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_lablabresult_llr_us_no` FOREIGN KEY (`llr_us_no`) REFERENCES `users` (`us_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.lablabsendoutlab definition

CREATE TABLE `lablabsendoutlab` (
  `lls_no` varchar(20) NOT NULL,
  `lls_l_no` varchar(10) DEFAULT NULL,
  `lls_us_no` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`lls_no`),
  KEY `idx_lablabsendoutlab_lls_l_no` (`lls_l_no`),
  KEY `idx_lablabsendoutlab_lls_us_no` (`lls_us_no`),
  CONSTRAINT `fk_lablabsendoutlab_lls_l_no` FOREIGN KEY (`lls_l_no`) REFERENCES `lab` (`l_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_lablabsendoutlab_lls_us_no` FOREIGN KEY (`lls_us_no`) REFERENCES `users` (`us_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.labrequest definition

CREATE TABLE `labrequest` (
  `lrq_no` varchar(20) NOT NULL,
  `lrq_interfacecode` varchar(100) DEFAULT NULL,
  `lrq_ctm_no` varchar(10) DEFAULT NULL,
  `lrq_pt_no` varchar(20) DEFAULT NULL,
  `lrq_requesttype` varchar(1) DEFAULT NULL,
  `lrq_requestno` varchar(30) DEFAULT NULL,
  `lrq_requestby` varchar(10) DEFAULT NULL,
  `lrq_requestdatetime` datetime DEFAULT NULL,
  `lrq_ln` varchar(30) DEFAULT NULL,
  `lrq_an` varchar(30) DEFAULT NULL,
  `lrq_vn` varchar(30) DEFAULT NULL,
  `lrq_saqno` varchar(30) DEFAULT NULL,
  `lrq_cpn_no` varchar(10) DEFAULT NULL,
  `lrq_w_no` varchar(10) DEFAULT NULL,
  `lrq_bedno` varchar(50) DEFAULT NULL,
  `lrq_dt_no` varchar(10) DEFAULT NULL,
  `lrq_r_no` varchar(10) DEFAULT NULL,
  `lrq_ojt_no` varchar(10) DEFAULT NULL,
  `lrq_urgent` varchar(1) DEFAULT NULL,
  `lrq_diagnose` varchar(1000) DEFAULT NULL,
  `lrq_commentreport` varchar(1000) DEFAULT NULL,
  `lrq_commentinternal` varchar(1000) DEFAULT NULL,
  `lrq_age` varchar(50) DEFAULT NULL,
  `lrq_ageyear` int(11) DEFAULT NULL,
  `lrq_agemonth` int(11) DEFAULT NULL,
  `lrq_ageday` int(11) DEFAULT NULL,
  `lrq_cost` decimal(12,4) DEFAULT NULL,
  `lrq_price` decimal(12,4) DEFAULT NULL,
  `lrq_isaccount` varchar(1) DEFAULT NULL,
  `lrq_unaccountby` varchar(10) DEFAULT NULL,
  `lrq_unaccountdatetime` datetime DEFAULT NULL,
  `lrq_isstatusoutlab` varchar(1) DEFAULT NULL,
  `lrq_isstatuspending` varchar(1) DEFAULT NULL,
  `lrq_isstatusreceive` varchar(1) DEFAULT NULL,
  `lrq_isstatusanalyse` varchar(1) DEFAULT NULL,
  `lrq_isstatusrepeat` varchar(1) DEFAULT NULL,
  `lrq_isstatusresult` varchar(1) DEFAULT NULL,
  `lrq_isstatusreport` varchar(1) DEFAULT NULL,
  `lrq_isstatusapprove` varchar(1) DEFAULT NULL,
  `lrq_iscritical` varchar(1) DEFAULT NULL,
  `lrq_isobject` varchar(1) DEFAULT NULL,
  `lrq_isexcel` varchar(1) DEFAULT NULL,
  `lrq_iscolab` varchar(1) DEFAULT NULL,
  `lrq_exportnapplus` varchar(1) DEFAULT NULL,
  `lrq_issinglesection` varchar(1) DEFAULT NULL,
  `lrq_isimportraxgeniuslis` varchar(1) DEFAULT NULL,
  `lrq_importraxgeniuslisdatetime` datetime DEFAULT NULL,
  `lrq_ispopuppatientchange` varchar(1) DEFAULT NULL,
  `lrq_popuppatientchangemessage` varchar(1000) DEFAULT NULL,
  `lrq_checkindatetime` datetime DEFAULT NULL,
  `lrq_receivedatetime` datetime DEFAULT NULL,
  `lrq_expectdatetime` datetime DEFAULT NULL,
  `lrq_standardtime` varchar(1000) DEFAULT NULL,
  `lrq_approvetime` varchar(1000) DEFAULT NULL,
  `lrq_statusd2d` varchar(1) DEFAULT NULL,
  `lrq_istransfer` varchar(1) DEFAULT NULL,
  `lrq_transferdatetime` datetime DEFAULT NULL,
  `lrq_isdelete` varchar(1) DEFAULT NULL,
  `lrq_deleteby` varchar(10) DEFAULT NULL,
  `lrq_deletedatetime` datetime DEFAULT NULL,
  `lrq_quadtemp` varchar(50) DEFAULT NULL,
  `lrq_recordcreatedatetime` datetime DEFAULT NULL,
  `lrq_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`lrq_no`),
  KEY `idx_labrequest_lrq_ctm_no` (`lrq_ctm_no`),
  KEY `idx_labrequest_lrq_pt_no` (`lrq_pt_no`),
  KEY `idx_labrequest_lrq_requestno` (`lrq_requestno`),
  KEY `idx_labrequest_lrq_requestby` (`lrq_requestby`),
  KEY `idx_labrequest_lrq_requestdatetime` (`lrq_requestdatetime`),
  KEY `idx_labrequest_lrq_w_no` (`lrq_w_no`),
  KEY `idx_labrequest_lrq_dt_no` (`lrq_dt_no`),
  KEY `idx_labrequest_lrq_r_no` (`lrq_r_no`),
  KEY `idx_labrequest_lrq_interfacecode` (`lrq_interfacecode`),
  KEY `idx_labrequest_lrq_ln` (`lrq_ln`),
  KEY `idx_labrequest_lrq_cpn_no` (`lrq_cpn_no`),
  KEY `idx_labrequest_lrq_ojt_no` (`lrq_ojt_no`),
  CONSTRAINT `fk_labrequest_lrq_cpn_no` FOREIGN KEY (`lrq_cpn_no`) REFERENCES `company` (`cpn_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_labrequest_lrq_ctm_no` FOREIGN KEY (`lrq_ctm_no`) REFERENCES `customer` (`ctm_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_labrequest_lrq_dt_no` FOREIGN KEY (`lrq_dt_no`) REFERENCES `doctor` (`dt_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_labrequest_lrq_ojt_no` FOREIGN KEY (`lrq_ojt_no`) REFERENCES `objective` (`ojt_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_labrequest_lrq_pt_no` FOREIGN KEY (`lrq_pt_no`) REFERENCES `patient` (`pt_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_labrequest_lrq_r_no` FOREIGN KEY (`lrq_r_no`) REFERENCES `rights` (`r_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_labrequest_lrq_w_no` FOREIGN KEY (`lrq_w_no`) REFERENCES `ward` (`w_no`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.labsection definition

CREATE TABLE `labsection` (
  `lst_no` varchar(20) NOT NULL,
  `lst_lrq_no` varchar(20) DEFAULT NULL,
  `lst_st_no` varchar(10) DEFAULT NULL,
  `lst_isstatusoutlab` varchar(1) DEFAULT NULL,
  `lst_isstatuspending` varchar(1) DEFAULT NULL,
  `lst_isstatusreceive` varchar(1) DEFAULT NULL,
  `lst_isstatusanalyse` varchar(1) DEFAULT NULL,
  `lst_isstatusrepeat` varchar(1) DEFAULT NULL,
  `lst_isstatusresult` varchar(1) DEFAULT NULL,
  `lst_isstatusreport` varchar(1) DEFAULT NULL,
  `lst_isstatusapprove` varchar(1) DEFAULT NULL,
  `lst_iscritical` varchar(1) DEFAULT NULL,
  `lst_isobject` varchar(1) DEFAULT NULL,
  `lst_isexcel` varchar(1) DEFAULT NULL,
  `lst_iscolab` varchar(1) DEFAULT NULL,
  `lst_exportnapplus` varchar(1) DEFAULT NULL,
  `lst_receivedatetime` datetime DEFAULT NULL,
  `lst_isdelete` varchar(1) DEFAULT NULL,
  `lst_deleteby` varchar(10) DEFAULT NULL,
  `lst_deletedatetime` datetime DEFAULT NULL,
  `lst_recordcreatedatetime` datetime DEFAULT NULL,
  `lst_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`lst_no`),
  KEY `idx_labsection_lst_lrq_no` (`lst_lrq_no`),
  KEY `idx_labsection_lst_st_no` (`lst_st_no`),
  CONSTRAINT `fk_labsection_lst_lrq_no` FOREIGN KEY (`lst_lrq_no`) REFERENCES `labrequest` (`lrq_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_labsection_lst_st_no` FOREIGN KEY (`lst_st_no`) REFERENCES `section` (`st_no`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.labspecimen definition

CREATE TABLE `labspecimen` (
  `lsp_no` varchar(20) NOT NULL,
  `lsp_lrq_no` varchar(20) DEFAULT NULL,
  `lsp_spm_no` varchar(10) DEFAULT NULL,
  `lsp_spt_no` varchar(10) DEFAULT NULL,
  `lsp_collectdatetime` varchar(50) DEFAULT NULL,
  `lsp_barcodeno` varchar(30) DEFAULT NULL,
  `lsp_specimennote` varchar(500) DEFAULT NULL,
  `lsp_location` varchar(1) DEFAULT NULL,
  `lsp_iscritical` varchar(1) DEFAULT NULL,
  `lsp_isobject` varchar(1) DEFAULT NULL,
  `lsp_isexcel` varchar(1) DEFAULT NULL,
  `lsp_iscolab` varchar(1) DEFAULT NULL,
  `lsp_exportnapplus` varchar(1) DEFAULT NULL,
  `lsp_statusexportraxgeniuslis` varchar(1) DEFAULT NULL,
  `lsp_exportraxgeniuslisdatetime` datetime DEFAULT NULL,
  `lsp_ischeckin` varchar(1) DEFAULT NULL,
  `lsp_checkinby` varchar(10) DEFAULT NULL,
  `lsp_checkindatetime` datetime DEFAULT NULL,
  `lsp_isreceive` varchar(1) DEFAULT NULL,
  `lsp_receiveby` varchar(10) DEFAULT NULL,
  `lsp_receivedatetime` datetime DEFAULT NULL,
  `lsp_isincident` varchar(1) DEFAULT NULL,
  `lsp_incidentby` varchar(10) DEFAULT NULL,
  `lsp_incidentdatetime` datetime DEFAULT NULL,
  `lsp_isreject` varchar(1) DEFAULT NULL,
  `lsp_rejectby` varchar(10) DEFAULT NULL,
  `lsp_rejectdatetime` datetime DEFAULT NULL,
  `lsp_isstatusoutlab` varchar(1) DEFAULT NULL,
  `lsp_isstatuspending` varchar(1) DEFAULT NULL,
  `lsp_isstatusreceive` varchar(1) DEFAULT NULL,
  `lsp_isstatusanalyse` varchar(1) DEFAULT NULL,
  `lsp_isstatusrepeat` varchar(1) DEFAULT NULL,
  `lsp_isstatusresult` varchar(1) DEFAULT NULL,
  `lsp_isstatusreport` varchar(1) DEFAULT NULL,
  `lsp_isstatusapprove` varchar(1) DEFAULT NULL,
  `lsp_isdelete` varchar(1) DEFAULT NULL,
  `lsp_deleteby` varchar(10) DEFAULT NULL,
  `lsp_deletedatetime` datetime DEFAULT NULL,
  `lsp_recordcreatedatetime` datetime DEFAULT NULL,
  `lsp_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`lsp_no`),
  KEY `idx_labspecimen_lsp_lrq_no` (`lsp_lrq_no`),
  KEY `idx_labspecimen_lsp_spm_no` (`lsp_spm_no`),
  KEY `idx_labspecimen_lsp_barcodeno` (`lsp_barcodeno`),
  KEY `idx_labspecimen_lsp_checkinby` (`lsp_checkinby`),
  KEY `idx_labspecimen_lsp_checkindatetime` (`lsp_checkindatetime`),
  KEY `idx_labspecimen_lsp_receiveby` (`lsp_receiveby`),
  KEY `idx_labspecimen_lsp_receivedatetime` (`lsp_receivedatetime`),
  KEY `idx_labspecimen_lsp_incidentby` (`lsp_incidentby`),
  KEY `idx_labspecimen_lsp_incidentdatetime` (`lsp_incidentdatetime`),
  KEY `idx_labspecimen_lsp_rejectby` (`lsp_rejectby`),
  KEY `idx_labspecimen_lsp_rejectdatetime` (`lsp_rejectdatetime`),
  KEY `idx_labspecimen_lsp_spt_no` (`lsp_spt_no`),
  CONSTRAINT `fk_labspecimen_lsp_lrq_no` FOREIGN KEY (`lsp_lrq_no`) REFERENCES `labrequest` (`lrq_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_labspecimen_lsp_spm_no` FOREIGN KEY (`lsp_spm_no`) REFERENCES `specimen` (`spm_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_labspecimen_lsp_spt_no` FOREIGN KEY (`lsp_spt_no`) REFERENCES `specimentype` (`spt_no`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.labtest definition

CREATE TABLE `labtest` (
  `lt_no` varchar(20) NOT NULL,
  `lt_lsp_no` varchar(20) DEFAULT NULL,
  `lt_lrq_no` varchar(20) DEFAULT NULL,
  `lt_t_no` varchar(10) DEFAULT NULL,
  `lt_st_no` varchar(10) DEFAULT NULL,
  `lt_l_no` varchar(10) DEFAULT NULL,
  `lt_issendoutlab` varchar(1) DEFAULT NULL,
  `lt_sendoutlabby` varchar(10) DEFAULT NULL,
  `lt_sendoutlabdatetime` datetime DEFAULT NULL,
  `lt_isprofile` varchar(1) DEFAULT NULL,
  `lt_lpf_no` varchar(20) DEFAULT NULL,
  `lt_isprice` varchar(1) DEFAULT NULL,
  `lt_accountcode` varchar(50) DEFAULT NULL,
  `lt_accountname` varchar(100) DEFAULT NULL,
  `lt_cost` decimal(12,4) DEFAULT NULL,
  `lt_price` decimal(12,4) DEFAULT NULL,
  `lt_isaccount` varchar(1) DEFAULT NULL,
  `lt_unaccountby` varchar(10) DEFAULT NULL,
  `lt_unaccountdatetime` datetime DEFAULT NULL,
  `lt_outlabstatus` varchar(1) DEFAULT NULL,
  `lt_isreject` varchar(1) DEFAULT NULL,
  `lt_rejectby` varchar(10) DEFAULT NULL,
  `lt_rejectdatetime` datetime DEFAULT NULL,
  `lt_ispreview` varchar(1) DEFAULT NULL,
  `lt_isrepeat` varchar(1) DEFAULT NULL,
  `lt_repeatcount` int(11) DEFAULT NULL,
  `lt_analysedatetime` datetime DEFAULT NULL,
  `lt_resultdatetime` datetime DEFAULT NULL,
  `lt_reportdatetime` datetime DEFAULT NULL,
  `lt_approvedatetime` datetime DEFAULT NULL,
  `lt_isunapprove` varchar(1) DEFAULT NULL,
  `lt_unapprovedatetime` datetime DEFAULT NULL,
  `lt_alltime` int(11) DEFAULT NULL,
  `lt_labtime` int(11) DEFAULT NULL,
  `lt_createtype` varchar(1) DEFAULT NULL,
  `lt_issenddashboard` varchar(1) DEFAULT NULL,
  `lt_senddashboarderrorcount` int(11) DEFAULT NULL,
  `lt_isdelete` varchar(1) DEFAULT NULL,
  `lt_deleteby` varchar(10) DEFAULT NULL,
  `lt_deletedatetime` datetime DEFAULT NULL,
  `lt_recordcreatedatetime` datetime DEFAULT NULL,
  `lt_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`lt_no`),
  KEY `idx_labtest_lt_lsp_no` (`lt_lsp_no`),
  KEY `idx_labtest_lt_lrq_no` (`lt_lrq_no`),
  KEY `idx_labtest_lt_t_no` (`lt_t_no`),
  KEY `idx_labtest_lt_st_no` (`lt_st_no`),
  KEY `idx_labtest_lt_l_no` (`lt_l_no`),
  KEY `idx_labtest_lt_sendoutlabby` (`lt_sendoutlabby`),
  KEY `idx_labtest_lt_sendoutlabdatetime` (`lt_sendoutlabdatetime`),
  KEY `idx_labtest_lt_lpf_no` (`lt_lpf_no`),
  CONSTRAINT `fk_labtest_lt_l_no` FOREIGN KEY (`lt_l_no`) REFERENCES `lab` (`l_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_labtest_lt_lsp_no` FOREIGN KEY (`lt_lsp_no`) REFERENCES `labspecimen` (`lsp_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_labtest_lt_st_no` FOREIGN KEY (`lt_st_no`) REFERENCES `section` (`st_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_labtest_lt_t_no` FOREIGN KEY (`lt_t_no`) REFERENCES `test` (`t_no`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.labtestreject definition

CREATE TABLE `labtestreject` (
  `ltr_no` varchar(20) NOT NULL,
  `ltr_lt_no` varchar(20) DEFAULT NULL,
  `ltr_lsp_no` varchar(20) DEFAULT NULL,
  `ltr_lrq_no` varchar(20) DEFAULT NULL,
  `ltr_rj_no` varchar(10) DEFAULT NULL,
  `ltr_comment` varchar(1000) DEFAULT NULL,
  `ltr_rejectby` varchar(10) DEFAULT NULL,
  `ltr_rejectdatetime` datetime DEFAULT NULL,
  `ltr_recordcreatedatetime` datetime DEFAULT NULL,
  `ltr_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`ltr_no`),
  KEY `idx_labtestreject_ltr_lt_no` (`ltr_lt_no`),
  KEY `idx_labtestreject_ltr_lsp_no` (`ltr_lsp_no`),
  KEY `idx_labtestreject_ltr_lrq_no` (`ltr_lrq_no`),
  KEY `idx_labtestreject_ltr_rj_no` (`ltr_rj_no`),
  KEY `idx_labtestreject_ltr_rejectby` (`ltr_rejectby`),
  KEY `idx_labtestreject_ltr_rejectdatetime` (`ltr_rejectdatetime`),
  CONSTRAINT `fk_labtestreject_ltr_lt_no` FOREIGN KEY (`ltr_lt_no`) REFERENCES `labtest` (`lt_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_labtestreject_ltr_rj_no` FOREIGN KEY (`ltr_rj_no`) REFERENCES `reject` (`rj_no`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.profilejointest definition

CREATE TABLE `profilejointest` (
  `pjt_no` varchar(10) NOT NULL,
  `pjt_pf_no` varchar(10) DEFAULT NULL,
  `pjt_t_no` varchar(10) DEFAULT NULL,
  `pjt_recordcreateby` varchar(10) DEFAULT NULL,
  `pjt_recordcreatedatetime` datetime DEFAULT NULL,
  `pjt_recordupdateby` varchar(10) DEFAULT NULL,
  `pjt_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`pjt_no`),
  KEY `idx_profilejointest_pjt_pf_no` (`pjt_pf_no`),
  KEY `idx_profilejointest_pjt_t_no` (`pjt_t_no`),
  CONSTRAINT `fk_profilejointest_pjt_pf_no` FOREIGN KEY (`pjt_pf_no`) REFERENCES `profile` (`pf_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_profilejointest_pjt_t_no` FOREIGN KEY (`pjt_t_no`) REFERENCES `test` (`t_no`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.sectionlabreceive definition

CREATE TABLE `sectionlabreceive` (
  `slr_no` varchar(20) NOT NULL,
  `slr_st_no` varchar(10) DEFAULT NULL,
  `slr_us_no` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`slr_no`),
  KEY `idx_sectionlabreceive_slr_st_no` (`slr_st_no`),
  KEY `idx_sectionlabreceive_slr_us_no` (`slr_us_no`),
  CONSTRAINT `fk_sectionlabreceive_slr_st_no` FOREIGN KEY (`slr_st_no`) REFERENCES `section` (`st_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_sectionlabreceive_slr_us_no` FOREIGN KEY (`slr_us_no`) REFERENCES `users` (`us_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.sectionlabresult definition

CREATE TABLE `sectionlabresult` (
  `slr_no` varchar(20) NOT NULL,
  `slr_st_no` varchar(10) DEFAULT NULL,
  `slr_us_no` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`slr_no`),
  KEY `idx_sectionlabresult_slr_st_no` (`slr_st_no`),
  KEY `idx_sectionlabresult_slr_us_no` (`slr_us_no`),
  CONSTRAINT `fk_sectionlabresult_slr_st_no` FOREIGN KEY (`slr_st_no`) REFERENCES `section` (`st_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_sectionlabresult_slr_us_no` FOREIGN KEY (`slr_us_no`) REFERENCES `users` (`us_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.userjoincustomer definition

CREATE TABLE `userjoincustomer` (
  `ujc_no` varchar(10) NOT NULL,
  `ujc_us_no` varchar(10) DEFAULT NULL,
  `ujc_ctm_no` varchar(10) DEFAULT NULL,
  `ujc_recordcreateby` varchar(10) DEFAULT NULL,
  `ujc_recordcreatedatetime` datetime DEFAULT NULL,
  `ujc_recordupdateby` varchar(10) DEFAULT NULL,
  `ujc_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`ujc_no`),
  KEY `idx_userjoincustomer_ujc_us_no` (`ujc_us_no`),
  KEY `idx_userjoincustomer_ujc_ctm_no` (`ujc_ctm_no`),
  CONSTRAINT `fk_userjoincustomer_ujc_ctm_no` FOREIGN KEY (`ujc_ctm_no`) REFERENCES `customer` (`ctm_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_userjoincustomer_ujc_us_no` FOREIGN KEY (`ujc_us_no`) REFERENCES `users` (`us_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.userjoinsection definition

CREATE TABLE `userjoinsection` (
  `ujs_no` varchar(10) NOT NULL,
  `ujs_us_no` varchar(10) DEFAULT NULL,
  `ujs_st_no` varchar(10) DEFAULT NULL,
  `ujs_recordcreateby` varchar(10) DEFAULT NULL,
  `ujs_recordcreatedatetime` datetime DEFAULT NULL,
  `ujs_recordupdateby` varchar(10) DEFAULT NULL,
  `ujs_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`ujs_no`),
  KEY `idx_userjoinsection_ujs_us_no` (`ujs_us_no`),
  KEY `idx_userjoinsection_ujs_st_no` (`ujs_st_no`),
  CONSTRAINT `fk_userjoinsection_ujs_st_no` FOREIGN KEY (`ujs_st_no`) REFERENCES `section` (`st_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_userjoinsection_ujs_us_no` FOREIGN KEY (`ujs_us_no`) REFERENCES `users` (`us_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.userjointest definition

CREATE TABLE `userjointest` (
  `ujt_no` varchar(10) NOT NULL,
  `ujt_us_no` varchar(10) DEFAULT NULL,
  `ujt_t_no` varchar(10) DEFAULT NULL,
  `ujt_recordcreateby` varchar(10) DEFAULT NULL,
  `ujt_recordcreatedatetime` datetime DEFAULT NULL,
  `ujt_recordupdateby` varchar(10) DEFAULT NULL,
  `ujt_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`ujt_no`),
  KEY `idx_userjointest_ujt_us_no` (`ujt_us_no`),
  KEY `idx_userjointest_ujt_t_no` (`ujt_t_no`),
  CONSTRAINT `fk_userjointest_ujt_t_no` FOREIGN KEY (`ujt_t_no`) REFERENCES `test` (`t_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_userjointest_ujt_us_no` FOREIGN KEY (`ujt_us_no`) REFERENCES `users` (`us_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.userjoinward definition

CREATE TABLE `userjoinward` (
  `ujw_no` varchar(10) NOT NULL,
  `ujw_us_no` varchar(10) DEFAULT NULL,
  `ujw_w_no` varchar(10) DEFAULT NULL,
  `ujw_recordcreateby` varchar(10) DEFAULT NULL,
  `ujw_recordcreatedatetime` datetime DEFAULT NULL,
  `ujw_recordupdateby` varchar(10) DEFAULT NULL,
  `ujw_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`ujw_no`),
  KEY `idx_userjoinward_ujw_us_no` (`ujw_us_no`),
  KEY `idx_userjoinward_ujw_w_no` (`ujw_w_no`),
  CONSTRAINT `fk_userjoinward_ujw_us_no` FOREIGN KEY (`ujw_us_no`) REFERENCES `users` (`us_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_userjoinward_ujw_w_no` FOREIGN KEY (`ujw_w_no`) REFERENCES `ward` (`w_no`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.`0_labincident` definition

CREATE TABLE `0_labincident` (
  `lic_no` varchar(20) NOT NULL,
  `lic_lsp_no` varchar(20) DEFAULT NULL,
  `lic_lrq_no` varchar(20) DEFAULT NULL,
  `lic_icd_no` varchar(10) DEFAULT NULL,
  `lic_comment` varchar(1000) DEFAULT NULL,
  `lic_incidentby` varchar(10) DEFAULT NULL,
  `lic_incidentdatetime` datetime DEFAULT NULL,
  `lic_recordcreatedatetime` datetime DEFAULT NULL,
  `lic_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`lic_no`),
  KEY `idx_0_labincident_lic_lsp_no` (`lic_lsp_no`),
  KEY `idx_0_labincident_lic_lrq_no` (`lic_lrq_no`),
  KEY `idx_0_labincident_lic_icd_no` (`lic_icd_no`),
  KEY `idx_0_labincident_lic_incidentby` (`lic_incidentby`),
  KEY `idx_0_labincident_lic_incidentdatetime` (`lic_incidentdatetime`),
  CONSTRAINT `fk_0_labincident_lic_icd_no` FOREIGN KEY (`lic_icd_no`) REFERENCES `incident` (`icd_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_0_labincident_lic_lsp_no` FOREIGN KEY (`lic_lsp_no`) REFERENCES `0_labspecimen` (`lsp_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.`0_labprofile` definition

CREATE TABLE `0_labprofile` (
  `lpf_no` varchar(20) NOT NULL,
  `lpf_lrq_no` varchar(20) DEFAULT NULL,
  `lpf_pf_no` varchar(10) DEFAULT NULL,
  `lpf_isprice` varchar(1) DEFAULT NULL,
  `lpf_accountcode` varchar(50) DEFAULT NULL,
  `lpf_cost` decimal(12,4) DEFAULT NULL,
  `lpf_price` decimal(12,4) DEFAULT NULL,
  `lpf_isdelete` varchar(1) DEFAULT NULL,
  `lpf_deleteby` varchar(10) DEFAULT NULL,
  `lpf_deletedatetime` datetime DEFAULT NULL,
  `lpf_recordcreatedatetime` datetime DEFAULT NULL,
  `lpf_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`lpf_no`),
  KEY `idx_0_labprofile_lpf_lrq_no` (`lpf_lrq_no`),
  KEY `idx_0_labprofile_lpf_pf_no` (`lpf_pf_no`),
  CONSTRAINT `fk_0_labprofile_lpf_lrq_no` FOREIGN KEY (`lpf_lrq_no`) REFERENCES `0_labrequest` (`lrq_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_0_labprofile_lpf_pf_no` FOREIGN KEY (`lpf_pf_no`) REFERENCES `profile` (`pf_no`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.`0_labreject` definition

CREATE TABLE `0_labreject` (
  `lrj_no` varchar(20) NOT NULL,
  `lrj_lsp_no` varchar(20) DEFAULT NULL,
  `lrj_lrq_no` varchar(20) DEFAULT NULL,
  `lrj_rj_no` varchar(10) DEFAULT NULL,
  `lrj_comment` varchar(1000) DEFAULT NULL,
  `lrj_rejectby` varchar(10) DEFAULT NULL,
  `lrj_rejectdatetime` datetime DEFAULT NULL,
  `lrj_recordcreatedatetime` datetime DEFAULT NULL,
  `lrj_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`lrj_no`),
  KEY `idx_0_labreject_lrj_lsp_no` (`lrj_lsp_no`),
  KEY `idx_0_labreject_lrj_lrq_no` (`lrj_lrq_no`),
  KEY `idx_0_labreject_lrj_rj_no` (`lrj_rj_no`),
  KEY `idx_0_labreject_lrj_rejectby` (`lrj_rejectby`),
  KEY `idx_0_labreject_lrj_rejectdatetime` (`lrj_rejectdatetime`),
  CONSTRAINT `fk_0_labreject_lrj_lsp_no` FOREIGN KEY (`lrj_lsp_no`) REFERENCES `0_labspecimen` (`lsp_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_0_labreject_lrj_rj_no` FOREIGN KEY (`lrj_rj_no`) REFERENCES `reject` (`rj_no`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.`0_labresult` definition

CREATE TABLE `0_labresult` (
  `lrs_no` varchar(20) NOT NULL,
  `lrs_lt_no` varchar(20) DEFAULT NULL,
  `lrs_lsp_no` varchar(20) DEFAULT NULL,
  `lrs_lrq_no` varchar(20) DEFAULT NULL,
  `lrs_prm_no` varchar(10) DEFAULT NULL,
  `lrs_status` varchar(1) DEFAULT NULL,
  `lrs_result` varchar(1000) DEFAULT NULL,
  `lrs_flagresult` varchar(2) DEFAULT NULL,
  `lrs_flagalert` varchar(2) DEFAULT NULL,
  `lrs_un_no` varchar(10) DEFAULT NULL,
  `lrs_normalrange` varchar(100) DEFAULT NULL,
  `lrs_instrumenttype` varchar(1) DEFAULT NULL,
  `lrs_itm_no` varchar(10) DEFAULT NULL,
  `lrs_flaginstrument` varchar(100) DEFAULT NULL,
  `lrs_isrepeat` varchar(1) DEFAULT NULL,
  `lrs_isedit` varchar(1) DEFAULT NULL,
  `lrs_isobject` varchar(1) DEFAULT NULL,
  `lrs_isexcel` varchar(1) DEFAULT NULL,
  `lrs_statusnapplus` varchar(1) DEFAULT NULL,
  `lrs_nappluscomment` varchar(500) DEFAULT NULL,
  `lrs_iscritical` varchar(1) DEFAULT NULL,
  `lrs_ctc_no` varchar(20) DEFAULT NULL,
  `lrs_lastresult1` varchar(1000) DEFAULT NULL,
  `lrs_lastresult1datetime` varchar(30) DEFAULT NULL,
  `lrs_lastresult2` varchar(1000) DEFAULT NULL,
  `lrs_lastresult2datetime` varchar(30) DEFAULT NULL,
  `lrs_lastresult3` varchar(1000) DEFAULT NULL,
  `lrs_lastresult3datetime` varchar(30) DEFAULT NULL,
  `lrs_statusdeltacheck` varchar(1) DEFAULT NULL,
  `lrs_deltacheckvalue` varchar(30) DEFAULT NULL,
  `lrs_comment` varchar(1000) DEFAULT NULL,
  `lrs_reportgroup` varchar(1) DEFAULT NULL,
  `lrs_isanalyse` varchar(1) DEFAULT NULL,
  `lrs_analysedatetime` datetime DEFAULT NULL,
  `lrs_isresult` varchar(1) DEFAULT NULL,
  `lrs_resultby` varchar(10) DEFAULT NULL,
  `lrs_resultdatetime` datetime DEFAULT NULL,
  `lrs_isreport` varchar(1) DEFAULT NULL,
  `lrs_reportby` varchar(10) DEFAULT NULL,
  `lrs_reportdatetime` datetime DEFAULT NULL,
  `lrs_isapprove` varchar(1) DEFAULT NULL,
  `lrs_approveby` varchar(10) DEFAULT NULL,
  `lrs_approvedatetime` datetime DEFAULT NULL,
  `lrs_isunapprove` varchar(1) DEFAULT NULL,
  `lrs_unapproveby` varchar(10) DEFAULT NULL,
  `lrs_unapprovedatetime` datetime DEFAULT NULL,
  `lrs_isinterpret` varchar(1) DEFAULT NULL,
  `lrs_interpretresult` varchar(1000) DEFAULT NULL,
  `lrs_atmstatus` varchar(4) DEFAULT NULL,
  `lrs_alltime` int(11) DEFAULT NULL,
  `lrs_labtime` int(11) DEFAULT NULL,
  `lrs_elr_no` varchar(20) DEFAULT NULL,
  `lrs_ep_no` varchar(20) DEFAULT NULL,
  `lrs_epl_no` varchar(20) DEFAULT NULL,
  `lrs_epc_no` varchar(20) DEFAULT NULL,
  `lrs_epcl_no` varchar(20) DEFAULT NULL,
  `lrs_epnp_no` varchar(20) DEFAULT NULL,
  `lrs_ehie_no` varchar(20) DEFAULT NULL,
  `lrs_istransfer` varchar(1) DEFAULT NULL,
  `lrs_createtype` varchar(1) DEFAULT NULL,
  `lrs_isdelete` varchar(1) DEFAULT NULL,
  `lrs_deleteby` varchar(10) DEFAULT NULL,
  `lrs_deletedatetime` datetime DEFAULT NULL,
  `lrs_recordcreatedatetime` datetime DEFAULT NULL,
  `lrs_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`lrs_no`),
  KEY `idx_0_labresult_lrs_lt_no` (`lrs_lt_no`),
  KEY `idx_0_labresult_lrs_lsp_no` (`lrs_lsp_no`),
  KEY `idx_0_labresult_lrs_lrq_no` (`lrs_lrq_no`),
  KEY `idx_0_labresult_lrs_prm_no` (`lrs_prm_no`),
  KEY `idx_0_labresult_lrs_un_no` (`lrs_un_no`),
  KEY `idx_0_labresult_lrs_itm_no` (`lrs_itm_no`),
  KEY `idx_0_labresult_lrs_analysedatetime` (`lrs_analysedatetime`),
  KEY `idx_0_labresult_lrs_resultby` (`lrs_resultby`),
  KEY `idx_0_labresult_lrs_resultdatetime` (`lrs_resultdatetime`),
  KEY `idx_0_labresult_lrs_reportby` (`lrs_reportby`),
  KEY `idx_0_labresult_lrs_reportdatetime` (`lrs_reportdatetime`),
  KEY `idx_0_labresult_lrs_approveby` (`lrs_approveby`),
  KEY `idx_0_labresult_lrs_approvedatetime` (`lrs_approvedatetime`),
  KEY `idx_0_labresult_lrs_ep_no` (`lrs_ep_no`),
  CONSTRAINT `fk_0_labresult_lrs_itm_no` FOREIGN KEY (`lrs_itm_no`) REFERENCES `instrument` (`itm_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_0_labresult_lrs_lt_no` FOREIGN KEY (`lrs_lt_no`) REFERENCES `0_labtest` (`lt_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_0_labresult_lrs_prm_no` FOREIGN KEY (`lrs_prm_no`) REFERENCES `parameter` (`prm_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_0_labresult_lrs_un_no` FOREIGN KEY (`lrs_un_no`) REFERENCES `unit` (`un_no`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.`0_labresultedit` definition

CREATE TABLE `0_labresultedit` (
  `lre_no` varchar(20) NOT NULL,
  `lre_lrs_no` varchar(20) DEFAULT NULL,
  `lre_lt_no` varchar(20) DEFAULT NULL,
  `lre_lsp_no` varchar(20) DEFAULT NULL,
  `lre_lrq_no` varchar(20) DEFAULT NULL,
  `lre_itm_no` varchar(10) DEFAULT NULL,
  `lre_type` varchar(1) DEFAULT NULL,
  `lre_oldresult` varchar(1000) DEFAULT NULL,
  `lre_newresult` varchar(1000) DEFAULT NULL,
  `lre_editby` varchar(10) DEFAULT NULL,
  `lre_editdatetime` datetime DEFAULT NULL,
  `lre_recordcreatedatetime` datetime DEFAULT NULL,
  `lre_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`lre_no`),
  KEY `idx_0_labresultedit_lre_lrs_no` (`lre_lrs_no`),
  KEY `idx_0_labresultedit_lre_lt_no` (`lre_lt_no`),
  KEY `idx_0_labresultedit_lre_lsp_no` (`lre_lsp_no`),
  KEY `idx_0_labresultedit_lre_lrq_no` (`lre_lrq_no`),
  KEY `idx_0_labresultedit_lre_itm_no` (`lre_itm_no`),
  KEY `idx_0_labresultedit_lre_editby` (`lre_editby`),
  KEY `idx_0_labresultedit_lre_editdatetime` (`lre_editdatetime`),
  CONSTRAINT `fx_0_labresultedit_lre_itm_no` FOREIGN KEY (`lre_itm_no`) REFERENCES `instrument` (`itm_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fx_0_labresultedit_lre_lrs_no` FOREIGN KEY (`lre_lrs_no`) REFERENCES `0_labresult` (`lrs_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.customerinterfaceparameter definition

CREATE TABLE `customerinterfaceparameter` (
  `cip_no` varchar(10) NOT NULL,
  `cip_cjt_no` varchar(10) DEFAULT NULL,
  `cip_prm_no` varchar(10) DEFAULT NULL,
  `cip_interfacecode` varchar(50) DEFAULT NULL,
  `cip_recordcreateby` varchar(10) DEFAULT NULL,
  `cip_recordcreatedatetime` datetime DEFAULT NULL,
  `cip_recordupdateby` varchar(10) DEFAULT NULL,
  `cip_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`cip_no`),
  KEY `idx_customerinterfaceparameter_cip_prm_no` (`cip_prm_no`),
  KEY `idx_customerinterfaceparameter_cip_cjt_no` (`cip_cjt_no`),
  CONSTRAINT `fk_customerinterfaceparameter_cip_cjt_no` FOREIGN KEY (`cip_cjt_no`) REFERENCES `customerjointest` (`cjt_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_customerinterfaceparameter_cip_prm_no` FOREIGN KEY (`cip_prm_no`) REFERENCES `parameter` (`prm_no`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.labincident definition

CREATE TABLE `labincident` (
  `lic_no` varchar(20) NOT NULL,
  `lic_lsp_no` varchar(20) DEFAULT NULL,
  `lic_lrq_no` varchar(20) DEFAULT NULL,
  `lic_icd_no` varchar(10) DEFAULT NULL,
  `lic_comment` varchar(1000) DEFAULT NULL,
  `lic_incidentby` varchar(10) DEFAULT NULL,
  `lic_incidentdatetime` datetime DEFAULT NULL,
  `lic_recordcreatedatetime` datetime DEFAULT NULL,
  `lic_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`lic_no`),
  KEY `idx_labincident_lic_lsp_no` (`lic_lsp_no`),
  KEY `idx_labincident_lic_lrq_no` (`lic_lrq_no`),
  KEY `idx_labincident_lic_icd_no` (`lic_icd_no`),
  KEY `idx_labincident_lic_incidentby` (`lic_incidentby`),
  KEY `idx_labincident_lic_incidentdatetime` (`lic_incidentdatetime`),
  CONSTRAINT `fk_labincident_lic_icd_no` FOREIGN KEY (`lic_icd_no`) REFERENCES `incident` (`icd_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_labincident_lic_lsp_no` FOREIGN KEY (`lic_lsp_no`) REFERENCES `labspecimen` (`lsp_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.labprofile definition

CREATE TABLE `labprofile` (
  `lpf_no` varchar(20) NOT NULL,
  `lpf_lrq_no` varchar(20) DEFAULT NULL,
  `lpf_pf_no` varchar(10) DEFAULT NULL,
  `lpf_isprice` varchar(1) DEFAULT NULL,
  `lpf_accountcode` varchar(50) DEFAULT NULL,
  `lpf_cost` decimal(12,4) DEFAULT NULL,
  `lpf_price` decimal(12,4) DEFAULT NULL,
  `lpf_isdelete` varchar(1) DEFAULT NULL,
  `lpf_deleteby` varchar(10) DEFAULT NULL,
  `lpf_deletedatetime` datetime DEFAULT NULL,
  `lpf_recordcreatedatetime` datetime DEFAULT NULL,
  `lpf_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`lpf_no`),
  KEY `idx_labprofile_lpf_lrq_no` (`lpf_lrq_no`),
  KEY `idx_labprofile_lpf_pf_no` (`lpf_pf_no`),
  CONSTRAINT `fk_labprofile_lpf_lrq_no` FOREIGN KEY (`lpf_lrq_no`) REFERENCES `labrequest` (`lrq_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_labprofile_lpf_pf_no` FOREIGN KEY (`lpf_pf_no`) REFERENCES `profile` (`pf_no`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.labreject definition

CREATE TABLE `labreject` (
  `lrj_no` varchar(20) NOT NULL,
  `lrj_lsp_no` varchar(20) DEFAULT NULL,
  `lrj_lrq_no` varchar(20) DEFAULT NULL,
  `lrj_rj_no` varchar(10) DEFAULT NULL,
  `lrj_comment` varchar(1000) DEFAULT NULL,
  `lrj_rejectby` varchar(10) DEFAULT NULL,
  `lrj_rejectdatetime` datetime DEFAULT NULL,
  `lrj_recordcreatedatetime` datetime DEFAULT NULL,
  `lrj_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`lrj_no`),
  KEY `idx_labreject_lrj_lsp_no` (`lrj_lsp_no`),
  KEY `idx_labreject_lrj_lrq_no` (`lrj_lrq_no`),
  KEY `idx_labreject_lrj_rj_no` (`lrj_rj_no`),
  KEY `idx_labreject_lrj_rejectby` (`lrj_rejectby`),
  KEY `idx_labreject_lrj_rejectdatetime` (`lrj_rejectdatetime`),
  CONSTRAINT `fk_labreject_lrj_lsp_no` FOREIGN KEY (`lrj_lsp_no`) REFERENCES `labspecimen` (`lsp_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_labreject_lrj_rj_no` FOREIGN KEY (`lrj_rj_no`) REFERENCES `reject` (`rj_no`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.labresult definition

CREATE TABLE `labresult` (
  `lrs_no` varchar(20) NOT NULL,
  `lrs_lt_no` varchar(20) DEFAULT NULL,
  `lrs_lsp_no` varchar(20) DEFAULT NULL,
  `lrs_lrq_no` varchar(20) DEFAULT NULL,
  `lrs_prm_no` varchar(10) DEFAULT NULL,
  `lrs_status` varchar(1) DEFAULT NULL,
  `lrs_result` varchar(1000) DEFAULT NULL,
  `lrs_flagresult` varchar(2) DEFAULT NULL,
  `lrs_flagalert` varchar(2) DEFAULT NULL,
  `lrs_un_no` varchar(10) DEFAULT NULL,
  `lrs_normalrange` varchar(100) DEFAULT NULL,
  `lrs_instrumenttype` varchar(1) DEFAULT NULL,
  `lrs_itm_no` varchar(10) DEFAULT NULL,
  `lrs_flaginstrument` varchar(100) DEFAULT NULL,
  `lrs_isrepeat` varchar(1) DEFAULT NULL,
  `lrs_isedit` varchar(1) DEFAULT NULL,
  `lrs_isobject` varchar(1) DEFAULT NULL,
  `lrs_isexcel` varchar(1) DEFAULT NULL,
  `lrs_statusnapplus` varchar(1) DEFAULT NULL,
  `lrs_nappluscomment` varchar(500) DEFAULT NULL,
  `lrs_iscritical` varchar(1) DEFAULT NULL,
  `lrs_ctc_no` varchar(20) DEFAULT NULL,
  `lrs_lastresult1` varchar(1000) DEFAULT NULL,
  `lrs_lastresult1datetime` varchar(30) DEFAULT NULL,
  `lrs_lastresult2` varchar(1000) DEFAULT NULL,
  `lrs_lastresult2datetime` varchar(30) DEFAULT NULL,
  `lrs_lastresult3` varchar(1000) DEFAULT NULL,
  `lrs_lastresult3datetime` varchar(30) DEFAULT NULL,
  `lrs_statusdeltacheck` varchar(1) DEFAULT NULL,
  `lrs_deltacheckvalue` varchar(30) DEFAULT NULL,
  `lrs_comment` varchar(1000) DEFAULT NULL,
  `lrs_reportgroup` varchar(1) DEFAULT NULL,
  `lrs_isanalyse` varchar(1) DEFAULT NULL,
  `lrs_analysedatetime` datetime DEFAULT NULL,
  `lrs_isresult` varchar(1) DEFAULT NULL,
  `lrs_resultby` varchar(10) DEFAULT NULL,
  `lrs_resultdatetime` datetime DEFAULT NULL,
  `lrs_isreport` varchar(1) DEFAULT NULL,
  `lrs_reportby` varchar(10) DEFAULT NULL,
  `lrs_reportdatetime` datetime DEFAULT NULL,
  `lrs_isapprove` varchar(1) DEFAULT NULL,
  `lrs_approveby` varchar(10) DEFAULT NULL,
  `lrs_approvedatetime` datetime DEFAULT NULL,
  `lrs_isunapprove` varchar(1) DEFAULT NULL,
  `lrs_unapproveby` varchar(10) DEFAULT NULL,
  `lrs_unapprovedatetime` datetime DEFAULT NULL,
  `lrs_isinterpret` varchar(1) DEFAULT NULL,
  `lrs_interpretresult` varchar(1000) DEFAULT NULL,
  `lrs_atmstatus` varchar(4) DEFAULT NULL,
  `lrs_alltime` int(11) DEFAULT NULL,
  `lrs_labtime` int(11) DEFAULT NULL,
  `lrs_elr_no` varchar(20) DEFAULT NULL,
  `lrs_ep_no` varchar(20) DEFAULT NULL,
  `lrs_epl_no` varchar(20) DEFAULT NULL,
  `lrs_epc_no` varchar(20) DEFAULT NULL,
  `lrs_epcl_no` varchar(20) DEFAULT NULL,
  `lrs_epnp_no` varchar(20) DEFAULT NULL,
  `lrs_ehie_no` varchar(20) DEFAULT NULL,
  `lrs_istransfer` varchar(1) DEFAULT NULL,
  `lrs_createtype` varchar(1) DEFAULT NULL,
  `lrs_isdelete` varchar(1) DEFAULT NULL,
  `lrs_deleteby` varchar(10) DEFAULT NULL,
  `lrs_deletedatetime` datetime DEFAULT NULL,
  `lrs_recordcreatedatetime` datetime DEFAULT NULL,
  `lrs_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`lrs_no`),
  KEY `idx_labresult_lrs_lt_no` (`lrs_lt_no`),
  KEY `idx_labresult_lrs_lsp_no` (`lrs_lsp_no`),
  KEY `idx_labresult_lrs_lrq_no` (`lrs_lrq_no`),
  KEY `idx_labresult_lrs_prm_no` (`lrs_prm_no`),
  KEY `idx_labresult_lrs_status` (`lrs_status`),
  KEY `idx_labresult_lrs_un_no` (`lrs_un_no`),
  KEY `idx_labresult_lrs_itm_no` (`lrs_itm_no`),
  KEY `idx_labresult_lrs_analysedatetime` (`lrs_analysedatetime`),
  KEY `idx_labresult_lrs_resultby` (`lrs_resultby`),
  KEY `idx_labresult_lrs_resultdatetime` (`lrs_resultdatetime`),
  KEY `idx_labresult_lrs_reportby` (`lrs_reportby`),
  KEY `idx_labresult_lrs_reportdatetime` (`lrs_reportdatetime`),
  KEY `idx_labresult_lrs_approveby` (`lrs_approveby`),
  KEY `idx_labresult_lrs_approvedatetime` (`lrs_approvedatetime`),
  KEY `idx_labresult_lrs_ep_no` (`lrs_ep_no`),
  CONSTRAINT `fk_labresult_lrs_itm_no` FOREIGN KEY (`lrs_itm_no`) REFERENCES `instrument` (`itm_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_labresult_lrs_lt_no` FOREIGN KEY (`lrs_lt_no`) REFERENCES `labtest` (`lt_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_labresult_lrs_prm_no` FOREIGN KEY (`lrs_prm_no`) REFERENCES `parameter` (`prm_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_labresult_lrs_un_no` FOREIGN KEY (`lrs_un_no`) REFERENCES `unit` (`un_no`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.labresultedit definition

CREATE TABLE `labresultedit` (
  `lre_no` varchar(20) NOT NULL,
  `lre_lrs_no` varchar(20) DEFAULT NULL,
  `lre_lt_no` varchar(20) DEFAULT NULL,
  `lre_lsp_no` varchar(20) DEFAULT NULL,
  `lre_lrq_no` varchar(20) DEFAULT NULL,
  `lre_itm_no` varchar(10) DEFAULT NULL,
  `lre_type` varchar(1) DEFAULT NULL,
  `lre_oldresult` varchar(1000) DEFAULT NULL,
  `lre_newresult` varchar(1000) DEFAULT NULL,
  `lre_editby` varchar(10) DEFAULT NULL,
  `lre_editdatetime` datetime DEFAULT NULL,
  `lre_recordcreatedatetime` datetime DEFAULT NULL,
  `lre_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`lre_no`),
  KEY `idx_labresultedit_lre_lrs_no` (`lre_lrs_no`),
  KEY `idx_labresultedit_lre_lt_no` (`lre_lt_no`),
  KEY `idx_labresultedit_lre_lsp_no` (`lre_lsp_no`),
  KEY `idx_labresultedit_lre_lrq_no` (`lre_lrq_no`),
  KEY `idx_labresultedit_lre_itm_no` (`lre_itm_no`),
  KEY `idx_labresultedit_lre_editby` (`lre_editby`),
  KEY `idx_labresultedit_lre_editdatetime` (`lre_editdatetime`),
  CONSTRAINT `fk_labresultedit_lre_itm_no` FOREIGN KEY (`lre_itm_no`) REFERENCES `instrument` (`itm_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_labresultedit_lre_lrs_no` FOREIGN KEY (`lre_lrs_no`) REFERENCES `labresult` (`lrs_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.`0_labrepeat` definition

CREATE TABLE `0_labrepeat` (
  `lrp_no` varchar(20) NOT NULL,
  `lrp_lrs_no` varchar(20) DEFAULT NULL,
  `lrp_lrq_no` varchar(20) DEFAULT NULL,
  `lrp_itm_no` varchar(10) DEFAULT NULL,
  `lrp_result` varchar(1000) DEFAULT NULL,
  `lrp_repeatdatetime` datetime DEFAULT NULL,
  `lrp_recordcreatedatetime` datetime DEFAULT NULL,
  `lrp_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`lrp_no`),
  KEY `idx_0_labrepeat_lrp_lrs_no` (`lrp_lrs_no`),
  KEY `idx_0_labrepeat_lrp_lrq_no` (`lrp_lrq_no`),
  KEY `idx_0_labrepeat_lrp_itm_no` (`lrp_itm_no`),
  KEY `idx_0_labrepeat_lrp_repeatdatetime` (`lrp_repeatdatetime`),
  CONSTRAINT `fk_0_labrepeat_lrp_itm_no` FOREIGN KEY (`lrp_itm_no`) REFERENCES `instrument` (`itm_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_0_labrepeat_lrp_lrs_no` FOREIGN KEY (`lrp_lrs_no`) REFERENCES `0_labresult` (`lrs_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;


-- pctag.labrepeat definition

CREATE TABLE `labrepeat` (
  `lrp_no` varchar(20) NOT NULL,
  `lrp_lrs_no` varchar(20) DEFAULT NULL,
  `lrp_lrq_no` varchar(20) DEFAULT NULL,
  `lrp_itm_no` varchar(10) DEFAULT NULL,
  `lrp_result` varchar(1000) DEFAULT NULL,
  `lrp_repeatdatetime` datetime DEFAULT NULL,
  `lrp_recordcreatedatetime` datetime DEFAULT NULL,
  `lrp_recordupdatedatetime` datetime DEFAULT NULL,
  PRIMARY KEY (`lrp_no`),
  KEY `idx_labrepeat_lrp_lrs_no` (`lrp_lrs_no`),
  KEY `idx_labrepeat_lrp_lrq_no` (`lrp_lrq_no`),
  KEY `idx_labrepeat_lrp_itm_no` (`lrp_itm_no`),
  KEY `idx_labrepeat_lrp_repeatdatetime` (`lrp_repeatdatetime`),
  CONSTRAINT `fk_labrepeat_lrp_itm_no` FOREIGN KEY (`lrp_itm_no`) REFERENCES `instrument` (`itm_no`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_labrepeat_lrp_lrs_no` FOREIGN KEY (`lrp_lrs_no`) REFERENCES `labresult` (`lrs_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=tis620;