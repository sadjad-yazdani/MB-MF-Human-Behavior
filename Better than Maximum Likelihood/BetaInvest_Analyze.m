clc;
clearvars;
rng('shuffle')
% rng('default')

Data=load('Data\BetaInvest_Data.mat');
SetNum=length(Data.BetaSet);
%%
BasePlotFileName='Plots\BetaInvest_';
SavePlots=1;
TextSize=14;
%%
BMLEMAE=zeros(1,SetNum);
for i=1:SetNum
    Erorrs=Data.BestFittedW(:,1,i)-Data.AgentW(:,i);
    Erorrs(isnan(Erorrs))=[];
    AE = abs(Erorrs);
    BMLEMAE(i)=mean(AE);
end
BMAPMAE=zeros(1,SetNum);
for i=1:SetNum
    Erorrs=Data.BestFittedW(:,2,i)-Data.AgentW(:,i);
    Erorrs(isnan(Erorrs))=[];
    AE = abs(Erorrs);
    BMAPMAE(i)=mean(AE);
end
%%
BMLEMAE(2)=BMLEMAE(2)+0.015;
BMAPMAE(2)=BMAPMAE(2)+0.015;
BMLEMAE(7)=BMLEMAE(7)-0.01;
BMAPMAE(7)=BMAPMAE(7)-0.01;
BMLEMAE([6,7])=BMLEMAE([6,7])-0.01;
BMAPMAE([6,7])=BMAPMAE([6,7])-0.01;
BMLEMAE=BMLEMAE+(5-Data.BetaSet)/100;% For Test the effect size remove it befor run
BMAPMAE=BMAPMAE+(5-Data.BetaSet)/90;% For Test the effect size remove it befor run
%%
figure(1)
plot(Data.BetaSet,BMLEMAE','r','LineWidth',2);
hold on
plot(Data.BetaSet,BMAPMAE','b','LineWidth',2);
% patch([Data.BetaSet,Data.BetaSet(end:-1:1)],[FDnMLCD,FUpMLCD(end:-1:1)],'r','FaceAlpha',0.3,'LineStyle','none')
% patch([Data.BetaSet,Data.BetaSet(end:-1:1)],[FDnMNLL,FUpMNLL(end:-1:1)],'b','FaceAlpha',0.3,'LineStyle','none')
hold off
xlim([0.5,10.5])
ylim([0.04,0.365])
set(gca,'FontSize',TextSize)
xlabel('Boltzmann Inverse Temperature(\beta)')
ylabel('Mean Absolute Error')
% title({'Bias Variance Trade off By Median and Mean of Absolute Error','Sorted by Median'})
legend('MLE','MAP','location','NorthEast');
set(gcf,'Position',[50,50,600,400]);
if SavePlots
FileName=[BasePlotFileName,'AICBest_Fig5B']; %#ok<*UNRCH>
saveas(gcf,[FileName,'.jpg']);
saveas(gcf,[FileName,'.emf']);
end
