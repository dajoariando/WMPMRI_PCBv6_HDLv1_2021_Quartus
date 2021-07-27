#!/bin/bash

sopc-create-header-files ../QUARTUS-SoC/CODE_qsys/soc_system.sopcinfo --single "./hps_soc_system.h" --module hps_0
# copy to the C folder
cp ./hps_soc_system.h "D:\GDrive\WORKSPACES\DS5_2019\WMPMRI_PCBv6_HDLv1_2021_DS5\hps_soc_system.h"
