function [ref_SU,ref_variable] = compuRefSobol_IshigamiFun(a,b)

D = a^2/8 + b*pi^4/5 + b^2*pi^8/18 + 1/2;

D1 = b*pi^4/5 + b^2*pi^8/50 + 1/2;
D2 = a^2/8;
D3 = 0;
D12 = 0;
D23 = 0;
D13 = 8*b^2*pi^8/225;
D123 = 0;

ref_variable = [1 0 0;0 1 0;0 0 1;1 1 0;0 1 1;1 0 1;1 1 1];
ref_SU = [D1/D; D2/D; D3/D; D12/D; D23/D; D13/D; D123/D];