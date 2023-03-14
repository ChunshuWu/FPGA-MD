
################################################################
# This is a generated script based on design: MU_PIPELINE
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
# source MU_PIPELINE_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcu280-fsvh2892-2L-e
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name MU_PIPELINE

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
xilinx.com:ip:c_shift_ram:12.0\
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
  set i_coeff [ create_bd_port -dir I -from 31 -to 0 i_coeff ]
  set i_delay_signals [ create_bd_port -dir I -from 73 -to 0 -type data i_delay_signals ]
  set i_fx [ create_bd_port -dir I -from 31 -to 0 i_fx ]
  set i_fy [ create_bd_port -dir I -from 31 -to 0 i_fy ]
  set i_fz [ create_bd_port -dir I -from 31 -to 0 i_fz ]
  set i_time_step [ create_bd_port -dir I -from 31 -to 0 i_time_step ]
  set i_valid [ create_bd_port -dir I i_valid ]
  set i_vx [ create_bd_port -dir I -from 31 -to 0 -type data i_vx ]
  set i_vy [ create_bd_port -dir I -from 31 -to 0 -type data i_vy ]
  set i_vz [ create_bd_port -dir I -from 31 -to 0 -type data i_vz ]
  set o_data_valid [ create_bd_port -dir O o_data_valid ]
  set o_delay_signals [ create_bd_port -dir O -from 73 -to 0 -type data o_delay_signals ]
  set o_dx [ create_bd_port -dir O -from 31 -to 0 o_dx ]
  set o_dy [ create_bd_port -dir O -from 31 -to 0 o_dy ]
  set o_dz [ create_bd_port -dir O -from 31 -to 0 o_dz ]
  set o_vx [ create_bd_port -dir O -from 31 -to 0 -type data o_vx ]
  set o_vy [ create_bd_port -dir O -from 31 -to 0 -type data o_vy ]
  set o_vz [ create_bd_port -dir O -from 31 -to 0 -type data o_vz ]

  # Create instance: acceleration_to_vel_x, and set properties
  set acceleration_to_vel_x [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 acceleration_to_vel_x ]
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
 ] $acceleration_to_vel_x

  # Create instance: acceleration_to_vel_y, and set properties
  set acceleration_to_vel_y [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 acceleration_to_vel_y ]
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
 ] $acceleration_to_vel_y

  # Create instance: acceleration_to_vel_z, and set properties
  set acceleration_to_vel_z [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 acceleration_to_vel_z ]
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
 ] $acceleration_to_vel_z

  # Create instance: delay_signals_D13, and set properties
  set delay_signals_D13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 delay_signals_D13 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {00000000000000000000000000000000000000000000000000000000000000000000000000} \
   CONFIG.DefaultData {00000000000000000000000000000000000000000000000000000000000000000000000000} \
   CONFIG.Depth {13} \
   CONFIG.SyncInitVal {00000000000000000000000000000000000000000000000000000000000000000000000000} \
   CONFIG.Width {74} \
 ] $delay_signals_D13

  # Create instance: frc_to_acceleration_x, and set properties
  set frc_to_acceleration_x [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 frc_to_acceleration_x ]
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
 ] $frc_to_acceleration_x

  # Create instance: frc_to_acceleration_y, and set properties
  set frc_to_acceleration_y [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 frc_to_acceleration_y ]
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
 ] $frc_to_acceleration_y

  # Create instance: frc_to_acceleration_z, and set properties
  set frc_to_acceleration_z [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 frc_to_acceleration_z ]
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
 ] $frc_to_acceleration_z

  # Create instance: new_vel_x_D4, and set properties
  set new_vel_x_D4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 new_vel_x_D4 ]
  set_property -dict [ list \
   CONFIG.Depth {4} \
   CONFIG.Width {32} \
 ] $new_vel_x_D4

  # Create instance: new_vel_y_D4, and set properties
  set new_vel_y_D4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 new_vel_y_D4 ]
  set_property -dict [ list \
   CONFIG.Depth {4} \
   CONFIG.Width {32} \
 ] $new_vel_y_D4

  # Create instance: new_vel_z_D4, and set properties
  set new_vel_z_D4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 new_vel_z_D4 ]
  set_property -dict [ list \
   CONFIG.Depth {4} \
   CONFIG.Width {32} \
 ] $new_vel_z_D4

  # Create instance: vel_to_dx, and set properties
  set vel_to_dx [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 vel_to_dx ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Both} \
   CONFIG.C_Latency {4} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $vel_to_dx

  # Create instance: vel_to_dy, and set properties
  set vel_to_dy [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 vel_to_dy ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Both} \
   CONFIG.C_Latency {4} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $vel_to_dy

  # Create instance: vel_to_dz, and set properties
  set vel_to_dz [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 vel_to_dz ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Both} \
   CONFIG.C_Latency {4} \
   CONFIG.C_Mult_Usage {Medium_Usage} \
   CONFIG.C_Rate {1} \
   CONFIG.C_Result_Exponent_Width {8} \
   CONFIG.C_Result_Fraction_Width {24} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {false} \
   CONFIG.Operation_Type {Multiply} \
   CONFIG.Result_Precision_Type {Single} \
 ] $vel_to_dz

  # Create instance: vel_x_D4, and set properties
  set vel_x_D4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 vel_x_D4 ]
  set_property -dict [ list \
   CONFIG.Depth {4} \
   CONFIG.Width {32} \
 ] $vel_x_D4

  # Create instance: vel_y_D4, and set properties
  set vel_y_D4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 vel_y_D4 ]
  set_property -dict [ list \
   CONFIG.Depth {4} \
   CONFIG.Width {32} \
 ] $vel_y_D4

  # Create instance: vel_z_D4, and set properties
  set vel_z_D4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 vel_z_D4 ]
  set_property -dict [ list \
   CONFIG.Depth {4} \
   CONFIG.Width {32} \
 ] $vel_z_D4

  # Create port connections
  connect_bd_net -net D_0_1 [get_bd_ports i_vx] [get_bd_pins vel_x_D4/D]
  connect_bd_net -net D_0_2 [get_bd_ports i_delay_signals] [get_bd_pins delay_signals_D13/D]
  connect_bd_net -net D_1_1 [get_bd_ports i_vz] [get_bd_pins vel_z_D4/D]
  connect_bd_net -net D_2_1 [get_bd_ports i_vy] [get_bd_pins vel_y_D4/D]
  connect_bd_net -net acceleration_to_vel_x_m_axis_result_tdata [get_bd_pins acceleration_to_vel_x/m_axis_result_tdata] [get_bd_pins new_vel_x_D4/D] [get_bd_pins vel_to_dx/s_axis_a_tdata]
  connect_bd_net -net acceleration_to_vel_y_m_axis_result_tdata [get_bd_pins acceleration_to_vel_y/m_axis_result_tdata] [get_bd_pins new_vel_y_D4/D] [get_bd_pins vel_to_dy/s_axis_a_tdata]
  connect_bd_net -net acceleration_to_vel_y_m_axis_result_tvalid [get_bd_pins acceleration_to_vel_y/m_axis_result_tvalid] [get_bd_pins vel_to_dx/s_axis_a_tvalid] [get_bd_pins vel_to_dx/s_axis_b_tvalid] [get_bd_pins vel_to_dy/s_axis_a_tvalid] [get_bd_pins vel_to_dy/s_axis_b_tvalid] [get_bd_pins vel_to_dz/s_axis_a_tvalid] [get_bd_pins vel_to_dz/s_axis_b_tvalid]
  connect_bd_net -net acceleration_to_vel_z_m_axis_result_tdata [get_bd_pins acceleration_to_vel_z/m_axis_result_tdata] [get_bd_pins new_vel_z_D4/D] [get_bd_pins vel_to_dz/s_axis_a_tdata]
  connect_bd_net -net aclk_0_1 [get_bd_ports clk] [get_bd_pins acceleration_to_vel_x/aclk] [get_bd_pins acceleration_to_vel_y/aclk] [get_bd_pins acceleration_to_vel_z/aclk] [get_bd_pins delay_signals_D13/CLK] [get_bd_pins frc_to_acceleration_x/aclk] [get_bd_pins frc_to_acceleration_y/aclk] [get_bd_pins frc_to_acceleration_z/aclk] [get_bd_pins new_vel_x_D4/CLK] [get_bd_pins new_vel_y_D4/CLK] [get_bd_pins new_vel_z_D4/CLK] [get_bd_pins vel_to_dx/aclk] [get_bd_pins vel_to_dy/aclk] [get_bd_pins vel_to_dz/aclk] [get_bd_pins vel_x_D4/CLK] [get_bd_pins vel_y_D4/CLK] [get_bd_pins vel_z_D4/CLK]
  connect_bd_net -net delay_signals_D13_Q [get_bd_ports o_delay_signals] [get_bd_pins delay_signals_D13/Q]
  connect_bd_net -net frc_to_acceleration_x_m_axis_result_tdata [get_bd_pins acceleration_to_vel_x/s_axis_a_tdata] [get_bd_pins frc_to_acceleration_x/m_axis_result_tdata]
  connect_bd_net -net frc_to_acceleration_y_m_axis_result_tdata [get_bd_pins acceleration_to_vel_y/s_axis_a_tdata] [get_bd_pins frc_to_acceleration_y/m_axis_result_tdata]
  connect_bd_net -net frc_to_acceleration_y_m_axis_result_tvalid [get_bd_pins acceleration_to_vel_x/s_axis_a_tvalid] [get_bd_pins acceleration_to_vel_x/s_axis_b_tvalid] [get_bd_pins acceleration_to_vel_x/s_axis_c_tvalid] [get_bd_pins acceleration_to_vel_y/s_axis_a_tvalid] [get_bd_pins acceleration_to_vel_y/s_axis_b_tvalid] [get_bd_pins acceleration_to_vel_y/s_axis_c_tvalid] [get_bd_pins acceleration_to_vel_z/s_axis_a_tvalid] [get_bd_pins acceleration_to_vel_z/s_axis_b_tvalid] [get_bd_pins acceleration_to_vel_z/s_axis_c_tvalid] [get_bd_pins frc_to_acceleration_y/m_axis_result_tvalid]
  connect_bd_net -net frc_to_acceleration_z_m_axis_result_tdata [get_bd_pins acceleration_to_vel_z/s_axis_a_tdata] [get_bd_pins frc_to_acceleration_z/m_axis_result_tdata]
  connect_bd_net -net new_vel_x_D4_Q [get_bd_ports o_vx] [get_bd_pins new_vel_x_D4/Q]
  connect_bd_net -net new_vel_y_D4_Q [get_bd_ports o_vy] [get_bd_pins new_vel_y_D4/Q]
  connect_bd_net -net new_vel_z_D4_Q [get_bd_ports o_vz] [get_bd_pins new_vel_z_D4/Q]
  connect_bd_net -net s_axis_a_tdata_0_1 [get_bd_ports i_fz] [get_bd_pins frc_to_acceleration_z/s_axis_a_tdata]
  connect_bd_net -net s_axis_a_tdata_1_1 [get_bd_ports i_fy] [get_bd_pins frc_to_acceleration_y/s_axis_a_tdata]
  connect_bd_net -net s_axis_a_tdata_2_1 [get_bd_ports i_fx] [get_bd_pins frc_to_acceleration_x/s_axis_a_tdata]
  connect_bd_net -net s_axis_a_tvalid_0_1 [get_bd_ports i_valid] [get_bd_pins frc_to_acceleration_x/s_axis_a_tvalid] [get_bd_pins frc_to_acceleration_x/s_axis_b_tvalid] [get_bd_pins frc_to_acceleration_y/s_axis_a_tvalid] [get_bd_pins frc_to_acceleration_y/s_axis_b_tvalid] [get_bd_pins frc_to_acceleration_z/s_axis_a_tvalid] [get_bd_pins frc_to_acceleration_z/s_axis_b_tvalid]
  connect_bd_net -net s_axis_b_tdata_0_1 [get_bd_ports i_time_step] [get_bd_pins acceleration_to_vel_x/s_axis_b_tdata] [get_bd_pins acceleration_to_vel_y/s_axis_b_tdata] [get_bd_pins acceleration_to_vel_z/s_axis_b_tdata] [get_bd_pins vel_to_dx/s_axis_b_tdata] [get_bd_pins vel_to_dy/s_axis_b_tdata] [get_bd_pins vel_to_dz/s_axis_b_tdata]
  connect_bd_net -net s_axis_b_tdata_1_1 [get_bd_ports i_coeff] [get_bd_pins frc_to_acceleration_x/s_axis_b_tdata] [get_bd_pins frc_to_acceleration_y/s_axis_b_tdata] [get_bd_pins frc_to_acceleration_z/s_axis_b_tdata]
  connect_bd_net -net vel_to_pos_x_m_axis_result_tdata [get_bd_ports o_dx] [get_bd_pins vel_to_dx/m_axis_result_tdata]
  connect_bd_net -net vel_to_pos_x_m_axis_result_tvalid [get_bd_ports o_data_valid] [get_bd_pins vel_to_dx/m_axis_result_tvalid]
  connect_bd_net -net vel_to_pos_y_m_axis_result_tdata [get_bd_ports o_dy] [get_bd_pins vel_to_dy/m_axis_result_tdata]
  connect_bd_net -net vel_to_pos_z_m_axis_result_tdata [get_bd_ports o_dz] [get_bd_pins vel_to_dz/m_axis_result_tdata]
  connect_bd_net -net vel_x_D3_Q [get_bd_pins acceleration_to_vel_x/s_axis_c_tdata] [get_bd_pins vel_x_D4/Q]
  connect_bd_net -net vel_y_D3_Q [get_bd_pins acceleration_to_vel_y/s_axis_c_tdata] [get_bd_pins vel_y_D4/Q]
  connect_bd_net -net vel_z_D3_Q [get_bd_pins acceleration_to_vel_z/s_axis_c_tdata] [get_bd_pins vel_z_D4/Q]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


common::send_gid_msg -ssname BD::TCL -id 2053 -severity "WARNING" "This Tcl script was generated from a block design that has not been validated. It is possible that design <$design_name> may result in errors during validation."

