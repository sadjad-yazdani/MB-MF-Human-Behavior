% Find K for KNN Regresion Codes By Kfold Strategy for including all
% features 
clc;
clearvars;
rng('shuffle');
DataFileName='Data\FindKData_All_Run3.mat';
ReplaceChaseFlag=true;
if exist(DataFileName,'file')
    Yes_NO = questdlg({'Cash File Exist','Replace it?'});
    if strcmp(Yes_NO,'No') || strcmp(Yes_NO,'Cancel')
        ReplaceChaseFlag=false;
    end
end
if ReplaceChaseFlag
% KArray=1:45;
KArray=[1,2,3,5,7,10:5:65,66:75,80:5:150];
AllFeaturesIndex={1:39 % ALL
                  1:29};% No Fitting
FeaturesIndex=AllFeaturesIndex{1};% ALL 
Episod = 10;
[Train,Test]=GetKFoldRegressorDataFromRepository(Episod,true);
STD = zeros(Episod,length(KArray));
MSE = zeros(Episod,length(KArray));
MAE = zeros(Episod,length(KArray));
Errors = zeros(Episod,length(KArray),Test.SNum);
tic
for E=1:Episod
    EpisodError=zeros(length(KArray),Test.SNum);
for i=1:length(KArray)
    K=KArray(i);
    fprintf(['Analyze K of KNN ',num2str(i),' of ',num2str(length(KArray)),' K = ',num2str(K),' Episod ',num2str(E),' of ',num2str(Episod),'.\n'])
    KNNRegressor = KNNReg(Train.Features(:,FeaturesIndex,E),Train.Label(:,E),'NumNeighbors',K,'RegresiorMethod','InverseDistance'); %#ok<*PFBNS>
    PredictedValue=GetRegValue(KNNRegressor,Test.Features(:,FeaturesIndex,E));
    EpisodError(i,:)=(PredictedValue-Test.Label(:,E))';
end
Errors(E,:,:)=EpisodError;
t=toc;
fprintf(['Elapsed time is ',num2str(t,'%1.0f'),' seconds.\n']);
fprintf(['Remind time is ',num2str(t/E*Episod-t,'%1.0f'),' seconds.\n']);
end
for E=1:Episod
    for i=1:length(KArray)
        STD(E,i)=std(Errors(E,i,:));
        MSE(E,i)=mean(Errors(E,i,:).^2);
        MAE(E,i)=mean(abs(Errors(E,i,:)));
    end
end
save(DataFileName,'Errors','STD','MSE','MAE','KArray','FeaturesIndex');
else
load(DataFileName);
end
%%
MeanMAE=mean(MAE,1);
BasePlotFileName='Plots\FindK_Fig';
TextSize=14;
SavePlots=0;
figure(1)
plot(KArray,MeanMAE,'linewidth',2)
set(gca,'FontSize',TextSize)
% errorbar(KArray,mean(MSE,1),mean(STD,1))
xlim([KArray(1),KArray(end)])
xlabel('K');
ylabel('Mean Absolute Error');
% ylim([0.148,0.23])
% title({'Mean Absolute Error of extracted ''w''' ,'By KNN Regression','all features included'})
[MinMeanMAE,Index]=min(MeanMAE);
hold on
plot([KArray(Index);KArray(Index)*0.8],[MinMeanMAE;MinMeanMAE*1.1],':k','linewidth',2)
text(KArray(Index)*0.8,MinMeanMAE*1.2,{['      K = ',num2str(KArray(Index))],['MAE = ',num2str(MinMeanMAE,'%0.4f')]},'FontSize',14,'horizontalalignment','center')
hold off
% set(gcf,'Position',[50,50,800,500]);
if SavePlots
FileName=[BasePlotFileName,'1_AllFeatures'];
saveas(gcf,[FileName,'.jpg']);
end
