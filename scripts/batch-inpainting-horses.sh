#!/bin/bash
matlab -nodisplay -r "cd('/home/ericribeiro/Documents/MATLAB/Deferrard'); addpath(genpath('/home/ericribeiro/Documents/MATLAB/Deferrard')); inpaint('horses', '300', 'superpixels', 2); inpaint('horses', '300', 'superpixels', 3); inpaint('horses', '300', 'superpixels', 4); inpaint('horses', '300', 'superpixels', 5); inpaint('horses', '300', 'superpixels', 6); exit"