module NMR_PULSE_PROGRAM
#(
	parameter DATABUS_WIDTH = 32,
	parameter NMR_MAIN_TIMER_WIDTH = 4
)
(
	// control signals
	input 		START,
	output reg 	FSMSTAT,
	
	// nmr control signals
	input		PHASE_CYC,
	input		PULSE_ON_RX,
	output reg	ACQ_WND,
	output reg	ACQ_WND_ALWAYS_ON, // the same with ACQ_WND, but this keeps on all the time not depending on ECHO_SKIP
	output reg	OUT_EN,		// tx output enable
	
	// nmr parameters
	input [DATABUS_WIDTH-1:0]	T1_PULSE180,
	input [DATABUS_WIDTH-1:0]	T1_DELAY,
	input [DATABUS_WIDTH-1:0]	PULSE90,
	input [DATABUS_WIDTH-1:0]	DELAY_NO_ACQ,
	input [DATABUS_WIDTH-1:0]	PULSE180,
	input [DATABUS_WIDTH-1:0]	DELAY_WITH_ACQ,
	input [DATABUS_WIDTH-1:0]	ECHO_PER_SCAN,	// echo per scan integer number
	input [DATABUS_WIDTH-1:0]	ECHO_SKIP,
	
	// adc clock generator
	output ADC_CLK,
	
	// nmr tx clock output
	output TX_OUT_P,
	output TX_OUT_N,
	
	// system signals
	input CLK,
	input RESET
);

	// rollover counter reg
	reg 	[DATABUS_WIDTH-1:0]	T1_PULSE180_CNT;
	reg 	[DATABUS_WIDTH-1:0]	T1_DELAY_CNT;
	wire 	[DATABUS_WIDTH-1:0]	JUMP_TO_S4;
	reg 	[DATABUS_WIDTH-1:0]	PULSE90_CNT;
	reg 	[DATABUS_WIDTH-1:0]	DELAY_NO_ACQ_CNT;
	wire 	[DATABUS_WIDTH-1:0]	JUMP_TO_S6;
	reg 	[DATABUS_WIDTH-1:0]	PULSE180_CNT;
	reg 	[DATABUS_WIDTH-1:0]	DELAY_WITH_ACQ_CNT;
	wire 	[DATABUS_WIDTH-1:0]	JUMP_TO_S7;
	reg 	[DATABUS_WIDTH-1:0]	ECHO_PER_SCAN_CNT;
	reg 	[DATABUS_WIDTH-1:0]	TAIL_DELAY_CNT;
	reg		[DATABUS_WIDTH-1:0] ECHO_SKIP_CNT;
	
	// nmr tx clock generator
	wire TX_CLK_X; // tx phase 0 output
	wire TX_CLK_Y; // tx phase 90 output

	reg	PHASE;		// select the output tx phase
	
	
	
	// register for NMR main timer
	reg [NMR_MAIN_TIMER_WIDTH-1:0] NMR_MAIN_TIMER_CNT;

	reg [10:0] State /* synthesis keep = 1 */;
	localparam [10:0]
		S0 	= 11'b00000000001,
		S1 	= 11'b00000000010,
		S2 	= 11'b00000000100,
		S3 	= 11'b00000001000,
		S4 	= 11'b00000010000,
		S5 	= 11'b00000100000,
		S6 	= 11'b00001000000,
		S7 	= 11'b00010000000,
		S8 	= 11'b00100000000,
		S9 	= 11'b01000000000,
		S10 	= 11'b10000000000;
	
	assign JUMP_TO_S4	= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - T1_PULSE180; // only MSB is used to define whether skipping/not is required
	assign JUMP_TO_S6	= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - PULSE90; // only MSB is used to define whether skipping/not is required
	assign JUMP_TO_S7	= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - PULSE180; // only MSB is used to define whether skipping/not is required
	
	initial
	begin
		FSMSTAT	<= 1'b0;
		PHASE	<= 1'b0;
		OUT_EN	<= 1'b0;
		ACQ_WND	<= 1'b0;
		ACQ_WND_ALWAYS_ON	<= 1'b0;
		NMR_MAIN_TIMER_CNT <= {NMR_MAIN_TIMER_WIDTH{1'b0}};
		State	<= S0;
		
	end
	
	// main controller always loop
	always @(posedge CLK, posedge RESET)
	begin
	
		if (RESET)
		begin
		
			FSMSTAT	<= 1'b0;
			PHASE	<= 1'b0;
			OUT_EN	<= 1'b0;
			ACQ_WND	<= 1'b0;
			ACQ_WND_ALWAYS_ON	<= 1'b0;
			NMR_MAIN_TIMER_CNT <= {NMR_MAIN_TIMER_WIDTH{1'b0}};
			State	<= S0;
			
		end
		else
		begin
			
			NMR_MAIN_TIMER_CNT <= NMR_MAIN_TIMER_CNT + 1'b1;
			
			case (State)
			
				S0 :
				begin
					
					OUT_EN <= 1'b0; 
					ECHO_PER_SCAN_CNT	<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - 	ECHO_PER_SCAN + 1;
					NMR_MAIN_TIMER_CNT <= {NMR_MAIN_TIMER_WIDTH{1'b0}};
					
					// Wait for the Start signal
					if (START)
						State <= S1;
				
				end
				
				S1 : 
				begin
					
					T1_PULSE180_CNT		<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - T1_PULSE180 + 1'b1;
					T1_DELAY_CNT		<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - T1_DELAY + 1'b1;
					PULSE90_CNT 		<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - PULSE90 + 1'b1;
					DELAY_NO_ACQ_CNT 	<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - DELAY_NO_ACQ + 1'b1;
					PULSE180_CNT		<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - PULSE180 + 1'b1;
					DELAY_WITH_ACQ_CNT	<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - DELAY_WITH_ACQ + 1'b1 + 1'b1; // another (+1'b1) compensate for S6 state 1 clock cycle 
					TAIL_DELAY_CNT		<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - ((PULSE180+DELAY_WITH_ACQ)<<5) + 1'b1; // tail delay to extend the ADC_CLK window. The delay is (echo_period*32) or (echo_period << 5
					ECHO_SKIP_CNT		<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - ECHO_SKIP + 1'd1;
					
					FSMSTAT <= 1'b1;
					
					// skip if the pulse length is 0. There are several scenario:
					// 1. There's no point of doing T1 inversion recovery if PULSE90 is 0, so skip S2 until S5 if this is true, no matter what T1_PULSE180 is.
					//    By skipping PULSE90, and with a single ECHO_PER_SCAN, FID measurement can be performed.
					// 2. If the inversion recovery is not intended, set the T1_PULSE180 to 0 to skip S2 and S3.					
					// 3. To do noise measurement, set the ECHO_PER_SCAN to be 1, and then set PULSE180 to be 0, effectively jumping all states before S7
					if (JUMP_TO_S7[DATABUS_WIDTH-1])
						State <= S7;
					else if (JUMP_TO_S6[DATABUS_WIDTH-1])
						State <= S6;
					else if (JUMP_TO_S4[DATABUS_WIDTH-1])
						State <= S4;
					else
						State <= S2;
								
				end
				
				S2 : // initial pulse 180 for T1 measurement
				begin
				
					OUT_EN <= 1'b1;
					PHASE <= 1'b0;
					ACQ_WND <= 1'b0;
					ACQ_WND_ALWAYS_ON <= 1'b0;
					
					T1_PULSE180_CNT <= T1_PULSE180_CNT + 1'b1;
					
					if (T1_PULSE180_CNT[DATABUS_WIDTH-1])
						State <= S3;
				
				end
				
				S3 : // delay no-acquisition
				begin
					
					OUT_EN <= 1'b0;
					ACQ_WND <= 1'b0;
					ACQ_WND_ALWAYS_ON <= 1'b0;
					
					T1_DELAY_CNT <= T1_DELAY_CNT + 1'b1;
					
					if (T1_DELAY_CNT[DATABUS_WIDTH-1])
						State <= S4;
					
				end
				
				S4 : // pulse 90 state
				begin
					
					OUT_EN <= 1'b1;
					PHASE <= 1'b0;
					ACQ_WND <= 1'b0;
					ACQ_WND_ALWAYS_ON <= 1'b0;
					
					PULSE90_CNT <= PULSE90_CNT + 1'b1;
					
					if (PULSE90_CNT[DATABUS_WIDTH-1])
						State <= S5;
					
				end
				
				S5 : // delay no-acquisition
				begin
					
					OUT_EN <= 1'b0;
					ACQ_WND <= 1'b0;
					ACQ_WND_ALWAYS_ON <= 1'b0;
					DELAY_NO_ACQ_CNT <= DELAY_NO_ACQ_CNT + 1'b1;
					
					if (DELAY_NO_ACQ_CNT[DATABUS_WIDTH-1])
						State <= S6;
					
				end
				
				S6 : // pulse 180 state
				begin
				
					OUT_EN <= 1'b1;
					PHASE <= 1'b1;
					ACQ_WND <= 1'b0;
					ACQ_WND_ALWAYS_ON <= 1'b0;
					
					PULSE180_CNT <= PULSE180_CNT + 1'b1;						

					
					if (PULSE180_CNT[DATABUS_WIDTH-1])
						State <= S7;
					
				end
				
				S7 : // delay with acquisition
				begin
					
					if (PULSE_ON_RX)
						OUT_EN <= 1'b1;
					else
						OUT_EN <= 1'b0; 
					
					
					if (ECHO_SKIP_CNT[DATABUS_WIDTH-1])
					begin
						ACQ_WND <= 1'b1;
						ECHO_SKIP_CNT		<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - ECHO_SKIP;
					end
					ACQ_WND_ALWAYS_ON <= 1'b1;
					
					DELAY_WITH_ACQ_CNT <= DELAY_WITH_ACQ_CNT + 1'b1;
					
					if (DELAY_WITH_ACQ_CNT[DATABUS_WIDTH-1])
						State <= S8;
					
				end
				
				S8 : // check echo per scan rollover counter
				begin
					
					OUT_EN <= 1'b0; 
					
					PULSE180_CNT		<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - PULSE180 + 1'b1;
					DELAY_WITH_ACQ_CNT	<= {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - DELAY_WITH_ACQ + 1'b1 + 1'b1; // another (+1'b1) compensate for S6 state 1 clock cycle 
					
					ECHO_SKIP_CNT <= ECHO_SKIP_CNT + 1'b1;
					ECHO_PER_SCAN_CNT <= ECHO_PER_SCAN_CNT + 1'b1;
					
					if (ECHO_PER_SCAN_CNT[DATABUS_WIDTH-1])
						State <= S9;
					else
						State <= S6;
						
				end
				
				S9 : // additional delay at the end of the sequence. Added to prolong the ADC_CLK that's enabled when FSM_STAT is 1
				begin
					
					
					ACQ_WND <= 1'b0;
					ACQ_WND_ALWAYS_ON <= 1'b0;
					TAIL_DELAY_CNT <= TAIL_DELAY_CNT + 1'b1;
					
					if (TAIL_DELAY_CNT[DATABUS_WIDTH-1])
						State <= S10;
					
				end
				
				S10: // end of sequence
				begin
					
					FSMSTAT <= 1'b0;
					
					State <= S0;
				
				end
				
				
			endcase
		
		end
	
	end
	
	// main NMR counter always loop
	//always @(posedge CLK, posedge RESET)
	//begin
	//	if (RESET)
	//	begin
	//		NMR_MAIN_TIMER_CNT <= {NMR_MAIN_TIMER_WIDTH{1'b0}};
	//	end
	//	else
	//	begin
	//		if (FSMSTAT)
	//			NMR_MAIN_TIMER_CNT <= NMR_MAIN_TIMER_CNT + 1'b1;
	//		else
	//			NMR_MAIN_TIMER_CNT <= {NMR_MAIN_TIMER_WIDTH{1'b0}};
	//	end
	//end
	
	// generate ADC clock
	assign ADC_CLK = NMR_MAIN_TIMER_CNT[1]; // index 0 is to get CLK/2 frequency, and index 1 is to get CLK/4 frequency
	
	// generate TX clock
	wire [1:0] TX_CLK_X_CNT, TX_CLK_Y_CNT;
	assign TX_CLK_X_CNT = NMR_MAIN_TIMER_CNT[3:2]; // index 2: CLK/8, index 3: CLK/16.
	assign TX_CLK_Y_CNT = NMR_MAIN_TIMER_CNT[3:2] + 1'b1; // add extra 90 degrees phase shift
	assign TX_CLK_X = TX_CLK_X_CNT[1]; // phase 0
	assign TX_CLK_Y = TX_CLK_Y_CNT[1]; // phase 90
	
	// switch TX clock output (phase cycling by pulse-90)
	wire TX_OUT_X_phcyc; // phase cycling output signal 
	wire TX_OUT_P_int; // internal tx_p after selected by phase (switching between 0 and 90 degrees input pulse)
	assign TX_OUT_X_phcyc = PHASE_CYC ? TX_CLK_X : ~TX_CLK_X;
	assign TX_OUT_P_int = PHASE ?  TX_CLK_Y : TX_OUT_X_phcyc;
	assign TX_OUT_P = OUT_EN ? TX_OUT_P_int : 1'b0;
	assign TX_OUT_N = OUT_EN ? ~TX_OUT_P_int : 1'b0;


endmodule
