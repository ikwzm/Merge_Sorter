#
# update_xgui.tcl  Tcl script for Update XGUI
#
set ip_name                 "ArgSort_AXI"
set ip_version              "1.5"
set project_name            "argsort_axi"


set ip_root_directory       [file join [file dirname [info script]] ".." "argsort_axi_$ip_version"]
set project_directory       [file join [file dirname [info script]] "work"]
set ip_version_             [string map {. _} $ip_version]
set xgui_tcl_file           "${ip_name}_v${ip_version_}.tcl"

#
# Copy GUI Tcl file to IP
#
file copy -force [file join "xgui" $xgui_tcl_file] [file join $ip_root_directory "xgui"]
#
# Open project
#
open_project [file join $project_directory $project_name]
#
# Open IP-XACT file
# 
ipx::open_ipxact_file [file join $ip_root_directory "component.xml"]
#
# Update GUI Tcl file
#
ipx::create_xgui_files          [ipx::current_core]
#
# Set Display Name same as Name
#
proc set_user_parameter_display_name_same_as_name { user_parameter } {
    set name         [get_property name $user_parameter]
    set display_name $name
    puts "## change_display_name $name -> $display_name"
    set_property display_name $display_name $user_parameter
}
proc set_user_parameter_all_display_name_same_as_name {} {
    set user_parameter_list [ipx::get_user_parameters -of_objects [ipx::current_core]]
    foreach user_parameter $user_parameter_list {
        set_user_parameter_display_name_same_as_name $user_parameter
    }
}
set_user_parameter_all_display_name_same_as_name
#
# Add PipeWork Logo
#
ipx::add_file_group -type utility {} [ipx::current_core]
file copy -force [file join [file dirname [info script]] ".." ".." "PipeWork" "icons" PipeWork_100x100.png] [file join $ip_root_directory "src" "PipeWork.png" ]
ipx::add_file "src/PipeWork.png" [ipx::get_file_groups xilinx_utilityxitfiles -of_objects [ipx::current_core]]
set_property type LOGO [ipx::get_files "src/PipeWork.png" -of_objects [ipx::get_file_groups xilinx_utilityxitfiles -of_objects [ipx::current_core]]]
#
# Generate files
#
# ipx::merge_project_changes port [ipx::current_core]
# ipx::create_xgui_files          [ipx::current_core]
ipx::update_checksums           [ipx::current_core]
ipx::check_integrity            [ipx::current_core]
ipx::save_core                  [ipx::current_core]
#
# Close and Done.
#
close_project

