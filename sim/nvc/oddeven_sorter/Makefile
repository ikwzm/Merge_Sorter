PROJECT_NAME  = oddeven_sorter
SCENARIO_PATH = ../../../src/test/scenarios/sorting_network

COPY          = cp
CAT           = cat
REMOVE        = -rm
NVC           = nvc
NVCFLAGS      = -L ./ -M 32M -H 32M

TEST_BENCH    = test_x08_o0_s0_q0 \
                test_x08_o0_s0_q1 \
                test_x08_o0_s0_q2 \
                test_x08_o0_s1_q0 \
                test_x08_o0_s1_q1 \
                test_x08_o0_s1_q2 \
                test_x08_o1_s0_q0 \
                test_x08_o1_s0_q1 \
                test_x08_o1_s0_q2 \
                test_x08_o1_s1_q0 \
                test_x08_o1_s1_q1 \
                test_x08_o1_s1_q2 \
                $(END_LIST)

test: $(TEST_BENCH)

clean:
	$(REMOVE) -rf *.snr WORK DUMMY_PLUG PIPEWORK MERGE_SORTER *.snr analyze_libs.sh

analyze_libs.sh: libs.yml
	../../../PipeWork/tools/vhdl-archiver.rb -v --config libs.yml > analyze_libs.sh

define TEST_UNIT_NAME
$(subst test_,OddEven_Sorter_Test_Bench_,$(1))
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
$(1): $(SCENARIO_PATH)/$(1)
	$(COPY) $(SCENARIO_PATH)/$(1) $(1)
endef

$(call NVC_ANALIZE_FILE, $(TEST_BENCH)) : analyze_libs.sh
	sh analyze_libs.sh

analyze_libs : $(call NVC_ANALIZE_FILE, $(TEST_BENCH))

SCENARIO_FILES = $(sort $(foreach TB, $(TEST_BENCH), $(call TEST_SCENARIO_NAME, $(TB))))

$(foreach FILE, $(SCENARIO_FILES), $(eval $(call MAKE_SCENARIO,$(FILE))))
$(foreach TEST, $(TEST_BENCH), $(eval $(call NVC_ELAB, $(TEST))))
$(foreach TEST, $(TEST_BENCH), $(eval $(call NVC_RUN , $(TEST),$(call TEST_SCENARIO_NAME, $(TEST)))))

