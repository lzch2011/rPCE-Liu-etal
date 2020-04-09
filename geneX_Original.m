function tranX = geneX_Original(nTrainData,modelConf)

% This function is to generate samples of inputs in the original (physical) space

% generate samples uniform in [0 1] and independent with each other
pdfs = modelConf.pdfs;
nFeature = length(pdfs);
uniXTrain = lhsdesign_Rb(nTrainData,nFeature);

tranX = zeros(size(uniXTrain));

parameters = modelConf.parameters;
bounds = modelConf.bounds;
if ~isempty(bounds)
    for iFeature = 1:nFeature
        tranX(:,iFeature) = all_icdf(uniXTrain(:,iFeature),pdfs{1,iFeature},parameters{1,iFeature},bounds{1,iFeature});
    end
else
    for iFeature = 1:nFeature
        tranX(:,iFeature) = all_icdf(uniXTrain(:,iFeature),pdfs{1,iFeature},parameters{1,iFeature});
    end
end
    
 
    