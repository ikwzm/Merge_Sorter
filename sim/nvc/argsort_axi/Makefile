PROJECT_NAME  = argsort_axi
PIPEWORK_PATH = ../../../PipeWork
SRC_TEST_PATH = ../../../src/test/vhdl/$(PROJECT_NAME)
SCENARIO_PATH = ../../../src/test/scenarios/$(PROJECT_NAME)

COPY          = cp
CAT           = cat
REMOVE        = -rm
NVC           = nvc
NVCFLAGS      = -L ./ -M 32M

TEST_BENCH    = test_x04_w1_f0 \
                test_x04_w1_f1 \
                test_x04_w1_f2 \
                test_x04_w2_f2 \
                test_x16_w1_f2 \
                $(END_LIST)

test: $(TEST_BENCH)

clean:
	$(REMOVE) -rf *.snr WORK DUMMY_PLUG PIPEWORK MERGE_SORTER *.snr analyze_libs.sh

analyze_libs.sh: libs.yml
	../../../PipeWork/tools/vhdl-archiver.rb -v --config libs.yml > analyze_libs.sh

define TEST_UNIT_NAME
$(subst test_,ArgSort_AXI_Test_Bench_,$(1))
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

$(2): $(SCENARIO_PATH)/test_1.snr $(SCENARIO_PATH)/test_2.snr $(SCENARIO_PATH)/test_3.snr
	$(CAT) $(SCENARIO_PATH)/test_1.snr $(SCENARIO_PATH)/test_2.snr $(SCENARIO_PATH)/test_3.snr > $(2)
endef

define NVC_ELAB
$(call NVC_EXECUTE_FILE,$(1)): $(call NVC_ANALIZE_FILE,$(1))
	$(NVC) $(NVCFLAGS) --work=WORK -e $(call TEST_UNIT_NAME,$(1))
endef

$(call NVC_ANALIZE_FILE, $(TEST_BENCH)) : analyze_libs.sh
	sh analyze_libs.sh

analyze_libs : $(call NVC_ANALIZE_FILE, $(TEST_BENCH))

$(foreach TB, $(TEST_BENCH), $(eval $(call NVC_ELAB, $(TB))))
$(foreach TB, $(TEST_BENCH), $(eval $(call NVC_RUN , $(TB), $(addsuffix .snr,$(TB)))))
