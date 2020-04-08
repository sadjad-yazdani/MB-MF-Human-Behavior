% Feature Selection By Forward Selection
clc;
clearvars;
ALLDataFileName='Data\FrwdSelectData_ByMAE_All_100NN.mat';
FitDataFileName='Data\FrwdSelectData_ByMAE_FitExc_100NN.mat';
All=load(ALLDataFileName);
Fit=load(FitDataFileName);

MaxFNum=25;%All.MaxFNum;
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
AllSelectNum=12;
FitSelectNum=12;
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
fprintf('Imporovment for All = %f\n',All.MAEALL-All.BestMAE(AllSelectNum))
fprintf('Imporovment for Fit = %f\n',Fit.MAEALL-Fit.BestMAE(FitSelectNum))
fprintf('Imporovment Percentage for All = %f%%\n',(All.MAEALL-All.BestMAE(AllSelectNum))/All.MAEALL*100)
fprintf('Imporovment Percentage for Fit = %f%%\n',(Fit.MAEALL-Fit.BestMAE(FitSelectNum))/Fit.MAEALL*100)
fprintf('All) Min Imporove = %f ,Last IMprove = %f  ,Next Imporove = %f\n',-max(diff(All.BestMAE(1:AllSelectNum))),All.BestMAE(AllSelectNum-1)-All.BestMAE(AllSelectNum),All.BestMAE(AllSelectNum)-All.BestMAE(AllSelectNum+1))
fprintf('Fit) Min Imporove = %f ,Last IMprove = %f  ,Next Imporove = %f\n',-max(diff(Fit.BestMAE(1:FitSelectNum))),Fit.BestMAE(FitSelectNum-1)-Fit.BestMAE(FitSelectNum),Fit.BestMAE(FitSelectNum)-Fit.BestMAE(FitSelectNum+1))

fprintf('Last Imporovment Percentage for All = %f%% -> %f%%\n',(All.BestMAE(AllSelectNum-1)-All.BestMAE(AllSelectNum))/All.BestMAE(AllSelectNum)*100,(All.BestMAE(AllSelectNum+1)-All.BestMAE(AllSelectNum))/All.BestMAE(AllSelectNum)*100)
fprintf('Last Imporovment Percentage for Fit = %f%% -> %f%%\n',(Fit.BestMAE(FitSelectNum-1)-Fit.BestMAE(FitSelectNum))/Fit.BestMAE(FitSelectNum)*100,(Fit.BestMAE(FitSelectNum+1)-Fit.BestMAE(FitSelectNum))/Fit.BestMAE(FitSelectNum)*100)
%% Plot OPtion
BasePlotFileName='Plots\FrwdSel_Fig';
TextSize=14;
InFigsTextSize=12;
SavePlots=0;
%% Plot
figure(1);
subplot(2,1,1)
AllSortedFeaturesName=All.FeaturesName(AllSortIndex);
stairs(1:MaxFNum+2 ,[All.BestMAE(1:MaxFNum),All.MAEALL,All.MAEALL],'linewidth',2)
hold on
stairs(1:AllSelectNum+1,All.BestMAE(1:AllSelectNum+1),'r','linewidth',2)
hold off
for i=1:MaxFNum
    text(i+0.5,All.BestMAE(i)+0.002,AllSortedFeaturesName{i},'Rotation',90,'FontSize',InFigsTextSize)
end
text(MaxFNum+1.5,All.MAEALL+0.005,'All Features','Rotation',90,'FontSize',InFigsTextSize)
text(-2.5,0.187,'A)','FontSize',TextSize,'FontWeight','Bold')
ylim([0.145,0.185])
xlim([0.5,MaxFNum+2.5])
set(gca,'FontSize',TextSize)

subplot(2,1,2)
FitSortedFeaturesName=Fit.FeaturesName(FitSortIndex);
stairs(1:MaxFNum+2,[Fit.BestMAE(1:MaxFNum),Fit.MAEALL,Fit.MAEALL],'linewidth',2)
hold on
stairs(1:FitSelectNum+1,Fit.BestMAE(1:FitSelectNum+1),'r','linewidth',2)
hold off
for i=1:MaxFNum
    text(i+0.5,Fit.BestMAE(i)+0.002-(0.017*(i==1))-(0.009*(i==2)),FitSortedFeaturesName{i},'Rotation',90,'FontSize',InFigsTextSize)
end
text(MaxFNum+1.5,Fit.MAEALL+0.005,'All No Fitting','Rotation',90,'FontSize',InFigsTextSize)
text(-2.5,0.245,'B)','FontSize',TextSize,'FontWeight','Bold')
ylim([0.211,0.24])
xlim([0.5,MaxFNum+2.5])
set(gca,'FontSize',TextSize)

% ylabel('Mean Absolute Error');
text(-3.5,0.245,'Mean Absolute Error','FontSize',TextSize+1,'FontWeight','normal','Rotation',90,'HorizontalAlignment','center')
xlabel('Number of Features');
set(gcf,'Position',[50,50,950,600]);
if SavePlots
FileName=[BasePlotFileName,'1']; %#ok<UNRCH>
saveas(gcf,[FileName,'.jpg']);
end
