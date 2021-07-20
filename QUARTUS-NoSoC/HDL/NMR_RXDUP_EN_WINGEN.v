

module NMR_RXDUP_EN_WINGEN
#(

	parameter DATABUS_WIDTH = 32

)
(
	// control signals
	input 	ACQ_WND ,
	input		ACQ_EN,
	output reg ACQ_WND_DLY,
	output ACQ_WND_PULSED,
	
	input [DATABUS_WIDTH-1:0]	RX_DELAY,
	
	input ADC_CLK,
	input RESET

);	

	// clock domain crossing
	reg ACQ_WND_REG;
	always @(posedge ADC_CLK)
	begin
		ACQ_WND_REG <= ACQ_WND;
	end
	
	
	// this is to compute delay for RX_EN/DUP_EN control signal, which is named as ACQ_WND_DLY and also to generate the disable TX during reception (TX_SD)
	GNRL_delayed_pulser
	#(
		.DELAY_WIDTH (32)
	)
	DELAYED_EN_RX1
	(
		// signals
		.SIG_IN	(ACQ_WND_REG),
		.SIG_OUT(ACQ_WND_PULSED), 
		
		// parameters
		.DELAY	(RX_DELAY-1'b1), // minus 1 clock cycle due to clock domain crossing of the ACQ_WND.
		
		// system
		.CLK	(ADC_CLK),
		.RESET	(RESET)
		
	);
	
	reg [4:0] State;
	localparam [4:0]
		S0 = 5'b00001,
		S1 = 5'b00010,
		S2 = 5'b00100,
		S3 = 5'b01000,
		S4 = 5'b10000;
	
	always @(posedge ADC_CLK, posedge RESET)
	begin
		if (RESET)
		begin
			
			State <= S0;
			ACQ_WND_DLY <= 1'b0;
			
		end
		else
		begin
		
			case (State)
			
				S0 :
				begin
								
					// Wait for the Start signal
					if (ACQ_WND_PULSED)
						State <= S1;
				
				end
				
				S1 : 
				begin
					
					ACQ_WND_DLY <= 1'b1;
					
					if (ACQ_EN) State <= S3;
					else State <= S2;
						
					
				end
				
				S2 : 
				begin
				
					if (ACQ_EN) State <= S3;
					
				end
				
				S3 : 
				begin
				
					if (!ACQ_EN) State <= S4;
					
				end
				
				S4 : 
				begin
				
					ACQ_WND_DLY <= 1'b0;
					State <= S0;
					
				end
			endcase
		end
				
	end
	
	
	
	
	endmodule
	