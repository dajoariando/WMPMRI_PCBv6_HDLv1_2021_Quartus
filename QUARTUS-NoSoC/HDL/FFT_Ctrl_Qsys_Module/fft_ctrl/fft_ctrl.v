/*

	author : David Ariando
	date : July 26th 2021
	the top level module for controlling fft operation from the ADC input into the RAM that can be accessed via Quartus directly

*/

module fft_ctrl
#(
	parameter DWIDTH = 14, 				// set by the FIFO width size
	parameter FFT_INWIDTH = 18, 		// set by the FFT input width size
	parameter FFT_OUTWIDTH = 29, 		// set by the FFT output width size
	parameter FFTPTS_WIDTH = 11, 		// set by the FFT input width size
	parameter BUSWIDTH = 32,			// the AXI bus width 
	parameter RAM_ADDR_WIDTH = 10,		// RAM address width
	parameter RAM_DATA_WIDTH = 64
)
(
						
	input start,								// the start signal
	input in_clk,								// fifo input clock domain
	input out_clk,								// fifo output clock domain
	input [FFTPTS_WIDTH-1:0] fftpts_in,			// number of data to be input to the fft
	input rst,									// reset signal
	input [DWIDTH-1:0] datain,					// ADC data input
	
	output [RAM_DATA_WIDTH-1:0] ram_rd_data,	// the ram data read access
	input [RAM_ADDR_WIDTH-1:0] ram_rd_addr		// the ram read address
	
);
	
	// signals between the input and the fft_fifo
	wire ffin_sop, ffin_eop, ffin_valid;
	
	// signals between the fft_fifo and the fft
	wire ffout_sop, ffout_eop, ffout_valid, ffout_ready;
	wire [DWIDTH-1:0] ffout_data;
	
	// signals between the fifo and the ram
	wire fftout_valid, fftout_ready, fftout_sop, fftout_eop;
	wire [FFTPTS_WIDTH-1:0] fftpts_out;
	wire [FFT_OUTWIDTH-1:0] fftout_data_real;
	wire [FFT_OUTWIDTH-1:0] fftout_data_imag;
	
	fft_ctrl_in 
	#(
		.BUSWIDTH (FFTPTS_WIDTH)
	) fft_ctrl_in1
	(

		.CLK	(in_clk),
		.RST	(rst),
		
		.START 			(start),
		.FRAMELENGTH	(fftpts_in),
		
		.sop	(ffin_sop),		// start of packet
		.eop	(ffin_eop),		// end of packet
		.valid	(ffin_valid)	// valid signal

	);
	
	fft_fifo fft_fifo1 (
		.fft_fifo_in_data               (datain),               //            fft_fifo_in.data
		.fft_fifo_in_valid              (ffin_valid),              //                       .valid
		.fft_fifo_in_ready              (),              //                       .ready
		.fft_fifo_in_startofpacket      (ffin_sop),      //                       .startofpacket
		.fft_fifo_in_endofpacket        (ffin_eop),        //                       .endofpacket
		.fft_fifo_out_data              (ffout_data),              						//           fft_fifo_out.data
		.fft_fifo_out_valid             (ffout_valid),             						//                       .valid
		.fft_fifo_out_ready             (ffout_ready),             						//                       .ready
		.fft_fifo_out_startofpacket     (ffout_sop),     								//                       .startofpacket
		.fft_fifo_out_endofpacket       (ffout_eop),       								//                       .endofpacket
		.fft_fifo_out_clk_reset_reset_n (~rst), // fft_fifo_out_clk_reset.reset_n
		.fft_fifo_out_clk_clk           (out_clk),           							//       fft_fifo_out_clk.clk
		.fft_fifo_in_clk_reset_reset_n  (~rst),  //  fft_fifo_in_clk_reset.reset_n
		.fft_fifo_in_clk_clk            (in_clk)             							//        fft_fifo_in_clk.clk
	);
	
	fft_gp fft_gp1 (
		.clk          (out_clk),          							//    clk.clk
		.reset_n      (~rst),      				//    rst.reset_n
		.sink_valid   (ffout_valid),   								//   sink.sink_valid
		.sink_ready   (ffout_ready),   								//       .sink_ready
		.sink_error   (2'b00),   									//       .sink_error
		.sink_sop     (ffout_sop),     								//       .sink_sop
		.sink_eop     (ffout_eop),     								//       .sink_eop
		//.sink_real    ( { {(FFT_INWIDTH-DWIDTH){1'b0}} , {ffout_data} } ),		//       .sink_real
		.sink_real    ( { {(FFT_INWIDTH-DWIDTH){ffout_data[DWIDTH-1]}} , {ffout_data} } ),		//       .sink_real
		.sink_imag    ({FFT_INWIDTH{1'b0}}),    						//       .sink_imag
		.fftpts_in    (fftpts_in),    								//       .fftpts_in
		.inverse      (1'b0),      									//       .inverse
		.source_valid (fftout_valid), // source.source_valid
		.source_ready (fftout_ready), //       .source_ready
		.source_error (), 											//       .source_error
		.source_sop   (fftout_sop),   //       .source_sop
		.source_eop   (fftout_eop),   //       .source_eop
		.source_real  (fftout_data_real),  //       .source_real
		.source_imag  (fftout_data_imag),  //       .source_imag
		.fftpts_out   (fftpts_out)    //       .fftpts_out
	);
	
	assign fftout_ready = 1'b1;
	
	wire [RAM_ADDR_WIDTH-1:0] ram_addr;			// the ram address
	wire [RAM_DATA_WIDTH-1:0] ram_datain;		// the ram data
	wire ram_wren;								// write enable signal
	
	fft_ctrl_out
	#(
		
		.ADDR_WIDTH (RAM_ADDR_WIDTH),
		.DATAIN_WIDTH (FFT_OUTWIDTH),
		.DATAOUT_WIDTH (RAM_DATA_WIDTH)
		
	) fft_ctrl_out1
	(

		.CLK	(out_clk),
		.RST	(rst),
		
		// fft output handler
		.sop		(fftout_sop),		// start of packet
		.eop		(fftout_eop),		// end of packet
		.valid		(fftout_valid),		// data valid signal
		.datain_re	(fftout_data_real), // data in real
		.datain_im	(fftout_data_imag), // data in imag
		
		// ram handler
		.addr		(ram_addr),			// the ram address
		.dataout	(ram_datain),		// the ram data
		.wren		(ram_wren)			// write enable signal
		
	);
	
	fft_ram	fft_ram1 (
		.aclr		(rst),
		.clock		(out_clk),
		.data		(ram_datain),
		.rdaddress	(ram_rd_addr),
		.wraddress	(ram_addr),
		.wren		(ram_wren),
		.q			(ram_rd_data)
	);



endmodule