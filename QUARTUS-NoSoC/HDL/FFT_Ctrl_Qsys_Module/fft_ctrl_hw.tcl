# TCL File Generated by Component Editor 18.1
# Mon Jul 26 03:19:04 EDT 2021
# DO NOT MODIFY


# 
# fft_ctrl "FFT Custom Controller" v1.0
# David Ariando 2021.07.26.03:19:04
# This FFT controller takes data from the input, perform FFT, and store the data into a RAM
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module fft_ctrl
# 
set_module_property DESCRIPTION "This FFT controller takes data from the input, perform FFT, and store the data into a RAM"
set_module_property NAME fft_ctrl
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP "Custom Logics"
set_module_property AUTHOR "David Ariando"
set_module_property DISPLAY_NAME "FFT Custom Controller"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL fft_ctrl
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file fft_ctrl.v VERILOG PATH ./fft_ctrl/fft_ctrl.v TOP_LEVEL_FILE
add_fileset_file fft_ctrl_in.v VERILOG PATH ./fft_ctrl/fft_ctrl_in.v
add_fileset_file fft_ctrl_out.v VERILOG PATH ./fft_ctrl/fft_ctrl_out.v
add_fileset_file fft_fifo.qip OTHER PATH ./fft_fifo/fft_fifo/synthesis/fft_fifo.qip
add_fileset_file fft_gp.qip OTHER PATH ./fft_gp/synthesis/fft_gp.qip
add_fileset_file fft_ram.qip OTHER PATH ./fft_ram/fft_ram.qip


# 
# parameters
# 
add_parameter DWIDTH INTEGER 14
set_parameter_property DWIDTH DEFAULT_VALUE 14
set_parameter_property DWIDTH DISPLAY_NAME DWIDTH
set_parameter_property DWIDTH TYPE INTEGER
set_parameter_property DWIDTH ENABLED false
set_parameter_property DWIDTH UNITS None
set_parameter_property DWIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property DWIDTH HDL_PARAMETER true
add_parameter FFT_INWIDTH INTEGER 18
set_parameter_property FFT_INWIDTH DEFAULT_VALUE 18
set_parameter_property FFT_INWIDTH DISPLAY_NAME FFT_INWIDTH
set_parameter_property FFT_INWIDTH TYPE INTEGER
set_parameter_property FFT_INWIDTH ENABLED false
set_parameter_property FFT_INWIDTH UNITS None
set_parameter_property FFT_INWIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property FFT_INWIDTH HDL_PARAMETER true
add_parameter FFT_OUTWIDTH INTEGER 29
set_parameter_property FFT_OUTWIDTH DEFAULT_VALUE 29
set_parameter_property FFT_OUTWIDTH DISPLAY_NAME FFT_OUTWIDTH
set_parameter_property FFT_OUTWIDTH TYPE INTEGER
set_parameter_property FFT_OUTWIDTH ENABLED false
set_parameter_property FFT_OUTWIDTH UNITS None
set_parameter_property FFT_OUTWIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property FFT_OUTWIDTH HDL_PARAMETER true
add_parameter FFTPTS_WIDTH INTEGER 11
set_parameter_property FFTPTS_WIDTH DEFAULT_VALUE 11
set_parameter_property FFTPTS_WIDTH DISPLAY_NAME FFTPTS_WIDTH
set_parameter_property FFTPTS_WIDTH TYPE INTEGER
set_parameter_property FFTPTS_WIDTH ENABLED false
set_parameter_property FFTPTS_WIDTH UNITS None
set_parameter_property FFTPTS_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property FFTPTS_WIDTH HDL_PARAMETER true
add_parameter BUSWIDTH INTEGER 32
set_parameter_property BUSWIDTH DEFAULT_VALUE 32
set_parameter_property BUSWIDTH DISPLAY_NAME BUSWIDTH
set_parameter_property BUSWIDTH TYPE INTEGER
set_parameter_property BUSWIDTH ENABLED false
set_parameter_property BUSWIDTH UNITS None
set_parameter_property BUSWIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property BUSWIDTH HDL_PARAMETER true
add_parameter RAM_ADDR_WIDTH INTEGER 10
set_parameter_property RAM_ADDR_WIDTH DEFAULT_VALUE 10
set_parameter_property RAM_ADDR_WIDTH DISPLAY_NAME RAM_ADDR_WIDTH
set_parameter_property RAM_ADDR_WIDTH TYPE INTEGER
set_parameter_property RAM_ADDR_WIDTH ENABLED false
set_parameter_property RAM_ADDR_WIDTH UNITS None
set_parameter_property RAM_ADDR_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property RAM_ADDR_WIDTH HDL_PARAMETER true
add_parameter RAM_DATA_WIDTH INTEGER 64
set_parameter_property RAM_DATA_WIDTH DEFAULT_VALUE 64
set_parameter_property RAM_DATA_WIDTH DISPLAY_NAME RAM_DATA_WIDTH
set_parameter_property RAM_DATA_WIDTH TYPE INTEGER
set_parameter_property RAM_DATA_WIDTH ENABLED false
set_parameter_property RAM_DATA_WIDTH UNITS None
set_parameter_property RAM_DATA_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property RAM_DATA_WIDTH HDL_PARAMETER true


