PIPEWORK_PATH        = ../../../PipeWork
PIPEWORK_SRC_PATH    = $(PIPEWORK_PATH)/src
PIPEWORK_WORK_PATH   = $(PIPEWORK_PATH)/sim/ghdl-0.35
PIPEWORK_TOOL_PATH   = $(PIPEWORK_PATH)/tools

DUMMY_PLUG_PATH      = ../../../Dummy_Plug
DUMMY_PLUG_SRC_PATH  = $(DUMMY_PLUG_PATH)/src/main/vhdl
DUMMY_PLUG_WORK_PATH = $(DUMMY_PLUG_PATH)/sim/ghdl-0.35/dummy_plug
DUMMY_PLUG_TOOL_PATH = $(DUMMY_PLUG_PATH)/tools

SCENARIO_PATH        = ../../../src/test/scenarios/merge_sorter_tree

COPY       = cp
REMOVE     = -rm
GHDL       = ghdl
GHDLFLAGS  = --mb-comments -P$(DUMMY_PLUG_WORK_PATH) -P$(PIPEWORK_WORK_PATH)

test   : test_x04_w1_o0_s0 \
         test_x04_w1_o0_s1 \
         test_x02_w1_o1_s0 \
         test_x02_w1_o1_s1 \
         test_x02_w2_o0_s0 \
         test_x04_w2_o0_s0 

clean  :
	$(REMOVE) *.o *.snr sources.mk

test_x02_w1_o1_s0 : test_x02_w1_o1_s0.snr merge_sorter_tree_test_bench.o dut 
	$(GHDL) -e $(GHDLFLAGS) --work=MERGE_SORTER Merge_Sorter_Tree_Test_Bench_X02_W1_O1_S0
	$(GHDL) -r $(GHDLFLAGS) --work=MERGE_SORTER Merge_Sorter_Tree_Test_Bench_X02_W1_O1_S0

test_x02_w2_o0_s0 : test_x02_w2_o0_s0.snr merge_sorter_tree_test_bench.o dut 
	$(GHDL) -e $(GHDLFLAGS) --work=MERGE_SORTER Merge_Sorter_Tree_Test_Bench_X02_W2_O0_S0
	$(GHDL) -r $(GHDLFLAGS) --work=MERGE_SORTER Merge_Sorter_Tree_Test_Bench_X02_W2_O0_S0

test_x02_w1_o1_s1 : test_x02_w1_o1_s1.snr merge_sorter_tree_test_bench.o dut 
	$(GHDL) -e $(GHDLFLAGS) --work=MERGE_SORTER Merge_Sorter_Tree_Test_Bench_X02_W1_O1_S1
	$(GHDL) -r $(GHDLFLAGS) --work=MERGE_SORTER Merge_Sorter_Tree_Test_Bench_X02_W1_O1_S1

test_x04_w1_o0_s0 : test_x04_w1_o0_s0.snr merge_sorter_tree_test_bench.o dut 
	$(GHDL) -e $(GHDLFLAGS) --work=MERGE_SORTER Merge_Sorter_Tree_Test_Bench_X04_W1_O0_S0
	$(GHDL) -r $(GHDLFLAGS) --work=MERGE_SORTER Merge_Sorter_Tree_Test_Bench_X04_W1_O0_S0

test_x04_w2_o0_s0 : test_x04_w2_o0_s0.snr merge_sorter_tree_test_bench.o dut 
	$(GHDL) -e $(GHDLFLAGS) --work=MERGE_SORTER Merge_Sorter_Tree_Test_Bench_X04_W2_O0_S0
	$(GHDL) -r $(GHDLFLAGS) --work=MERGE_SORTER Merge_Sorter_Tree_Test_Bench_X04_W2_O0_S0

test_x04_w1_o0_s1 : test_x04_w1_o0_s1.snr merge_sorter_tree_test_bench.o dut 
	$(GHDL) -e $(GHDLFLAGS) --work=MERGE_SORTER Merge_Sorter_Tree_Test_Bench_X04_W1_O0_S1
	$(GHDL) -r $(GHDLFLAGS) --work=MERGE_SORTER Merge_Sorter_Tree_Test_Bench_X04_W1_O0_S1

dut    : merge_sorter_tree.o

test_x02_w1_o1_s0.snr : $(SCENARIO_PATH)/test_x02_w1_o1_s0.snr
	$(COPY) $< $@

test_x02_w2_o0_s0.snr : $(SCENARIO_PATH)/test_x02_w2_o0_s0.snr
	$(COPY) $< $@

test_x02_w1_o1_s1.snr : $(SCENARIO_PATH)/test_x02_w1_o1_s1.snr
	$(COPY) $< $@

test_x04_w1_o0_s0.snr : $(SCENARIO_PATH)/test_x04_w1_o0_s0.snr
	$(COPY) $< $@

test_x04_w2_o0_s0.snr : $(SCENARIO_PATH)/test_x04_w2_o0_s0.snr
	$(COPY) $< $@

test_x04_w1_o0_s1.snr : $(SCENARIO_PATH)/test_x04_w1_o0_s1.snr
	$(COPY) $< $@

sources.mk   : sources.yml
	$(PIPEWORK_TOOL_PATH)/vhdl-archiver.rb -v --config sources.yml > sources.mk

include sources.mk
