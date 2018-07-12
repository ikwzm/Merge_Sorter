PIPEWORK_PATH        = ../../../PipeWork
PIPEWORK_SRC_PATH    = $(PIPEWORK_PATH)/src
PIPEWORK_WORK_PATH   = $(PIPEWORK_PATH)/sim/ghdl-0.35
PIPEWORK_TOOL_PATH   = $(PIPEWORK_PATH)/tools

DUMMY_PLUG_PATH      = ../../../Dummy_Plug
DUMMY_PLUG_SRC_PATH  = $(DUMMY_PLUG_PATH)/src/main/vhdl
DUMMY_PLUG_WORK_PATH = $(DUMMY_PLUG_PATH)/sim/ghdl-0.35/dummy_plug
DUMMY_PLUG_TOOL_PATH = $(DUMMY_PLUG_PATH)/tools

SCENARIO_PATH        = ../../../src/test/scenarios/merge_sorter_core

COPY       = cp
REMOVE     = -rm
GHDL       = ghdl
GHDLFLAGS  = --mb-comments -P$(DUMMY_PLUG_WORK_PATH) -P$(PIPEWORK_WORK_PATH)

test   : test_x04_m1_s1_f2 \
         test_x04_m1_s0_f0 \
         test_x04_m0_s1_f0 \
         test_x04_m0_s1_f1 \
         test_x04_m0_s1_f2 \
         $(END_LIST)

clean  :
	$(REMOVE) sources.mk *.o *.cf

dut    : merge_sorter_core.o

test_x04_m1_s1_f2 : test_x04_m1_s1_f2.snr merge_sorter_core_test_bench.o dut 
	$(GHDL) -e $(GHDLFLAGS) --work=MERGE_SORTER Merge_Sorter_Core_Test_Bench_X04_M1_S1_F2
	$(GHDL) -r $(GHDLFLAGS) --work=MERGE_SORTER Merge_Sorter_Core_Test_Bench_X04_M1_S1_F2

test_x04_m1_s0_f0 : test_x04_m1_s0_f0.snr merge_sorter_core_test_bench.o dut 
	$(GHDL) -e $(GHDLFLAGS) --work=MERGE_SORTER Merge_Sorter_Core_Test_Bench_X04_M1_S0_F0
	$(GHDL) -r $(GHDLFLAGS) --work=MERGE_SORTER Merge_Sorter_Core_Test_Bench_X04_M1_S0_F0

test_x04_m0_s1_f0 : test_x04_m0_s1_f0.snr merge_sorter_core_test_bench.o dut 
	$(GHDL) -e $(GHDLFLAGS) --work=MERGE_SORTER Merge_Sorter_Core_Test_Bench_X04_M0_S1_F0
	$(GHDL) -r $(GHDLFLAGS) --work=MERGE_SORTER Merge_Sorter_Core_Test_Bench_X04_M0_S1_F0

test_x04_m0_s1_f1 : test_x04_m0_s1_f1.snr merge_sorter_core_test_bench.o dut 
	$(GHDL) -e $(GHDLFLAGS) --work=MERGE_SORTER Merge_Sorter_Core_Test_Bench_X04_M0_S1_F1
	$(GHDL) -r $(GHDLFLAGS) --work=MERGE_SORTER Merge_Sorter_Core_Test_Bench_X04_M0_S1_F1

test_x04_m0_s1_f2 : test_x04_m0_s1_f2.snr merge_sorter_core_test_bench.o dut 
	$(GHDL) -e $(GHDLFLAGS) --work=MERGE_SORTER Merge_Sorter_Core_Test_Bench_X04_M0_S1_F2
	$(GHDL) -r $(GHDLFLAGS) --work=MERGE_SORTER Merge_Sorter_Core_Test_Bench_X04_M0_S1_F2

test_x04_m1_s1_f2.snr : $(SCENARIO_PATH)/test_x04_m1_s1_f2.snr
	$(COPY) $< $@

test_x04_m1_s0_f0.snr : $(SCENARIO_PATH)/test_x04_m1_s0_f0.snr
	$(COPY) $< $@

test_x04_m0_s1_f0.snr : $(SCENARIO_PATH)/test_x04_m0_s1_f0.snr
	$(COPY) $< $@

test_x04_m0_s1_f1.snr : $(SCENARIO_PATH)/test_x04_m0_s1_f1.snr
	$(COPY) $< $@

test_x04_m0_s1_f2.snr : $(SCENARIO_PATH)/test_x04_m0_s1_f2.snr
	$(COPY) $< $@

sources.mk   : sources.yml
	$(PIPEWORK_TOOL_PATH)/vhdl-archiver.rb -v --config sources.yml > sources.mk

include sources.mk
