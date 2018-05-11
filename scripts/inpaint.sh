#!/bin/sh
# created by: Eric Ribeiro on 20/04/2018
# inputs:
#
# $1: imname  
# $2: extinction value parameter
# $3: extinction method parameter(areas, dynamics, volumes or superpixels)
# $4: adjacency


matlab -nodisplay -r "cd('/home/ericribeiro/Documents/MATLAB/Deferrard'); addpath(genpath('/home/ericribeiro/Documents/MATLAB/Deferrard')); inpaint('${1}', '${2}', '${3}', ${4}); exit"