word : ../../../src/main/vhdl/core/word.vhd 
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/word.vhd

sorting_network : ../../../src/main/vhdl/core/sorting_network.vhd word
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/sorting_network.vhd

core_components : ../../../src/main/vhdl/core/core_components.vhd word sorting_network
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/core_components.vhd

word_compare : ../../../src/main/vhdl/core/word_compare.vhd word
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/word_compare.vhd

sorting_network_core : ../../../src/main/vhdl/core/sorting_network_core.vhd word sorting_network core_components word_compare
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/sorting_network_core.vhd

word_queue : ../../../src/main/vhdl/core/word_queue.vhd word
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/word_queue.vhd

merge_sorter_node : ../../../src/main/vhdl/core/merge_sorter_node.vhd word sorting_network core_components word_compare word_queue sorting_network_core
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/merge_sorter_node.vhd

merge_sorter_tree : ../../../src/main/vhdl/core/merge_sorter_tree.vhd word core_components merge_sorter_node word_queue
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/merge_sorter_tree.vhd

sorting_network.old : ../../../src/main/vhdl/core/sorting_network.old word sorting_network
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/sorting_network.old

merge_sorter_tree_test_bench : ../../../src/test/vhdl/merge_sorter_tree_test_bench.vhd word merge_sorter_tree
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/test/vhdl/merge_sorter_tree_test_bench.vhd

