function [firstOrderSobol,totalSobol] = computeFirstTotalSobol(strucSU)

nTrial = length(strucSU);
nVar = size(strucSU{1,1}.variable,2);
firstOrderSobol = zeros(nVar,nTrial);
totalSobol = zeros(nVar,nTrial);

for iTrial = 1:nTrial
    for iVar = 1:nVar
        currentVar = zeros(1,nVar);
        currentVar(iVar) = 1;
        [idEmp, idR] = ismember(currentVar, strucSU{1,iTrial}.variable, 'rows');
        if idEmp
            firstOrderSobol(iVar,iTrial) = strucSU{1,iTrial}.SU(idR);
        end
        idCol = strucSU{1,iTrial}.variable(:,iVar);
        if sum(idCol) >0
            totalSobol(iVar,iTrial) = sum(strucSU{1,iTrial}.SU(logical(idCol)));
        end
    end
end