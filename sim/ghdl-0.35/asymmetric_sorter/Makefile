PROJECT_NAME  = asymmetric_sorter
SCENARIO_PATH = ../../../src/test/scenarios/sorting_network

COPY          = cp
CAT           = cat
REMOVE        = -rm
GHDL          = ghdl
GHDLFLAGS     = --mb-comments

TEST_BENCH    = test_x2x3_o0_s0_q0 \
                test_x3x2_o0_s0_q0 \
                test_x5x1_o0_s0_q0 \
                test_x6x1_o0_s0_q0 \
                test_x4x2_o0_s1_q2 \
                test_x2x4_o0_s1_q2 \
                test_x7x1_o0_s0_q0 \
                test_x8x1_o0_s1_q2 \
                test_x3x3_o1_s0_q1 \
                test_x3x3_o1_s0_q2 \
                test_x9x1_o1_s0_q2 \
                test_x10x1_o0_s0_q2 \
                test_x5x2_o0_s0_q2 \
                test_x2x5_o0_s0_q2 \
                test_x11x1_o0_s0_q2 \
                $(END_LIST)

SCENARIO_X05_O0_S0 += test_x5x1_o0_s0.snr
SCENARIO_X06_O0_S0 += test_x2x3_o0_s0.snr
SCENARIO_X06_O0_S0 += test_x3x2_o0_s0.snr
SCENARIO_X06_O0_S0 += test_x6x1_o0_s0.snr
SCENARIO_X07_O0_S0 += test_x7x1_o0_s0.snr
SCENARIO_X08_O0_S1 += test_x2x4_o0_s1.snr
SCENARIO_X08_O0_S1 += test_x4x2_o0_s1.snr
SCENARIO_X08_O0_S1 += test_x8x1_o0_s1.snr
SCENARIO_X09_O1_S0 += test_x3x3_o1_s0.snr
SCENARIO_X09_O1_S0 += test_x9x1_o1_s0.snr
SCENARIO_X10_O0_S0 += test_x10x1_o0_s0.snr
SCENARIO_X10_O0_S0 += test_x5x2_o0_s0.snr
SCENARIO_X10_O0_S0 += test_x2x5_o0_s0.snr
SCENARIO_X11_O0_S0 += test_x11x1_o0_s0.snr

test: $(TEST_BENCH) generate_test

clean:
	$(REMOVE) libs.mk *.cf

dut test_bench : work-obj93.cf

libs.mk: libs.yml
	../../../PipeWork/tools/vhdl-archiver.rb -v --config libs.yml > libs.mk

include  libs.mk

dummy_plug-obj93.cf   : $(DUMMY_PLUG_SRC)
	@for file in $(DUMMY_PLUG_SRC) ; do \
	echo $(GHDL) -a $(GHDLFLAGS) --work=DUMMY_PLUG   $$file ; \
	     $(GHDL) -a $(GHDLFLAGS) --work=DUMMY_PLUG   $$file ; \
	done

pipework-obj93.cf     : $(PIPEWORK_SRC)
	@for file in $(PIPEWORK_SRC) ; do \
	echo $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK     $$file ; \
	     $(GHDL) -a $(GHDLFLAGS) --work=PIPEWORK     $$file ; \
	done

merge_sorter-obj93.cf : $(MERGE_SORTER_SRC) pipework-obj93.cf 
	@for file in $(MERGE_SORTER_SRC) ; do \
	echo $(GHDL) -a $(GHDLFLAGS) --work=MERGE_SORTER $$file ; \
	     $(GHDL) -a $(GHDLFLAGS) --work=MERGE_SORTER $$file ; \
	done

work-obj93.cf         : $(WORK_SRC) merge_sorter-obj93.cf dummy_plug-obj93.cf
	@for file in $(WORK_SRC) ; do \
	echo $(GHDL) -a $(GHDLFLAGS) --work=WORK         $$file ; \
	     $(GHDL) -a $(GHDLFLAGS) --work=WORK         $$file ; \
	done

define TEST_UNIT_NAME
$(subst test_,Asymmetric_Sorter_Test_Bench_,$(1))
endef

define TEST_SCENARIO_NAME
$(addsuffix .snr,$(subst _q0,,$(subst _q1,,$(subst _q2,,$(1)))))
endef

define GHDL_RUN
$(1): $(2) test_bench dut
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $(call TEST_UNIT_NAME,$(1))
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $(call TEST_UNIT_NAME,$(1))
endef

define MAKE_SCENARIO
$(1): $(SCENARIO_PATH)/$(2)
	$(COPY) $(SCENARIO_PATH)/$(2) $(1)
endef

$(foreach FILE, $(SCENARIO_X05_O0_S0), $(eval $(call MAKE_SCENARIO,$(FILE),test_x05_o0_s0.snr)))
$(foreach FILE, $(SCENARIO_X06_O0_S0), $(eval $(call MAKE_SCENARIO,$(FILE),test_x06_o0_s0.snr)))
$(foreach FILE, $(SCENARIO_X07_O0_S0), $(eval $(call MAKE_SCENARIO,$(FILE),test_x07_o0_s0.snr)))
$(foreach FILE, $(SCENARIO_X08_O0_S1), $(eval $(call MAKE_SCENARIO,$(FILE),test_x08_o0_s1.snr)))
$(foreach FILE, $(SCENARIO_X09_O1_S0), $(eval $(call MAKE_SCENARIO,$(FILE),test_x09_o1_s0.snr)))
$(foreach FILE, $(SCENARIO_X10_O0_S0), $(eval $(call MAKE_SCENARIO,$(FILE),test_x10_o0_s0.snr)))
$(foreach FILE, $(SCENARIO_X11_O0_S0), $(eval $(call MAKE_SCENARIO,$(FILE),test_x11_o0_s0.snr)))

$(foreach TEST, $(TEST_BENCH), $(eval $(call GHDL_RUN,$(TEST),$(call TEST_SCENARIO_NAME,$(TEST)))))

generate_test: work-obj93.cf
	$(GHDL) -e $(GHDLFLAGS) --work=WORK Asymmetric_Sort_Network_Generate_Test
	$(GHDL) -r $(GHDLFLAGS) --work=WORK Asymmetric_Sort_Network_Generate_Test

PRINT_NETWORKS = x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16

define PRINT_UNIT_NAME
$(addprefix ASYMMETRIC_SORT_NETWORK_,$(addsuffix _PRINT,$(shell echo $(1) | tr a-z A-Z)))
endef

define PRINT_TARGET_NAME
$(addprefix print_network_,$(1))
endef

define RUN_PRINT_NETWORK
$(1) : work-obj93.cf
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $(2)
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $(2)
endef

print_network: $(foreach NETWORK, $(PRINT_NETWORKS), $(call PRINT_TARGET_NAME,$(NETWORK)))

$(foreach NETWORK, $(PRINT_NETWORKS), $(eval $(call RUN_PRINT_NETWORK,$(call PRINT_TARGET_NAME,$(NETWORK)),$(call PRINT_UNIT_NAME, $(NETWORK)))))

