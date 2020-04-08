% Feature Selection By Forward Selection
clc;
clearvars;
FrwdSelectDataFileName='Data\FrwdSelectData_ByMAE_All_68NN.mat';
FitDataFileName='Data\FrwdSelectData_ByMAE_FitExc_68NN.mat';
FindKDataFileName='Data\FindKData_All.mat';
All=load(FrwdSelectDataFileName);
Fit=load(FitDataFileName);
K=load(FindKDataFileName);

MaxFNum=20;%All.MaxFNum;
FNum=All.FNum;
%% Extract Datas
Selected=zeros(FNum);
for J=1:MaxFNum
    Selected(J,All.Features{J})=1;
end
SelectedRank=sum(Selected,1);
[~,AllSortIndex]=sort(SelectedRank,'descend');
AllSortIndex(All.MaxFNum+1:end)=[];

Selected=zeros(FNum);
for J=1:MaxFNum
    Selected(J,Fit.Features{J})=1;
end
SelectedRank=sum(Selected,1);
[~,FitSortIndex]=sort(SelectedRank,'descend');
FitSortIndex(Fit.MaxFNum+1:end)=[];
%% Display Best Features Index
AllSelectNum=16;
FitSelectNum=16;
FeaturesIndex=1:39;
SelectedFeaturesAll=FeaturesIndex(AllSortIndex(1:AllSelectNum));
fprintf('Selected Features for ALL= [%d',SelectedFeaturesAll(1))
fprintf(',%d',SelectedFeaturesAll(2:end))
fprintf(']\n')
FeaturesIndex=1:39;
FeaturesIndex(Fit.EliminatedFeatures)=[];
SelectedFeaturesFit=FeaturesIndex(FitSortIndex(1:FitSelectNum));
fprintf('Selected Features for Fit= [%d',SelectedFeaturesFit(1))
fprintf(',%d',SelectedFeaturesFit(2:end))
fprintf(']\n')
%%
fprintf('Imporovment for All = %f\n',All.MAEALL-All.BestMAE(AllSelectNum))
fprintf('Imporovment for Fit = %f\n',Fit.MAEALL-Fit.BestMAE(FitSelectNum))
fprintf('Imporovment Percentage for All = %f%%\n',(All.MAEALL-All.BestMAE(AllSelectNum))/All.MAEALL*100)
fprintf('Imporovment Percentage for Fit = %f%%\n',(Fit.MAEALL-Fit.BestMAE(FitSelectNum))/Fit.MAEALL*100)
fprintf('All) Min Imporove = %f ,Last IMprove = %f  ,Next Imporove = %f\n',-max(diff(All.BestMAE(1:AllSelectNum))),All.BestMAE(AllSelectNum-1)-All.BestMAE(AllSelectNum),All.BestMAE(AllSelectNum)-All.BestMAE(AllSelectNum+1))
fprintf('Fit) Min Imporove = %f ,Last IMprove = %f  ,Next Imporove = %f\n',-max(diff(Fit.BestMAE(1:FitSelectNum))),Fit.BestMAE(FitSelectNum-1)-Fit.BestMAE(FitSelectNum),Fit.BestMAE(FitSelectNum)-Fit.BestMAE(FitSelectNum+1))

fprintf('Last Imporovment Percentage for All = %f%% -> %f%%\n',(All.BestMAE(AllSelectNum-1)-All.BestMAE(AllSelectNum))/All.BestMAE(AllSelectNum)*100,(All.BestMAE(AllSelectNum+1)-All.BestMAE(AllSelectNum))/All.BestMAE(AllSelectNum)*100)
fprintf('Last Imporovment Percentage for Fit = %f%% -> %f%%\n',(Fit.BestMAE(FitSelectNum-1)-Fit.BestMAE(FitSelectNum))/Fit.BestMAE(FitSelectNum)*100,(Fit.BestMAE(FitSelectNum+1)-Fit.BestMAE(FitSelectNum))/Fit.BestMAE(FitSelectNum)*100)

