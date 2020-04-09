clear all
close all

funName = 'Ishigami';  % condidates: 'BoreHole', 'Ishigami'
nTrainData = 50;

load(sprintf('modelPCE_%s_N%d',funName,nTrainData))
nTrial = length(model);

%%==============================================================%
%%          display predication results 
%%==============================================================%
R2_rPCE = zeros(nTrial,1);
Q2_rPCE = zeros(nTrial,1);
nFold = length(model(nTrial).rPCE.LARS);
R2_rPCE_LARS = zeros(nTrial,nFold);
R2_rPCE_OMP = zeros(nTrial,nFold);
R2_rPCE_Merge = zeros(nTrial,nFold);
R2_LARS = zeros(nTrial,1);
R2_OMP = zeros(nTrial,1);
Q2_LARS = zeros(nTrial,1);
Q2_OMP = zeros(nTrial,1);

idSort = [];
for iTrial = 1:nTrial
    if strcmpi(model(iTrial).rPCE.selectApproach.name,'lars')
        R2_rPCE(iTrial) = model(iTrial).rPCE.LARS(end).Predict.R2;
        Q2_rPCE(iTrial) = model(iTrial).rPCE.LARS(end).PCE.Q2;
    elseif strcmpi(model(iTrial).rPCE.selectApproach.name,'omp')
        R2_rPCE(iTrial) = model(iTrial).rPCE.OMP(end).Predict.R2;
        Q2_rPCE(iTrial) = model(iTrial).rPCE.OMP(end).PCE.Q2;
    elseif strcmpi(model(iTrial).rPCE.selectApproach.name,'merge')
        R2_rPCE(iTrial) = model(iTrial).rPCE.Merge(end).Predict.R2;
        Q2_rPCE(iTrial) = model(iTrial).rPCE.Merge(end).PCE.Q2;
    end
    
    R2_LARS(iTrial) = model(iTrial).LARS.Predict.R2;
    R2_OMP(iTrial) = model(iTrial).OMP.Predict.R2;
    Q2_LARS(iTrial) = model(iTrial).LARS.PCE.Q2;
    Q2_OMP(iTrial) = model(iTrial).LARS.PCE.Q2;
    for iFold = 1:nFold
        R2_rPCE_LARS(iTrial,iFold) = model(iTrial).rPCE.LARS(iFold).Predict.R2;
        R2_rPCE_OMP(iTrial,iFold) = model(iTrial).rPCE.OMP(iFold).Predict.R2;
        R2_rPCE_Merge(iTrial,iFold) = model(iTrial).rPCE.Merge(iFold).Predict.R2;
    end
end
%============================================%
%   Boxplot of R2 of original data with different resampling schemes and
%   model-selection approaches
%============================================%
nFold = size(R2_rPCE_LARS,2);
combineY = [R2_LARS; R2_OMP; R2_rPCE_LARS(:); R2_rPCE_OMP(:); R2_rPCE_Merge(:)];
catInd = kron((1:(3*nFold+2))', ones(length(R2_LARS),1));
matrixPos = [(2:(1+nFold))-0.25,2:(1+nFold),(2:(1+nFold))+0.25];
positions = [1-0.125, 1+0.125 matrixPos];

figure
boxplot(combineY,catInd, 'positions', positions)
ylabel('R^2','FontSize', 14)
set(gca,'xtick',[(positions(1)+positions(2))/2 matrixPos((nFold+1):(2*nFold))])

if nFold == 4
    set(gca,'xticklabel',{'k=1','k=3','k=5','k=N','k=M'}, 'FontSize', 14)
elseif nFold == 5
    set(gca,'xticklabel',{'k=1','k=3','k=5','k=10','k=N','k=M'}, 'FontSize', 14)
else 
    set(gca,'xticklabel',{'k=1','k=3','k=5','k=10','k=20','k=N','k=M'}, 'FontSize', 14)
end

matrixCol = repmat(['c', 'y', 'r'],nFold,1)';
color = [(matrixCol(:))','y', 'r' ];
h = findobj(gca,'Tag','Box');
for j=1:length(h)
   patch(get(h(j),'XData'),get(h(j),'YData'),color(j),'FaceAlpha',.5);
end
c = get(gca, 'Children');
leg = legend(c(3:5), 'LARS','OMP','LARS+OMP' ,'FontSize','14');
set(gcf, 'OuterPosition', [1 1 725 500]);

%============================================%
%   mean value of R2 of original data with different resampling schemes and
%   model-selection approaches
%============================================%
fprintf('The mean value of R2 of rPCE with various configurations\n')
fprintf(' LARS     OMP    Mix\n')
fprintf('%.4f  %.4f  %.4f\n',[mean(R2_rPCE_LARS).',mean(R2_rPCE_OMP).',mean(R2_rPCE_Merge).'].')

fprintf('The mean value of R2 equals\n')
fprintf('LARS        OMP             RPCE\n')
fprintf('%.4f       %.4f          %.4f\n',mean(R2_LARS),mean(R2_OMP),mean(R2_rPCE))
fprintf('The mean value of Q2 equals\n')
fprintf('LARS        OMP             RPCE\n')
fprintf('%.4f       %.4f          %.4f\n',mean(Q2_LARS),mean(Q2_OMP),mean(Q2_rPCE))