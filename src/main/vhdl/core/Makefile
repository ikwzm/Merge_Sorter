ENTITY_FILES = merge_sorter_core.vhd  \
               merge_sorter_node.vhd  \
               merge_sorter_tree.vhd  \
               core_intake_fifo.vhd   \
               core_stream_intake.vhd \
               word_compare.vhd       \
               word_queue.vhd         \
               drop_none.vhd          \
               ${ENDLIST}

core_components.vhd : ${ENTITY_FILES}
	../../../../PipeWork/tools/MakeComponentPackage.rb --verbose \
            --brief   'Merge Sorter Core Component Library Description Package' \
            --version 0.5.0 \
            --author  'Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>' \
            --library Merge_Sorter \
            --package Core_Components \
            --output  core_components.vhd \
            ${ENTITY_FILES}

clean:
	-rm core_components.vhd
