onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fft_ctrl_tb/start
add wave -noupdate /fft_ctrl_tb/in_clk
add wave -noupdate /fft_ctrl_tb/fftpts_in
add wave -noupdate /fft_ctrl_tb/rst
add wave -noupdate /fft_ctrl_tb/datain
add wave -noupdate /fft_ctrl_tb/out_clk
add wave -noupdate /fft_ctrl_tb/count_up
add wave -noupdate -divider fft_ctrl_in
add wave -noupdate /fft_ctrl_tb/DUT/fft_ctrl_in1/CLK
add wave -noupdate /fft_ctrl_tb/DUT/fft_ctrl_in1/RST
add wave -noupdate /fft_ctrl_tb/DUT/fft_ctrl_in1/START
add wave -noupdate /fft_ctrl_tb/DUT/fft_ctrl_in1/FRAMELENGTH
add wave -noupdate /fft_ctrl_tb/DUT/fft_ctrl_in1/sop
add wave -noupdate /fft_ctrl_tb/DUT/fft_ctrl_in1/eop
add wave -noupdate /fft_ctrl_tb/DUT/fft_ctrl_in1/valid
add wave -noupdate /fft_ctrl_tb/DUT/fft_ctrl_in1/FRAMECNT
add wave -noupdate /fft_ctrl_tb/DUT/fft_ctrl_in1/START_reg
add wave -noupdate /fft_ctrl_tb/DUT/fft_ctrl_in1/TOKEN
add wave -noupdate /fft_ctrl_tb/DUT/fft_ctrl_in1/State
add wave -noupdate -divider fft_fifo
add wave -noupdate /fft_ctrl_tb/DUT/fft_fifo1/fft_fifo_in_data
add wave -noupdate /fft_ctrl_tb/DUT/fft_fifo1/fft_fifo_in_valid
add wave -noupdate /fft_ctrl_tb/DUT/fft_fifo1/fft_fifo_in_ready
add wave -noupdate /fft_ctrl_tb/DUT/fft_fifo1/fft_fifo_in_startofpacket
add wave -noupdate /fft_ctrl_tb/DUT/fft_fifo1/fft_fifo_in_endofpacket
add wave -noupdate /fft_ctrl_tb/DUT/fft_fifo1/fft_fifo_in_clk_clk
add wave -noupdate /fft_ctrl_tb/DUT/fft_fifo1/fft_fifo_in_clk_reset_reset_n
add wave -noupdate /fft_ctrl_tb/DUT/fft_fifo1/fft_fifo_out_data
add wave -noupdate /fft_ctrl_tb/DUT/fft_fifo1/fft_fifo_out_valid
add wave -noupdate /fft_ctrl_tb/DUT/fft_fifo1/fft_fifo_out_ready
add wave -noupdate /fft_ctrl_tb/DUT/fft_fifo1/fft_fifo_out_startofpacket
add wave -noupdate /fft_ctrl_tb/DUT/fft_fifo1/fft_fifo_out_endofpacket
add wave -noupdate /fft_ctrl_tb/DUT/fft_fifo1/fft_fifo_out_clk_clk
add wave -noupdate /fft_ctrl_tb/DUT/fft_fifo1/fft_fifo_out_clk_reset_reset_n
add wave -noupdate -divider fftcore
add wave -noupdate /fft_ctrl_tb/DUT/fft_gp1/clk
add wave -noupdate /fft_ctrl_tb/DUT/fft_gp1/reset_n
add wave -noupdate /fft_ctrl_tb/DUT/fft_gp1/sink_valid
add wave -noupdate /fft_ctrl_tb/DUT/fft_gp1/sink_ready
add wave -noupdate /fft_ctrl_tb/DUT/fft_gp1/sink_error
add wave -noupdate /fft_ctrl_tb/DUT/fft_gp1/sink_sop
add wave -noupdate /fft_ctrl_tb/DUT/fft_gp1/sink_eop
add wave -noupdate -format Analog-Step -height 74 -max 7999.9999999999991 -min -8000.0 -radix decimal -childformat {{{/fft_ctrl_tb/DUT/fft_gp1/sink_real[17]} -radix unsigned} {{/fft_ctrl_tb/DUT/fft_gp1/sink_real[16]} -radix unsigned} {{/fft_ctrl_tb/DUT/fft_gp1/sink_real[15]} -radix unsigned} {{/fft_ctrl_tb/DUT/fft_gp1/sink_real[14]} -radix unsigned} {{/fft_ctrl_tb/DUT/fft_gp1/sink_real[13]} -radix unsigned} {{/fft_ctrl_tb/DUT/fft_gp1/sink_real[12]} -radix unsigned} {{/fft_ctrl_tb/DUT/fft_gp1/sink_real[11]} -radix unsigned} {{/fft_ctrl_tb/DUT/fft_gp1/sink_real[10]} -radix unsigned} {{/fft_ctrl_tb/DUT/fft_gp1/sink_real[9]} -radix unsigned} {{/fft_ctrl_tb/DUT/fft_gp1/sink_real[8]} -radix unsigned} {{/fft_ctrl_tb/DUT/fft_gp1/sink_real[7]} -radix unsigned} {{/fft_ctrl_tb/DUT/fft_gp1/sink_real[6]} -radix unsigned} {{/fft_ctrl_tb/DUT/fft_gp1/sink_real[5]} -radix unsigned} {{/fft_ctrl_tb/DUT/fft_gp1/sink_real[4]} -radix unsigned} {{/fft_ctrl_tb/DUT/fft_gp1/sink_real[3]} -radix unsigned} {{/fft_ctrl_tb/DUT/fft_gp1/sink_real[2]} -radix unsigned} {{/fft_ctrl_tb/DUT/fft_gp1/sink_real[1]} -radix unsigned} {{/fft_ctrl_tb/DUT/fft_gp1/sink_real[0]} -radix unsigned}} -subitemconfig {{/fft_ctrl_tb/DUT/fft_gp1/sink_real[17]} {-height 15 -radix unsigned} {/fft_ctrl_tb/DUT/fft_gp1/sink_real[16]} {-height 15 -radix unsigned} {/fft_ctrl_tb/DUT/fft_gp1/sink_real[15]} {-height 15 -radix unsigned} {/fft_ctrl_tb/DUT/fft_gp1/sink_real[14]} {-height 15 -radix unsigned} {/fft_ctrl_tb/DUT/fft_gp1/sink_real[13]} {-height 15 -radix unsigned} {/fft_ctrl_tb/DUT/fft_gp1/sink_real[12]} {-height 15 -radix unsigned} {/fft_ctrl_tb/DUT/fft_gp1/sink_real[11]} {-height 15 -radix unsigned} {/fft_ctrl_tb/DUT/fft_gp1/sink_real[10]} {-height 15 -radix unsigned} {/fft_ctrl_tb/DUT/fft_gp1/sink_real[9]} {-height 15 -radix unsigned} {/fft_ctrl_tb/DUT/fft_gp1/sink_real[8]} {-height 15 -radix unsigned} {/fft_ctrl_tb/DUT/fft_gp1/sink_real[7]} {-height 15 -radix unsigned} {/fft_ctrl_tb/DUT/fft_gp1/sink_real[6]} {-height 15 -radix unsigned} {/fft_ctrl_tb/DUT/fft_gp1/sink_real[5]} {-height 15 -radix unsigned} {/fft_ctrl_tb/DUT/fft_gp1/sink_real[4]} {-height 15 -radix unsigned} {/fft_ctrl_tb/DUT/fft_gp1/sink_real[3]} {-height 15 -radix unsigned} {/fft_ctrl_tb/DUT/fft_gp1/sink_real[2]} {-height 15 -radix unsigned} {/fft_ctrl_tb/DUT/fft_gp1/sink_real[1]} {-height 15 -radix unsigned} {/fft_ctrl_tb/DUT/fft_gp1/sink_real[0]} {-height 15 -radix unsigned}} /fft_ctrl_tb/DUT/fft_gp1/sink_real
add wave -noupdate /fft_ctrl_tb/DUT/fft_gp1/sink_imag
add wave -noupdate /fft_ctrl_tb/DUT/fft_gp1/fftpts_in
add wave -noupdate /fft_ctrl_tb/DUT/fft_gp1/inverse
add wave -noupdate /fft_ctrl_tb/DUT/fft_gp1/source_valid
add wave -noupdate /fft_ctrl_tb/DUT/fft_gp1/source_ready
add wave -noupdate /fft_ctrl_tb/DUT/fft_gp1/source_error
add wave -noupdate /fft_ctrl_tb/DUT/fft_gp1/source_sop
add wave -noupdate /fft_ctrl_tb/DUT/fft_gp1/source_eop
add wave -noupdate -format Analog-Step -height 74 -max 1104630.0 -min -3776950.0 -radix decimal /fft_ctrl_tb/DUT/fft_gp1/source_real
add wave -noupdate -format Analog-Step -height 74 -max 67605.999999999985 -min -67611.0 -radix decimal /fft_ctrl_tb/DUT/fft_gp1/source_imag
add wave -noupdate /fft_ctrl_tb/DUT/fft_gp1/fftpts_out
add wave -noupdate -divider ram_controller
add wave -noupdate /fft_ctrl_tb/DUT/fft_ctrl_out1/CLK
add wave -noupdate /fft_ctrl_tb/DUT/fft_ctrl_out1/RST
add wave -noupdate /fft_ctrl_tb/DUT/fft_ctrl_out1/sop
add wave -noupdate /fft_ctrl_tb/DUT/fft_ctrl_out1/eop
add wave -noupdate /fft_ctrl_tb/DUT/fft_ctrl_out1/valid
add wave -noupdate /fft_ctrl_tb/DUT/fft_ctrl_out1/datain_re
add wave -noupdate /fft_ctrl_tb/DUT/fft_ctrl_out1/datain_im
add wave -noupdate /fft_ctrl_tb/DUT/fft_ctrl_out1/addr
add wave -noupdate /fft_ctrl_tb/DUT/fft_ctrl_out1/dataout
add wave -noupdate /fft_ctrl_tb/DUT/fft_ctrl_out1/wren
add wave -noupdate /fft_ctrl_tb/DUT/fft_ctrl_out1/datareg_re
add wave -noupdate /fft_ctrl_tb/DUT/fft_ctrl_out1/datareg_im
add wave -noupdate /fft_ctrl_tb/DUT/fft_ctrl_out1/State
add wave -noupdate -divider {ram data read}
add wave -noupdate /fft_ctrl_tb/ram_rd_data
add wave -noupdate /fft_ctrl_tb/ram_rd_addr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {366976524 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 379
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1050 us}
