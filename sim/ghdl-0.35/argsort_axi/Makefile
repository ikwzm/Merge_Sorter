PIPEWORK_PATH        = ../../../PipeWork
PIPEWORK_SRC_PATH    = $(PIPEWORK_PATH)/src
PIPEWORK_WORK_PATH   = $(PIPEWORK_PATH)/sim/ghdl-0.35
PIPEWORK_TOOL_PATH   = $(PIPEWORK_PATH)/tools

DUMMY_PLUG_PATH      = ../../../Dummy_Plug
DUMMY_PLUG_SRC_PATH  = $(DUMMY_PLUG_PATH)/src/main/vhdl
DUMMY_PLUG_WORK_PATH = $(DUMMY_PLUG_PATH)/sim/ghdl-0.35/dummy_plug
DUMMY_PLUG_TOOL_PATH = $(DUMMY_PLUG_PATH)/tools

SCENARIO_PATH        = ../../../src/test/scenarios/argsort_axi

COPY       = cp
REMOVE     = -rm
GHDL       = ghdl
GHDLFLAGS  = --mb-comments -P$(DUMMY_PLUG_WORK_PATH) -P$(PIPEWORK_WORK_PATH)

test   : test_w04_f2 \
         $(END_LIST)

clean  :
	$(REMOVE) sources.mk *.o *.cf

dut    : argsort_axi.o

sources.mk   : sources.yml
	$(PIPEWORK_TOOL_PATH)/vhdl-archiver.rb -v --config sources.yml > sources.mk

include sources.mk
