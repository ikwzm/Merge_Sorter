word.o : ../../../src/main/vhdl/core/word.vhd 
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/word.vhd

core_components.o : ../../../src/main/vhdl/core/core_components.vhd word.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/core_components.vhd

word_compare.o : ../../../src/main/vhdl/core/word_compare.vhd word.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/word_compare.vhd

word_queue.o : ../../../src/main/vhdl/core/word_queue.vhd word.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/word_queue.vhd

single_way_cell.o : ../../../src/main/vhdl/single_way_tree/single_way_cell.vhd word.o core_components.o word_compare.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/single_way_tree/single_way_cell.vhd

single_way_tree.o : ../../../src/main/vhdl/single_way_tree/single_way_tree.vhd word.o core_components.o single_way_cell.o word_queue.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/single_way_tree/single_way_tree.vhd

merge_sorter_single_way_tree_test_bench.o : ../../../src/test/vhdl/merge_sorter_single_way_tree_test_bench.vhd word.o single_way_tree.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/test/vhdl/merge_sorter_single_way_tree_test_bench.vhd

