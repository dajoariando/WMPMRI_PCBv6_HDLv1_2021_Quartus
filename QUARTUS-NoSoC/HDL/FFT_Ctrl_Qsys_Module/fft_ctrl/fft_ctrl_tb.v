/*

	author : David Ariando
	date : July 26th 2021
	this module is a testbench for the fft_ctrl

*/


`timescale 1ps / 1ps

module fft_ctrl_tb();
	
	localparam DWIDTH = 14;			// set by the FIFO width size
	localparam FFT_INWIDTH = 18;	// set by the FFT input width size
	localparam FFT_OUTWIDTH = 29;	// set by the FFT output width size
	localparam FFTPTS_WIDTH = 11;	// set by the FFT input width size
	localparam BUSWIDTH = 32; 		// the AXI bus width
	localparam RAM_ADDR_WIDTH = 10;	// RAM address width
	localparam RAM_DATA_WIDTH = 64;	// RAM data width
	
	
	// parameters are referenced in MHz for calculation
	parameter timescale_ref = 1000000; // reference scale based on timescale => 1ps => 1THz => 1000000 MHz
	parameter CLK_RATE_HZ = 4.3; // in MHz
	localparam integer clockticks = (timescale_ref / CLK_RATE_HZ) / 2.0;
	
	
	reg start;
	reg in_clk;
	reg [FFTPTS_WIDTH-1:0] fftpts_in;
	reg rst;
	reg [DWIDTH-1:0] datain;
	reg out_clk;
	
	wire [RAM_DATA_WIDTH-1:0] ram_rd_data;	// the ram data read access
	reg [RAM_ADDR_WIDTH-1:0] ram_rd_addr;	// the ram read address
	
	
	
	reg count_up;
	reg [31:0] counter;
	
	always @* out_clk <= in_clk;
	
	fft_ctrl
	#(
		.DWIDTH (DWIDTH),					// set by the FIFO width size
		.FFT_INWIDTH (FFT_INWIDTH),			// set by the FFT input width size
		.FFT_OUTWIDTH (FFT_OUTWIDTH),		// set by the FFT output width size
		.FFTPTS_WIDTH (FFTPTS_WIDTH),		// set by the FFT input width size
		.BUSWIDTH (BUSWIDTH),				// the AXI bus width
		.RAM_ADDR_WIDTH (RAM_ADDR_WIDTH),	// RAM address width
		.RAM_DATA_WIDTH (RAM_DATA_WIDTH)	// RAM data width
		
	) DUT
	(

		.start		(start),		// the start signal
		.in_clk		(in_clk),		// fifo input clock domain
		.out_clk	(out_clk),		// fifo output clock domain
		.fftpts_in	(fftpts_in),	// number of data to be input to the fft
		.rst		(rst),			// reset signal       
		.datain		(datain),		// ADC data input
                                    
		.ram_rd_data (ram_rd_data),	// the ram data read access	
		.ram_rd_addr (ram_rd_addr)	// the ram read address
		
	);

	always begin
		#clockticks in_clk = ~in_clk;
	end
	
	initial begin
		in_clk = 1'b1;
		rst = 1'b1;
		datain = 0;
		fftpts_in = 1024;
		count_up = 0;
		start = 0;
		counter = 0;
		ram_rd_addr = 0;
		
		#(clockticks*10) rst = 1'b1;
		#(clockticks*10) rst = 1'b0;
		
		#(clockticks*100) start = 1;
			
		#(clockticks*2) start = 0;
			
		#(clockticks*8000) count_up = 1;
		
		#(clockticks*128) count_up = 0;	
		
	end
	
	always @(posedge in_clk)
	begin
		counter = counter + 1;
		if (count_up) ram_rd_addr = ram_rd_addr + 1'b1;
	end
		
	always @* datain <= 8000*($sin(2*3.14*0.01*counter));

endmodule