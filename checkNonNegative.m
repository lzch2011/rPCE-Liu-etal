function isNegative = checkNonNegative(PSI,alpha,modelConf,XTrain,YTrain)

beta = (PSI.'*PSI)\(PSI.'*YTrain);
XNew = lhsaugment(XTrain,1e3);

newPSI = basisGe(2*XNew-1,alpha,modelConf.pdfs,modelConf.parameters,modelConf.signCDF);
YNew = newPSI*beta;

if isfield(modelConf.C2M,'nonNegativeThreshold')
    threshold = modelConf.C2M.nonNegativeThreshold;
else
    threshold = -1.2*std(YTrain);
end

nNegative = sum(YNew<threshold);

if (nNegative/1e3) > 1e-2
    isNegative = 1;
else
    isNegative = 0;
end

