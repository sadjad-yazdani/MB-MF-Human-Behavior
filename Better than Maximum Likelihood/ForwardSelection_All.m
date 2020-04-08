% Feature Selection By Forward Selection
clc;
clearvars;
rng('shuffle');
K=120;
DataFileName=['Data\FrwdSelectData_All_',num2str(K),'NN.mat'];
FoldNumber=5;
[Train,Test]=GetKFoldRegressorDataFromRepository(FoldNumber,true);
EliminatedFeatures=[];
% Train.Features(:,EliminatedFeatures,:)=[];
% Train.FeaturesName(EliminatedFeatures)=[];
% Test.Features(:,EliminatedFeatures,:)=[];
% Test.FeaturesName(EliminatedFeatures)=[];
ReplaceChaseFlag=true;
if exist(DataFileName,'file')
    Yes_NO = questdlg({'Cash File Exist','Replace it?'});
    if strcmp(Yes_NO,'No') || strcmp(Yes_NO,'Cancel')
        ReplaceChaseFlag=false;
    end
end
if ReplaceChaseFlag
FNum=size(Test.Features,2);
MaxFNum=29;
Features=cell(1,MaxFNum);
Erorrs=zeros(FoldNumber,Test.SNum);
Features{1}=[];
UnSelectedFeatures=1:FNum;
BestMSE=zeros(1,MaxFNum);
AnalizeErorrs=zeros(FNum,Test.SNum*Test.SetNum);
for J=1:MaxFNum
    MSE=zeros(FNum-J+1,1);
    for j=1:FNum-J+1
        display(['Analyze Feature Number ',num2str(j),' For ',num2str(J),' Features.'])
        FeaturesTemp=[Features{J},UnSelectedFeatures(j)];
        for f=1:FoldNumber
        KNNRegressor = KNNReg(Train.Features(:,FeaturesTemp,f),Train.Label(:,f),'NumNeighbors',K,'RegresiorMethod','InverseDistance');
        PredictedValue=GetRegValue(KNNRegressor,Test.Features(:,FeaturesTemp,f));
        Erorrs(f,:)=PredictedValue-Test.Label(:,f);
        end
        MSE(j)=mean2(Erorrs.^2);
    end
    [BestMSE(J),Best]=min(MSE);
    Features{J}=[Features{J},UnSelectedFeatures(Best)];
    UnSelectedFeatures(Best)=[];
    Features{J+1}=Features{J};
    for f=1:FoldNumber
        KNNRegressor = KNNReg(Train.Features(:,Features{J},f),Train.Label(:,f),'NumNeighbors',K,'RegresiorMethod','InverseDistance');
        PredictedValue=GetRegValue(KNNRegressor,Test.Features(:,Features{J},f));
        Erorrs(f,:)=PredictedValue-Test.Label(:,f);
    end
    AnalizeErorrs(J,:)=reshape(Erorrs,[],1);
end
%% All Features MSE 
for f=1:FoldNumber
KNNRegressor = KNNReg(Train.Features(:,:,f),Train.Label(:,f),'NumNeighbors',K,'RegresiorMethod','InverseDistance');
PredictedValue=GetRegValue(KNNRegressor,Test.Features(:,:,f));
Erorrs(f,:)=PredictedValue-Test.Label(:,f);
end
MSEALL=mean2(Erorrs.^2);
%%
FeaturesName=Train.FeaturesName;
save(DataFileName,'Features','BestMSE','AnalizeErorrs','MSEALL','FNum','MaxFNum','EliminatedFeatures','FeaturesName')
else
load(DataFileName)
end
%%
BasePlotFileName='Plots\FrwdSelAll_Fig';
TextSize=14;
SavePlots=0;
Selected=zeros(FNum);
for J=1:MaxFNum
    Selected(J,Features{J})=1;
end
SelectedRank=sum(Selected,1);
[Sorted,SortIndex]=sort(SelectedRank,'descend');
SortIndex(MaxFNum+1:end)=[];


figure(2);
set(gca,'FontSize',TextSize)
SortedFeaturesName=Test.FeaturesName(SortIndex);
stairs(1:MaxFNum+2,[BestMSE,MSEALL,MSEALL],'linewidth',2)
for i=1:MaxFNum
    text(i+0.5,BestMSE(i)+0.0005,SortedFeaturesName{i},'Rotation',90,'FontSize',12)
end
text(MaxFNum+1.5,MSEALL+0.0005,'All','Rotation',90,'FontSize',10)
% ylim([0.0245,0.0435])
% title({'Mean Square Error of extracted ''w''' ,'By Forward Selection (All Features Included)'})
xlabel('Number of Features');
xlim([1,MaxFNum+2])
ylabel('Mean Square Error');
set(gcf,'Position',[50,50,900,300]);

if SavePlots
FileName=[BasePlotFileName,'1_MSE'];
saveas(gcf,[FileName,'.jpg']);
end
%%
FeaturesIndex=1:39;
FeaturesIndex(EliminatedFeatures)=[];
SelectedFeatures=FeaturesIndex(SortIndex(1:10));
fprintf('SelectedFeatures = [%d',SelectedFeatures(1))
fprintf(',%d',SelectedFeatures(2:end))
fprintf(']\n')