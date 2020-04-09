% Code for paper "Surrogate modeling based on resampled polynomial chaos
% expansions" by Liu et al.
% Matlab-based software UQLab (https://www.uqlab.com) should be downloaded and installed in advance 
% Date: April 8, 2020
% Code only for academic researches

The code "main_rPCE" should be run first to get the LARS, OMP and rPCE models.
From the data saved by "main_rPCE", 
"prediction" predict the output of new inputs;
"computeSobol" compute Sobol' indices;
"diagPredict" gives the scattering plots of output of testing data;
"determinationCoeff" summarizes the determination coeffcients (Q2 and R2).