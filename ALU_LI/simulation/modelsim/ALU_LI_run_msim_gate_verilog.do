transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {ALU_LI_6_1200mv_85c_slow.vo}

vlog -vlog01compat -work work +incdir+C:/Users/admin/Desktop/isle3/simple-team24/processor_third/ALU_LI/simulation/modelsim {C:/Users/admin/Desktop/isle3/simple-team24/processor_third/ALU_LI/simulation/modelsim/ALU_LI_test1.vt}

vsim -t 1ps +transport_int_delays +transport_path_delays -L altera_ver -L cycloneive_ver -L gate_work -L work -voptargs="+acc"  test1

add wave *
view structure
view signals
run -all
