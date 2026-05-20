# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0" -display_name {CORE}]
  set_property tooltip {CORE} ${Page_0}
  ipgui::add_param $IPINST -name "WORD_BITS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "INDEX_BITS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "COMP_SIGN" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SORT_ORDER" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MRG_WAYS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MRG_WORDS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "STM_FEEDBACK" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SORT_SIZE_BITS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MRG_FIFO_SIZE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "STM_IN_QUEUE_SIZE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DEBUG_ENABLE" -parent ${Page_0}

  #Adding Page
  set STM-AXI [ipgui::add_page $IPINST -name "STM-AXI"]
  #Adding Group
  set AXI_I/F [ipgui::add_group $IPINST -name "AXI I/F" -parent ${STM-AXI}]
  ipgui::add_param $IPINST -name "STM_AXI_ADDR_WIDTH" -parent ${AXI_I/F}
  ipgui::add_param $IPINST -name "STM_AXI_DATA_WIDTH" -parent ${AXI_I/F}
  ipgui::add_param $IPINST -name "STM_AXI_USER_WIDTH" -parent ${AXI_I/F}
  ipgui::add_param $IPINST -name "STM_AXI_ID_WIDTH" -parent ${AXI_I/F}
  ipgui::add_param $IPINST -name "STM_AXI_ID_BASE" -parent ${AXI_I/F}

  #Adding Group
  set READ [ipgui::add_group $IPINST -name "READ" -parent ${STM-AXI}]
  ipgui::add_param $IPINST -name "STM_RD_AXI_XFER_SIZE" -parent ${READ}
  ipgui::add_param $IPINST -name "STM_RD_AXI_BUF_SIZE" -parent ${READ}
  ipgui::add_param $IPINST -name "STM_RD_AXI_QUEUE" -parent ${READ}
  ipgui::add_param $IPINST -name "STM_RD_AXI_DATA_REGS" -parent ${READ}
  ipgui::add_param $IPINST -name "STM_RD_AXI_ACK_REGS" -parent ${READ}

  #Adding Group
  set WRITE [ipgui::add_group $IPINST -name "WRITE" -parent ${STM-AXI}]
  ipgui::add_param $IPINST -name "STM_WR_AXI_XFER_SIZE" -parent ${WRITE}
  ipgui::add_param $IPINST -name "STM_WR_AXI_BUF_SIZE" -parent ${WRITE}
  ipgui::add_param $IPINST -name "STM_WR_AXI_QUEUE" -parent ${WRITE}
  ipgui::add_param $IPINST -name "STM_WR_AXI_REQ_REGS" -parent ${WRITE}
  ipgui::add_param $IPINST -name "STM_WR_AXI_ACK_REGS" -parent ${WRITE}
  ipgui::add_param $IPINST -name "STM_WR_AXI_RESP_REGS" -parent ${WRITE}


  #Adding Page
  set MRG-AXI [ipgui::add_page $IPINST -name "MRG-AXI"]
  #Adding Group
  set AXI_I/F [ipgui::add_group $IPINST -name "AXI I/F" -parent ${MRG-AXI}]
  ipgui::add_param $IPINST -name "MRG_AXI_ADDR_WIDTH" -parent ${AXI_I/F}
  ipgui::add_param $IPINST -name "MRG_AXI_DATA_WIDTH" -parent ${AXI_I/F}
  ipgui::add_param $IPINST -name "MRG_AXI_USER_WIDTH" -parent ${AXI_I/F}
  ipgui::add_param $IPINST -name "MRG_AXI_ID_WIDTH" -parent ${AXI_I/F}
  ipgui::add_param $IPINST -name "MRG_AXI_ID_BASE" -parent ${AXI_I/F}

  #Adding Group
  set READ [ipgui::add_group $IPINST -name "READ" -parent ${MRG-AXI}]
  ipgui::add_param $IPINST -name "MRG_RD_AXI_XFER_SIZE" -parent ${READ}
  ipgui::add_param $IPINST -name "MRG_RD_AXI_BUF_SIZE" -parent ${READ}
  ipgui::add_param $IPINST -name "MRG_RD_AXI_QUEUE" -parent ${READ}
  ipgui::add_param $IPINST -name "MRG_RD_AXI_ACK_REGS" -parent ${READ}
  ipgui::add_param $IPINST -name "MRG_RD_AXI_DATA_REGS" -parent ${READ}
  ipgui::add_param $IPINST -name "MRG_RD_ARB_NODE_NUM" -parent ${READ}
  ipgui::add_param $IPINST -name "MRG_RD_ARB_PIPELINE" -parent ${READ}
  ipgui::add_param $IPINST -name "MRG_RD_PRE_STATE" -parent ${READ}

  #Adding Group
  set WRITE [ipgui::add_group $IPINST -name "WRITE" -parent ${MRG-AXI}]
  ipgui::add_param $IPINST -name "MRG_WR_AXI_XFER_SIZE" -parent ${WRITE}
  ipgui::add_param $IPINST -name "MRG_WR_AXI_BUF_SIZE" -parent ${WRITE}
  ipgui::add_param $IPINST -name "MRG_WR_AXI_QUEUE" -parent ${WRITE}
  ipgui::add_param $IPINST -name "MRG_WR_AXI_REQ_REGS" -parent ${WRITE}
  ipgui::add_param $IPINST -name "MRG_WR_AXI_ACK_REGS" -parent ${WRITE}
  ipgui::add_param $IPINST -name "MRG_WR_AXI_RESP_REGS" -parent ${WRITE}


  #Adding Page
  set CSR-AXI [ipgui::add_page $IPINST -name "CSR-AXI"]
  #Adding Group
  set AXI_I/F [ipgui::add_group $IPINST -name "AXI I/F" -parent ${CSR-AXI}]
  ipgui::add_param $IPINST -name "CSR_AXI_ADDR_WIDTH" -parent ${AXI_I/F}
  ipgui::add_param $IPINST -name "CSR_AXI_DATA_WIDTH" -parent ${AXI_I/F}



}

