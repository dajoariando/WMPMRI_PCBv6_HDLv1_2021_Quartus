/*

	author : David Ariando
	date : July 26th 2021
	this module is a controller to transfer data from the the fft core into the ram that can be accessed using the finite state machine

*/

module fft_ctrl_out
#(
	
	parameter ADDR_WIDTH = 10,
	parameter DATAIN_WIDTH = 29,
	parameter DATAOUT_WIDTH = 64
	
)
(

	input CLK,
	input RST,
	
	// fft output handler
	input sop,							// start of packet
	input eop,							// end of packet
	input valid,						// data valid signal
	input [DATAIN_WIDTH-1:0] datain_re, // data in real
	input [DATAIN_WIDTH-1:0] datain_im, // data in imag
	
	// ram handler
	output reg [ADDR_WIDTH-1:0] addr,			// the ram address
	output reg [DATAOUT_WIDTH-1:0] dataout,		// the ram data
	output reg wren								// write enable signal
	

);
	
	reg [DATAIN_WIDTH-1:0] datareg_re;
	reg [DATAIN_WIDTH-1:0] datareg_im;
	
	reg [4:0] State;
	localparam [4:0]
		S0 = 5'b00001,
		S1 = 5'b00010,
		S2 = 5'b00100,
		S3 = 5'b01000,
		S4 = 5'b10000;
		
	always @(posedge CLK)
	begin
		// generate buffer for the data to account for one clock cycle delay to capture start of packet (sop) signal
		datareg_re <= datain_re;
		datareg_im <= datain_im;
	end
	
	initial
	begin
		addr <= {ADDR_WIDTH{1'b0}};
		State <= S0;
		dataout <= {DATAOUT_WIDTH{1'b0}};
		wren <= 1'b0;
	end
	
	always @(posedge CLK, posedge RST)
	begin
		if (RST)
		begin
			addr <= {ADDR_WIDTH{1'b0}};
			State <= S0;
			dataout <= {DATAOUT_WIDTH{1'b0}};
			wren <= 1'b0;
		end
		
		else
		begin
			
			case (State)
				
				S0 : // wait for the sop signal and valid signal at the same time
				begin
					addr <= {ADDR_WIDTH{1'b0}};
					wren <= 1'b0;
					if (sop && valid) // detecting START_reg rising edge
						State <= S1;
				end
				
				S1 : // write register no 0. It requires a whole state because incremental addr cannot be used for the first register
				begin
				
					addr <= {ADDR_WIDTH{1'b0}};
					dataout <= {{(32-DATAIN_WIDTH){datareg_re[DATAIN_WIDTH-1]}},{datareg_re},{(32-DATAIN_WIDTH){datareg_im[DATAIN_WIDTH-1]}},{datareg_im}};
					wren <= 1'b1;
					
					if (sop && valid) // always come back to S1 if (sop && valid)
						State <= S1;
					else
						State <= S2;
						
				end
				
				S2 : // increment and write other registers
				begin
				
					dataout <= {{(32-DATAIN_WIDTH){datareg_re[DATAIN_WIDTH-1]}},{datareg_re},{(32-DATAIN_WIDTH){datareg_im[DATAIN_WIDTH-1]}},{datareg_im}};
					if (valid)
					begin
						addr <= addr + 1'b1;
						wren <= 1'b1;
					end
					
					if (eop)
						State <= S3;
					else if (sop && valid) // always come back to S1 if (sop && valid)
						State <= S1;
								
				end
				
				S3 : // send the last data before returning to S0
				begin
					
					dataout <= {{(32-DATAIN_WIDTH){datareg_re[DATAIN_WIDTH-1]}},{datareg_re},{(32-DATAIN_WIDTH){datareg_im[DATAIN_WIDTH-1]}},{datareg_im}};
					addr <= addr + 1'b1;
					wren <= 1'b1;
					
					if (sop && valid)
						State <= S1;
					else
						State <= S0;
					
				end
				
			endcase
			
		end
	end






endmodule