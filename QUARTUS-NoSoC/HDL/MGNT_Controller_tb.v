`timescale 1ps/1ps

module MGNT_Controller_tb ();

localparam DATABUS_WIDTH = 32;

// control signals
reg 		START;
wire 	FSMSTAT;

// pulse parameters
reg [DATABUS_WIDTH-1:0]	CHG_PLEN;	// charging pulse length
reg [DATABUS_WIDTH-1:0]	CHG_DLEN;	// delay length after charging
reg [DATABUS_WIDTH-1:0]	DCHG_PLEN;	// discharging pulse length
reg [DATABUS_WIDTH-1:0]	DCHG_DLEN;	// delay length after discharging
reg [DATABUS_WIDTH-1:0]	N;			// number of repetition
reg [DATABUS_WIDTH-1:0]	D;			// delay post sequence


// output pulses
wire CHG_OUT;	// charging output pulses
wire DCHG_OUT; // discharging output pulses

// system signals
reg CLK;
reg RESET;

// parameters are referenced in MHz for calculation
parameter timescale_ref = 1000000; // reference scale based on timescale => 1ps => 1THz => 1000000 MHz
parameter CLK_RATE_HZ = 25; // in MHz
localparam integer clockticks = (timescale_ref / CLK_RATE_HZ) / 2.0;


MGNT_Controller
#(
	.DATABUS_WIDTH (DATABUS_WIDTH)
)
MGNT_Controller1
(
	// control signals
	.START		(START),
	.FSMSTAT	(FSMSTAT),
	
	// pulse parameters
	.CHG_PLEN	(CHG_PLEN),	// charging pulse length
	.CHG_DLEN	(CHG_DLEN),	// delay length after charging
	.DCHG_PLEN	(DCHG_PLEN),	// discharging pulse length
	.DCHG_DLEN	(DCHG_DLEN),	// delay length after discharging
	.N			(N),	// number of repetition
	.D			(D),	// delay post sequence
	
	// output pulses
	.CHG_OUT	(CHG_OUT),	// charging output pulses
	.DCHG_OUT	(DCHG_OUT), // discharging output pulses
	
	// system signals
	.CLK		(CLK),
	.RESET		(RESET)
);

initial begin

	CLK = 1'b1;
	RESET = 1'b0;
	START = 1'b0;
	
	CHG_PLEN = 3;
	CHG_DLEN = 4;
	DCHG_PLEN = 5;
	DCHG_DLEN = 6;
	N = 10;
	D = 50;
	
	#(clockticks*2) RESET = 1'b1;
	#(clockticks*2) RESET = 1'b0;
	
	#(clockticks*2) START = 1'b1;
	#(clockticks*10) START = 1'b0;

	#(clockticks*500) START = 1'b1;
	#(clockticks*10) START = 1'b0;

end

always begin
	#clockticks CLK = ~CLK;
end





endmodule