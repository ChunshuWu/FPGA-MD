
################################################################
# This is a generated script based on design: FP_SUB_XYZ_D3
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2021.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source FP_SUB_XYZ_D3_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcu280-fsvh2892-2L-e
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name FP_SUB_XYZ_D3

# This script was generated for a remote BD. To create a non-remote design,
# change the variable <run_remote_bd_flow> to <0>.

set run_remote_bd_flow 1
if { $run_remote_bd_flow == 1 } {
  # Set the reference directory for source file relative paths (by default 
  # the value is script directory path)
  set origin_dir ./bd

  # Use origin directory path location variable, if specified in the tcl shell
  if { [info exists ::origin_dir_loc] } {
     set origin_dir $::origin_dir_loc
  }

  set str_bd_folder [file normalize ${origin_dir}]
  set str_bd_filepath ${str_bd_folder}/${design_name}/${design_name}.bd

  # Check if remote design exists on disk
  if { [file exists $str_bd_filepath ] == 1 } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2030 -severity "ERROR" "The remote BD file path <$str_bd_filepath> already exists!"}
     common::send_gid_msg -ssname BD::TCL -id 2031 -severity "INFO" "To create a non-remote BD, change the variable <run_remote_bd_flow> to <0>."
     common::send_gid_msg -ssname BD::TCL -id 2032 -severity "INFO" "Also make sure there is no design <$design_name> existing in your current project."

     return 1
  }

  # Check if design exists in memory
  set list_existing_designs [get_bd_designs -quiet $design_name]
  if { $list_existing_designs ne "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2033 -severity "ERROR" "The design <$design_name> already exists in this project! Will not create the remote BD <$design_name> at the folder <$str_bd_folder>."}

     common::send_gid_msg -ssname BD::TCL -id 2034 -severity "INFO" "To create a non-remote BD, change the variable <run_remote_bd_flow> to <0> or please set a different value to variable <design_name>."

     return 1
  }

  # Check if design exists on disk within project
  set list_existing_designs [get_files -quiet */${design_name}.bd]
  if { $list_existing_designs ne "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2035 -severity "ERROR" "The design <$design_name> already exists in this project at location:
    $list_existing_designs"}
     catch {common::send_gid_msg -ssname BD::TCL -id 2036 -severity "ERROR" "Will not create the remote BD <$design_name> at the folder <$str_bd_folder>."}

     common::send_gid_msg -ssname BD::TCL -id 2037 -severity "INFO" "To create a non-remote BD, change the variable <run_remote_bd_flow> to <0> or please set a different value to variable <design_name>."

     return 1
  }

  # Now can create the remote BD
  # NOTE - usage of <-dir> will create <$str_bd_folder/$design_name/$design_name.bd>
  create_bd_design -dir $str_bd_folder $design_name
} else {

  # Create regular design
  if { [catch {create_bd_design $design_name} errmsg] } {
     common::send_gid_msg -ssname BD::TCL -id 2038 -severity "INFO" "Please set a different value to variable <design_name>."

     return 1
  }
}

