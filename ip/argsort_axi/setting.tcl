#
# setting.tcl  Tcl script for create project and generate IP
#
set ip_name                 "ArgSort_AXI"
set ip_version              "1.7"
set ip_core_revision        1
set ip_vendor_name          "ikwzm"
set ip_description          "ArgSort_AXI"
set ip_library_name         "Merge_Sorter"
set ip_root_directory       [file join [file dirname [info script]] ".." "argsort_axi_$ip_version"]

set project_name            "argsort_axi"
set project_directory       [file join [file dirname [info script]] "work"]
set device_parts            "xc7z010clg400-1"
