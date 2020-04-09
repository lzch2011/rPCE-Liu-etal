function [Psi] = basisGe(U,alpha,modelConf)

% Here we generate the PSI matrix 
%
%exits :
% Psi = size matrix (number_observation) * (dimension of the base)
% Psi (i, j) = evaluation of the jth polynomial (multi-dimensional) of the base
% for the th observation

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% corr(U,'type','Kendall')
    
% compute
M=size(alpha,1);
Psi=ones(size(U,1),size(alpha,2));

pdfs = modelConf.pdfs;
parameters = modelConf.parameters;
bounds = modelConf.bounds;

PolyType = auto_retrieve_poly_types(modelConf.pdfs, modelConf.bounds);

for ii=1:M
    if ~isempty(bounds)
        AB = poly_rec_coeffs(max(alpha(ii,:)), PolyType{1,ii}, pdfs{1,ii}, parameters{1,ii}, bounds{1,ii});
    else
        AB = poly_rec_coeffs(max(alpha(ii,:)), PolyType{1,ii}, pdfs{1,ii}, parameters{1,ii});
    end
%     save('AB_C2M','AB')
    eval = eval_rec_rule(U(:,ii),AB);
%     save(sprintf('eval_C2M%d',ii),'eval')
    uPsi = eval(:,alpha(ii,:)+1);
%     save(sprintf('uPsi_C2M%d',ii),'uPsi')
    Psi=Psi.*uPsi;
%     save(sprintf('Psi_C2M%d',ii),'Psi')
end
end



    


    