
################################################################
# This is a generated script based on design: FORCE_COMPUTE
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
# source FORCE_COMPUTE_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcu280-fsvh2892-2L-e
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name FORCE_COMPUTE

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
  set clk [ create_bd_port -dir I -type clk -freq_hz 10000000 clk ]
  set coeff_8 [ create_bd_port -dir I -from 31 -to 0 coeff_8 ]
  set coeff_14 [ create_bd_port -dir I -from 31 -to 0 coeff_14 ]
  set dx [ create_bd_port -dir I -from 31 -to 0 -type data dx ]
  set dy [ create_bd_port -dir I -from 31 -to 0 -type data dy ]
  set dz [ create_bd_port -dir I -from 31 -to 0 -type data dz ]
  set frc_valid [ create_bd_port -dir O frc_valid ]
  set fx [ create_bd_port -dir O -from 31 -to 0 fx ]
  set fy [ create_bd_port -dir O -from 31 -to 0 fy ]
  set fz [ create_bd_port -dir O -from 31 -to 0 fz ]
  set r2 [ create_bd_port -dir I -from 31 -to 0 r2 ]
  set term_0_8 [ create_bd_port -dir I -from 31 -to 0 term_0_8 ]
  set term_0_14 [ create_bd_port -dir I -from 31 -to 0 term_0_14 ]
  set term_1_8 [ create_bd_port -dir I -from 31 -to 0 term_1_8 ]
  set term_1_14 [ create_bd_port -dir I -from 31 -to 0 term_1_14 ]
  set term_valid [ create_bd_port -dir I term_valid ]

  # Create instance: MUL_ADD_TERM_8, and set properties
  set MUL_ADD_TERM_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 MUL_ADD_TERM_8 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {5} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {false} \
   CONFIG.Operation_Type {FMA} \
   CONFIG.Result_Precision_Type {Single} \
 ] $MUL_ADD_TERM_8

  # Create instance: MUL_ADD_TERM_14, and set properties
  set MUL_ADD_TERM_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 MUL_ADD_TERM_14 ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Add} \
   CONFIG.C_Latency {5} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {false} \
   CONFIG.Operation_Type {FMA} \
   CONFIG.Result_Precision_Type {Single} \
 ] $MUL_ADD_TERM_14

  # Create instance: MUL_COEFF_8, and set properties
  set MUL_COEFF_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 MUL_COEFF_8 ]
  set_property -dict [ list \
   CONFIG.C_Latency {4} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $MUL_COEFF_8

  # Create instance: MUL_COEFF_14, and set properties
  set MUL_COEFF_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 MUL_COEFF_14 ]
  set_property -dict [ list \
   CONFIG.C_Latency {4} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $MUL_COEFF_14

  # Create instance: MUL_FX, and set properties
  set MUL_FX [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 MUL_FX ]
  set_property -dict [ list \
   CONFIG.C_Latency {4} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $MUL_FX

  # Create instance: MUL_FY, and set properties
  set MUL_FY [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 MUL_FY ]
  set_property -dict [ list \
   CONFIG.C_Latency {4} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $MUL_FY

  # Create instance: MUL_FZ, and set properties
  set MUL_FZ [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 MUL_FZ ]
  set_property -dict [ list \
   CONFIG.C_Latency {4} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $MUL_FZ

  # Create instance: SUB_BASE_FORCE, and set properties
  set SUB_BASE_FORCE [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 SUB_BASE_FORCE ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {3} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {false} \
 ] $SUB_BASE_FORCE

  # Create port connections
  connect_bd_net -net MUL_ADD_TERM_14_m_axis_result_tdata [get_bd_pins MUL_ADD_TERM_14/m_axis_result_tdata] [get_bd_pins MUL_COEFF_14/s_axis_b_tdata]
  connect_bd_net -net MUL_ADD_TERM_8_m_axis_result_tdata [get_bd_pins MUL_ADD_TERM_8/m_axis_result_tdata] [get_bd_pins MUL_COEFF_8/s_axis_b_tdata]
  connect_bd_net -net MUL_ADD_TERM_8_m_axis_result_tvalid [get_bd_pins MUL_ADD_TERM_8/m_axis_result_tvalid] [get_bd_pins MUL_COEFF_14/s_axis_a_tvalid] [get_bd_pins MUL_COEFF_14/s_axis_b_tvalid] [get_bd_pins MUL_COEFF_8/s_axis_a_tvalid] [get_bd_pins MUL_COEFF_8/s_axis_b_tvalid]
  connect_bd_net -net MUL_COEFF_14_m_axis_result_tdata [get_bd_pins MUL_COEFF_14/m_axis_result_tdata] [get_bd_pins SUB_BASE_FORCE/s_axis_a_tdata]
  connect_bd_net -net MUL_COEFF_14_m_axis_result_tvalid [get_bd_pins MUL_COEFF_14/m_axis_result_tvalid] [get_bd_pins SUB_BASE_FORCE/s_axis_b_tvalid]
  connect_bd_net -net MUL_COEFF_8_m_axis_result_tdata [get_bd_pins MUL_COEFF_8/m_axis_result_tdata] [get_bd_pins SUB_BASE_FORCE/s_axis_b_tdata]
  connect_bd_net -net MUL_COEFF_8_m_axis_result_tvalid [get_bd_pins MUL_COEFF_8/m_axis_result_tvalid] [get_bd_pins SUB_BASE_FORCE/s_axis_a_tvalid]
  connect_bd_net -net MUL_FX1_m_axis_result_tdata [get_bd_ports fy] [get_bd_pins MUL_FY/m_axis_result_tdata]
  connect_bd_net -net MUL_FX2_m_axis_result_tdata [get_bd_ports fz] [get_bd_pins MUL_FZ/m_axis_result_tdata]
  connect_bd_net -net MUL_FX_m_axis_result_tdata [get_bd_ports fx] [get_bd_pins MUL_FX/m_axis_result_tdata]
  connect_bd_net -net MUL_FY_m_axis_result_tvalid [get_bd_ports frc_valid] [get_bd_pins MUL_FY/m_axis_result_tvalid]
  connect_bd_net -net SUB_BASE_FORCE_m_axis_result_tdata [get_bd_pins MUL_FX/s_axis_b_tdata] [get_bd_pins MUL_FY/s_axis_b_tdata] [get_bd_pins MUL_FZ/s_axis_b_tdata] [get_bd_pins SUB_BASE_FORCE/m_axis_result_tdata]
  connect_bd_net -net SUB_BASE_FORCE_m_axis_result_tvalid [get_bd_pins MUL_FX/s_axis_a_tvalid] [get_bd_pins MUL_FX/s_axis_b_tvalid] [get_bd_pins MUL_FY/s_axis_a_tvalid] [get_bd_pins MUL_FY/s_axis_b_tvalid] [get_bd_pins MUL_FZ/s_axis_a_tvalid] [get_bd_pins MUL_FZ/s_axis_b_tvalid] [get_bd_pins SUB_BASE_FORCE/m_axis_result_tvalid]
  connect_bd_net -net aclk_0_1 [get_bd_ports clk] [get_bd_pins MUL_ADD_TERM_14/aclk] [get_bd_pins MUL_ADD_TERM_8/aclk] [get_bd_pins MUL_COEFF_14/aclk] [get_bd_pins MUL_COEFF_8/aclk] [get_bd_pins MUL_FX/aclk] [get_bd_pins MUL_FY/aclk] [get_bd_pins MUL_FZ/aclk] [get_bd_pins SUB_BASE_FORCE/aclk]
  connect_bd_net -net dx_1 [get_bd_ports dx] [get_bd_pins MUL_FX/s_axis_a_tdata]
  connect_bd_net -net dy_1 [get_bd_ports dy] [get_bd_pins MUL_FY/s_axis_a_tdata]
  connect_bd_net -net dz_1 [get_bd_ports dz] [get_bd_pins MUL_FZ/s_axis_a_tdata]
  connect_bd_net -net s_axis_a_tdata_0_1 [get_bd_ports term_1_14] [get_bd_pins MUL_ADD_TERM_14/s_axis_a_tdata]
  connect_bd_net -net s_axis_a_tdata_0_2 [get_bd_ports coeff_8] [get_bd_pins MUL_COEFF_8/s_axis_a_tdata]
  connect_bd_net -net s_axis_a_tdata_0_3 [get_bd_ports coeff_14] [get_bd_pins MUL_COEFF_14/s_axis_a_tdata]
  connect_bd_net -net s_axis_a_tdata_1_1 [get_bd_ports term_1_8] [get_bd_pins MUL_ADD_TERM_8/s_axis_a_tdata]
  connect_bd_net -net s_axis_a_tvalid_0_1 [get_bd_ports term_valid] [get_bd_pins MUL_ADD_TERM_14/s_axis_a_tvalid] [get_bd_pins MUL_ADD_TERM_14/s_axis_b_tvalid] [get_bd_pins MUL_ADD_TERM_14/s_axis_c_tvalid] [get_bd_pins MUL_ADD_TERM_8/s_axis_a_tvalid] [get_bd_pins MUL_ADD_TERM_8/s_axis_b_tvalid] [get_bd_pins MUL_ADD_TERM_8/s_axis_c_tvalid]
  connect_bd_net -net s_axis_b_tdata_0_1 [get_bd_ports r2] [get_bd_pins MUL_ADD_TERM_14/s_axis_b_tdata] [get_bd_pins MUL_ADD_TERM_8/s_axis_b_tdata]
  connect_bd_net -net s_axis_c_tdata_0_1 [get_bd_ports term_0_8] [get_bd_pins MUL_ADD_TERM_8/s_axis_c_tdata]
  connect_bd_net -net s_axis_c_tdata_1_1 [get_bd_ports term_0_14] [get_bd_pins MUL_ADD_TERM_14/s_axis_c_tdata]

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


