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
CAT        = cat
REMOVE     = -rm
GHDL       = ghdl
GHDLFLAGS  = --mb-comments -P$(DUMMY_PLUG_WORK_PATH) -P$(PIPEWORK_WORK_PATH)

test   : test_x04_f0 \
         test_x04_f1 \
         test_x04_f2 \
         $(END_LIST)

clean  :
	$(REMOVE) sources.mk *.o *.cf

dut         : argsort_axi.o

test_bench  : argsort_axi_test_bench.o

test_x04_f0 : test_x04_f0.snr test_bench dut 
	$(GHDL) -e $(GHDLFLAGS) --work=MERGE_SORTER ArgSort_AXI_Test_Bench_X04_F0
	$(GHDL) -r $(GHDLFLAGS) --work=MERGE_SORTER ArgSort_AXI_Test_Bench_X04_F0

test_x04_f1 : test_x04_f1.snr test_bench dut 
	$(GHDL) -e $(GHDLFLAGS) --work=MERGE_SORTER ArgSort_AXI_Test_Bench_X04_F1
	$(GHDL) -r $(GHDLFLAGS) --work=MERGE_SORTER ArgSort_AXI_Test_Bench_X04_F1

test_x04_f2 : test_x04_f2.snr test_bench dut 
	$(GHDL) -e $(GHDLFLAGS) --work=MERGE_SORTER ArgSort_AXI_Test_Bench_X04_F2
	$(GHDL) -r $(GHDLFLAGS) --work=MERGE_SORTER ArgSort_AXI_Test_Bench_X04_F2

test_x04_f0.snr : $(SCENARIO_PATH)/test_1.snr $(SCENARIO_PATH)/test_2.snr
	$(CAT) $^ > $@

test_x04_f1.snr : $(SCENARIO_PATH)/test_1.snr $(SCENARIO_PATH)/test_2.snr
	$(CAT) $^ > $@

test_x04_f2.snr : $(SCENARIO_PATH)/test_1.snr $(SCENARIO_PATH)/test_2.snr
	$(CAT) $^ > $@

sources.mk   : sources.yml
	$(PIPEWORK_TOOL_PATH)/vhdl-archiver.rb -v --config sources.yml > sources.mk

include sources.mk