proc update_PARAM_VALUE.COMP_SIGN { PARAM_VALUE.COMP_SIGN } {
	# Procedure called to update COMP_SIGN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.COMP_SIGN { PARAM_VALUE.COMP_SIGN } {
	# Procedure called to validate COMP_SIGN
	return true
}

proc update_PARAM_VALUE.CSR_AXI_ADDR_WIDTH { PARAM_VALUE.CSR_AXI_ADDR_WIDTH } {
	# Procedure called to update CSR_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CSR_AXI_ADDR_WIDTH { PARAM_VALUE.CSR_AXI_ADDR_WIDTH } {
	# Procedure called to validate CSR_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.CSR_AXI_DATA_WIDTH { PARAM_VALUE.CSR_AXI_DATA_WIDTH } {
	# Procedure called to update CSR_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CSR_AXI_DATA_WIDTH { PARAM_VALUE.CSR_AXI_DATA_WIDTH } {
	# Procedure called to validate CSR_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.DEBUG_ENABLE { PARAM_VALUE.DEBUG_ENABLE } {
	# Procedure called to update DEBUG_ENABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DEBUG_ENABLE { PARAM_VALUE.DEBUG_ENABLE } {
	# Procedure called to validate DEBUG_ENABLE
	return true
}

proc update_PARAM_VALUE.INDEX_BITS { PARAM_VALUE.INDEX_BITS } {
	# Procedure called to update INDEX_BITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.INDEX_BITS { PARAM_VALUE.INDEX_BITS } {
	# Procedure called to validate INDEX_BITS
	return true
}

proc update_PARAM_VALUE.MRG_AXI_ADDR_WIDTH { PARAM_VALUE.MRG_AXI_ADDR_WIDTH } {
	# Procedure called to update MRG_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MRG_AXI_ADDR_WIDTH { PARAM_VALUE.MRG_AXI_ADDR_WIDTH } {
	# Procedure called to validate MRG_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.MRG_AXI_DATA_WIDTH { PARAM_VALUE.MRG_AXI_DATA_WIDTH } {
	# Procedure called to update MRG_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MRG_AXI_DATA_WIDTH { PARAM_VALUE.MRG_AXI_DATA_WIDTH } {
	# Procedure called to validate MRG_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.MRG_AXI_ID_BASE { PARAM_VALUE.MRG_AXI_ID_BASE } {
	# Procedure called to update MRG_AXI_ID_BASE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MRG_AXI_ID_BASE { PARAM_VALUE.MRG_AXI_ID_BASE } {
	# Procedure called to validate MRG_AXI_ID_BASE
	return true
}

proc update_PARAM_VALUE.MRG_AXI_ID_WIDTH { PARAM_VALUE.MRG_AXI_ID_WIDTH } {
	# Procedure called to update MRG_AXI_ID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MRG_AXI_ID_WIDTH { PARAM_VALUE.MRG_AXI_ID_WIDTH } {
	# Procedure called to validate MRG_AXI_ID_WIDTH
	return true
}

proc update_PARAM_VALUE.MRG_AXI_USER_WIDTH { PARAM_VALUE.MRG_AXI_USER_WIDTH } {
	# Procedure called to update MRG_AXI_USER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MRG_AXI_USER_WIDTH { PARAM_VALUE.MRG_AXI_USER_WIDTH } {
	# Procedure called to validate MRG_AXI_USER_WIDTH
	return true
}

proc update_PARAM_VALUE.MRG_FIFO_SIZE { PARAM_VALUE.MRG_FIFO_SIZE } {
	# Procedure called to update MRG_FIFO_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MRG_FIFO_SIZE { PARAM_VALUE.MRG_FIFO_SIZE } {
	# Procedure called to validate MRG_FIFO_SIZE
	return true
}

proc update_PARAM_VALUE.MRG_RD_ARB_NODE_NUM { PARAM_VALUE.MRG_RD_ARB_NODE_NUM } {
	# Procedure called to update MRG_RD_ARB_NODE_NUM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MRG_RD_ARB_NODE_NUM { PARAM_VALUE.MRG_RD_ARB_NODE_NUM } {
	# Procedure called to validate MRG_RD_ARB_NODE_NUM
	return true
}

