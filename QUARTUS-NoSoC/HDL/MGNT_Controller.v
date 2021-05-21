/*
	Author	: David Ariando
	Date	: May 21st, 2021
	
	This module generates charging & discharging pulse for the magnet with configurable pulse length, delay length and number of pulses.
*/

module MGNT_Controller
#(
	parameter DATABUS_WIDTH = 32
)
(
	// control signals
	input 		START,
	output reg 	FSMSTAT,
	
	// pulse parameters
	input [DATABUS_WIDTH-1:0]	CHG_PLEN,	// charging pulse length
	input [DATABUS_WIDTH-1:0]	CHG_DLEN,	// delay length after charging
	input [DATABUS_WIDTH-1:0]	DCHG_PLEN,	// discharging pulse length
	input [DATABUS_WIDTH-1:0]	DCHG_DLEN,	// delay length after discharging
	input [DATABUS_WIDTH-1:0]	N,			// number of repetition
	input [DATABUS_WIDTH-1:0]	D,			// delay post sequence
	
	// output pulses
	output reg CHG_OUT,	// charging output pulses
	output reg DCHG_OUT, // discharging output pulses
	
	// system signals
	input CLK,
	input RESET
);

	// rollover counter reg
	reg 	[DATABUS_WIDTH-1:0]	CHG_PLEN_CNT;
	reg 	[DATABUS_WIDTH-1:0]	CHG_DLEN_CNT;
	reg 	[DATABUS_WIDTH-1:0]	DCHG_PLEN_CNT;
	reg 	[DATABUS_WIDTH-1:0]	DCHG_DLEN_CNT;
	reg 	[DATABUS_WIDTH-1:0]	N_CNT;
	reg 	[DATABUS_WIDTH-1:0]	D_CNT;

	reg [10:0] State /* synthesis keep = 1 */;
	localparam [10:0]
		S0 		= 11'b00000000001,
		S1 		= 11'b00000000010,
		S2 		= 11'b00000000100,
		S3 		= 11'b00000001000,
		S4 		= 11'b00000010000,
		S5 		= 11'b00000100000,
		S6 		= 11'b00001000000,
		S7 		= 11'b00010000000,
		S8 		= 11'b00100000000,
		S9 		= 11'b01000000000,
		S10 	= 11'b10000000000;
	
	initial
	begin
		
		CHG_PLEN_CNT	<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - CHG_PLEN	+ 1'b1;
		CHG_DLEN_CNT	<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - CHG_DLEN	+ 1'b1;
		DCHG_PLEN_CNT	<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - DCHG_PLEN	+ 1'b1;
		DCHG_DLEN_CNT	<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - DCHG_DLEN	+ 2'b10;
		N_CNT			<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - N         	+ 1'b1;
		D_CNT			<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - D         	+ 1'b1;
	
		CHG_OUT		<= 1'b0;
		DCHG_OUT	<= 1'b0;
		State	<= S0;
	end
	
	// main controller always loop
	always @(posedge CLK, posedge RESET)
	begin
	
		if (RESET)
		begin

			FSMSTAT		<= 1'b0;
			CHG_OUT		<= 1'b0;
			DCHG_OUT	<= 1'b0;
			State		<= S0;
			
			CHG_PLEN_CNT	<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - CHG_PLEN	+ 1'b1;
			CHG_DLEN_CNT	<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - CHG_DLEN	+ 1'b1;
			DCHG_PLEN_CNT	<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - DCHG_PLEN	+ 1'b1;
			DCHG_DLEN_CNT	<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - DCHG_DLEN	+ 2'b10;
			N_CNT			<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - N         	+ 1'b1;
			D_CNT			<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - D         	+ 1'b1;
			
		end
		else
		begin
		
			case (State)
			
				S0 :
				begin
					
					FSMSTAT		<= 1'b0;
					CHG_OUT		<= 1'b0;
					DCHG_OUT	<= 1'b0;
					
					// Wait for the Start signal
					if (START)
						State <= S1;
				
				end
				
				S1 : // initialization
				begin
					
					CHG_PLEN_CNT	<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - CHG_PLEN	+ 1'b1;
					CHG_DLEN_CNT	<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - CHG_DLEN	+ 1'b1;
					DCHG_PLEN_CNT	<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - DCHG_PLEN	+ 1'b1;
					DCHG_DLEN_CNT	<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - DCHG_DLEN	+ 2'b10;
					N_CNT			<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - N         	+ 1'b1;
					D_CNT			<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - D         	+ 1'b1;
					
					FSMSTAT <= 1'b1;
					
					State <= S2;
								
				end
				
				S2 : // charging pulse
				begin
				
					CHG_OUT <= 1'b1;
					
					CHG_PLEN_CNT <= CHG_PLEN_CNT + 1'b1;
					
					if (CHG_PLEN_CNT[DATABUS_WIDTH-1])
						State <= S3;
				
				end
				
				S3 : // post-charging delay
				begin
				
					CHG_PLEN_CNT	<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - CHG_PLEN	+ 1'b1; // reinitialize CHG_PLEN_CNT
					
					CHG_OUT <= 1'b0;
					
					CHG_DLEN_CNT <= CHG_DLEN_CNT + 1'b1;
					
					if (CHG_DLEN_CNT[DATABUS_WIDTH-1])
						State <= S4;
					
				end
				
				S4 : // discharging pulse
				begin
					
					CHG_DLEN_CNT	<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - CHG_DLEN	+ 1'b1; // reinitialize CHG_DLEN_CNT
					
					DCHG_OUT <= 1'b1;
					
					DCHG_PLEN_CNT <= DCHG_PLEN_CNT + 1'b1;
					
					if (DCHG_PLEN_CNT[DATABUS_WIDTH-1])
						State <= S5;
					
				end
				
				S5 : // post-discharging pulse
				begin
				
					DCHG_PLEN_CNT	<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - DCHG_PLEN	+ 1'b1; // reinitialize DCHG_PLEN_CNT

					DCHG_OUT <= 1'b0;
					
					DCHG_DLEN_CNT <= DCHG_DLEN_CNT + 1'b1;
					
					if (DCHG_DLEN_CNT[DATABUS_WIDTH-1])
						State <= S6;
					
				end
				
				S6 : // count for N times
				begin
				
					DCHG_DLEN_CNT	<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - DCHG_DLEN	+ 2'b10; // reinitialize DCHG_DLEN_CNT
					
					N_CNT <= N_CNT + 1'b1;						

					if (N_CNT[DATABUS_WIDTH-1])
						State <= S7;
					else
						State <= S2;
					
				end
				
				S7 : // delay post-sequence
				begin
				
					D_CNT <= D_CNT + 1'b1;
					
					if (D_CNT[DATABUS_WIDTH-1])
						State <= S8;
				
				end
				
				S8 : // finish the sequence
				begin
					
					if (!START) // check if START signal is deasserted to make sure there's no multiple runs
						State <= S0;
					
				end
				
			endcase
		
		end
	
	end

endmodule
