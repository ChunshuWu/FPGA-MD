
################################################################
# This is a generated script based on design: FORCE_LUT
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
# source FORCE_LUT_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcu280-fsvh2892-2L-e
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name FORCE_LUT

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
xilinx.com:ip:blk_mem_gen:8.4\
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
  set addr [ create_bd_port -dir I -from 11 -to 0 addr ]
  set clk [ create_bd_port -dir I -type clk clk ]
  set data_in [ create_bd_port -dir I -from 31 -to 0 data_in ]
  set rd_en [ create_bd_port -dir I rd_en ]
  set term_0_8 [ create_bd_port -dir O -from 31 -to 0 term_0_8 ]
  set term_0_14 [ create_bd_port -dir O -from 31 -to 0 term_0_14 ]
  set term_1_8 [ create_bd_port -dir O -from 31 -to 0 term_1_8 ]
  set term_1_14 [ create_bd_port -dir O -from 31 -to 0 term_1_14 ]
  set wr_en [ create_bd_port -dir I -from 0 -to 0 wr_en ]

  # Create instance: FORCE_LUT_0_8, and set properties
  set FORCE_LUT_0_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 FORCE_LUT_0_8 ]
  set_property -dict [ list \
   CONFIG.Byte_Size {9} \
   CONFIG.Coe_File {/home/chunshu/Documents/InterFPGA_MD/InterFPGA_MD/Benchmark_kernel/src/mem_init/c0_8.coe} \
   CONFIG.Collision_Warnings {NONE} \
   CONFIG.Disable_Collision_Warnings {true} \
   CONFIG.Disable_Out_of_Range_Warnings {true} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_32bit_Address {false} \
   CONFIG.Enable_A {Use_ENA_Pin} \
   CONFIG.Load_Init_File {true} \
   CONFIG.Operating_Mode_A {NO_CHANGE} \
   CONFIG.Register_PortA_Output_of_Memory_Primitives {true} \
   CONFIG.Use_Byte_Write_Enable {false} \
   CONFIG.Use_RSTA_Pin {false} \
   CONFIG.Write_Depth_A {2560} \
   CONFIG.use_bram_block {Stand_Alone} \
 ] $FORCE_LUT_0_8

  # Create instance: FORCE_LUT_0_14, and set properties
  set FORCE_LUT_0_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 FORCE_LUT_0_14 ]
  set_property -dict [ list \
   CONFIG.Byte_Size {9} \
   CONFIG.Coe_File {/home/chunshu/Documents/InterFPGA_MD/InterFPGA_MD/Benchmark_kernel/src/mem_init/c0_14.coe} \
   CONFIG.Collision_Warnings {NONE} \
   CONFIG.Disable_Collision_Warnings {true} \
   CONFIG.Disable_Out_of_Range_Warnings {true} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_32bit_Address {false} \
   CONFIG.Enable_A {Use_ENA_Pin} \
   CONFIG.Load_Init_File {true} \
   CONFIG.Operating_Mode_A {NO_CHANGE} \
   CONFIG.Register_PortA_Output_of_Memory_Primitives {true} \
   CONFIG.Use_Byte_Write_Enable {false} \
   CONFIG.Use_RSTA_Pin {false} \
   CONFIG.Write_Depth_A {2560} \
   CONFIG.use_bram_block {Stand_Alone} \
 ] $FORCE_LUT_0_14

  # Create instance: FORCE_LUT_1_8, and set properties
  set FORCE_LUT_1_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 FORCE_LUT_1_8 ]
  set_property -dict [ list \
   CONFIG.Byte_Size {9} \
   CONFIG.Coe_File {/home/chunshu/Documents/InterFPGA_MD/InterFPGA_MD/Benchmark_kernel/src/mem_init/c1_8.coe} \
   CONFIG.Collision_Warnings {NONE} \
   CONFIG.Disable_Collision_Warnings {true} \
   CONFIG.Disable_Out_of_Range_Warnings {true} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_32bit_Address {false} \
   CONFIG.Enable_A {Use_ENA_Pin} \
   CONFIG.Load_Init_File {true} \
   CONFIG.Operating_Mode_A {NO_CHANGE} \
   CONFIG.Register_PortA_Output_of_Memory_Primitives {true} \
   CONFIG.Use_Byte_Write_Enable {false} \
   CONFIG.Use_RSTA_Pin {false} \
   CONFIG.Write_Depth_A {2560} \
   CONFIG.use_bram_block {Stand_Alone} \
 ] $FORCE_LUT_1_8

  # Create instance: FORCE_LUT_1_14, and set properties
  set FORCE_LUT_1_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 FORCE_LUT_1_14 ]
  set_property -dict [ list \
   CONFIG.Byte_Size {9} \
   CONFIG.Coe_File {/home/chunshu/Documents/InterFPGA_MD/InterFPGA_MD/Benchmark_kernel/src/mem_init/c1_14.coe} \
   CONFIG.Collision_Warnings {NONE} \
   CONFIG.Disable_Collision_Warnings {true} \
   CONFIG.Disable_Out_of_Range_Warnings {true} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_32bit_Address {false} \
   CONFIG.Enable_A {Use_ENA_Pin} \
   CONFIG.Load_Init_File {true} \
   CONFIG.Operating_Mode_A {NO_CHANGE} \
   CONFIG.Register_PortA_Output_of_Memory_Primitives {true} \
   CONFIG.Use_Byte_Write_Enable {false} \
   CONFIG.Use_RSTA_Pin {false} \
   CONFIG.Write_Depth_A {2560} \
   CONFIG.use_bram_block {Stand_Alone} \
 ] $FORCE_LUT_1_14

  # Create port connections
  connect_bd_net -net FORCE_LUT_0_14_douta [get_bd_ports term_0_14] [get_bd_pins FORCE_LUT_0_14/douta]
  connect_bd_net -net FORCE_LUT_0_8_douta [get_bd_ports term_0_8] [get_bd_pins FORCE_LUT_0_8/douta]
  connect_bd_net -net FORCE_LUT_1_14_douta [get_bd_ports term_1_14] [get_bd_pins FORCE_LUT_1_14/douta]
  connect_bd_net -net FORCE_LUT_1_8_douta [get_bd_ports term_1_8] [get_bd_pins FORCE_LUT_1_8/douta]
  connect_bd_net -net addra_0_1 [get_bd_ports addr] [get_bd_pins FORCE_LUT_0_14/addra] [get_bd_pins FORCE_LUT_0_8/addra] [get_bd_pins FORCE_LUT_1_14/addra] [get_bd_pins FORCE_LUT_1_8/addra]
  connect_bd_net -net clka_0_1 [get_bd_ports clk] [get_bd_pins FORCE_LUT_0_14/clka] [get_bd_pins FORCE_LUT_0_8/clka] [get_bd_pins FORCE_LUT_1_14/clka] [get_bd_pins FORCE_LUT_1_8/clka]
  connect_bd_net -net dina_0_1 [get_bd_ports data_in] [get_bd_pins FORCE_LUT_0_14/dina] [get_bd_pins FORCE_LUT_0_8/dina] [get_bd_pins FORCE_LUT_1_14/dina] [get_bd_pins FORCE_LUT_1_8/dina]
  connect_bd_net -net ena_0_1 [get_bd_ports rd_en] [get_bd_pins FORCE_LUT_0_14/ena] [get_bd_pins FORCE_LUT_0_8/ena] [get_bd_pins FORCE_LUT_1_14/ena] [get_bd_pins FORCE_LUT_1_8/ena]
  connect_bd_net -net wea_0_1 [get_bd_ports wr_en] [get_bd_pins FORCE_LUT_0_14/wea] [get_bd_pins FORCE_LUT_0_8/wea] [get_bd_pins FORCE_LUT_1_14/wea] [get_bd_pins FORCE_LUT_1_8/wea]

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

