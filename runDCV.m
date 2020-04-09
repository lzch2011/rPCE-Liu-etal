function dcvQ2 = runDCV(modelConf,X,Y)

nTrial = 10;
nFold = 20;

vec_nFold = modelConf.rPCE.kFold.nFold;

if strcmpi(modelConf.rPCE.methodChoice, 'mix')
    errMatrix = zeros(3,length(vec_nFold)+1);
else
    errMatrix = zeros(1,length(vec_nFold)+1);
end


for iTrial = 1:nTrial
    [XFold,YFold]=divTrainData(X,Y,nFold);
    for iFold = 1:nFold
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
end

dcvQ2 = 1-errMatrix/length(Y)/nTrial;