display(All.FeaturesName(SelectedFeaturesAll))
display(All.FeaturesName(SelectedFeaturesFit))
%% Plot OPtion
BasePlotFileName='Plots\Fig6_';
TextSize=12;
InFigsTextSize=10;
SavePlots=1;
%% Plot
figure(1);
subplot(4,3,[4,7])
% subplot(2,3,1)
% MaxKIndex=length(K.KArray)-1;
MaxKIndex=32;
MeanMAE=mean(K.MAE(:,1:MaxKIndex),1);
plot(K.KArray(1:MaxKIndex),MeanMAE,'linewidth',2)
set(gca,'FontSize',TextSize)
% errorbar(KArray,mean(MSE,1),mean(STD,1))
xlim([K.KArray(1),K.KArray(MaxKIndex+1)])
xlabel('\it k');
ylabel('Mean Absolute Error');
% ylim([0.148,0.23])
% title({'Mean Absolute Error of extracted ''w''' ,'By KNN Regression','all features included'})
[MinMeanMAE,Index]=min(MeanMAE);
hold on
plot([K.KArray(Index);K.KArray(Index)*0.8],[MinMeanMAE;MinMeanMAE*1.1],':k','linewidth',2)
text(K.KArray(Index)*0.8,MinMeanMAE*1.2,{['      ','\it k',' = ',num2str(K.KArray(Index))],['MAE = ',num2str(MinMeanMAE,'%0.4f')]},'FontSize',14,'horizontalalignment','center')
hold off

% set(gca,'XTick',1:2:15)
text(-3,0.3,'A)','FontSize',TextSize,'FontWeight','Bold')

% subplot(2,3,4)
% MeanMAE=mean(K.MAE(:,1:MaxKIndex),1);
% plot(K.KArray(1:MaxKIndex),MeanMAE,'linewidth',2)
% set(gca,'FontSize',TextSize)
% % errorbar(KArray,mean(MSE,1),mean(STD,1))
% xlim([K.KArray(1),K.KArray(MaxKIndex+1)])
% ylim([MinMeanMAE-1e-4,MinMeanMAE+1e-3])
% xlabel('K');
% ylabel('Mean Absolute Error');
% 
% 
% set(gca,'XTick',20:20:140)
% text(-40,0.1113,'B)','FontSize',TextSize,'FontWeight','Bold')


set(gca,'FontSize',TextSize)
subplot(4,3,[2,3,5,6])
% subplot(2,3,[2,3])
AllSortedFeaturesName=All.FeaturesName(AllSortIndex);
stairs(1:MaxFNum+2 ,[All.BestMAE(1:MaxFNum),All.MAEALL,All.MAEALL],'linewidth',2)
hold on
stairs(1:AllSelectNum+1,All.BestMAE(1:AllSelectNum+1),'r','linewidth',2)
hold off
for i=1:MaxFNum
    text(i+0.5,All.BestMAE(i)+0.001-(0.011*(i==1)),AllSortedFeaturesName{i},'Rotation',90,'FontSize',InFigsTextSize)
end
text(MaxFNum+1.5,All.MAEALL+0.001,'All Features','Rotation',90,'FontSize',InFigsTextSize)
text(-2.1,0.235,'B)','FontSize',TextSize,'FontWeight','Bold')
% ylim([0.07,0.09])
ylim([0.18,0.23])
% set(gca,'YTick',0.07:0.005:0.09)
% set(gca,'YTickLabel',70:5:90)
% text(0,0.092,'x10^-^3','FontSize',TextSize)
xlim([0.5,MaxFNum+2.5])
ylabel('Mean Absolute Error');
set(gca,'FontSize',TextSize)

subplot(4,3,[8,9,11,12])
% subplot(2,3,[5,6])
FitSortedFeaturesName=Fit.FeaturesName(FitSortIndex);
stairs(1:MaxFNum+2,[Fit.BestMAE(1:MaxFNum),Fit.MAEALL,Fit.MAEALL],'linewidth',2)
hold on
stairs(1:FitSelectNum+1,Fit.BestMAE(1:FitSelectNum+1),'r','linewidth',2)
hold off
for i=1:MaxFNum
    text(i+0.5,Fit.BestMAE(i)+0.001-(0.008*(i==1)),FitSortedFeaturesName{i},'Rotation',90,'FontSize',InFigsTextSize)
end
text(MaxFNum+1.5,Fit.MAEALL+0.001,'All No Fitting','Rotation',90,'FontSize',InFigsTextSize)
text(-2.1,0.237,'C)','FontSize',TextSize,'FontWeight','Bold')

ylim([0.21,0.236])
set(gca,'YTick',0.21:0.01:0.23)
% ylim([0.083,0.102])
% set(gca,'YTick',0.08:0.005:0.1)
% set(gca,'YTickLabel',80:5:100)
% text(0,0.103,'x10^-^3','FontSize',TextSize)
xlim([0.5,MaxFNum+2.5])
set(gca,'FontSize',TextSize)

ylabel('Mean Absolute Error');
% text(-3.5,0.245,'Mean Absolute Error','FontSize',TextSize+1,'FontWeight','normal','Rotation',90,'HorizontalAlignment','center')
xlabel('Number of Features');
set(gcf,'Position',[50,50,950,600]);
if SavePlots
FileName=[BasePlotFileName,'1'];
saveas(gcf,[FileName,'.jpg']);
saveas(gcf,[FileName,'.emf']);
end
