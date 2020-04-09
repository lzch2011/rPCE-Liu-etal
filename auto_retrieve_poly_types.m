function PolyType = auto_retrieve_poly_types(pdf, bounds)
% POLY_TYPES = UQ_AUTO_RETRIEVE_POLY_TYPES(INPUT_MODULE): simple script to
%     retrieve the default orthogonal polynomials based on the specified
%     INPUT_MODULE.
%
% See also: UQ_POLY_MARGINALS,UQ_PCE_INITIALIZE

%% consistency checks and initializations



%% creating the array of poly_types
PolyType = cell(1,length(pdf));
for ii = 1:length(pdf)
    % Default to arbitrary for bounded variables
    defPolyType = 0; 
    if ~isempty(bounds)
        if ~isempty(bounds{1,ii})  && ~strcmpi(pdf{1,ii},'uniform')
            PolyType{ii} = 'Arbitrary';
            defPolyType = 1;
        end
    end
    
    if defPolyType == 0
        switch lower(char(pdf{1,ii}))
            case {'gaussian'}
                PolyType{ii} = 'Hermite';
            case {'normal'}
                PolyType{ii} = 'Hermite';
            case {'lognormal'}
                PolyType{ii} = 'Hermite';
            case {'uniform'}
                PolyType{ii} = 'Legendre';
            case {'beta'}
                PolyType{ii} = 'Jacobi';
            case {'gamma'}
                PolyType{ii} = 'Laguerre';
            case {'constant'}
                % Added for consistent treatment of 'Constant'
                PolyType{ii} = 'Zero';
            otherwise % default to Hermite polynomials
                PolyType{ii} = 'Hermite';
        end
    end
end
end
    
