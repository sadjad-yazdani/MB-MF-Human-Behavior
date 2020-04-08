% clc;
clearvars;
rng('shuffle')
%% Load or Make Data
TempDataFile='Data\PerformanceData_BoxPlot.mat';
ReplaceChaseFlag=true;
if exist(TempDataFile,'file')
    Yes_NO = questdlg({'Cash File Exist','Replace it?'});
    if strcmp(Yes_NO,'No') || strcmp(Yes_NO,'Cancel')
        ReplaceChaseFlag=false;
    end
end
if ReplaceChaseFlag
K=68;
[Train,Test]=GetDataFromRepository(true,1);

FeaturesIndex={ 1:39 %All Features Included
                [37,28,8 ,30,29,38,3 ,16,31,32,2 ,12,9 ,11,19,6 ];  % Subset1 FrwSlc All
                [11,28,29,14,19,7 ,2 ,4 ,3 ,10,8 ,5 ,9 ,12,6 ,21]}; % Subset3 FrwSlc FitExc
KNNNum=length(FeaturesIndex);
EstimatedValue=zeros(Test.SNum,KNNNum);
for i=1:KNNNum
fprintf('Analyze Feature for Index # %d  of  %d .\n',i,KNNNum)
KNNRegressor = KNNReg(Train.Features(:,FeaturesIndex{i}),Train.Label,'NumNeighbors',K,'RegresiorMethod','InverseDistance');
EstimatedValue(:,i)=GetRegValue(KNNRegressor,Test.Features(:,FeaturesIndex{i}));
end
save(TempDataFile,'Test','EstimatedValue','KNNNum')
else
load(TempDataFile)
end
FitNum=size(Test.BestFittedW,2);
%% Extract Error MAE and STD
MAE=zeros(KNNNum+FitNum,1);
STD=zeros(KNNNum+FitNum,1);
for i=1:KNNNum
    Erorrs=EstimatedValue(:,i)-Test.Label;
    Erorrs(isnan(Erorrs))=[];
    AE = abs(Erorrs);
    MAE(i)=mean(AE);
    STD(i)=std(AE);
end
for i=KNNNum+1:KNNNum+FitNum
    Erorrs=Test.BestFittedW(:,i-KNNNum)-Test.Label;
    Erorrs(isnan(Erorrs))=[];
    AE = abs(Erorrs);
    MAE(i)=mean(AE);
    STD(i)=std(AE);
end
% 
disp(MAE)
disp(STD)
%% Extract Error MSE and STD
MSE=zeros(KNNNum+FitNum,1);
STD_SE=zeros(KNNNum+FitNum,1);
for i=1:KNNNum
    Erorrs=EstimatedValue(:,i)-Test.Label;
    Erorrs(isnan(Erorrs))=[];
    SE = Erorrs.^2;
    MSE(i)=mean(SE);
    STD_SE(i)=std(SE);
end
for i=KNNNum+1:KNNNum+FitNum
    Erorrs=Test.BestFittedW(:,i-KNNNum)-Test.Label;
    Erorrs(isnan(Erorrs))=[];
    SE = abs(Erorrs);
    MSE(i)=mean(SE);
    STD_SE(i)=std(SE);
end
% 
disp(MSE)
disp(STD_SE)
%% Plots Options
BasePlotFileName='Plots\Performance_Box_Fig';
TextSize=14;
SavePlots=0;
MaxC=0.3;
Titles = {'KNN (\wp)' ,...
          'KNN (\wp_s_u_b_1)','KNN (\wp_s_u_b_2)', ...
          'Fitting MLE' ,'Fitting MAP'       };
%%
% H=[0.5:0.001:0.6,0.6:0.001:0.8,0.8:0.0003:1,0:0.0003:0.16];
% N=length(H);
% MAP=hsv2rgb([H',ones(N,1),ones(N,1)]);
% Fig 1 Plot Scatter and Parzen estimation
clear Fig
Fig.Fig=2;
Fig.XLim=[0,1];
Fig.YLim=[-0.01,1.01];
Fig.AddLine=false;
Fig.TextSize=13;
Fig.AreaT=0.15;
Fig.AreaA=(1-Fig.AreaT)/2;
Fig.AreaC=0.009;
Fig.CAreaPercentageTreshold=-1;
% Fig.TypeValues=false;
% Fig.ParzenH=0.05;
% Fig.ColorMAP=MAP;
% Fig.ColorRenge=[0,MaxC];
% Fig.ColorBar=false;
for p=1:KNNNum
    Fig.SubFig={3,2,p+(p>1)};
    Fig.Title=Titles{p};
    PlotPerformanceBox(Test.Label,EstimatedValue(:,p),Fig);
end
for p=1:FitNum
    Fig.SubFig={3,2,p+KNNNum+1};
    Fig.Title=Titles{p+KNNNum};
    PlotPerformanceBox(Test.Label,Test.BestFittedW(:,p),Fig);
end
%
set(gcf,'Position',[10,50,700,950]);
subplot(3,2,1)
text(-.25,-0.1,'Estimated w ','Rotation',90,'FontSize',TextSize,'HorizontalAlignment','center','VerticalAlignment','middle')
subplot(3,2,5)
ylabel('Fitted w ')
% text(-.25,0.5,'Fitted w ','Rotation',90,'FontSize',TextSize,'HorizontalAlignment','center','VerticalAlignment','middle')
subplot(3,2,5)
text(1.15,-0.25,'Real w','FontSize',TextSize,'HorizontalAlignment','center','VerticalAlignment','middle')
% subplot('Position',[0.92,0.1,0.2,0.8]);
% set(gca,'visible','off');
% caxis([0,MaxC])
% colormap(MAP)
% colorbar('Location','west','position',[0.95,0.1,0.04,0.8],'Ticks',0:0.1:1,'FontSize',TextSize-2);
% set(gca,'FontSize',TextSize)
% subplot(3,2,4)
% text(1.04,2.8,'P(Real w|w)','FontSize',TextSize,'HorizontalAlignment','center','VerticalAlignment','middle')
%
if SavePlots
FileName=[BasePlotFileName,'1'];
saveas(gcf,[FileName,'.jpg']);
end

