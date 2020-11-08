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

word_queue.o : ../../../src/main/vhdl/core/word_queue.vhd word.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/word_queue.vhd

merge_sorter_node.o : ../../../src/main/vhdl/core/merge_sorter_node.vhd word.o sorting_network.o core_components.o word_compare.o word_queue.o sorting_network_core.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/merge_sorter_node.vhd

word_reducer.o : ../../../src/main/vhdl/core/word_reducer.vhd word.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/word_reducer.vhd

merge_sorter_tree.o : ../../../src/main/vhdl/core/merge_sorter_tree.vhd word.o core_components.o merge_sorter_node.o word_queue.o word_reducer.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/merge_sorter_tree.vhd

sorting_network.old.o : ../../../src/main/vhdl/core/sorting_network.old word.o sorting_network.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/sorting_network.old

merge_sorter_tree_test_bench.o : ../../../src/test/vhdl/merge_sorter_tree_test_bench.vhd word.o merge_sorter_tree.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/test/vhdl/merge_sorter_tree_test_bench.vhd

