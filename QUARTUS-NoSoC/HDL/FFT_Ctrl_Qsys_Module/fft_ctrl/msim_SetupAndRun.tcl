set QSYS_SIMDIR C:/Users/dave/Documents/WORKSPACES/FFT/fft_fifo/fft_fifo/simulation/
source $QSYS_SIMDIR/mentor/msim_setup.tcl
dev_com
com

set QSYS_SIMDIR C:/Users/dave/Documents/WORKSPACES/FFT/fft_gp/simulation/
source $QSYS_SIMDIR/mentor/msim_setup.tcl
dev_com
com

# disable optimization that causes many variables to vanish
eval vsim -voptargs=+acc -t ps -L work -L work_lib -L fft_fifo -L fft_ii_0 -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclonev fft_ctrl_tb