proc update_PARAM_VALUE.MRG_RD_ARB_PIPELINE { PARAM_VALUE.MRG_RD_ARB_PIPELINE } {
	# Procedure called to update MRG_RD_ARB_PIPELINE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MRG_RD_ARB_PIPELINE { PARAM_VALUE.MRG_RD_ARB_PIPELINE } {
	# Procedure called to validate MRG_RD_ARB_PIPELINE
	return true
}

proc update_PARAM_VALUE.MRG_RD_AXI_ACK_REGS { PARAM_VALUE.MRG_RD_AXI_ACK_REGS } {
	# Procedure called to update MRG_RD_AXI_ACK_REGS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MRG_RD_AXI_ACK_REGS { PARAM_VALUE.MRG_RD_AXI_ACK_REGS } {
	# Procedure called to validate MRG_RD_AXI_ACK_REGS
	return true
}

proc update_PARAM_VALUE.MRG_RD_AXI_BUF_SIZE { PARAM_VALUE.MRG_RD_AXI_BUF_SIZE } {
	# Procedure called to update MRG_RD_AXI_BUF_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MRG_RD_AXI_BUF_SIZE { PARAM_VALUE.MRG_RD_AXI_BUF_SIZE } {
	# Procedure called to validate MRG_RD_AXI_BUF_SIZE
	return true
}

proc update_PARAM_VALUE.MRG_RD_AXI_DATA_REGS { PARAM_VALUE.MRG_RD_AXI_DATA_REGS } {
	# Procedure called to update MRG_RD_AXI_DATA_REGS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MRG_RD_AXI_DATA_REGS { PARAM_VALUE.MRG_RD_AXI_DATA_REGS } {
	# Procedure called to validate MRG_RD_AXI_DATA_REGS
	return true
}

proc update_PARAM_VALUE.MRG_RD_AXI_QUEUE { PARAM_VALUE.MRG_RD_AXI_QUEUE } {
	# Procedure called to update MRG_RD_AXI_QUEUE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MRG_RD_AXI_QUEUE { PARAM_VALUE.MRG_RD_AXI_QUEUE } {
	# Procedure called to validate MRG_RD_AXI_QUEUE
	return true
}

proc update_PARAM_VALUE.MRG_RD_AXI_XFER_SIZE { PARAM_VALUE.MRG_RD_AXI_XFER_SIZE } {
	# Procedure called to update MRG_RD_AXI_XFER_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MRG_RD_AXI_XFER_SIZE { PARAM_VALUE.MRG_RD_AXI_XFER_SIZE } {
	# Procedure called to validate MRG_RD_AXI_XFER_SIZE
	return true
}

proc update_PARAM_VALUE.MRG_RD_PRE_STATE { PARAM_VALUE.MRG_RD_PRE_STATE } {
	# Procedure called to update MRG_RD_PRE_STATE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MRG_RD_PRE_STATE { PARAM_VALUE.MRG_RD_PRE_STATE } {
	# Procedure called to validate MRG_RD_PRE_STATE
	return true
}

proc update_PARAM_VALUE.MRG_WAYS { PARAM_VALUE.MRG_WAYS } {
	# Procedure called to update MRG_WAYS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MRG_WAYS { PARAM_VALUE.MRG_WAYS } {
	# Procedure called to validate MRG_WAYS
	return true
}

proc update_PARAM_VALUE.MRG_WORDS { PARAM_VALUE.MRG_WORDS } {
	# Procedure called to update MRG_WORDS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MRG_WORDS { PARAM_VALUE.MRG_WORDS } {
	# Procedure called to validate MRG_WORDS
	return true
}

proc update_PARAM_VALUE.MRG_WR_AXI_ACK_REGS { PARAM_VALUE.MRG_WR_AXI_ACK_REGS } {
	# Procedure called to update MRG_WR_AXI_ACK_REGS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MRG_WR_AXI_ACK_REGS { PARAM_VALUE.MRG_WR_AXI_ACK_REGS } {
	# Procedure called to validate MRG_WR_AXI_ACK_REGS
	return true
}

proc update_PARAM_VALUE.MRG_WR_AXI_BUF_SIZE { PARAM_VALUE.MRG_WR_AXI_BUF_SIZE } {
	# Procedure called to update MRG_WR_AXI_BUF_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MRG_WR_AXI_BUF_SIZE { PARAM_VALUE.MRG_WR_AXI_BUF_SIZE } {
	# Procedure called to validate MRG_WR_AXI_BUF_SIZE
	return true
}

proc update_PARAM_VALUE.MRG_WR_AXI_QUEUE { PARAM_VALUE.MRG_WR_AXI_QUEUE } {
	# Procedure called to update MRG_WR_AXI_QUEUE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MRG_WR_AXI_QUEUE { PARAM_VALUE.MRG_WR_AXI_QUEUE } {
	# Procedure called to validate MRG_WR_AXI_QUEUE
	return true
}

