PIPEWORK_PATH        = ../../../PipeWork
PIPEWORK_SRC_PATH    = $(PIPEWORK_PATH)/src
PIPEWORK_WORK_PATH   = $(PIPEWORK_PATH)/sim/ghdl-0.35
PIPEWORK_TOOL_PATH   = $(PIPEWORK_PATH)/tools

DUMMY_PLUG_PATH      = ../../../Dummy_Plug
DUMMY_PLUG_SRC_PATH  = $(DUMMY_PLUG_PATH)/src/main/vhdl
DUMMY_PLUG_WORK_PATH = $(DUMMY_PLUG_PATH)/sim/ghdl-0.35/dummy_plug
DUMMY_PLUG_TOOL_PATH = $(DUMMY_PLUG_PATH)/tools

SCENARIO_PATH        = ../../../src/test/scenarios/argsort_kernel/

COPY       = cp
CAT        = cat
REMOVE     = -rm
GHDL       = ghdl
GHDLFLAGS  = --mb-comments -P$(DUMMY_PLUG_WORK_PATH) -P$(PIPEWORK_WORK_PATH)

TEST   = test_x04_w1_f0 \
         test_x04_w1_f1 \
         test_x04_w1_f2 \
         test_x04_w2_f2 \
         test_x16_w1_f2 \
         $(END_LIST)

test   : $(TEST)

clean  :
	$(REMOVE) sources.mk *.cf

dut         : argsort_kernel

test_bench  : argsort_kernel_test_bench

define RUN
$(1): $(2) test_bench dut
	$(GHDL) -e $(GHDLFLAGS) --work=MERGE_SORTER $(subst test_,ArgSort_Kernel_Test_Bench_,$(1))
	$(GHDL) -r $(GHDLFLAGS) --work=MERGE_SORTER $(subst test_,ArgSort_Kernel_Test_Bench_,$(1))

$(2): $(SCENARIO_PATH)/$(1)_1.snr $(SCENARIO_PATH)/$(1)_2.snr $(SCENARIO_PATH)/$(1)_3.snr
	$(CAT) $(SCENARIO_PATH)/$(1)_1.snr $(SCENARIO_PATH)/$(1)_2.snr $(SCENARIO_PATH)/$(1)_3.snr > $(2)
endef

$(foreach ENTITY, $(TEST), $(eval $(call RUN,$(ENTITY),$(addsuffix .snr,$(ENTITY)))))

sources.mk   : sources.yml
	$(PIPEWORK_TOOL_PATH)/vhdl-archiver.rb -v --config sources.yml > sources.mk

include sources.mk

