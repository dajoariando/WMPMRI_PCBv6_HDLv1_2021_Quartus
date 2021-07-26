	fft_fifo u0 (
		.fft_fifo_in_data               (<connected-to-fft_fifo_in_data>),               //            fft_fifo_in.data
		.fft_fifo_in_valid              (<connected-to-fft_fifo_in_valid>),              //                       .valid
		.fft_fifo_in_ready              (<connected-to-fft_fifo_in_ready>),              //                       .ready
		.fft_fifo_in_startofpacket      (<connected-to-fft_fifo_in_startofpacket>),      //                       .startofpacket
		.fft_fifo_in_endofpacket        (<connected-to-fft_fifo_in_endofpacket>),        //                       .endofpacket
		.fft_fifo_out_data              (<connected-to-fft_fifo_out_data>),              //           fft_fifo_out.data
		.fft_fifo_out_valid             (<connected-to-fft_fifo_out_valid>),             //                       .valid
		.fft_fifo_out_ready             (<connected-to-fft_fifo_out_ready>),             //                       .ready
		.fft_fifo_out_startofpacket     (<connected-to-fft_fifo_out_startofpacket>),     //                       .startofpacket
		.fft_fifo_out_endofpacket       (<connected-to-fft_fifo_out_endofpacket>),       //                       .endofpacket
		.fft_fifo_out_clk_reset_reset_n (<connected-to-fft_fifo_out_clk_reset_reset_n>), // fft_fifo_out_clk_reset.reset_n
		.fft_fifo_out_clk_clk           (<connected-to-fft_fifo_out_clk_clk>),           //       fft_fifo_out_clk.clk
		.fft_fifo_in_clk_reset_reset_n  (<connected-to-fft_fifo_in_clk_reset_reset_n>),  //  fft_fifo_in_clk_reset.reset_n
		.fft_fifo_in_clk_clk            (<connected-to-fft_fifo_in_clk_clk>)             //        fft_fifo_in_clk.clk
	);

