clear all
close all

funName = 'Ishigami';  % condidates: 'BoreHole', 'Ishigami'
nTrainData = 50;
load(sprintf('modelPCE_%s_N%d',funName,nTrainData))

[struc_rPCE_SU,struc_LARS_SU,struc_OMP_SU] = PCE_SA(model);

[ref_SU,ref_variable] = compuRefSobol_IshigamiFun(7,0.1);

nD = length(ref_SU);
nTrial = length(struc_LARS_SU);
LARS_SU = zeros(nTrial,nD);
OMP_SU = zeros(nTrial,nD);
rPCE_SU = zeros(nTrial,nD);
for iTrial = 1:nTrial
    ivariable = struc_LARS_SU{1,iTrial}.variable;
    [~,index_A,index_B] = intersect(ref_variable,ivariable,'rows');
    LARS_SU(iTrial,index_A) = struc_LARS_SU{1,iTrial}.SU(index_B);
    
    ivariable = struc_OMP_SU{1,iTrial}.variable;
    [~,index_A,index_B] = intersect(ref_variable,ivariable,'rows');
    OMP_SU(iTrial,index_A) = struc_OMP_SU{1,iTrial}.SU(index_B);
    
    ivariable = struc_rPCE_SU{1,iTrial}.variable;
    [~,index_A,index_B] = intersect(ref_variable,ivariable,'rows');
    rPCE_SU(iTrial,index_A) = struc_rPCE_SU{1,iTrial}.SU(index_B);
end

combineY = [LARS_SU-repmat(ref_SU.',nTrial,1),OMP_SU-repmat(ref_SU.',nTrial,1),rPCE_SU-repmat(ref_SU.',nTrial,1)];
catInd = kron((1:(3*nD))', ones(nTrial,1));
matrixPos = [(1:nD)-0.25,1:nD,(1:nD)+0.25];
positions = matrixPos;

figure('Units','inches','Position',[0 0 8 3.5],...
'PaperPositionMode','auto');

boxplot(combineY,catInd, 'positions', positions) 
set(gca,'xtick',matrixPos((nD+1):(2*nD)),'FontSize', 10)
set(gca,'FontUnits','points','FontSize',10,'FontName','Times')
set(gca,'TickLabelInterpreter', 'latex');
set(gca,'xticklabel',{'$\triangle S_1$','$\triangle S_{2}$','$\triangle S_{3}$','$\triangle S_{1,2}$','$\triangle S_{2,3}$','$\triangle S_{1,3}$','$\triangle S_{1,2,3}$'}, 'FontSize', 10)

matrixCol = repmat(['c', 'y', 'r'],nD,1)';
color = matrixCol;
h = findobj(gca,'Tag','Box');
for j=1:length(h)
   patch(get(h(j),'XData'),get(h(j),'YData'),color(j),'FaceAlpha',.5);
end
c = get(gca, 'Children');
leg = legend(c(1:3), 'LARS','OMP','rPCE' ,'FontSize','14');


fprintf('The mean value of Sobol indices\n')
fprintf('Ref     rPCE    LARS    OMP\n')
fprintf('%.4f  %.4f  %.4f %.4f\n',[ref_SU,mean(rPCE_SU).',mean(LARS_SU).',mean(OMP_SU).'].')