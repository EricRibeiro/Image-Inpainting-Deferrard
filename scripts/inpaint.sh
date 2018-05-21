#!/bin/sh
#
# created by: Eric Ribeiro on 20/04/2018
#
# arguments:
#
# $1: imname  
# $2: extinction value parameter or quantity of superpixels
# $3: extinction method parameter(areas, dynamics, volumes or superpixels)
# $4: adjacency
# $5: patch size (must be even)
#
# examples: inpaint piramide 1050 superpixels 1 3 or inpaint piramide 25 areas 5 5
#
# note: remember to change the path in the code below to match yours.

matlab -nodisplay -r "cd('/home/ericribeiro/Documents/MATLAB/Deferrard'); addpath(genpath('/home/ericribeiro/Documents/MATLAB/Deferrard')); inpaint('${1}', '${2}', '${3}', ${4}, ${5}); exit"