/*

	author : David Ariando
	date : July 26th 2021
	this module is a controller to transfer data from the ADC interface into the FIFO input before the FFT core

*/


module fft_ctrl_in 
#(
	parameter BUSWIDTH = 12
)
(

	input CLK,
	input RST,
	
	input START,
	input [BUSWIDTH-1:0] FRAMELENGTH,
	
	output reg sop, // start of packet
	output reg eop, // end of packet
	output reg valid // valid signal

);
	
	reg [BUSWIDTH:0] FRAMECNT_LOADVAL; // the framecounter loadval 
	reg [BUSWIDTH:0] FRAMECNT; // the framecounter
	reg START_reg; // start signal register
	reg TOKEN;
	
	reg [4:0] State;
	localparam [4:0]
		S0 = 5'b00001,
		S1 = 5'b00010,
		S2 = 5'b00100,
		S3 = 5'b01000,
		S4 = 5'b10000;
		
	always @(posedge CLK)
	begin
		FRAMECNT_LOADVAL <= {1'b1,{ (BUSWIDTH) {1'b0} }} - FRAMELENGTH + 1'b1;
		START_reg <= START;
	end
	
	initial
	begin
		FRAMECNT <= {(BUSWIDTH+1){1'b0}};
		TOKEN <= 1'b0;
		sop <= 1'b0;
		eop <= 1'b0;
		valid <= 1'b0;
	end
	
	always @(posedge CLK, posedge RST)
	begin
		if (RST)
		begin
			FRAMECNT <= FRAMECNT_LOADVAL;
			State <= S0;
			sop <= 1'b0;
			eop <= 1'b0;
			valid <= 1'b0;
		end
		
		else
		begin
			
			case (State)
				
				S0 : // wait for the start signal
				begin
					FRAMECNT <= FRAMECNT_LOADVAL;
					TOKEN <= START_reg;
					eop <= 1'b0;
					valid <= 1'b0;
					if (TOKEN == 1'b0 && START_reg == 1'b1) // detecting START_reg rising edge
						State <= S1;
				end
				
				S1 : // assert the sop
				begin
					FRAMECNT <= FRAMECNT + 2'd2;
					sop <= 1'b1;
					valid <= 1'b1;
					
					State <= S2;
				end
				
				S2 : // count for framecounter
				begin
					FRAMECNT <= FRAMECNT + 1'b1;
					sop <= 1'b0;
					if (FRAMECNT[BUSWIDTH])
						State <= S3;
				end
				
				S3 : // assert the eop
				begin
					eop <= 1'b1;
					State <= S0;
				end
				
			endcase
			
		end
	end
	




endmodule