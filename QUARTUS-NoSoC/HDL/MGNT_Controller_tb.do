onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Ctrl
add wave -noupdate /MGNT_Controller_tb/CLK
add wave -noupdate /MGNT_Controller_tb/RESET
add wave -noupdate /MGNT_Controller_tb/START
add wave -noupdate /MGNT_Controller_tb/FSMSTAT
add wave -noupdate -divider Parameters
add wave -noupdate -radix unsigned /MGNT_Controller_tb/CHG_PLEN
add wave -noupdate -radix unsigned /MGNT_Controller_tb/CHG_DLEN
add wave -noupdate -radix unsigned /MGNT_Controller_tb/DCHG_PLEN
add wave -noupdate -radix unsigned /MGNT_Controller_tb/DCHG_DLEN
add wave -noupdate -radix unsigned /MGNT_Controller_tb/N
add wave -noupdate -radix unsigned /MGNT_Controller_tb/MGNT_Controller1/D
add wave -noupdate -divider Output
add wave -noupdate /MGNT_Controller_tb/CHG_OUT
add wave -noupdate /MGNT_Controller_tb/DCHG_OUT
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7834375 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 343
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {10500 ns}