proc update_PARAM_VALUE.MRG_WR_AXI_REQ_REGS { PARAM_VALUE.MRG_WR_AXI_REQ_REGS } {
	# Procedure called to update MRG_WR_AXI_REQ_REGS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MRG_WR_AXI_REQ_REGS { PARAM_VALUE.MRG_WR_AXI_REQ_REGS } {
	# Procedure called to validate MRG_WR_AXI_REQ_REGS
	return true
}

proc update_PARAM_VALUE.MRG_WR_AXI_RESP_REGS { PARAM_VALUE.MRG_WR_AXI_RESP_REGS } {
	# Procedure called to update MRG_WR_AXI_RESP_REGS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MRG_WR_AXI_RESP_REGS { PARAM_VALUE.MRG_WR_AXI_RESP_REGS } {
	# Procedure called to validate MRG_WR_AXI_RESP_REGS
	return true
}

proc update_PARAM_VALUE.MRG_WR_AXI_XFER_SIZE { PARAM_VALUE.MRG_WR_AXI_XFER_SIZE } {
	# Procedure called to update MRG_WR_AXI_XFER_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MRG_WR_AXI_XFER_SIZE { PARAM_VALUE.MRG_WR_AXI_XFER_SIZE } {
	# Procedure called to validate MRG_WR_AXI_XFER_SIZE
	return true
}

proc update_PARAM_VALUE.SORT_ORDER { PARAM_VALUE.SORT_ORDER } {
	# Procedure called to update SORT_ORDER when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SORT_ORDER { PARAM_VALUE.SORT_ORDER } {
	# Procedure called to validate SORT_ORDER
	return true
}

proc update_PARAM_VALUE.SORT_SIZE_BITS { PARAM_VALUE.SORT_SIZE_BITS } {
	# Procedure called to update SORT_SIZE_BITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SORT_SIZE_BITS { PARAM_VALUE.SORT_SIZE_BITS } {
	# Procedure called to validate SORT_SIZE_BITS
	return true
}

proc update_PARAM_VALUE.STM_AXI_ADDR_WIDTH { PARAM_VALUE.STM_AXI_ADDR_WIDTH } {
	# Procedure called to update STM_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.STM_AXI_ADDR_WIDTH { PARAM_VALUE.STM_AXI_ADDR_WIDTH } {
	# Procedure called to validate STM_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.STM_AXI_DATA_WIDTH { PARAM_VALUE.STM_AXI_DATA_WIDTH } {
	# Procedure called to update STM_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.STM_AXI_DATA_WIDTH { PARAM_VALUE.STM_AXI_DATA_WIDTH } {
	# Procedure called to validate STM_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.STM_AXI_ID_BASE { PARAM_VALUE.STM_AXI_ID_BASE } {
	# Procedure called to update STM_AXI_ID_BASE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.STM_AXI_ID_BASE { PARAM_VALUE.STM_AXI_ID_BASE } {
	# Procedure called to validate STM_AXI_ID_BASE
	return true
}

proc update_PARAM_VALUE.STM_AXI_ID_WIDTH { PARAM_VALUE.STM_AXI_ID_WIDTH } {
	# Procedure called to update STM_AXI_ID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.STM_AXI_ID_WIDTH { PARAM_VALUE.STM_AXI_ID_WIDTH } {
	# Procedure called to validate STM_AXI_ID_WIDTH
	return true
}

proc update_PARAM_VALUE.STM_AXI_USER_WIDTH { PARAM_VALUE.STM_AXI_USER_WIDTH } {
	# Procedure called to update STM_AXI_USER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.STM_AXI_USER_WIDTH { PARAM_VALUE.STM_AXI_USER_WIDTH } {
	# Procedure called to validate STM_AXI_USER_WIDTH
	return true
}

proc update_PARAM_VALUE.STM_FEEDBACK { PARAM_VALUE.STM_FEEDBACK } {
	# Procedure called to update STM_FEEDBACK when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.STM_FEEDBACK { PARAM_VALUE.STM_FEEDBACK } {
	# Procedure called to validate STM_FEEDBACK
	return true
}

proc update_PARAM_VALUE.STM_IN_QUEUE_SIZE { PARAM_VALUE.STM_IN_QUEUE_SIZE } {
	# Procedure called to update STM_IN_QUEUE_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.STM_IN_QUEUE_SIZE { PARAM_VALUE.STM_IN_QUEUE_SIZE } {
	# Procedure called to validate STM_IN_QUEUE_SIZE
	return true
}

proc update_PARAM_VALUE.STM_RD_AXI_ACK_REGS { PARAM_VALUE.STM_RD_AXI_ACK_REGS } {
	# Procedure called to update STM_RD_AXI_ACK_REGS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.STM_RD_AXI_ACK_REGS { PARAM_VALUE.STM_RD_AXI_ACK_REGS } {
	# Procedure called to validate STM_RD_AXI_ACK_REGS
	return true
}

