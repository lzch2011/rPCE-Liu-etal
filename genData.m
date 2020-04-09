function [XTrain,YTrain,XOracle,YOracle] = genData(nTrainData,nOracleData,modelConf,funName)

switch lower(funName)
    case 'borehole'
        XTrain = geneX_Original(nTrainData,modelConf);
        YTrain = borehole(XTrain);
        XOracle = geneX_Original(nOracleData,modelConf);
        YOracle = borehole(XOracle);
    case 'ishigami'
        XTrain = geneX_Original(nTrainData,modelConf);
        YTrain = ishigami(XTrain, 7, 0.1);
        XOracle = geneX_Original(nOracleData,modelConf);
        YOracle = ishigami(XOracle, 7, 0.1);
    case {'realdata','trussdata'}
        if strcmpi(funName,'realdata')
            load realData.mat X Y
        elseif strcmpi(funName,'trussdata')
            load trussData.mat X Y
        end
        if (nTrainData+nOracleData)>length(Y)
            error('The nTrainData+nTestData is larger than available data size!')
        else
            randIndex = randperm(length(Y));
            YOracle=Y(randIndex(1:nOracleData));
            XOracle=X(randIndex(1:nOracleData),:);
            YTrain=Y(randIndex((nOracleData+1):(nOracleData+nTrainData)));
            XTrain=X(randIndex((nOracleData+1):(nOracleData+nTrainData)),:);
        end
    case 'shortcol'
        XTrain = geneX_Original(nTrainData,modelConf);
        YTrain = shortcol(XTrain);
        XOracle = geneX_Original(nOracleData,modelConf);
        YOracle = shortcol(XOracle);
    case 'simplebeam'
        XTrain = geneX_Original(nTrainData,modelConf);
        YTrain = simplySupportedBeam(XTrain);
        XOracle = geneX_Original(nOracleData,modelConf);
        YOracle = simplySupportedBeam(XOracle);
    case 'sobol'
        XTrain = geneX_Original(nTrainData,modelConf);
        YTrain = sobolFun(XTrain);
        XOracle = geneX_Original(nOracleData,modelConf);
        YOracle = sobolFun(XOracle);
    case 'fung'
        XTrain = geneX_Original(nTrainData,modelConf);
        YTrain = gfunc(XTrain);
        XOracle = geneX_Original(nOracleData,modelConf);
        YOracle = gfunc(XOracle);
    case 'high_dim_ex'
        XTrain = geneX_Original(nTrainData,modelConf);
        YTrain = computeHighDimen(XTrain);
        XOracle = geneX_Original(nOracleData,modelConf);
        YOracle = computeHighDimen(XOracle);
end
end