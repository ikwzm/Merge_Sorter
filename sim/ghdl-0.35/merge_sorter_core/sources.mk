word.o : ../../../src/main/vhdl/core/word.vhd 
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/word.vhd

core_components.o : ../../../src/main/vhdl/core/core_components.vhd word.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/core_components.vhd

word_compare.o : ../../../src/main/vhdl/core/word_compare.vhd word.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/word_compare.vhd

merge_sorter_node.o : ../../../src/main/vhdl/core/merge_sorter_node.vhd word.o core_components.o word_compare.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/merge_sorter_node.vhd

word_queue.o : ../../../src/main/vhdl/core/word_queue.vhd word.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/word_queue.vhd

core_intake_fifo.o : ../../../src/main/vhdl/core/core_intake_fifo.vhd word.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/core_intake_fifo.vhd

core_stream_intake.o : ../../../src/main/vhdl/core/core_stream_intake.vhd word.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/core_stream_intake.vhd

drop_none.o : ../../../src/main/vhdl/core/drop_none.vhd word.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/drop_none.vhd

merge_sorter_tree.o : ../../../src/main/vhdl/core/merge_sorter_tree.vhd word.o core_components.o merge_sorter_node.o word_queue.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/merge_sorter_tree.vhd

merge_sorter_core.o : ../../../src/main/vhdl/core/merge_sorter_core.vhd word.o core_components.o core_stream_intake.o core_intake_fifo.o merge_sorter_tree.o word_queue.o drop_none.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/main/vhdl/core/merge_sorter_core.vhd

merge_sorter_core_test_bench.o : ../../../src/test/vhdl/merge_sorter_core_test_bench.vhd core_components.o merge_sorter_core.o
	ghdl -a -C $(GHDLFLAGS) --work=MERGE_SORTER ../../../src/test/vhdl/merge_sorter_core_test_bench.vhd