proc update_PARAM_VALUE.STM_RD_AXI_BUF_SIZE { PARAM_VALUE.STM_RD_AXI_BUF_SIZE } {
	# Procedure called to update STM_RD_AXI_BUF_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.STM_RD_AXI_BUF_SIZE { PARAM_VALUE.STM_RD_AXI_BUF_SIZE } {
	# Procedure called to validate STM_RD_AXI_BUF_SIZE
	return true
}

proc update_PARAM_VALUE.STM_RD_AXI_DATA_REGS { PARAM_VALUE.STM_RD_AXI_DATA_REGS } {
	# Procedure called to update STM_RD_AXI_DATA_REGS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.STM_RD_AXI_DATA_REGS { PARAM_VALUE.STM_RD_AXI_DATA_REGS } {
	# Procedure called to validate STM_RD_AXI_DATA_REGS
	return true
}

proc update_PARAM_VALUE.STM_RD_AXI_QUEUE { PARAM_VALUE.STM_RD_AXI_QUEUE } {
	# Procedure called to update STM_RD_AXI_QUEUE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.STM_RD_AXI_QUEUE { PARAM_VALUE.STM_RD_AXI_QUEUE } {
	# Procedure called to validate STM_RD_AXI_QUEUE
	return true
}

proc update_PARAM_VALUE.STM_RD_AXI_XFER_SIZE { PARAM_VALUE.STM_RD_AXI_XFER_SIZE } {
	# Procedure called to update STM_RD_AXI_XFER_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.STM_RD_AXI_XFER_SIZE { PARAM_VALUE.STM_RD_AXI_XFER_SIZE } {
	# Procedure called to validate STM_RD_AXI_XFER_SIZE
	return true
}

proc update_PARAM_VALUE.STM_WR_AXI_ACK_REGS { PARAM_VALUE.STM_WR_AXI_ACK_REGS } {
	# Procedure called to update STM_WR_AXI_ACK_REGS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.STM_WR_AXI_ACK_REGS { PARAM_VALUE.STM_WR_AXI_ACK_REGS } {
	# Procedure called to validate STM_WR_AXI_ACK_REGS
	return true
}

proc update_PARAM_VALUE.STM_WR_AXI_BUF_SIZE { PARAM_VALUE.STM_WR_AXI_BUF_SIZE } {
	# Procedure called to update STM_WR_AXI_BUF_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.STM_WR_AXI_BUF_SIZE { PARAM_VALUE.STM_WR_AXI_BUF_SIZE } {
	# Procedure called to validate STM_WR_AXI_BUF_SIZE
	return true
}

proc update_PARAM_VALUE.STM_WR_AXI_QUEUE { PARAM_VALUE.STM_WR_AXI_QUEUE } {
	# Procedure called to update STM_WR_AXI_QUEUE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.STM_WR_AXI_QUEUE { PARAM_VALUE.STM_WR_AXI_QUEUE } {
	# Procedure called to validate STM_WR_AXI_QUEUE
	return true
}

proc update_PARAM_VALUE.STM_WR_AXI_REQ_REGS { PARAM_VALUE.STM_WR_AXI_REQ_REGS } {
	# Procedure called to update STM_WR_AXI_REQ_REGS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.STM_WR_AXI_REQ_REGS { PARAM_VALUE.STM_WR_AXI_REQ_REGS } {
	# Procedure called to validate STM_WR_AXI_REQ_REGS
	return true
}

proc update_PARAM_VALUE.STM_WR_AXI_RESP_REGS { PARAM_VALUE.STM_WR_AXI_RESP_REGS } {
	# Procedure called to update STM_WR_AXI_RESP_REGS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.STM_WR_AXI_RESP_REGS { PARAM_VALUE.STM_WR_AXI_RESP_REGS } {
	# Procedure called to validate STM_WR_AXI_RESP_REGS
	return true
}

proc update_PARAM_VALUE.STM_WR_AXI_XFER_SIZE { PARAM_VALUE.STM_WR_AXI_XFER_SIZE } {
	# Procedure called to update STM_WR_AXI_XFER_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.STM_WR_AXI_XFER_SIZE { PARAM_VALUE.STM_WR_AXI_XFER_SIZE } {
	# Procedure called to validate STM_WR_AXI_XFER_SIZE
	return true
}

proc update_PARAM_VALUE.WORD_BITS { PARAM_VALUE.WORD_BITS } {
	# Procedure called to update WORD_BITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WORD_BITS { PARAM_VALUE.WORD_BITS } {
	# Procedure called to validate WORD_BITS
	return true
}


proc update_MODELPARAM_VALUE.MRG_WAYS { MODELPARAM_VALUE.MRG_WAYS PARAM_VALUE.MRG_WAYS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MRG_WAYS}] ${MODELPARAM_VALUE.MRG_WAYS}
}

proc update_MODELPARAM_VALUE.MRG_WORDS { MODELPARAM_VALUE.MRG_WORDS PARAM_VALUE.MRG_WORDS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MRG_WORDS}] ${MODELPARAM_VALUE.MRG_WORDS}
}

