word.o : ../../../src/main/vhdl/core/word.vhd 
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/word.vhd

sorting_network.o : ../../../src/main/vhdl/core/sorting_network.vhd word.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/sorting_network.vhd

core_components.o : ../../../src/main/vhdl/core/core_components.vhd word.o sorting_network.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/core_components.vhd

word_compare.o : ../../../src/main/vhdl/core/word_compare.vhd word.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/word_compare.vhd

sorting_network_core.o : ../../../src/main/vhdl/core/sorting_network_core.vhd word.o sorting_network.o core_components.o word_compare.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/sorting_network_core.vhd

oddeven_sorter.o : ../../../src/main/vhdl/examples/oddeven_sorter/oddeven_sorter.vhd word.o sorting_network.o core_components.o sorting_network_core.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/examples/oddeven_sorter/oddeven_sorter.vhd

sorting_network.old.o : ../../../src/main/vhdl/core/sorting_network.old word.o sorting_network.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/sorting_network.old

oddeven_sorter_test_bench.o : ../../../src/test/vhdl/oddeven_sorter_test_bench.vhd word.o oddeven_sorter.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/test/vhdl/oddeven_sorter_test_bench.vhd

