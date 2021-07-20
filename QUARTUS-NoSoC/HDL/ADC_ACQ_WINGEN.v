/*

	this is the active window generator for ADC acquisition
	it computes the ADC initial delay in the delay_with_acquisition window
	and generate another window for the real ADC data acquisition, which
	in general will be shorter than the original delay_with_acqusition window
	The window for ADC real acquisition itself will be proportional to the length
	of SAMPLES_PER_ECHO or in KeA2 it is called number-of-points.
	
	There is an issue: TOKEN was implemented to prevent retriggering. But also at the same time, if CLK is generated after ACQ_WND rises,
	TOKEN is not resetted to 0, which will prevent the state machine from running. It is fixed by having reset button implemented to reset the TOKEN to 0 just before any acquisition

	The ACQ_WND is sometimes not at the same clock domain so there's a need for clock domain crossing
	
*/

module ADC_ACQ_WINGEN
# (
	parameter DATABUS_WIDTH = 32 
)
(

	// parameters
	input [DATABUS_WIDTH-1:0] ADC_INIT_DELAY,		// minimum value of 3
	input [DATABUS_WIDTH-1:0] SAMPLES_PER_ECHO,	// minimum value of 1
	
	// control signal
	input ACQ_WND,
	output reg ACQ_EN,
	
	// system signal
	input CLK,
	input RESET
);
	
	reg [DATABUS_WIDTH-1:0] ADC_DELAY_CNT;
	wire [DATABUS_WIDTH-1:0] ADC_DELAY_CNT_LOADVAL;
	reg [DATABUS_WIDTH-1:0] SAMPLES_PER_ECHO_CNT;
	wire [DATABUS_WIDTH-1:0] SAMPLES_PER_ECHO_CNT_LOADVAL;
	
	reg TOKEN; // token to avoid restarting ACQ_EN window when the ACQ_WND is long
	
	// clock domain crossing
	reg ACQ_WND_REG;
	always @(posedge CLK)
	begin
		ACQ_WND_REG <= ACQ_WND;
	end
	
	reg [4:0] State;
	localparam [4:0]
		S0 = 5'b00001,
		S1 = 5'b00010,
		S2 = 5'b00100,
		S3 = 5'b01000,
		S4 = 5'b10000;
		
	
	assign ADC_DELAY_CNT_LOADVAL = {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - ADC_INIT_DELAY + 1'b1 + 1'b1 + 1'b1;
	assign SAMPLES_PER_ECHO_CNT_LOADVAL = {1'b1,{ (DATABUS_WIDTH-1) {1'b0} }} - SAMPLES_PER_ECHO + 1'b1;
	
	initial
	begin
		ADC_DELAY_CNT <= {DATABUS_WIDTH{1'b0}};
		SAMPLES_PER_ECHO_CNT <= {DATABUS_WIDTH{1'b0}};
		TOKEN <= 1'b0;
	end
	
	always @(posedge CLK, posedge RESET)
	begin
		if (RESET)
		begin
			ACQ_EN <= 1'b0;
			TOKEN <= 1'b0;
			ADC_DELAY_CNT <= ADC_DELAY_CNT_LOADVAL;
			SAMPLES_PER_ECHO_CNT <= SAMPLES_PER_ECHO_CNT_LOADVAL;
			State <= S0;
		end
		
		else
		begin
			
			case (State)
				
				S0 : // wait for the acquisition window timing
				begin
					ADC_DELAY_CNT <= ADC_DELAY_CNT_LOADVAL;
					SAMPLES_PER_ECHO_CNT <= SAMPLES_PER_ECHO_CNT_LOADVAL;
					TOKEN <= ACQ_WND_REG;
					if (TOKEN == 1'b0 && ACQ_WND_REG == 1'b1) // detecting ACQ_WND_REG rising edge
						State = S1;
				end
				
				S1 : // wait for the given ADC initial delay
				begin
					ADC_DELAY_CNT <= ADC_DELAY_CNT + 1'b1;
					if (ADC_DELAY_CNT[DATABUS_WIDTH-1])
						State <= S2;
				end
				
				S2 : // enable ACQ_EN
				begin
					SAMPLES_PER_ECHO_CNT <= SAMPLES_PER_ECHO_CNT + 1'b1;
					ACQ_EN <= 1'b1;
					if (SAMPLES_PER_ECHO_CNT[DATABUS_WIDTH-1])
						State <= S3;
				end
				
				S3 : // clear the ACQ_EN and finish the state machine
				begin
					ACQ_EN <= 1'b0;
					State <= S0;
				end
				
			endcase
			
		end
	end

endmodule