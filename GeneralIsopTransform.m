function Y = GeneralIsopTransform(X, modelConf, Y_Marginals)
nFeature = size(X,2);
Y = zeros(size(X));
pdfNames = modelConf.pdfs;
parameters = modelConf.parameters;
bounds = modelConf.bounds;

for ii = 1:nFeature
    if ~isempty(bounds)
        u = all_cdf(X(:,ii),pdfNames{1,ii},parameters{1,ii},bounds{1,ii});
    else
        u = all_cdf(X(:,ii),pdfNames{1,ii},parameters{1,ii});
    end
    if isfield(Y_Marginals(ii),'bounds')
        Y(:,ii) = all_icdf(u, Y_Marginals(ii).pdf,Y_Marginals(ii).parameters,Y_Marginals(ii).bounds);
    else
        Y(:,ii) = all_icdf(u, Y_Marginals(ii).pdf,Y_Marginals(ii).parameters);
    end
end
