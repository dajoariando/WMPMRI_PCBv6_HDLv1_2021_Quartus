set_global_assignment -entity "fft_fifo" -library "lib_fft_fifo" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "fft_fifo" -library "lib_fft_fifo" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "fft_fifo" -library "lib_fft_fifo" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_fft_fifo" -name SPD_FILE [file join $::quartus(sip_path) "../fft_fifo.spd"]
set_global_assignment -library "lib_fft_fifo" -name MISC_FILE [file join $::quartus(sip_path) "../../fft_fifo.qsys"]

set_global_assignment -library "lib_fft_fifo" -name MISC_FILE [file join $::quartus(sip_path) "fft_fifo.v"]
set_global_assignment -library "lib_fft_fifo" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_avalon_dc_fifo.v"]
set_global_assignment -library "lib_fft_fifo" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_dcfifo_synchronizer_bundle.v"]
set_global_assignment -library "lib_fft_fifo" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_std_synchronizer_nocut.v"]
