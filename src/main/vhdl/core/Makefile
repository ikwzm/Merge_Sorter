ENTITY_FILES = merge_sorter_core_main.vhd          \
               merge_sorter_core_fifo.vhd          \
               merge_sorter_core_stream_intake.vhd \
               ${ENDLIST}

merge_sorter_core_components.vhd : ${ENTITY_FILES}
	../../../../PipeWork/tools/MakeComponentPackage.rb --verbose \
            --brief   'Merge Sorter Core Component Library Description Package' \
            --version 0.0.9 \
            --author  'Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>' \
            --library Merge_Sorter \
            --package Merge_Sorter_Core_Components \
            --output  merge_sorter_core_components.vhd \
            ${ENTITY_FILES}

clean:
	-rm merge_sorter_core_components.vhd
