function model = dispatchCenter(XTrain,YTrain,XOracle,YOracle,modelConf)

switch lower(modelConf.methodChoice)
    case {'lars','omp'}
            [~,model] = evalc('runUQLab(XTrain,YTrain,XOracle,YOracle,modelConf);');
    case 'rpce'
        [rPCEModel_Merge,rPCEModel_LARS,rPCEModel_OMP,selectId,dicR2,dicQ2] = runRPCE(XTrain,YTrain,XOracle,YOracle,modelConf);
        
        model.LARS = rPCEModel_LARS;
        model.OMP = rPCEModel_OMP;
        model.Merge = rPCEModel_Merge;
        model.selectApproach.name = selectId;
        model.selectApproach.Q2 = dicQ2;
        model.selectApproach.DCVQ2 = dicR2;
end