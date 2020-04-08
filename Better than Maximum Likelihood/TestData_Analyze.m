clc;
clearvars;
rng('shuffle')
% rng('default')
TempDataFile='Data\TestAnalizeTempFile.mat';
Fitter={'MLE','MAP'};
% KNNMethodes={'KNN'};
FeaturesIndex={ 1:39 %All Features Included
%                 1:29         % No Fitting Features
                [37,28,8 ,30,29,38,3 ,16,31,32,2 ,12,9 ,11,19,6 ];  % Subset1 FrwSlc All
                [11,28,29,14,19,7 ,2 ,4 ,3 ,10,8 ,5 ,9 ,12,6 ,21]}; % Subset3 FrwSlc FitExc
KNNMethodes={'\itk-nn (\wp)',...             'KNN ExcFit',...
             '\itk-nn (\wp_s_u_b_1)',...
             '\itk-nn (\wp_s_u_b_2)'};
KNNMethodNum=length(KNNMethodes);
ReplaceChaseFlag=true;
if exist(TempDataFile,'file')
    Yes_NO = questdlg({'Cash File Exist','Replace it?'});
    if strcmp(Yes_NO,'No') || strcmp(Yes_NO,'Cancel')
        ReplaceChaseFlag=false;
    end
end
if ReplaceChaseFlag
K=68;
[Train,Test]=GetNoisyDataFromRepository(true);
PredictedValue=zeros(Test.SNum,Test.SetNum,KNNMethodNum);
for k=1:KNNMethodNum
    KNNRegressor = KNNReg(Train.Features(:,FeaturesIndex{k}),Train.Label,'NumNeighbors',K,'RegresiorMethod','InverseDistance');
    for s=1:Test.SetNum
        display(['Analyze Feature for Set # ',num2str(s),' of ',num2str(Test.SetNum),' .',KNNMethodes{k}])
        PredictedValue(:,s,k)=GetRegValue(KNNRegressor,Test.Features(:,FeaturesIndex{k},s));
    end
end
save(TempDataFile,'Test','PredictedValue')
else
load(TempDataFile)
end
%%
BasePlotFileName='Plots\TestDataAnalize1_Fig';
SavePlots=1;
TextSize=14;
%%
%%
FittngMethodsNum=size(Test.FittedW,2);
FMAE=zeros(FittngMethodsNum,Test.SetNum);
for f=1:FittngMethodsNum
for i=1:Test.SetNum
    Erorrs=Test.FittedW(:,f,i)-Test.Label(:,i);
    Erorrs(isnan(Erorrs))=[];
    AE = abs(Erorrs);
    FMAE(f,i)=mean(AE);
end
end

BestFittngMethodsNum=size(Test.BestFittedW,2);
BFMAE=zeros(BestFittngMethodsNum,Test.SetNum);
for f=1:BestFittngMethodsNum
for i=1:Test.SetNum
    Erorrs=Test.BestFittedW(:,f,i)-Test.Label(:,i);
    Erorrs(isnan(Erorrs))=[];
    AE = abs(Erorrs);
    BFMAE(f,i)=mean(AE);
end
end
EMAE=zeros(KNNMethodNum,Test.SetNum);
EDnM=zeros(KNNMethodNum,Test.SetNum);
EUpM=zeros(KNNMethodNum,Test.SetNum);
for k=1:KNNMethodNum
for r=1:Test.SetNum
    Erorrs=PredictedValue(:,r,k)-Test.Label(:,r);
    AE = abs(Erorrs);
    EMAE(k,r)=mean(AE);
    EDnM(k,r)=mean(AE(AE<=EMAE(k,r)));
    EUpM(k,r)=mean(AE(AE>=EMAE(k,r)));
end
end
%%
figure(9)
plot(BFMAE','--','LineWidth',2);
hold on
plot(EMAE(1:3,:)','LineWidth',2);
hold off
I=1;
% patch([1:12,12:-1:1],[EDnM(I,:),EUpM(I,end:-1:1)],'r','FaceAlpha',0.3,'LineStyle','none')
xlim([0.5,Test.SetNum+0.5])
set(gca,'FontSize',TextSize)
set(gca,'XTick',1:Test.SetNum)
set(gca,'XTickLabels',Test.SetTick)
% set(gca,'XTickLabelRotation',90)
xlabel('Noise Ratio')
ylabel('Mean Absolute Error')
% title({'Bias Variance Trade off By Median and Mean of Absolute Error','Sorted by Median'})
% set(gcf,'Position',[50,50,1200,700]);
legend([Fitter,KNNMethodes],'location','northeastoutside')
set(gcf,'Position',[50,50,1200,500]);
if SavePlots
FileName=[BasePlotFileName,'9_NoiseEfect'];
saveas(gcf,[FileName,'.jpg']);
saveas(gcf,[FileName,'.emf']);
end
