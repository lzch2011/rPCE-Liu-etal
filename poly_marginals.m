function [PolyMarginals, PolyCopula] = poly_marginals(PolyType,modelConf)

pdfName = modelConf.pdfs;
parameters = modelConf.parameters;
bounds = modelConf.bounds;

for ii =1:length(pdfName)
    
    if ~isempty(modelConf.bounds) && strcmpi(PolyType{1,ii},'arbitrary')
        % These are assumed to be computed already in the initialization of
        % PCE. They should have been computed since they are needed to
        % compute numerically the recurrence coefficients.
        PolyMarginals(ii).pdf  = pdfName{1,ii};
        PolyMarginals(ii).parameters = parameters{1,ii};
        PolyMarginals(ii).bounds = bounds{1,ii};
    else
        % For all other cases, the 'Marginals' are defined from a
        % correspondence between polynomials and marginals.
        switch lower(PolyType{1,ii})
            case 'legendre'
                PolyMarginals(ii).pdf  = 'uniform';
                param = [-1 1];
            case 'hermite'
                PolyMarginals(ii).pdf  = 'gaussian';
                param = [0 1];
            case 'laguerre'
                PolyMarginals(ii).pdf  = 'gamma';
                param = parameters{1,ii};
            case 'jacobi'
                % In the case that we have Jacobi polynomials,
                % we scale back to the [0 1] beta distribution.
                PolyMarginals(ii).pdf  = 'beta';
                param = [parameters{1,ii} 0 1];
        end
        %PolyMarginals(ii).Type = name;
        PolyMarginals(ii).parameters = param;
    end
end

% Also add the independent copula (even if it is unnecessary at this stage)
PolyCopula.Type = 'Independent';
