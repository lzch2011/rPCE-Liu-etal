function [est_Q2,best_nFold,best_Method] = funBestResample(modelConf,X,Y)

vec_nFold = modelConf.rPCE.kFold.nFold;
[XFold,YFold]=divTrainData(X,Y,length(Y));

if strcmpi(modelConf.rPCE.methodChoice, 'mix')
    errMatrix = zeros(3,length(vec_nFold)+1);
else
    errMatrix = zeros(1,length(vec_nFold)+1);
end

for iFold = 1:length(Y)
    [XCons,YCons,XTest,YTest] = genConsTestData(XFold,YFold,iFold,length(Y));
    
    vec_nFold(end) = length(YCons);
    modelConf.rPCE.kFold.nFold = vec_nFold;
    if strcmpi(modelConf.rPCE.methodChoice,'mix')
        [rPCEModel_Mix,rPCEModel_LARS,rPCEModel_OMP] = runRPCE(XCons,YCons,XTest,YTest,modelConf);
        R2_Mix = extractfield(rPCEModel_Mix,'R2');
        R2_LARS = extractfield(rPCEModel_LARS,'R2');
        R2_OMP = extractfield(rPCEModel_OMP,'R2');
        
        errMatrix(1,:) = errMatrix(1,:) + (1-R2_Mix)*length(YTest);
        errMatrix(2,:) = errMatrix(2,:) + (1-R2_LARS)*length(YTest);
        errMatrix(3,:) = errMatrix(3,:) + (1-R2_OMP)*length(YTest);
    else
        rPCEModel = runRPCE(XCons,YCons,XTest,YTest,modelConf);
        R2 = extractfield(rPCEModel,'R2');
        errMatrix = errMatrix + (1-R2)*length(YTest);
    end
end


[~,Ind] = min(errMatrix(:));

est_Q2 = 1-errMatrix/length(Y);

if strcmpi(modelConf.rPCE.methodChoice, 'mix')
    [methodInd, nFoldInd]=ind2sub(size(errMatrix),Ind);
    if methodInd == 1
        best_Method = 'Mix';
    elseif methodInd == 2
        best_Method = 'LARS';
    elseif methodInd == 3
        best_Method = 'OMP';
    end
else
    nFoldInd = Ind;
end

if nFoldInd <= length(vec_nFold)
    best_nFold = vec_nFold(nFoldInd);
else
    best_nFold = length(Y)+1;
end
