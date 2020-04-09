function U = reformX(X,modelConf)
if modelConf.signCDF == 1
    for iM = 1:size(X,2)
        if ~strcmp(char(modelConf.pdfs(iM)), 'Uniform')
            ipara = modelConf.parameters{1,iM}; 
            modelConf.parameters{1,iM} = [ipara(3),ipara(4)];
        end
    end
    X = funPIT(X,modelConf.pdfs,modelConf.parameters);
    pdfs = cell(1,size(X,2));
    for ii = 1 : size(X,2)
        pdfs{1,ii} = 'Uniform' ;
    end
    modelConf.pdfs = pdfs;
end

% obtain U
PolyType = auto_retrieve_poly_types(modelConf.pdfs, modelConf.bounds);
[PolyMarginals] = poly_marginals(PolyType,modelConf);
U = GeneralIsopTransform(X, modelConf, PolyMarginals);
