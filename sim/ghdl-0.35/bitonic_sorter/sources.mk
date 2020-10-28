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

bitonic_sorter.o : ../../../src/main/vhdl/examples/bitonic_sorter/bitonic_sorter.vhd word.o sorting_network.o core_components.o sorting_network_core.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/examples/bitonic_sorter/bitonic_sorter.vhd

bitonic_sorter_test_bench.o : ../../../src/test/vhdl/bitonic_sorter_test_bench.vhd word.o bitonic_sorter.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/test/vhdl/bitonic_sorter_test_bench.vhd

