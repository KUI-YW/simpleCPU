transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/admin/Desktop/isle3/simple-team24/processor_third/bunki_v2 {C:/Users/admin/Desktop/isle3/simple-team24/processor_third/bunki_v2/bunki_v2.v}
vlog -vlog01compat -work work +incdir+C:/Users/admin/Desktop/isle3/simple-team24/processor_third/zero16 {C:/Users/admin/Desktop/isle3/simple-team24/processor_third/zero16/zero16.v}
vlog -vlog01compat -work work +incdir+C:/Users/admin/Desktop/isle3/simple-team24/processor_third/rwflagger {C:/Users/admin/Desktop/isle3/simple-team24/processor_third/rwflagger/rwflagger.v}
vlog -vlog01compat -work work +incdir+C:/Users/admin/Desktop/isle3/simple-team24/processor_third/register_writer {C:/Users/admin/Desktop/isle3/simple-team24/processor_third/register_writer/register_writer.v}
vlog -vlog01compat -work work +incdir+C:/Users/admin/Desktop/isle3/simple-team24/processor_third/register {C:/Users/admin/Desktop/isle3/simple-team24/processor_third/register/register.v}
vlog -vlog01compat -work work +incdir+C:/Users/admin/Desktop/isle3/simple-team24/processor_third/program_counter {C:/Users/admin/Desktop/isle3/simple-team24/processor_third/program_counter/program_counter.v}
vlog -vlog01compat -work work +incdir+C:/Users/admin/Desktop/isle3/simple-team24/processor_third/pipeline_register {C:/Users/admin/Desktop/isle3/simple-team24/processor_third/pipeline_register/pipeline_register.v}
vlog -vlog01compat -work work +incdir+C:/Users/admin/Desktop/isle3/simple-team24/processor_third/phase_counter {C:/Users/admin/Desktop/isle3/simple-team24/processor_third/phase_counter/phase_counter.v}
vlog -vlog01compat -work work +incdir+C:/Users/admin/Desktop/isle3/simple-team24/processor_third/multiplexer {C:/Users/admin/Desktop/isle3/simple-team24/processor_third/multiplexer/multiplexer.v}
vlog -vlog01compat -work work +incdir+C:/Users/admin/Desktop/isle3/simple-team24/processor_third/jumper {C:/Users/admin/Desktop/isle3/simple-team24/processor_third/jumper/jumper.v}
vlog -vlog01compat -work work +incdir+C:/Users/admin/Desktop/isle3/simple-team24/processor_third/forwarding_unit {C:/Users/admin/Desktop/isle3/simple-team24/processor_third/forwarding_unit/forwarding_unit.v}
vlog -vlog01compat -work work +incdir+C:/Users/admin/Desktop/isle3/simple-team24/processor_third/ext12to16 {C:/Users/admin/Desktop/isle3/simple-team24/processor_third/ext12to16/ext12to16.v}
vlog -vlog01compat -work work +incdir+C:/Users/admin/Desktop/isle3/simple-team24/processor_third/data_hazard_staller {C:/Users/admin/Desktop/isle3/simple-team24/processor_third/data_hazard_staller/data_hazard_staller.v}
vlog -vlog01compat -work work +incdir+C:/Users/admin/Desktop/isle3/simple-team24/processor_third/controller {C:/Users/admin/Desktop/isle3/simple-team24/processor_third/controller/controller.v}
vlog -vlog01compat -work work +incdir+C:/Users/admin/Desktop/isle3/simple-team24/processor_third/compare_branch_checker {C:/Users/admin/Desktop/isle3/simple-team24/processor_third/compare_branch_checker/compare_branch_checker.v}
vlog -vlog01compat -work work +incdir+C:/Users/admin/Desktop/isle3/simple-team24/processor_third/ALU_LI {C:/Users/admin/Desktop/isle3/simple-team24/processor_third/ALU_LI/ALU_LI.v}
vlog -vlog01compat -work work +incdir+C:/Users/admin/Desktop/isle3/simple-team24/processor_third/top {C:/Users/admin/Desktop/isle3/simple-team24/processor_third/top/instr_mem.v}
vlog -vlog01compat -work work +incdir+C:/Users/admin/Desktop/isle3/simple-team24/processor_third/top {C:/Users/admin/Desktop/isle3/simple-team24/processor_third/top/datamem2.v}

vlog -vlog01compat -work work +incdir+C:/Users/admin/Desktop/isle3/simple-team24/processor_third/top/simulation/modelsim {C:/Users/admin/Desktop/isle3/simple-team24/processor_third/top/simulation/modelsim/top_test2.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  test2

add wave *
view structure
view signals
run -all
