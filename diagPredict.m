
clear all;
close all;

funName = 'Ishigami';  % condidates: 'BoreHole', 'Ishigami'
nTrainData = 50;

load(sprintf('modelPCE_%s_N%d',funName,nTrainData))

y_rPCE = [];
y_LARS = [];
y_OMP = [];
y_true = [];
for iTrial = 1:length(model)
    if strcmpi(model(iTrial).rPCE.selectApproach.name,'lars')
        y_rPCE = [y_rPCE; model(iTrial).rPCE.LARS(end).Predict.YTest];
    elseif strcmpi(model(iTrial).rPCE.selectApproach.name,'omp')
        y_rPCE = [y_rPCE; model(iTrial).rPCE.OMP(end).Predict.YTest];
    elseif strcmpi(model(iTrial).rPCE.selectApproach.name,'merge')
        y_rPCE = [y_rPCE; model(iTrial).rPCE.Merge(end).Predict.YTest];
    end
    y_LARS = [y_LARS; model(iTrial).LARS.Predict.YTest];
    y_OMP = [y_OMP; model(iTrial).OMP.Predict.YTest];
    
    y_true = [y_true; model(iTrial).Data.YTest];
end

R2_rPCE = 1- sum((y_rPCE-y_true).^2)/length(y_true)/var(y_true);
R2_LARS = 1- sum((y_LARS-y_true).^2)/length(y_true)/var(y_true);
R2_OMP = 1- sum((y_OMP-y_true).^2)/length(y_true)/var(y_true);

figure('Position', [10 10 900 300])
subplot(1,3,1)
plot(y_true,y_LARS,'.','MarkerSize',6)
hold on;
plot(y_true,y_true,'lineWidth',2)
xlabel({'$y$'},'interpreter','latex')
ylabel({'$\hat{y}$'},'interpreter','latex')
set(gca,'FontUnits','points','FontSize',16,'FontName','Times')
axis equal
axis( [-20 30 -20 30])
subplot(1,3,2)
plot(y_true,y_OMP,'.','MarkerSize',6)
hold on;
plot(y_true,y_true,'lineWidth',2)
xlabel({'$y$'},'interpreter','latex')
ylabel({'$\hat{y}$'},'interpreter','latex')
set(gca,'FontUnits','points','FontSize',16,'FontName','Times')
axis equal
axis( [-20 30 -20 30])
subplot(1,3,3)
plot(y_true,y_rPCE,'.','MarkerSize',6)
hold on;
plot(y_true,y_true,'lineWidth',2)
xlabel({'$y$'},'interpreter','latex')
ylabel({'$\hat{y}$'},'interpreter','latex')
set(gca,'FontUnits','points','FontSize',16,'FontName','Times')
axis equal
axis( [-20 30 -20 30])
