# Hercules
Source code for Hercules with two examples

### Rebuild Onboard Project:

```
cd bbgemm
source bbgeem.tcl
```



### Generate Bit stream and xsa

Open the project, you can read the source code and wiring, and the main logic is in the block design. Generate the bit stream and export the xsa file, the bit stream is used to burn into the PL side, and the xsa file uses petalinux to generate the startup file of the PS side.



### Run Hercules compare

After burning the bit stream and starting the PS-side linux system, use VIO to set clk_en from 0 to 1, and then set ap_start from 0 to 1. Use ILA to set the right signal trigger of the difftest_v1 module to 1. Compile and execute the gemm_compress_foldxor.c file on the PS end system. It can be seen that the trigger was not triggered, indicating that the comparison was completed and no errors were found. If an error is found, the DUT will stop at the wrong position, and a readback operation is required.
