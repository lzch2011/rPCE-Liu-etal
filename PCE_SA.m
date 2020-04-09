
function [rPCE_SU,LARS_SU,OMP_SU] = PCE_SA(model)

nTrial = length(model);

%======================================%
%   extract related quantities 
%======================================%
rPCE_Coeff = cell(1,nTrial);
rPCE_alphaIndex = cell(1,nTrial);
rPCE_alphaFull = cell(1,nTrial);
LARS_Coeff = cell(1,nTrial);
LARS_alphaFull = cell(1,nTrial);
LARS_alphaIndex = cell(1,nTrial);
OMP_Coeff = cell(1,nTrial);
OMP_alphaIndex = cell(1,nTrial);
OMP_alphaFull = cell(1,nTrial);
for iTrial = 1:nTrial
    if strcmpi(model(iTrial).rPCE.selectApproach.name,'lars')
        rPCE_Coeff{1,iTrial} = model(iTrial).rPCE.LARS(end).PCE.Coeff;
        rPCE_alphaIndex{1,iTrial} = model(iTrial).rPCE.LARS(end).PCE.alphaIndex;
        rPCE_alphaFull{1,iTrial} = model(iTrial).rPCE.LARS(end).PCE.alphaFull;
    elseif strcmpi(model(iTrial).rPCE.selectApproach.name,'omp')
        rPCE_Coeff{1,iTrial} = model(iTrial).rPCE.OMP(end).PCE.Coeff;
        rPCE_alphaIndex{1,iTrial} = model(iTrial).rPCE.OMP(end).PCE.alphaIndex;
        rPCE_alphaFull{1,iTrial} = model(iTrial).rPCE.OMP(end).PCE.alphaFull;
    elseif strcmpi(model(iTrial).rPCE.selectApproach.name,'merge')
        rPCE_Coeff{1,iTrial} = model(iTrial).rPCE.Merge(end).PCE.Coeff;
        rPCE_alphaIndex{1,iTrial} = model(iTrial).rPCE.Merge(end).PCE.alphaIndex;
        rPCE_alphaFull{1,iTrial} = model(iTrial).rPCE.Merge(end).PCE.alphaFull;
    end
    
    LARS_Coeff{1,iTrial} = model(iTrial).LARS.PCE.Coeff;
    LARS_alphaIndex{1,iTrial} = model(iTrial).LARS.PCE.alphaIndex;
    LARS_alphaFull{1,iTrial} = model(iTrial).LARS.PCE.alphaFull;
    
    OMP_Coeff{1,iTrial} = model(iTrial).OMP.PCE.Coeff;
    OMP_alphaIndex{1,iTrial} = model(iTrial).OMP.PCE.alphaIndex;
    OMP_alphaFull{1,iTrial} = model(iTrial).OMP.PCE.alphaFull;
end

%======================================%
%   Sobol's indices based on PCE 
%======================================%
rPCE_SU = cell(1,nTrial);
LARS_SU = cell(1,nTrial);
OMP_SU = cell(1,nTrial);
for iTrial = 1:nTrial
    iOMP_Coeff = OMP_Coeff{1,iTrial}(OMP_alphaIndex{1,iTrial});
    iLARS_Coeff = LARS_Coeff{1,iTrial}(LARS_alphaIndex{1,iTrial});
    irPCE_Coeff = rPCE_Coeff{1,iTrial}(rPCE_alphaIndex{1,iTrial});
    
    OMP_alpha = OMP_alphaFull{1,iTrial}(OMP_alphaIndex{1,iTrial},:);
    LARS_alpha = LARS_alphaFull{1,iTrial}(LARS_alphaIndex{1,iTrial},:);
    rPCE_alpha = rPCE_alphaFull{1,iTrial}(rPCE_alphaIndex{1,iTrial},:);
    
    % resort the alpha and coeff
    [~,idOMP]=sort(OMP_alphaIndex{1,iTrial});
    [~,idLARS]=sort(LARS_alphaIndex{1,iTrial});
    [~,idrPCE]=sort(rPCE_alphaIndex{1,iTrial});
    iOMP_Coeff = iOMP_Coeff(idOMP);
    iLARS_Coeff = iLARS_Coeff(idLARS);
    irPCE_Coeff = irPCE_Coeff(idrPCE);
    OMP_alpha= OMP_alpha(idOMP,:);
    LARS_alpha= LARS_alpha(idLARS,:);
    rPCE_alpha= rPCE_alpha(idrPCE,:);
    
    OMP_varY = sum(iOMP_Coeff(2:end).^2);
    LARS_varY = sum(iLARS_Coeff(2:end).^2);
    rPCE_varY = sum(irPCE_Coeff(2:end).^2);
    
    OMP_variable = OMP_alpha./OMP_alpha;
    OMP_variable(isnan (OMP_variable)) = 0;
    LARS_variable = LARS_alpha./LARS_alpha;
    LARS_variable(isnan (LARS_variable)) = 0;
    rPCE_variable = rPCE_alpha./rPCE_alpha;
    rPCE_variable(isnan (rPCE_variable)) = 0;
    
    [OMP_variable,IA,IC] = unique(OMP_variable(2:end,:),'rows','stable');
    iOMP_Coeff = iOMP_Coeff(2:end);
    nSU = size(OMP_variable,1);
    SU = zeros(nSU,1);
    for iSU = 1:nSU
        SU(iSU) = sum(iOMP_Coeff(IC==iSU).^2)/OMP_varY;
    end
    iOMP_SU.variable = OMP_variable;
    iOMP_SU.SU = SU;
    OMP_SU{1,iTrial} = iOMP_SU;
    
    
    [LARS_variable,IA,IC] = unique(LARS_variable(2:end,:),'rows','stable');
    iLARS_Coeff = iLARS_Coeff(2:end);
    nSU = size(LARS_variable,1);
    SU = zeros(nSU,1);
    for iSU = 1:nSU
        SU(iSU) = sum(iLARS_Coeff(IC==iSU).^2)/LARS_varY;
    end
    iLARS_SU.variable = LARS_variable;
    iLARS_SU.SU = SU;
    LARS_SU{1,iTrial} = iLARS_SU;
    
    [rPCE_variable,IA,IC] = unique(rPCE_variable(2:end,:),'rows','stable');
    irPCE_Coeff = irPCE_Coeff(2:end);
    nSU = size(rPCE_variable,1);
    SU = zeros(nSU,1);
    for iSU = 1:nSU
        SU(iSU) = sum(irPCE_Coeff(IC==iSU).^2)/rPCE_varY;
    end
    irPCE_SU.variable = rPCE_variable;
    irPCE_SU.SU = SU;
    rPCE_SU{1,iTrial} = irPCE_SU;
end



