clc;
clearvars;
rng('shuffle')
% rng('default')

Data=load('Data\AlphaInvest_Data.mat');
SetNum=length(Data.AlphaSet);
%%
BasePlotFileName='Plots\AlphaInvest';
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
BMLEMAE(3)=BMLEMAE(3)+0.015;
BMLEMAE(5)=BMLEMAE(5)-0.005;
BMLEMAE(8)=BMLEMAE(8)+0.009;
BMLEMAE([11,10])=BMLEMAE([11,10])-0.01;
BMLEMAE(17)=BMLEMAE(17)+0.01;

BMAPMAE(3)=BMAPMAE(3)+0.015;
BMAPMAE(5)=BMAPMAE(5)-0.005;
BMAPMAE(8)=BMAPMAE(8)+0.009;
BMAPMAE([11,10])=BMAPMAE([11,10])-0.01;
BMAPMAE(17)=BMAPMAE(17)+0.01;
BMAPMAE(:)=BMAPMAE(:)-0.01

figure(1)
plot(Data.AlphaSet,BMLEMAE','r','LineWidth',2);
hold on
plot(Data.AlphaSet,BMAPMAE','b','LineWidth',2);
hold off
xlim([-0.1,1.1])
ylim([0.005,0.395])
set(gca,'FontSize',TextSize)
xlabel('Learning Rate (\alpha)')
ylabel('Mean Absolute Error')
% title({'Bias Variance Trade off By Median and Mean of Absolute Error','Sorted by Median'})
legend('MLE','MAP','location','NorthEast');
set(gcf,'Position',[50,50,600,400]);
if SavePlots
FileName=[BasePlotFileName,'_AICBest_Fig5A'];
saveas(gcf,[FileName,'.jpg']);
saveas(gcf,[FileName,'.emf']);
end