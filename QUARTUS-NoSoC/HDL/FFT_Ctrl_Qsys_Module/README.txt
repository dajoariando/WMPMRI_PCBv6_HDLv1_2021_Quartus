author: David Ariando
July 25th 2021

The dataflow of the module is:
ADC -> fft_fifo -> fft_gp -> fft_ram -> SoC
fft_ctrl_in controls the data coming from the ADC to the fft_fifo
fft_ctrl_out controls the data coming from the FFT core (fft gp) to the fft_ram

In order to simulate, open Modelsim and run the custom simulation script "msim_SetupAndRun.tcl" inside the fft_ctrl folder.