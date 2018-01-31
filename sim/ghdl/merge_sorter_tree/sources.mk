merge_sorter_compare.o : ../../../src/main/vhdl/merge_sorter_compare.vhd 
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/merge_sorter_compare.vhd

merge_sorter_queue.o : ../../../src/main/vhdl/merge_sorter_queue.vhd 
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/merge_sorter_queue.vhd

merge_sorter_node.o : ../../../src/main/vhdl/merge_sorter_node.vhd merge_sorter_compare.o merge_sorter_queue.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/merge_sorter_node.vhd

merge_sorter_tree.o : ../../../src/main/vhdl/merge_sorter_tree.vhd merge_sorter_queue.o merge_sorter_node.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/merge_sorter_tree.vhd

merge_sorter_tree_test_bench.o : ../../../src/test/vhdl/merge_sorter_tree_test_bench.vhd merge_sorter_tree.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/test/vhdl/merge_sorter_tree_test_bench.vhd

