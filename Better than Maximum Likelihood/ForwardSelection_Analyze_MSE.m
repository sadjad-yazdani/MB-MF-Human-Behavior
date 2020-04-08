% Feature Selection By Forward Selection
clc;
clearvars;
ALLDataFileName='Data\FrwdSelectData_All_100NN.mat';
FitDataFileName='Data\FrwdSelectData_FitExc_100NN.mat';
All=load(ALLDataFileName);
Fit=load(FitDataFileName);

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
FitSelectNum=14;
FeaturesIndex=1:39;
SelectedFeatures=FeaturesIndex(AllSortIndex(1:AllSelectNum));
fprintf('Selected Features for ALL= [%d',SelectedFeatures(1))
fprintf(',%d',SelectedFeatures(2:end))
fprintf(']\n')
FeaturesIndex=1:39;
FeaturesIndex(Fit.EliminatedFeatures)=[];
SelectedFeatures=FeaturesIndex(FitSortIndex(1:FitSelectNum));
fprintf('Selected Features for Fit= [%d',SelectedFeatures(1))
fprintf(',%d',SelectedFeatures(2:end))
fprintf(']\n')
%%
fprintf('Imporovment for All = %f\n',All.MSEALL-All.BestMSE(AllSelectNum))
fprintf('Imporovment for Fit = %f\n',Fit.MSEALL-Fit.BestMSE(FitSelectNum))
fprintf('Imporovment Percentage for All = %f%%\n',(All.MSEALL-All.BestMSE(AllSelectNum))/All.MSEALL*100)
fprintf('Imporovment Percentage for Fit = %f%%\n',(Fit.MSEALL-Fit.BestMSE(FitSelectNum))/Fit.MSEALL*100)
fprintf('All) Min Imporove = %f Last IMprove = %f  NextImporove = %f\n',max(diff(All.BestMSE(1:AllSelectNum))),All.BestMSE(AllSelectNum)-All.BestMSE(AllSelectNum-1),All.BestMSE(AllSelectNum)-All.BestMSE(AllSelectNum+1))
fprintf('Fit) Min Imporove = %f Last IMprove = %f  NextImporove = %f\n',max(diff(Fit.BestMSE(1:FitSelectNum))),Fit.BestMSE(FitSelectNum)-Fit.BestMSE(FitSelectNum-1),Fit.BestMSE(FitSelectNum)-Fit.BestMSE(FitSelectNum+1))

fprintf('Last Imporovment Percentage for All = %f%% -> %f%%\n',(All.BestMSE(AllSelectNum-1)-All.BestMSE(AllSelectNum))/All.BestMSE(AllSelectNum)*100,(All.BestMSE(AllSelectNum+1)-All.BestMSE(AllSelectNum))/All.BestMSE(AllSelectNum)*100)
fprintf('Last Imporovment Percentage for Fit = %f%% -> %f%%\n',(Fit.BestMSE(FitSelectNum-1)-Fit.BestMSE(FitSelectNum))/Fit.BestMSE(FitSelectNum)*100,(Fit.BestMSE(FitSelectNum+1)-Fit.BestMSE(FitSelectNum))/Fit.BestMSE(FitSelectNum)*100)
%% Plot OPtion
BasePlotFileName='Plots\FrwdSel_Fig';
TextSize=14;
InFigsTextSize=12;
SavePlots=0;
%% Plot
figure(1);
subplot(2,1,1)
AllSortedFeaturesName=All.FeaturesName(AllSortIndex);
stairs(1:MaxFNum+2 ,[All.BestMSE(1:MaxFNum),All.MSEALL,All.MSEALL],'linewidth',2)
hold on
stairs(1:AllSelectNum+1,All.BestMSE(1:AllSelectNum+1),'r','linewidth',2)
hold off
for i=1:MaxFNum
    text(i+0.5,All.BestMSE(i)+0.002,AllSortedFeaturesName{i},'Rotation',90,'FontSize',InFigsTextSize)
end
text(MaxFNum+1.5,All.MSEALL+0.005,'All Features','Rotation',90,'FontSize',InFigsTextSize)
text(-1.7,0.1,'A)','FontSize',TextSize,'FontWeight','Bold')
% ylim([0.1,0.16])
xlim([0.5,MaxFNum+2.5])
set(gca,'FontSize',TextSize)

subplot(2,1,2)
FitSortedFeaturesName=Fit.FeaturesName(FitSortIndex);
stairs(1:MaxFNum+2,[Fit.BestMSE(1:MaxFNum),Fit.MSEALL,Fit.MSEALL],'linewidth',2)
hold on
stairs(1:FitSelectNum+1,Fit.BestMSE(1:FitSelectNum+1),'r','linewidth',2)
hold off
for i=1:MaxFNum
    text(i+0.5,Fit.BestMSE(i)+0.002-(0.027*(i==1))-(0.035*(i==2)),FitSortedFeaturesName{i},'Rotation',90,'FontSize',InFigsTextSize)
end
text(MaxFNum+1.5,Fit.MSEALL+0.005,'All No Fitting','Rotation',90,'FontSize',InFigsTextSize)
text(-1.7,0.15,'B)','FontSize',TextSize,'FontWeight','Bold')
% ylim([0.14,0.25])
xlim([0.5,MaxFNum+2.5])
set(gca,'FontSize',TextSize)

% title({'Mean Square Error of extracted ''w''' ,'By Forward Selection (All Features Included)'})

xlabel('Number of Features');
set(gcf,'Position',[50,50,700,600]);
if SavePlots
FileName=[BasePlotFileName,'1']; %#ok<UNRCH>
saveas(gcf,[FileName,'.jpg']);
end
