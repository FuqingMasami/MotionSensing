# MotionSensing
Motion sensing with CMU

In my work, the syhchronization, segmentation and quantization are all the same with the Walkie-talkie paper, which can be found via https://ieeexplore.ieee.org/document/7460726. Going through the related parts could be beneficial.

Here are the three key functions in matlab.

1. find_offsets.m

This is used to find the offsets of two signals, and to align them.

2. quan_window.m

This is used to quantize a window using a guard band. The guard band is controlled by Alpha. The bit_depth should be set as 1 so that each sample will only be quantized as 1 or 0.

3. tkg_new.m 

This is used to generate keys for two signals. Each signals will be sliced to no-overlapping windows and use quan_window.m to do the quantization.