proc update_MODELPARAM_VALUE.WORD_BITS { MODELPARAM_VALUE.WORD_BITS PARAM_VALUE.WORD_BITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WORD_BITS}] ${MODELPARAM_VALUE.WORD_BITS}
}

proc update_MODELPARAM_VALUE.INDEX_BITS { MODELPARAM_VALUE.INDEX_BITS PARAM_VALUE.INDEX_BITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INDEX_BITS}] ${MODELPARAM_VALUE.INDEX_BITS}
}

proc update_MODELPARAM_VALUE.COMP_SIGN { MODELPARAM_VALUE.COMP_SIGN PARAM_VALUE.COMP_SIGN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.COMP_SIGN}] ${MODELPARAM_VALUE.COMP_SIGN}
}

proc update_MODELPARAM_VALUE.SORT_ORDER { MODELPARAM_VALUE.SORT_ORDER PARAM_VALUE.SORT_ORDER } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SORT_ORDER}] ${MODELPARAM_VALUE.SORT_ORDER}
}

proc update_MODELPARAM_VALUE.SORT_SIZE_BITS { MODELPARAM_VALUE.SORT_SIZE_BITS PARAM_VALUE.SORT_SIZE_BITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SORT_SIZE_BITS}] ${MODELPARAM_VALUE.SORT_SIZE_BITS}
}

proc update_MODELPARAM_VALUE.MRG_FIFO_SIZE { MODELPARAM_VALUE.MRG_FIFO_SIZE PARAM_VALUE.MRG_FIFO_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MRG_FIFO_SIZE}] ${MODELPARAM_VALUE.MRG_FIFO_SIZE}
}

proc update_MODELPARAM_VALUE.STM_FEEDBACK { MODELPARAM_VALUE.STM_FEEDBACK PARAM_VALUE.STM_FEEDBACK } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.STM_FEEDBACK}] ${MODELPARAM_VALUE.STM_FEEDBACK}
}

proc update_MODELPARAM_VALUE.STM_IN_QUEUE_SIZE { MODELPARAM_VALUE.STM_IN_QUEUE_SIZE PARAM_VALUE.STM_IN_QUEUE_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.STM_IN_QUEUE_SIZE}] ${MODELPARAM_VALUE.STM_IN_QUEUE_SIZE}
}

proc update_MODELPARAM_VALUE.CSR_AXI_ADDR_WIDTH { MODELPARAM_VALUE.CSR_AXI_ADDR_WIDTH PARAM_VALUE.CSR_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CSR_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.CSR_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.CSR_AXI_DATA_WIDTH { MODELPARAM_VALUE.CSR_AXI_DATA_WIDTH PARAM_VALUE.CSR_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CSR_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.CSR_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.STM_AXI_ADDR_WIDTH { MODELPARAM_VALUE.STM_AXI_ADDR_WIDTH PARAM_VALUE.STM_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.STM_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.STM_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.STM_AXI_DATA_WIDTH { MODELPARAM_VALUE.STM_AXI_DATA_WIDTH PARAM_VALUE.STM_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.STM_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.STM_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.STM_AXI_ID_WIDTH { MODELPARAM_VALUE.STM_AXI_ID_WIDTH PARAM_VALUE.STM_AXI_ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.STM_AXI_ID_WIDTH}] ${MODELPARAM_VALUE.STM_AXI_ID_WIDTH}
}

proc update_MODELPARAM_VALUE.STM_AXI_USER_WIDTH { MODELPARAM_VALUE.STM_AXI_USER_WIDTH PARAM_VALUE.STM_AXI_USER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.STM_AXI_USER_WIDTH}] ${MODELPARAM_VALUE.STM_AXI_USER_WIDTH}
}

proc update_MODELPARAM_VALUE.STM_AXI_ID_BASE { MODELPARAM_VALUE.STM_AXI_ID_BASE PARAM_VALUE.STM_AXI_ID_BASE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.STM_AXI_ID_BASE}] ${MODELPARAM_VALUE.STM_AXI_ID_BASE}
}

proc update_MODELPARAM_VALUE.STM_RD_AXI_XFER_SIZE { MODELPARAM_VALUE.STM_RD_AXI_XFER_SIZE PARAM_VALUE.STM_RD_AXI_XFER_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.STM_RD_AXI_XFER_SIZE}] ${MODELPARAM_VALUE.STM_RD_AXI_XFER_SIZE}
}

proc update_MODELPARAM_VALUE.STM_RD_AXI_BUF_SIZE { MODELPARAM_VALUE.STM_RD_AXI_BUF_SIZE PARAM_VALUE.STM_RD_AXI_BUF_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.STM_RD_AXI_BUF_SIZE}] ${MODELPARAM_VALUE.STM_RD_AXI_BUF_SIZE}
}

proc update_MODELPARAM_VALUE.STM_RD_AXI_QUEUE { MODELPARAM_VALUE.STM_RD_AXI_QUEUE PARAM_VALUE.STM_RD_AXI_QUEUE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.STM_RD_AXI_QUEUE}] ${MODELPARAM_VALUE.STM_RD_AXI_QUEUE}
}