current_bd_design $design_name

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:floating_point:7.1\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set aclk [ create_bd_port -dir I -type clk -freq_hz 10000000 aclk ]
  set m_axis_result_tdata_0 [ create_bd_port -dir O -from 31 -to 0 m_axis_result_tdata_0 ]
  set m_axis_result_tdata_1 [ create_bd_port -dir O -from 31 -to 0 m_axis_result_tdata_1 ]
  set m_axis_result_tdata_2 [ create_bd_port -dir O -from 31 -to 0 m_axis_result_tdata_2 ]
  set m_axis_result_tvalid [ create_bd_port -dir O m_axis_result_tvalid ]
  set s_axis_a_tdata_0 [ create_bd_port -dir I -from 31 -to 0 s_axis_a_tdata_0 ]
  set s_axis_a_tdata_1 [ create_bd_port -dir I -from 31 -to 0 s_axis_a_tdata_1 ]
  set s_axis_a_tdata_2 [ create_bd_port -dir I -from 31 -to 0 s_axis_a_tdata_2 ]
  set s_axis_a_tvalid [ create_bd_port -dir I s_axis_a_tvalid ]
  set s_axis_b_tdata_0 [ create_bd_port -dir I -from 31 -to 0 s_axis_b_tdata_0 ]
  set s_axis_b_tdata_1 [ create_bd_port -dir I -from 31 -to 0 s_axis_b_tdata_1 ]
  set s_axis_b_tdata_2 [ create_bd_port -dir I -from 31 -to 0 s_axis_b_tdata_2 ]
  set s_axis_b_tvalid [ create_bd_port -dir I s_axis_b_tvalid ]

  # Create instance: floating_point_0, and set properties
  set floating_point_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_0 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {3} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Optimization {Speed_Optimized} \
   CONFIG.C_Rate {1} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {false} \
 ] $floating_point_0

  # Create instance: floating_point_1, and set properties
  set floating_point_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_1 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {3} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Optimization {Speed_Optimized} \
   CONFIG.C_Rate {1} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {false} \
 ] $floating_point_1

  # Create instance: floating_point_2, and set properties
  set floating_point_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 floating_point_2 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {3} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Optimization {Speed_Optimized} \
   CONFIG.C_Rate {1} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {false} \
 ] $floating_point_2

  # Create port connections
  connect_bd_net -net aclk_0_1 [get_bd_ports aclk] [get_bd_pins floating_point_0/aclk] [get_bd_pins floating_point_1/aclk] [get_bd_pins floating_point_2/aclk]
  connect_bd_net -net floating_point_0_m_axis_result_tdata [get_bd_ports m_axis_result_tdata_0] [get_bd_pins floating_point_0/m_axis_result_tdata]
  connect_bd_net -net floating_point_0_m_axis_result_tdata1 [get_bd_ports m_axis_result_tdata_1] [get_bd_pins floating_point_1/m_axis_result_tdata]
  connect_bd_net -net floating_point_0_m_axis_result_tdata2 [get_bd_ports m_axis_result_tdata_2] [get_bd_pins floating_point_2/m_axis_result_tdata]
  connect_bd_net -net floating_point_0_m_axis_result_tvalid [get_bd_ports m_axis_result_tvalid] [get_bd_pins floating_point_0/m_axis_result_tvalid]
  connect_bd_net -net s_axis_a_tdata_0_1 [get_bd_ports s_axis_a_tdata_0] [get_bd_pins floating_point_0/s_axis_a_tdata]
  connect_bd_net -net s_axis_a_tdata_0_2 [get_bd_ports s_axis_a_tdata_1] [get_bd_pins floating_point_1/s_axis_a_tdata]
  connect_bd_net -net s_axis_a_tdata_0_3 [get_bd_ports s_axis_a_tdata_2] [get_bd_pins floating_point_2/s_axis_a_tdata]
  connect_bd_net -net s_axis_a_tvalid_0_1 [get_bd_ports s_axis_a_tvalid] [get_bd_pins floating_point_0/s_axis_a_tvalid] [get_bd_pins floating_point_1/s_axis_a_tvalid] [get_bd_pins floating_point_2/s_axis_a_tvalid]
  connect_bd_net -net s_axis_b_tdata_0_1 [get_bd_ports s_axis_b_tdata_0] [get_bd_pins floating_point_0/s_axis_b_tdata]
  connect_bd_net -net s_axis_b_tdata_0_2 [get_bd_ports s_axis_b_tdata_1] [get_bd_pins floating_point_1/s_axis_b_tdata]
  connect_bd_net -net s_axis_b_tdata_0_3 [get_bd_ports s_axis_b_tdata_2] [get_bd_pins floating_point_2/s_axis_b_tdata]
  connect_bd_net -net s_axis_b_tvalid_0_1 [get_bd_ports s_axis_b_tvalid] [get_bd_pins floating_point_0/s_axis_b_tvalid] [get_bd_pins floating_point_1/s_axis_b_tvalid] [get_bd_pins floating_point_2/s_axis_b_tvalid]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


