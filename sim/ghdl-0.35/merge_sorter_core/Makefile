PROJECT_NAME  = merge_sorter_core
SCENARIO_PATH = ../../../src/test/scenarios/merge_sorter_core/

COPY          = cp
CAT           = cat
REMOVE        = -rm
GHDL          = ghdl
GHDLFLAGS     = --mb-comments

TEST_BENCH    = test_x04_w1_m1_s1_f2 \
                test_x04_w1_m1_s0_f0 \
                test_x04_w1_m0_s1_f0 \
                test_x04_w1_m0_s1_f1 \
                test_x04_w1_m0_s1_f2 \
                test_x04_w2_m1_s0_f0 \
                test_x04_w2_m0_s1_f0 \
                test_x04_w2_m0_s1_f1 \
                test_x04_w2_m0_s1_f2 \
                $(END_LIST)

test   : $(TEST_BENCH)

clean  :
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

define RUN
$(1): $(2) test_bench dut 
	$(GHDL) -e $(GHDLFLAGS) --work=WORK $(subst test_,Merge_Sorter_Core_Test_Bench_,$(1))
	$(GHDL) -r $(GHDLFLAGS) --work=WORK $(subst test_,Merge_Sorter_Core_Test_Bench_,$(1))

$(2): $(addprefix $(SCENARIO_PATH),$(2))
	$(COPY) $(addprefix $(SCENARIO_PATH),$(2)) $(2)
endef

$(foreach ENTITY, $(TEST_BENCH), $(eval $(call RUN, $(ENTITY), $(addsuffix .snr,$(ENTITY)))))