proc update_MODELPARAM_VALUE.STM_RD_AXI_DATA_REGS { MODELPARAM_VALUE.STM_RD_AXI_DATA_REGS PARAM_VALUE.STM_RD_AXI_DATA_REGS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.STM_RD_AXI_DATA_REGS}] ${MODELPARAM_VALUE.STM_RD_AXI_DATA_REGS}
}

proc update_MODELPARAM_VALUE.STM_RD_AXI_ACK_REGS { MODELPARAM_VALUE.STM_RD_AXI_ACK_REGS PARAM_VALUE.STM_RD_AXI_ACK_REGS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.STM_RD_AXI_ACK_REGS}] ${MODELPARAM_VALUE.STM_RD_AXI_ACK_REGS}
}

proc update_MODELPARAM_VALUE.STM_WR_AXI_XFER_SIZE { MODELPARAM_VALUE.STM_WR_AXI_XFER_SIZE PARAM_VALUE.STM_WR_AXI_XFER_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.STM_WR_AXI_XFER_SIZE}] ${MODELPARAM_VALUE.STM_WR_AXI_XFER_SIZE}
}

proc update_MODELPARAM_VALUE.STM_WR_AXI_BUF_SIZE { MODELPARAM_VALUE.STM_WR_AXI_BUF_SIZE PARAM_VALUE.STM_WR_AXI_BUF_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.STM_WR_AXI_BUF_SIZE}] ${MODELPARAM_VALUE.STM_WR_AXI_BUF_SIZE}
}

proc update_MODELPARAM_VALUE.STM_WR_AXI_QUEUE { MODELPARAM_VALUE.STM_WR_AXI_QUEUE PARAM_VALUE.STM_WR_AXI_QUEUE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.STM_WR_AXI_QUEUE}] ${MODELPARAM_VALUE.STM_WR_AXI_QUEUE}
}

proc update_MODELPARAM_VALUE.STM_WR_AXI_REQ_REGS { MODELPARAM_VALUE.STM_WR_AXI_REQ_REGS PARAM_VALUE.STM_WR_AXI_REQ_REGS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.STM_WR_AXI_REQ_REGS}] ${MODELPARAM_VALUE.STM_WR_AXI_REQ_REGS}
}

proc update_MODELPARAM_VALUE.STM_WR_AXI_ACK_REGS { MODELPARAM_VALUE.STM_WR_AXI_ACK_REGS PARAM_VALUE.STM_WR_AXI_ACK_REGS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.STM_WR_AXI_ACK_REGS}] ${MODELPARAM_VALUE.STM_WR_AXI_ACK_REGS}
}

proc update_MODELPARAM_VALUE.STM_WR_AXI_RESP_REGS { MODELPARAM_VALUE.STM_WR_AXI_RESP_REGS PARAM_VALUE.STM_WR_AXI_RESP_REGS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.STM_WR_AXI_RESP_REGS}] ${MODELPARAM_VALUE.STM_WR_AXI_RESP_REGS}
}

proc update_MODELPARAM_VALUE.MRG_AXI_ADDR_WIDTH { MODELPARAM_VALUE.MRG_AXI_ADDR_WIDTH PARAM_VALUE.MRG_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MRG_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.MRG_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.MRG_AXI_DATA_WIDTH { MODELPARAM_VALUE.MRG_AXI_DATA_WIDTH PARAM_VALUE.MRG_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MRG_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.MRG_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.MRG_AXI_ID_WIDTH { MODELPARAM_VALUE.MRG_AXI_ID_WIDTH PARAM_VALUE.MRG_AXI_ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MRG_AXI_ID_WIDTH}] ${MODELPARAM_VALUE.MRG_AXI_ID_WIDTH}
}

proc update_MODELPARAM_VALUE.MRG_AXI_USER_WIDTH { MODELPARAM_VALUE.MRG_AXI_USER_WIDTH PARAM_VALUE.MRG_AXI_USER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MRG_AXI_USER_WIDTH}] ${MODELPARAM_VALUE.MRG_AXI_USER_WIDTH}
}

proc update_MODELPARAM_VALUE.MRG_AXI_ID_BASE { MODELPARAM_VALUE.MRG_AXI_ID_BASE PARAM_VALUE.MRG_AXI_ID_BASE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MRG_AXI_ID_BASE}] ${MODELPARAM_VALUE.MRG_AXI_ID_BASE}
}

proc update_MODELPARAM_VALUE.MRG_RD_AXI_XFER_SIZE { MODELPARAM_VALUE.MRG_RD_AXI_XFER_SIZE PARAM_VALUE.MRG_RD_AXI_XFER_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MRG_RD_AXI_XFER_SIZE}] ${MODELPARAM_VALUE.MRG_RD_AXI_XFER_SIZE}
}