# 
# display items
# 


# 
# connection point s0
# 
add_interface s0 avalon end
set_interface_property s0 addressUnits WORDS
set_interface_property s0 associatedClock rd_clk
set_interface_property s0 associatedReset rst
set_interface_property s0 bitsPerSymbol 8
set_interface_property s0 burstOnBurstBoundariesOnly false
set_interface_property s0 burstcountUnits WORDS
set_interface_property s0 explicitAddressSpan 0
set_interface_property s0 holdTime 0
set_interface_property s0 linewrapBursts false
set_interface_property s0 maximumPendingReadTransactions 0
set_interface_property s0 maximumPendingWriteTransactions 0
set_interface_property s0 readLatency 0
set_interface_property s0 readWaitTime 1
set_interface_property s0 setupTime 0
set_interface_property s0 timingUnits Cycles
set_interface_property s0 writeWaitTime 0
set_interface_property s0 ENABLED true
set_interface_property s0 EXPORT_OF ""
set_interface_property s0 PORT_NAME_MAP ""
set_interface_property s0 CMSIS_SVD_VARIABLES ""
set_interface_property s0 SVD_ADDRESS_GROUP ""

add_interface_port s0 ram_rd_data readdata Output RAM_DATA_WIDTH
add_interface_port s0 ram_rd_addr address Input RAM_ADDR_WIDTH
set_interface_assignment s0 embeddedsw.configuration.isFlash 0
set_interface_assignment s0 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment s0 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment s0 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point wr_clk
# 
add_interface wr_clk clock end
set_interface_property wr_clk clockRate 0
set_interface_property wr_clk ENABLED true
set_interface_property wr_clk EXPORT_OF ""
set_interface_property wr_clk PORT_NAME_MAP ""
set_interface_property wr_clk CMSIS_SVD_VARIABLES ""
set_interface_property wr_clk SVD_ADDRESS_GROUP ""

add_interface_port wr_clk in_clk clk Input 1


# 
# connection point rst
# 
add_interface rst reset end
set_interface_property rst associatedClock wr_clk
set_interface_property rst synchronousEdges DEASSERT
set_interface_property rst ENABLED true
set_interface_property rst EXPORT_OF ""
set_interface_property rst PORT_NAME_MAP ""
set_interface_property rst CMSIS_SVD_VARIABLES ""
set_interface_property rst SVD_ADDRESS_GROUP ""

add_interface_port rst rst reset Input 1


# 
# connection point rd_clk
# 
add_interface rd_clk clock end
set_interface_property rd_clk clockRate 0
set_interface_property rd_clk ENABLED true
set_interface_property rd_clk EXPORT_OF ""
set_interface_property rd_clk PORT_NAME_MAP ""
set_interface_property rd_clk CMSIS_SVD_VARIABLES ""
set_interface_property rd_clk SVD_ADDRESS_GROUP ""

add_interface_port rd_clk out_clk clk Input 1


# 
# connection point ext_interface
# 
add_interface ext_interface conduit end
set_interface_property ext_interface associatedClock wr_clk
set_interface_property ext_interface associatedReset ""
set_interface_property ext_interface ENABLED true
set_interface_property ext_interface EXPORT_OF ""
set_interface_property ext_interface PORT_NAME_MAP ""
set_interface_property ext_interface CMSIS_SVD_VARIABLES ""
set_interface_property ext_interface SVD_ADDRESS_GROUP ""

add_interface_port ext_interface datain data Input 14
add_interface_port ext_interface fftpts_in fftpts_in Input FFTPTS_WIDTH
add_interface_port ext_interface start start Input 1

