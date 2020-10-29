PIPEWORK_PATH        = ../../../PipeWork
PIPEWORK_SRC_PATH    = $(PIPEWORK_PATH)/src
PIPEWORK_WORK_PATH   = $(PIPEWORK_PATH)/sim/ghdl-0.35
PIPEWORK_TOOL_PATH   = $(PIPEWORK_PATH)/tools

DUMMY_PLUG_PATH      = ../../../Dummy_Plug
DUMMY_PLUG_SRC_PATH  = $(DUMMY_PLUG_PATH)/src/main/vhdl
DUMMY_PLUG_WORK_PATH = $(DUMMY_PLUG_PATH)/sim/ghdl-0.35/dummy_plug
DUMMY_PLUG_TOOL_PATH = $(DUMMY_PLUG_PATH)/tools

SCENARIO_PATH        = ../../../src/test/scenarios/sorting_network

COPY       = cp
REMOVE     = -rm
GHDL       = ghdl
GHDLFLAGS  = --mb-comments -P$(DUMMY_PLUG_WORK_PATH) -P$(PIPEWORK_WORK_PATH)

test   : test_x08_o0_s0_q0 \
         test_x08_o0_s0_q1 \
         test_x08_o0_s0_q2 \
         $(END_LIST)

clean  :
	$(REMOVE) sources.mk *.o *.cf

dut    : oddeven_sorter.o

test_x04_o0_s0_q0 : test_x04_o0_s0.snr oddeven_sorter_test_bench.o dut 
	$(GHDL) -e $(GHDLFLAGS) --work=MERGE_SORTER Oddeven_Sorter_Test_Bench_X04_O0_S0_Q0
	$(GHDL) -r $(GHDLFLAGS) --work=MERGE_SORTER Oddeven_Sorter_Test_Bench_X04_O0_S0_Q0

test_x04_o0_s0_q1 : test_x04_o0_s0.snr oddeven_sorter_test_bench.o dut 
	$(GHDL) -e $(GHDLFLAGS) --work=MERGE_SORTER Oddeven_Sorter_Test_Bench_X04_O0_S0_Q1
	$(GHDL) -r $(GHDLFLAGS) --work=MERGE_SORTER Oddeven_Sorter_Test_Bench_X04_O0_S0_Q1

test_x04_o0_s0_q2 : test_x04_o0_s0.snr oddeven_sorter_test_bench.o dut 
	$(GHDL) -e $(GHDLFLAGS) --work=MERGE_SORTER Oddeven_Sorter_Test_Bench_X04_O0_S0_Q2
	$(GHDL) -r $(GHDLFLAGS) --work=MERGE_SORTER Oddeven_Sorter_Test_Bench_X04_O0_S0_Q2

test_x08_o0_s0_q0 : test_x08_o0_s0.snr oddeven_sorter_test_bench.o dut 
	$(GHDL) -e $(GHDLFLAGS) --work=MERGE_SORTER Oddeven_Sorter_Test_Bench_X08_O0_S0_Q0
	$(GHDL) -r $(GHDLFLAGS) --work=MERGE_SORTER Oddeven_Sorter_Test_Bench_X08_O0_S0_Q0

test_x08_o0_s0_q1 : test_x08_o0_s0.snr oddeven_sorter_test_bench.o dut 
	$(GHDL) -e $(GHDLFLAGS) --work=MERGE_SORTER Oddeven_Sorter_Test_Bench_X08_O0_S0_Q1
	$(GHDL) -r $(GHDLFLAGS) --work=MERGE_SORTER Oddeven_Sorter_Test_Bench_X08_O0_S0_Q1

test_x08_o0_s0_q2 : test_x08_o0_s0.snr oddeven_sorter_test_bench.o dut 
	$(GHDL) -e $(GHDLFLAGS) --work=MERGE_SORTER Oddeven_Sorter_Test_Bench_X08_O0_S0_Q2
	$(GHDL) -r $(GHDLFLAGS) --work=MERGE_SORTER Oddeven_Sorter_Test_Bench_X08_O0_S0_Q2

test_x04_o0_s0.snr : $(SCENARIO_PATH)/test_x04_o0_s0.snr
	$(COPY) $< $@

test_x08_o0_s0.snr : $(SCENARIO_PATH)/test_x08_o0_s0.snr
	$(COPY) $< $@

sources.mk   : sources.yml
	$(PIPEWORK_TOOL_PATH)/vhdl-archiver.rb -v --config sources.yml > sources.mk

include sources.mk