proc update_MODELPARAM_VALUE.MRG_RD_AXI_BUF_SIZE { MODELPARAM_VALUE.MRG_RD_AXI_BUF_SIZE PARAM_VALUE.MRG_RD_AXI_BUF_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MRG_RD_AXI_BUF_SIZE}] ${MODELPARAM_VALUE.MRG_RD_AXI_BUF_SIZE}
}

proc update_MODELPARAM_VALUE.MRG_RD_AXI_QUEUE { MODELPARAM_VALUE.MRG_RD_AXI_QUEUE PARAM_VALUE.MRG_RD_AXI_QUEUE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MRG_RD_AXI_QUEUE}] ${MODELPARAM_VALUE.MRG_RD_AXI_QUEUE}
}

proc update_MODELPARAM_VALUE.MRG_RD_AXI_DATA_REGS { MODELPARAM_VALUE.MRG_RD_AXI_DATA_REGS PARAM_VALUE.MRG_RD_AXI_DATA_REGS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MRG_RD_AXI_DATA_REGS}] ${MODELPARAM_VALUE.MRG_RD_AXI_DATA_REGS}
}

proc update_MODELPARAM_VALUE.MRG_RD_AXI_ACK_REGS { MODELPARAM_VALUE.MRG_RD_AXI_ACK_REGS PARAM_VALUE.MRG_RD_AXI_ACK_REGS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MRG_RD_AXI_ACK_REGS}] ${MODELPARAM_VALUE.MRG_RD_AXI_ACK_REGS}
}

proc update_MODELPARAM_VALUE.MRG_RD_ARB_NODE_NUM { MODELPARAM_VALUE.MRG_RD_ARB_NODE_NUM PARAM_VALUE.MRG_RD_ARB_NODE_NUM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MRG_RD_ARB_NODE_NUM}] ${MODELPARAM_VALUE.MRG_RD_ARB_NODE_NUM}
}

proc update_MODELPARAM_VALUE.MRG_RD_ARB_PIPELINE { MODELPARAM_VALUE.MRG_RD_ARB_PIPELINE PARAM_VALUE.MRG_RD_ARB_PIPELINE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MRG_RD_ARB_PIPELINE}] ${MODELPARAM_VALUE.MRG_RD_ARB_PIPELINE}
}

proc update_MODELPARAM_VALUE.MRG_RD_PRE_STATE { MODELPARAM_VALUE.MRG_RD_PRE_STATE PARAM_VALUE.MRG_RD_PRE_STATE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MRG_RD_PRE_STATE}] ${MODELPARAM_VALUE.MRG_RD_PRE_STATE}
}

proc update_MODELPARAM_VALUE.MRG_WR_AXI_XFER_SIZE { MODELPARAM_VALUE.MRG_WR_AXI_XFER_SIZE PARAM_VALUE.MRG_WR_AXI_XFER_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MRG_WR_AXI_XFER_SIZE}] ${MODELPARAM_VALUE.MRG_WR_AXI_XFER_SIZE}
}

proc update_MODELPARAM_VALUE.MRG_WR_AXI_BUF_SIZE { MODELPARAM_VALUE.MRG_WR_AXI_BUF_SIZE PARAM_VALUE.MRG_WR_AXI_BUF_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MRG_WR_AXI_BUF_SIZE}] ${MODELPARAM_VALUE.MRG_WR_AXI_BUF_SIZE}
}

proc update_MODELPARAM_VALUE.MRG_WR_AXI_QUEUE { MODELPARAM_VALUE.MRG_WR_AXI_QUEUE PARAM_VALUE.MRG_WR_AXI_QUEUE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MRG_WR_AXI_QUEUE}] ${MODELPARAM_VALUE.MRG_WR_AXI_QUEUE}
}

proc update_MODELPARAM_VALUE.MRG_WR_AXI_REQ_REGS { MODELPARAM_VALUE.MRG_WR_AXI_REQ_REGS PARAM_VALUE.MRG_WR_AXI_REQ_REGS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MRG_WR_AXI_REQ_REGS}] ${MODELPARAM_VALUE.MRG_WR_AXI_REQ_REGS}
}

proc update_MODELPARAM_VALUE.MRG_WR_AXI_ACK_REGS { MODELPARAM_VALUE.MRG_WR_AXI_ACK_REGS PARAM_VALUE.MRG_WR_AXI_ACK_REGS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MRG_WR_AXI_ACK_REGS}] ${MODELPARAM_VALUE.MRG_WR_AXI_ACK_REGS}
}

proc update_MODELPARAM_VALUE.MRG_WR_AXI_RESP_REGS { MODELPARAM_VALUE.MRG_WR_AXI_RESP_REGS PARAM_VALUE.MRG_WR_AXI_RESP_REGS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MRG_WR_AXI_RESP_REGS}] ${MODELPARAM_VALUE.MRG_WR_AXI_RESP_REGS}
}

proc update_MODELPARAM_VALUE.DEBUG_ENABLE { MODELPARAM_VALUE.DEBUG_ENABLE PARAM_VALUE.DEBUG_ENABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DEBUG_ENABLE}] ${MODELPARAM_VALUE.DEBUG_ENABLE}
}

