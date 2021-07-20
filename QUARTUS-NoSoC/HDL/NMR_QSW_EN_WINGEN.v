// this module output is delayed by one due to the clock domain crossing

module NMR_QSW_EN_WINGEN 
(
		
	// control signal
	input ACQ_WND_PULSED,
	input ACQ_WND,
	output reg EN_QSW,
	input RESET,
	input ADC_CLK
	
	
);

	// clock domain crossing
	reg ACQ_WND_REG;
	always @(posedge ADC_CLK)
	begin
		ACQ_WND_REG <= ACQ_WND;
	end

// this is to generate Qswitch enable signal
	reg [2:0] State;
	localparam [2:0]
		S0 = 3'b001,
		S1 = 3'b010,
		S2 = 3'b100;
	always @(posedge ADC_CLK, posedge RESET)
	begin
		if (RESET)
		begin
			
			State <= S0;
			EN_QSW <= 1'b0;
			
		end
		else
		begin
		
			case (State)
			
				S0 : // find logic low of ACQ_WND_REG
				begin
				
					EN_QSW <= 1'b0;
					if ( !ACQ_WND_REG ) State = S1;
					
				end
				
				S1 : // find rising edge of ACQ_WND_REG
				begin
				
					if ( ACQ_WND_REG ) State = S2;
				
				end
				
				S2 : // find rising edge of ACQ_WND_PULSED
				begin
					
					EN_QSW <= 1'b1;
					if ( ACQ_WND_PULSED ) State = S0;
				
				end
				
			endcase
		end
	end


endmodule