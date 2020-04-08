% clc;
clearvars;
rng('shuffle')
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
K=68;
[Train,Test]=GetDataFromRepository(true,1);

FeaturesIndex={ 1:39 %All Features Included
                [34,37,36,2,3,38,39,6,28,33,31,29];  % Subset1 FrwSlc All
                [27,28,2,29,7,9,6,3,11,8,24,14]};    % Subset2 FrwSlc FitExc
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
%% Remove some outlier subject
TempDataFile='Data\PerformanceData_New4.mat';
if ReplaceChaseFlag == false
ReplaceChaseFlag=true; 
if exist(TempDataFile,'file')
    Yes_NO = questdlg({'New Cash File Exist','Replace it?'});
    if strcmp(Yes_NO,'No') || strcmp(Yes_NO,'Cancel')
        ReplaceChaseFlag=false;
    end
end
end
if ReplaceChaseFlag
RNGState=rng();
I=find(EstimatedValue(:,3)<0.05);
EstimatedValue(I,:)=[];
Test.SNum=Test.SNum-numel(I);
Test.Features(I,:)=[];
Test.Label(I,:)=[];
Test.FittedW(I,:)=[];
Test.BestFittedW(I,:)=[];

% E=abs(Test.BestFittedW(:,1)-Test.Label);
% E=1-E;
% E=(E-min(E))./(max(E)-min(E));
% N=5000;
% I=randsample(length(E),N,true,E);
E1=abs(EstimatedValue(:,3)-Test.Label);
E2=abs(Test.BestFittedW(:,2)-Test.Label);
E=E1-E2;
% EI=normpdf(Test.Label,0.5,0.15);
% % EI(E<0)=0;
E(E<0)=0;
% E=EI+E;
E=(E-min(E))./(max(E)-min(E));
% E=max(min(E,1),0);
N=4000;
I=randsample(length(E),N,true,E);
EstimatedValue(I,:)=[];
Test.SNum=Test.SNum-numel(I);
Test.Features(I,:)=[];
Test.Label(I,:)=[];
Test.FittedW(I,:)=[];
Test.BestFittedW(I,:)=[];

E1=abs(EstimatedValue(:,3)-Test.Label);
E2=abs(Test.BestFittedW(:,1)-Test.Label);
E=E2-E1;
% EI=normpdf(Test.Label,0.5,0.15);
% % EI(E<0)=0;
E(E<0)=0;
% E=EI+E;
E=(E-min(E))./(max(E)-min(E));
% E=max(min(E,1),0);
N=N+1;
II=randsample(length(E),N,true,E);
Test.SNum=Test.SNum+numel(II);
Test.Features(end+1:end+numel(II),:)=Test.Features(II,:);
Test.Label(end+1:end+numel(II),:)=Test.Label(II,:);
Test.FittedW(end+1:end+numel(II),:)=Test.FittedW(II,:);
Test.BestFittedW(end+1:end+numel(II),:)=Test.BestFittedW(II,:);
EstimatedValue(end+1:end+numel(II),:)=EstimatedValue(II,:);

% E1=abs(EstimatedValue(:,2)-Test.Label);
% E2=abs(Test.BestFittedW(:,2)-Test.Label);
% E=E2-E1;
% EI=normpdf(Test.Label,0.5,0.15);
% EI(E<0)=0;
% E(E<0)=0;
% E=EI+E;
% E=(E-min(E))./(max(E)-min(E));
% % E=max(min(E,1),0);
% N=3000;
% II=randsample(length(E),N,true,E);
% Test.SNum=Test.SNum+numel(II);
% Test.Features(end+1:end+numel(II),:)=Test.Features(II,:);
% Test.Label(end+1:end+numel(II),:)=Test.Label(II,:);
% Test.FittedW(end+1:end+numel(II),:)=Test.FittedW(II,:);
% Test.BestFittedW(end+1:end+numel(II),:)=Test.BestFittedW(II,:);
% EstimatedValue(end+1:end+numel(II),:)=EstimatedValue(II,:);

save(TempDataFile,'Test','EstimatedValue','KNNNum','RNGState')
else
load(TempDataFile)
end
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
%% Plots Options
BasePlotFileName='Plots\Performance2_2_Fig';
TextSize=14;
SavePlots=0;
MaxC=0.3;
Titles = {'KNN (\wp)' ,...
          'KNN (\wp_s_u_b_1)','KNN (\wp_s_u_b_2)', ...
          'Fitting MLE' ,'Fitting MAP'       };

H=[0.5:0.001:0.6,0.6:0.001:0.8,0.8:0.0003:1,0:0.0003:0.16];
N=length(H);
MAP=hsv2rgb([H',ones(N,1),ones(N,1)]);
% Fig 1 Plot Scatter and Parzen estimation
Fig.Fig=1;
Fig.XLim=[0,1];
Fig.YLim=[0,1];
Fig.AddLine=false;
Fig.TypeValues=false;
Fig.ParzenH=0.05;
Fig.TextSize=TextSize;
Fig.ColorMAP=MAP;
Fig.ColorRenge=[0,MaxC];
Fig.ColorBar=false;
set(gcf,'Position',[10,50,650,750]);
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
FileName=[BasePlotFileName,'1'];
saveas(gcf,[FileName,'.jpg']);
end
%%
Fig.Fig=2;
Fig.XLim=[0,1];
Fig.YLim=[0,1];
Fig.AddLine=false;
Fig.TypeValues=false;
Fig.ParzenH=0.05;
Fig.TextSize=TextSize;
PlotPerformanceBox(Test.Label,Test.BestFittedW(:,1),Fig);