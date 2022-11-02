PROJECT_NAME  = oddeven_sorter
SCENARIO_PATH = ../../../src/test/scenarios/sorting_network

COPY          = cp
CAT           = cat
REMOVE        = -rm
GHDL          = ghdl
GHDLFLAGS     = --mb-comments

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
$(subst test_,OddEven_Sorter_Test_Bench_,$(1))
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
$(1): $(SCENARIO_PATH)/$(1)
	$(COPY) $(SCENARIO_PATH)/$(1) $(1)
endef

SCENARIO_FILES = $(sort $(foreach TB, $(TEST_BENCH), $(call TEST_SCENARIO_NAME, $(TB))))

$(foreach FILE, $(SCENARIO_FILES), $(eval $(call MAKE_SCENARIO,$(FILE))))

$(foreach TEST, $(TEST_BENCH), $(eval $(call GHDL_RUN, $(TEST),$(call TEST_SCENARIO_NAME, $(TEST)))))
