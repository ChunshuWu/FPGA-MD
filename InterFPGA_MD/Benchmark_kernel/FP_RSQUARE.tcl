
################################################################
# This is a generated script based on design: FP_RSQUARE
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
# source FP_RSQUARE_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcu280-fsvh2892-2L-e
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name FP_RSQUARE

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
  set aclk [ create_bd_port -dir I -type clk -freq_hz 10000000 aclk ]
  set d25_elements [ create_bd_port -dir O -from 3 -to 0 -type data d25_elements ]
  set d36_home_parid [ create_bd_port -dir O -from 8 -to 0 -type data d36_home_parid ]
  set d36_nb_cid [ create_bd_port -dir O -from 5 -to 0 -type data d36_nb_cid ]
  set d36_nb_parid [ create_bd_port -dir O -from 8 -to 0 -type data d36_nb_parid ]
  set d36_nb_reg_release_flag [ create_bd_port -dir O -from 0 -to 0 -type data d36_nb_reg_release_flag ]
  set d36_nb_reg_sel [ create_bd_port -dir O -from 5 -to 0 -type data d36_nb_reg_sel ]
  set dx [ create_bd_port -dir O -from 31 -to 0 -type data dx ]
  set dy [ create_bd_port -dir O -from 31 -to 0 -type data dy ]
  set dz [ create_bd_port -dir O -from 31 -to 0 -type data dz ]
  set elements [ create_bd_port -dir I -from 3 -to 0 -type data elements ]
  set home_parid [ create_bd_port -dir I -from 8 -to 0 -type data home_parid ]
  set home_valid [ create_bd_port -dir I home_valid ]
  set home_x [ create_bd_port -dir I -from 31 -to 0 home_x ]
  set home_y [ create_bd_port -dir I -from 31 -to 0 home_y ]
  set home_z [ create_bd_port -dir I -from 31 -to 0 home_z ]
  set nb_cid [ create_bd_port -dir I -from 5 -to 0 -type data nb_cid ]
  set nb_parid [ create_bd_port -dir I -from 8 -to 0 -type data nb_parid ]
  set nb_reg_release_flag [ create_bd_port -dir I -from 0 -to 0 -type data nb_reg_release_flag ]
  set nb_reg_sel [ create_bd_port -dir I -from 5 -to 0 -type data nb_reg_sel ]
  set nb_valid [ create_bd_port -dir I nb_valid ]
  set nb_x [ create_bd_port -dir I -from 31 -to 0 nb_x ]
  set nb_y [ create_bd_port -dir I -from 31 -to 0 nb_y ]
  set nb_z [ create_bd_port -dir I -from 31 -to 0 nb_z ]
  set r2 [ create_bd_port -dir O -from 31 -to 0 r2 ]
  set r2_valid [ create_bd_port -dir O r2_valid ]

  # Create instance: dx, and set properties
  set dx [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 dx ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {3} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Optimization {Speed_Optimized} \
   CONFIG.C_Rate {1} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {false} \
 ] $dx

  # Create instance: dx2, and set properties
  set dx2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 dx2 ]
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
 ] $dx2

  # Create instance: dx2_dy2, and set properties
  set dx2_dy2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 dx2_dy2 ]
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
 ] $dx2_dy2

  # Create instance: dx_d28, and set properties
  set dx_d28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 dx_d28 ]
  set_property -dict [ list \
   CONFIG.Depth {28} \
   CONFIG.Width {32} \
 ] $dx_d28

  # Create instance: dy, and set properties
  set dy [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 dy ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {3} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Optimization {Speed_Optimized} \
   CONFIG.C_Rate {1} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {false} \
 ] $dy

  # Create instance: dy_d4, and set properties
  set dy_d4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 dy_d4 ]
  set_property -dict [ list \
   CONFIG.Depth {4} \
   CONFIG.Width {32} \
 ] $dy_d4

  # Create instance: dy_d24, and set properties
  set dy_d24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 dy_d24 ]
  set_property -dict [ list \
   CONFIG.Depth {24} \
   CONFIG.Width {32} \
 ] $dy_d24

  # Create instance: dz, and set properties
  set dz [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 dz ]
  set_property -dict [ list \
   CONFIG.Add_Sub_Value {Subtract} \
   CONFIG.C_Latency {3} \
   CONFIG.C_Mult_Usage {Full_Usage} \
   CONFIG.C_Optimization {Speed_Optimized} \
   CONFIG.C_Rate {1} \
   CONFIG.Flow_Control {NonBlocking} \
   CONFIG.Has_RESULT_TREADY {false} \
   CONFIG.Maximum_Latency {false} \
 ] $dz

  # Create instance: dz_d9, and set properties
  set dz_d9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 dz_d9 ]
  set_property -dict [ list \
   CONFIG.Depth {9} \
   CONFIG.Width {32} \
 ] $dz_d9

  # Create instance: dz_d19, and set properties
  set dz_d19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 dz_d19 ]
  set_property -dict [ list \
   CONFIG.Depth {19} \
   CONFIG.Width {32} \
 ] $dz_d19

  # Create instance: elements_d25, and set properties
  set elements_d25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 elements_d25 ]
  set_property -dict [ list \
   CONFIG.Depth {25} \
   CONFIG.Width {4} \
 ] $elements_d25

  # Create instance: home_parid_d36, and set properties
  set home_parid_d36 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 home_parid_d36 ]
  set_property -dict [ list \
   CONFIG.Depth {36} \
   CONFIG.Width {9} \
 ] $home_parid_d36

  # Create instance: nb_cid_d36, and set properties
  set nb_cid_d36 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 nb_cid_d36 ]
  set_property -dict [ list \
   CONFIG.Depth {36} \
   CONFIG.Width {6} \
 ] $nb_cid_d36

  # Create instance: nb_parid_d36, and set properties
  set nb_parid_d36 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 nb_parid_d36 ]
  set_property -dict [ list \
   CONFIG.Depth {36} \
   CONFIG.Width {9} \
 ] $nb_parid_d36

  # Create instance: nb_reg_release_sel_d36, and set properties
  set nb_reg_release_sel_d36 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 nb_reg_release_sel_d36 ]
  set_property -dict [ list \
   CONFIG.Depth {36} \
   CONFIG.Width {1} \
 ] $nb_reg_release_sel_d36

  # Create instance: nb_reg_sel_d36, and set properties
  set nb_reg_sel_d36 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 nb_reg_sel_d36 ]
  set_property -dict [ list \
   CONFIG.Depth {36} \
   CONFIG.Width {6} \
 ] $nb_reg_sel_d36

  # Create instance: r2, and set properties
  set r2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:floating_point:7.1 r2 ]
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
 ] $r2

  # Create port connections
  connect_bd_net -net D_0_1 [get_bd_ports nb_parid] [get_bd_pins nb_parid_d36/D]
  connect_bd_net -net D_0_2 [get_bd_ports elements] [get_bd_pins elements_d25/D]
  connect_bd_net -net D_0_3 [get_bd_ports nb_cid] [get_bd_pins nb_cid_d36/D]
  connect_bd_net -net D_0_4 [get_bd_ports nb_reg_sel] [get_bd_pins nb_reg_sel_d36/D]
  connect_bd_net -net D_1_1 [get_bd_ports home_parid] [get_bd_pins home_parid_d36/D]
  connect_bd_net -net D_1_2 [get_bd_ports nb_reg_release_flag] [get_bd_pins nb_reg_release_sel_d36/D]
  connect_bd_net -net aclk_0_1 [get_bd_ports aclk] [get_bd_pins dx/aclk] [get_bd_pins dx2/aclk] [get_bd_pins dx2_dy2/aclk] [get_bd_pins dx_d28/CLK] [get_bd_pins dy/aclk] [get_bd_pins dy_d24/CLK] [get_bd_pins dy_d4/CLK] [get_bd_pins dz/aclk] [get_bd_pins dz_d19/CLK] [get_bd_pins dz_d9/CLK] [get_bd_pins elements_d25/CLK] [get_bd_pins home_parid_d36/CLK] [get_bd_pins nb_cid_d36/CLK] [get_bd_pins nb_parid_d36/CLK] [get_bd_pins nb_reg_release_sel_d36/CLK] [get_bd_pins nb_reg_sel_d36/CLK] [get_bd_pins r2/aclk]
  connect_bd_net -net dx2_dy2_m_axis_result_tdata [get_bd_pins dx2_dy2/m_axis_result_tdata] [get_bd_pins r2/s_axis_c_tdata]
  connect_bd_net -net dx2_dy2_m_axis_result_tvalid [get_bd_pins dx2_dy2/m_axis_result_tvalid] [get_bd_pins r2/s_axis_a_tvalid] [get_bd_pins r2/s_axis_b_tvalid] [get_bd_pins r2/s_axis_c_tvalid]
  connect_bd_net -net dx2_m_axis_result_tdata [get_bd_pins dx2/m_axis_result_tdata] [get_bd_pins dx2_dy2/s_axis_c_tdata]
  connect_bd_net -net dx2_m_axis_result_tvalid [get_bd_pins dx2/m_axis_result_tvalid] [get_bd_pins dx2_dy2/s_axis_a_tvalid] [get_bd_pins dx2_dy2/s_axis_b_tvalid] [get_bd_pins dx2_dy2/s_axis_c_tvalid]
  connect_bd_net -net dx_d14_Q [get_bd_ports dx] [get_bd_pins dx_d28/Q]
  connect_bd_net -net dx_m_axis_result_tdata [get_bd_pins dx/m_axis_result_tdata] [get_bd_pins dx2/s_axis_a_tdata] [get_bd_pins dx2/s_axis_b_tdata] [get_bd_pins dx_d28/D]
  connect_bd_net -net dx_m_axis_result_tvalid [get_bd_pins dx/m_axis_result_tvalid] [get_bd_pins dx2/s_axis_a_tvalid] [get_bd_pins dx2/s_axis_b_tvalid]
  connect_bd_net -net dy_d10_Q [get_bd_ports dy] [get_bd_pins dy_d24/Q]
  connect_bd_net -net dy_d4_Q [get_bd_pins dx2_dy2/s_axis_a_tdata] [get_bd_pins dx2_dy2/s_axis_b_tdata] [get_bd_pins dy_d24/D] [get_bd_pins dy_d4/Q]
  connect_bd_net -net dy_m_axis_result_tdata [get_bd_pins dy/m_axis_result_tdata] [get_bd_pins dy_d4/D]
  connect_bd_net -net dz_d5_Q [get_bd_ports dz] [get_bd_pins dz_d19/Q]
  connect_bd_net -net dz_d9_Q [get_bd_pins dz_d19/D] [get_bd_pins dz_d9/Q] [get_bd_pins r2/s_axis_a_tdata] [get_bd_pins r2/s_axis_b_tdata]
  connect_bd_net -net dz_m_axis_result_tdata [get_bd_pins dz/m_axis_result_tdata] [get_bd_pins dz_d9/D]
  connect_bd_net -net elements_d18_Q [get_bd_ports d25_elements] [get_bd_pins elements_d25/Q]
  connect_bd_net -net home_parid_d17_Q [get_bd_ports d36_home_parid] [get_bd_pins home_parid_d36/Q]
  connect_bd_net -net home_parid_d18_Q [get_bd_ports d36_nb_parid] [get_bd_pins nb_parid_d36/Q]
  connect_bd_net -net nb_cid_d36_Q [get_bd_ports d36_nb_cid] [get_bd_pins nb_cid_d36/Q]
  connect_bd_net -net nb_reg_release_sel_d36_Q [get_bd_ports d36_nb_reg_release_flag] [get_bd_pins nb_reg_release_sel_d36/Q]
  connect_bd_net -net nb_reg_sel_d37_Q [get_bd_ports d36_nb_reg_sel] [get_bd_pins nb_reg_sel_d36/Q]
  connect_bd_net -net r2_m_axis_result_tdata [get_bd_ports r2] [get_bd_pins r2/m_axis_result_tdata]
  connect_bd_net -net r2_m_axis_result_tvalid [get_bd_ports r2_valid] [get_bd_pins r2/m_axis_result_tvalid]
  connect_bd_net -net s_axis_a_tdata_0_1 [get_bd_ports home_x] [get_bd_pins dx/s_axis_a_tdata]
  connect_bd_net -net s_axis_a_tdata_0_2 [get_bd_ports home_y] [get_bd_pins dy/s_axis_a_tdata]
  connect_bd_net -net s_axis_a_tdata_0_3 [get_bd_ports home_z] [get_bd_pins dz/s_axis_a_tdata]
  connect_bd_net -net s_axis_a_tvalid_0_1 [get_bd_ports home_valid] [get_bd_pins dx/s_axis_a_tvalid] [get_bd_pins dy/s_axis_a_tvalid] [get_bd_pins dz/s_axis_a_tvalid]
  connect_bd_net -net s_axis_b_tdata_0_1 [get_bd_ports nb_x] [get_bd_pins dx/s_axis_b_tdata]
  connect_bd_net -net s_axis_b_tdata_0_2 [get_bd_ports nb_y] [get_bd_pins dy/s_axis_b_tdata]
  connect_bd_net -net s_axis_b_tdata_0_3 [get_bd_ports nb_z] [get_bd_pins dz/s_axis_b_tdata]
  connect_bd_net -net s_axis_b_tvalid_0_1 [get_bd_ports nb_valid] [get_bd_pins dx/s_axis_b_tvalid] [get_bd_pins dy/s_axis_b_tvalid] [get_bd_pins dz/s_axis_b_tvalid]

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


