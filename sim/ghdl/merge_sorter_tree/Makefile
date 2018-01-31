PIPEWORK_PATH        = ../../../PipeWork
PIPEWORK_SRC_PATH    = $(PIPEWORK_PATH)/src
PIPEWORK_WORK_PATH   = $(PIPEWORK_PATH)/sim/ghdl
PIPEWORK_TOOL_PATH   = $(PIPEWORK_PATH)/tools

DUMMY_PLUG_PATH      = ../../../Dummy_Plug
DUMMY_PLUG_SRC_PATH  = $(DUMMY_PLUG_PATH)/src/main/vhdl
DUMMY_PLUG_WORK_PATH = $(DUMMY_PLUG_PATH)/sim/ghdl/dummy_plug
DUMMY_PLUG_TOOL_PATH = $(DUMMY_PLUG_PATH)/tools

SCENARIO_PATH        = ../../../src/test/scenarios/merge_sorter_tree

COPY       = cp
REMOVE     = -rm
GHDL       = ghdl
GHDLFLAGS  = --mb-comments -P$(DUMMY_PLUG_WORK_PATH) -P$(PIPEWORK_WORK_PATH)

test   : test_1

test_1 : merge_sorter_tree_test_bench.o dut $(SCENARIO_PATH)/test_1.snr 
	-$(COPY) $(SCENARIO_PATH)/test_1.snr test.snr
	-$(GHDL) -e $(GHDLFLAGS) --work=MERGE_SORTER Merge_Sorter_Tree_Test_Bench
	-$(GHDL) -r $(GHDLFLAGS) --work=MERGE_SORTER Merge_Sorter_Tree_Test_Bench

dut    : merge_sorter_tree.o

sources.mk   : sources.yml
	$(PIPEWORK_TOOL_PATH)/vhdl-archiver.rb -v --config sources.yml > sources.mk

include sources.mk
