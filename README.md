# Miniapp MatMatMul

This miniapp tests the performance of the PETSc function  `MatMatMul`, that performs Matrix-Matrix multiplication AQ where A is a nxn and Q is a nxm matrix. 
This is compared to the usage of the function  `MatMul `, that performs Matrix-Vector multiplication. In particular, MatMul is called m times, multiplying A to each column vector of Q, resulting in the corresponding column of the result matrix AQ. 
The goal is to compare the timing of the two methods, and their scaling when the code is parallelized.


## Before usage:
* Set up correct path for petsc in  `Makefile`
* Unzip  `data.zip ` to the folder /data


## Usage:

The code can be run using `script.sh`, in which number of processors to test can be setup. The standard is 1 to 16 and the corresponging result is given by the timers collected in the /Output folder, and plot in the  `MatMul.png ` image, employing the matlab script  `Read_timer_AQ.m `.
