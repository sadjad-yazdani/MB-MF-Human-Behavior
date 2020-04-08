clc;
clearvars;
%% Load or Make Data
TempDataFile='Data\PerformanceData.mat';
ReplaceChaseFlag=true;
if exist(TempDataFile,'file')
    Yes_NO = questdlg({'Cash File Exist','Replace it?'});
    if strcmp(Yes_NO,'No') || strcmp(Yes_NO,'Cancel')
        ReplaceChaseFlag=false;
    end
end
if ReplaceChaseFlag
RNGState=rng('shuffle');
K=68;
[Train,Test]=GetDataFromRepository(true,1);

FeaturesIndex={ 1:39 %All Features Included
                [37,28,8 ,30,29,38,3 ,16,31,32,2 ,12,9 ,11,19,6 ];  % Subset1 FrwSlc All
                [11,28,29,14,19,7 ,2 ,4 ,3 ,10,8 ,5 ,9 ,12,6 ,21]}; % Subset3 FrwSlc FitExc
%                 [5,10,13,9,6,7,16,19,29,28,25]};    % Subset2 FrwSlc FitExc
KNNNum=length(FeaturesIndex);
EstimatedValue=zeros(Test.SNum,KNNNum);
for i=1:KNNNum
fprintf('Analyze Feature for Index # %d  of  %d .\n',i,KNNNum)
KNNRegressor = KNNReg(Train.Features(:,FeaturesIndex{i}),Train.Label,'NumNeighbors',K,'RegresiorMethod','InverseDistance');
EstimatedValue(:,i)=GetRegValue(KNNRegressor,Test.Features(:,FeaturesIndex{i}));
end
save(TempDataFile,'Test','EstimatedValue','KNNNum','RNGState')
else
load(TempDataFile)
end
FitNum=size(Test.BestFittedW,2);
%% Extract Error MAE and STD
MAE=zeros(KNNNum+FitNum,1);
STD=zeros(KNNNum+FitNum,1);
R=zeros(KNNNum+FitNum,1);
for i=1:KNNNum
    Erorrs=EstimatedValue(:,i)-Test.Label;
    Erorrs(isnan(Erorrs))=[];
    AE = abs(Erorrs);
    MAE(i)=mean(AE);
    STD(i)=std(AE);
    R(i)=corr(EstimatedValue(:,i),Test.Label);
end
for i=KNNNum+1:KNNNum+FitNum
    Erorrs=Test.BestFittedW(:,i-KNNNum)-Test.Label;
    Erorrs(isnan(Erorrs))=[];
    AE = abs(Erorrs);
    MAE(i)=mean(AE);
    STD(i)=std(AE);
    R(i)=corr(Test.BestFittedW(:,i-KNNNum),Test.Label);
end
%% Plots Options
BasePlotFileName='Plots\Performance_Fig';
TextSize=14;
SavePlots=1;
MaxC=0.3;
Titles = {'\itk-nn (\wp)' ,...
          '\itk-nn (\wp_{sub1})','\itk-nn (\wp_{sub2})', ...
          'Fitting MLE' ,'Fitting MAP'       };

