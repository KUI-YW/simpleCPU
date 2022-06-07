transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/admin/Desktop/isle3/simple-team24/processor_second/forwarding_unit {C:/Users/admin/Desktop/isle3/simple-team24/processor_second/forwarding_unit/forwarding_unit.v}

vlog -vlog01compat -work work +incdir+C:/Users/admin/Desktop/isle3/simple-team24/processor_second/forwarding_unit/simulation/modelsim {C:/Users/admin/Desktop/isle3/simple-team24/processor_second/forwarding_unit/simulation/modelsim/forwarding_unit_test1.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  test1

add wave *
view structure
view signals
run -all
