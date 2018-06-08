merge_sorter_queue.o : ../../../src/main/vhdl/core/merge_sorter_queue.vhd 
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/merge_sorter_queue.vhd

merge_sorter_core_components.o : ../../../src/main/vhdl/core/merge_sorter_core_components.vhd 
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/merge_sorter_core_components.vhd

merge_sorter_tree.o : ../../../src/main/vhdl/core/merge_sorter_tree.vhd merge_sorter_queue.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/merge_sorter_tree.vhd

merge_sorter_tree_test_bench.o : ../../../src/test/vhdl/merge_sorter_tree_test_bench.vhd merge_sorter_core_components.o merge_sorter_tree.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/test/vhdl/merge_sorter_tree_test_bench.vhd

