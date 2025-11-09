PROJECT_NAME  = asymmetric_sorter
SCENARIO_PATH = ../../../src/test/scenarios/sorting_network

COPY          = cp
CAT           = cat
REMOVE        = -rm
NVC           = nvc
NVCFLAGS      = -L ./ -M 128M -H 128M

TEST_BENCH    = test_x2x3_o0_s0_q0 \
                test_x3x2_o0_s0_q0 \
                test_x6x1_o0_s0_q0 \
                test_x4x2_o0_s1_q2 \
                test_x2x4_o0_s1_q2 \
                test_x8x1_o0_s1_q2 \
                test_x3x3_o1_s0_q1 \
                test_x3x3_o1_s0_q2 \
                test_x9x1_o1_s0_q2 \
                test_x5x2_o0_s0_q2 \
                test_x2x5_o0_s0_q2 \
                $(END_LIST)

SCENARIO_X06_O0_S0 += test_x2x3_o0_s0.snr
SCENARIO_X06_O0_S0 += test_x3x2_o0_s0.snr
SCENARIO_X06_O0_S0 += test_x6x1_o0_s0.snr
SCENARIO_X08_O0_S1 += test_x2x4_o0_s1.snr
SCENARIO_X08_O0_S1 += test_x4x2_o0_s1.snr
SCENARIO_X08_O0_S1 += test_x8x1_o0_s1.snr
SCENARIO_X09_O1_S0 += test_x3x3_o1_s0.snr
SCENARIO_X09_O1_S0 += test_x9x1_o1_s0.snr
SCENARIO_X10_O0_S0 += test_x5x2_o0_s0.snr
SCENARIO_X10_O0_S0 += test_x2x5_o0_s0.snr

test: $(TEST_BENCH) generate_test

clean:
	$(REMOVE) -rf *.snr WORK DUMMY_PLUG PIPEWORK MERGE_SORTER *.snr analyze_libs.sh

analyze_libs.sh: libs.yml
	../../../PipeWork/tools/vhdl-archiver.rb -v --config libs.yml > analyze_libs.sh

define TEST_UNIT_NAME
$(subst test_,Asymmetric_Sorter_Test_Bench_,$(1))
endef

define TEST_SCENARIO_NAME
$(addsuffix .snr,$(subst _q0,,$(subst _q1,,$(subst _q2,,$(1)))))
endef

define NVC_ANALIZE_FILE
$(addprefix WORK/WORK.,$(call TEST_UNIT_NAME, $(shell echo $(call TEST_UNIT_NAME,$(1)) | tr a-z A-Z)))
endef

define NVC_EXECUTE_FILE
$(addsuffix .elab.so,$(addprefix WORK/_WORK., $(shell echo $(call TEST_UNIT_NAME,$(1)) | tr a-z A-Z)))
endef

define NVC_RUN
$(1): $(call NVC_EXECUTE_FILE,$(1)) $(2)
	$(NVC) $(NVCFLAGS) --work=WORK -r $(call TEST_UNIT_NAME,$(1))
endef

define NVC_ELAB
$(call NVC_EXECUTE_FILE,$(1)): $(call NVC_ANALIZE_FILE,$(1))
	$(NVC) $(NVCFLAGS) --work=WORK -e $(call TEST_UNIT_NAME,$(1))
endef

define MAKE_SCENARIO
$(1): $(SCENARIO_PATH)/$(2)
	$(COPY) $(SCENARIO_PATH)/$(2) $(1)
endef

$(foreach FILE, $(SCENARIO_X06_O0_S0), $(eval $(call MAKE_SCENARIO,$(FILE),test_x06_o0_s0.snr)))
$(foreach FILE, $(SCENARIO_X08_O0_S1), $(eval $(call MAKE_SCENARIO,$(FILE),test_x08_o0_s1.snr)))
$(foreach FILE, $(SCENARIO_X09_O1_S0), $(eval $(call MAKE_SCENARIO,$(FILE),test_x09_o1_s0.snr)))
$(foreach FILE, $(SCENARIO_X10_O0_S0), $(eval $(call MAKE_SCENARIO,$(FILE),test_x10_o0_s0.snr)))

$(call NVC_ANALIZE_FILE, $(TEST_BENCH)) : analyze_libs.sh
	sh analyze_libs.sh

$(foreach TEST, $(TEST_BENCH), $(eval $(call NVC_ELAB, $(TEST))))
$(foreach TEST, $(TEST_BENCH), $(eval $(call NVC_RUN , $(TEST),$(call TEST_SCENARIO_NAME, $(TEST)))))

generate_test: WORK/WORK.ASYMMETRIC_SORT_NETWORK_GENERATE_TEST
	$(NVC) $(NVCFLAGS) --work=WORK -e ASYMMETRIC_SORT_NETWORK_GENERATE_TEST
	$(NVC) $(NVCFLAGS) --work=WORK -r ASYMMETRIC_SORT_NETWORK_GENERATE_TEST
