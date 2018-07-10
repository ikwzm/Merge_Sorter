merge_sorter_core.o : ../../../src/main/vhdl/core/merge_sorter_core.vhd 
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/merge_sorter_core.vhd

merge_sorter_compare.o : ../../../src/main/vhdl/core/merge_sorter_compare.vhd 
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/merge_sorter_compare.vhd

merge_sorter_core_components.o : ../../../src/main/vhdl/core/merge_sorter_core_components.vhd merge_sorter_core.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/merge_sorter_core_components.vhd

merge_sorter_queue.o : ../../../src/main/vhdl/core/merge_sorter_queue.vhd merge_sorter_core.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/merge_sorter_queue.vhd

merge_sorter_single_way_cell.o : ../../../src/main/vhdl/single_way_tree/merge_sorter_single_way_cell.vhd merge_sorter_core.o merge_sorter_core_components.o merge_sorter_compare.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/single_way_tree/merge_sorter_single_way_cell.vhd

merge_sorter_single_way_tree.o : ../../../src/main/vhdl/single_way_tree/merge_sorter_single_way_tree.vhd merge_sorter_core.o merge_sorter_core_components.o merge_sorter_single_way_cell.o merge_sorter_queue.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/single_way_tree/merge_sorter_single_way_tree.vhd

merge_sorter_single_way_tree_test_bench.o : ../../../src/test/vhdl/merge_sorter_single_way_tree_test_bench.vhd merge_sorter_core.o merge_sorter_single_way_tree.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/test/vhdl/merge_sorter_single_way_tree_test_bench.vhd
