
module fft_fifo (
	fft_fifo_in_data,
	fft_fifo_in_valid,
	fft_fifo_in_ready,
	fft_fifo_in_startofpacket,
	fft_fifo_in_endofpacket,
	fft_fifo_in_clk_clk,
	fft_fifo_in_clk_reset_reset_n,
	fft_fifo_out_data,
	fft_fifo_out_valid,
	fft_fifo_out_ready,
	fft_fifo_out_startofpacket,
	fft_fifo_out_endofpacket,
	fft_fifo_out_clk_clk,
	fft_fifo_out_clk_reset_reset_n);	

	input	[14:0]	fft_fifo_in_data;
	input		fft_fifo_in_valid;
	output		fft_fifo_in_ready;
	input		fft_fifo_in_startofpacket;
	input		fft_fifo_in_endofpacket;
	input		fft_fifo_in_clk_clk;
	input		fft_fifo_in_clk_reset_reset_n;
	output	[14:0]	fft_fifo_out_data;
	output		fft_fifo_out_valid;
	input		fft_fifo_out_ready;
	output		fft_fifo_out_startofpacket;
	output		fft_fifo_out_endofpacket;
	input		fft_fifo_out_clk_clk;
	input		fft_fifo_out_clk_reset_reset_n;
endmodule
