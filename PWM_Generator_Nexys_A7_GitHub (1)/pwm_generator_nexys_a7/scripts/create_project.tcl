# Run from the repository root in Vivado Tcl Console:
# source scripts/create_project.tcl
#
# Default target: Nexys A7-100T (xc7a100tcsg324-1).
# For Nexys A7-50T, change PART to xc7a50ticsg324-1.

set PROJECT_NAME "PWM_Generator_Nexys_A7"
set PART "xc7a100tcsg324-1"

create_project $PROJECT_NAME ./vivado_project -part $PART -force
# The FPGA part is specified above; board files are optional in Vivado.

add_files [glob ./rtl/*.v]
add_files -fileset sim_1 [glob ./sim/*.v]
add_files -fileset constrs_1 ./constraints/nexys_a7_master_subset.xdc

set_property top pwm_top [current_fileset]
set_property top tb_pwm_generator [get_filesets sim_1]

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

puts "Project created. Run behavioral simulation, then Run Synthesis and Run Implementation."