H=[0.5:0.001:0.6,0.6:0.0015:0.8,0.8:0.00040:1,0:0.000345:0.16];
N=length(H);
MAP=hsv2rgb([H',ones(N,1),ones(N,1)]);
% Fig 1 Plot Scatter and Parzen estimation
Fig.Fig=1;
Fig.XLim=[0,1];
Fig.YLim=[0,1];
Fig.AddLine=false;
Fig.TypeValues=false;
Fig.ParzenH=0.04;
Fig.TextSize=TextSize;
Fig.ColorMAP=MAP;
Fig.ColorRenge=[0,MaxC];
Fig.ColorBar=false;
for p=1:KNNNum
    Fig.SubFig={3,2,p+(p>1)};
    Fig.Title=Titles{p};
    PlotPerformance(Test.Label,EstimatedValue(:,p),Fig);
end
for p=1:FitNum
    Fig.SubFig={3,2,p+KNNNum+1};
    Fig.Title=Titles{p+KNNNum};
    PlotPerformance(Test.Label,Test.BestFittedW(:,p),Fig);
end
%
set(gcf,'Position',[10,50,650,750]);
subplot(3,2,1)
text(-.25,-0.1,'Estimated w ','Rotation',90,'FontSize',TextSize,'HorizontalAlignment','center','VerticalAlignment','middle')
subplot(3,2,5)
ylabel('Fitted w ')
% text(-.25,0.5,'Fitted w ','Rotation',90,'FontSize',TextSize,'HorizontalAlignment','center','VerticalAlignment','middle')
subplot(3,2,5)
text(1.15,-0.25,'Real w','FontSize',TextSize,'HorizontalAlignment','center','VerticalAlignment','middle')
subplot('Position',[0.92,0.1,0.2,0.8]);
set(gca,'visible','off');
caxis([0,MaxC])
colormap(MAP)
colorbar('Location','west','position',[0.95,0.1,0.04,0.8],'Ticks',0:0.1:1,'FontSize',TextSize-2);
set(gca,'FontSize',TextSize)
subplot(3,2,4)
text(1.04,2.8,'P(Real w|w)','FontSize',TextSize,'HorizontalAlignment','center','VerticalAlignment','middle')
%
if SavePlots
FileName=[BasePlotFileName,'0'];
saveas(gcf,[FileName,'.jpg']);
saveas(gcf,[FileName,'.emf']);
end
%% Extract Error Histograms
Bins=-1:0.1:1;
% B=[-1,-0.9 -0.8 -0.7 -0.6 -0.5 -0.3 -0.15];
% Bins=[B,0,-B(end:-1:1)];
BinNum=length(Bins);
Hist=zeros(BinNum,KNNNum+FitNum);
for i=1:KNNNum
    Erorrs=EstimatedValue(:,i)-Test.Label;
    Erorrs(isnan(Erorrs))=[];
    Hist(:,i)=hist(Erorrs,Bins);
end
for i=KNNNum+1:KNNNum+FitNum
    Erorrs=Test.BestFittedW(:,i-KNNNum)-Test.Label;
    Erorrs(isnan(Erorrs))=[];
    Hist(:,i)=hist(Erorrs,Bins);
end
% Plot Histogram of Errors
figure(6);clf
b=bar(Bins,Hist/Test.SNum);
b(1).FaceColor=[0,1,0];
b(2).FaceColor=[1,1,0];
b(3).FaceColor=[0,1,1];
b(4).FaceColor=[1,0,0];
b(5).FaceColor=[1,0,1];
set(gca,'FontSize',TextSize)
set(gca,'YScale','log')
xlim([-1.1,1.1])
legend(Titles,'location','NorthEastOutside')
xlabel('Error');
ylabel('Probability of Error');
set(gcf,'Position',[50,50,1200,500]);
%%
if SavePlots
FileName=[BasePlotFileName,'2_ErrorsHist_Fig8'];
saveas(gcf,[FileName,'.jpg']);
saveas(gcf,[FileName,'.emf']);
end
%%
ZeroError=find(Bins==0);
Values=Hist(ZeroError,:)/Test.SNum;
%%
clear Fig
Fig.Fig=5;
Fig.XLim=[0,1];
Fig.YLim=[-0.02,1.0215];
Fig.AddLine=false;
Fig.TextSize=13;
Fig.AreaT=0.1;
Fig.AreaA=(1-Fig.AreaT)/2;
Fig.AreaC=0.02;
Fig.CAreaPercentageTreshold=0;
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
% Legend
Fig.SubFig={3,2,2};
Fig.Title='';
PlotPerformanceBoxLegendV2(Fig);
%
set(gcf,'Position',[10,50,650,950]);
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
FileName=[BasePlotFileName,'3_Fig7'];
saveas(gcf,[FileName,'.jpg']);
saveas(gcf,[FileName,'.emf']);
end

%%
% display Table 
table(MAE,STD,R,'RowNames',Titles)
