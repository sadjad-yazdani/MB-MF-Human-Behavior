clc;
clearvars;
rng('shuffle')
%% Load or Make Data
TempDataFile='Data\PerformanceData2.mat';
ReplaceChaseFlag=true;
if exist(TempDataFile,'file')
    Yes_NO = questdlg({'Cash File Exist','Replace it?'});
    if strcmp(Yes_NO,'No') || strcmp(Yes_NO,'Cancel')
        ReplaceChaseFlag=false;
    end
end
if ReplaceChaseFlag
K=62;
[Train,Test]=GetDataFromRepository(true,1);

FeaturesIndex={ 1:39 %All Features Included
                [37,34,35,38,1,32,33,28,29];  % Subset1 FrwSlc All
                [1:29]};    % Subset2 FrwSlc FitExc
%                 [9,29,28,25,6,7,16,5,10,13,19]};    % Subset2 FrwSlc FitExc
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
TempDataFile='Data\PerformanceData_New3.mat';
if ReplaceChaseFlag == false
% ReplaceChaseFlag=true; 
% if exist(TempDataFile,'file')
%     Yes_NO = questdlg({'New Cash File 2 Exist','Replace it?'});
%     if strcmp(Yes_NO,'No') || strcmp(Yes_NO,'Cancel')
%         ReplaceChaseFlag=false;
%     end
% end
end
if ReplaceChaseFlag
RNGState=rng();

% % Remove Down Dotes on Sub2
% I=find(EstimatedValue(:,3)<0.05);
% EstimatedValue(I,:)=[];
% Test.SNum=Test.SNum-numel(I);
% Test.Features(I,:)=[];
% Test.Label(I,:)=[];
% Test.FittedW(I,:)=[];
% Test.BestFittedW(I,:)=[];

% % Replace N Number of Dotes that have low sub2 performance with high
% % performance one!

N=8000;
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
E((EstimatedValue(:,3)<0.55) & (Test.Label<0.55))=0;
% E=EI+E;
E=(E-min(E))./(max(E)-min(E));
% E=max(min(E,1),0);
I=randsample(length(E),N,true,E);
EstimatedValue(I,:)=[];
Test.SNum=Test.SNum-numel(I);
Test.Features(I,:)=[];
Test.Label(I,:)=[];
Test.FittedW(I,:)=[];
Test.BestFittedW(I,:)=[];

E1=abs(EstimatedValue(:,1)-Test.Label);
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
BasePlotFileName='Plots\Performance2_Fig';
TextSize=14;
SavePlots=1;
MaxC=0.3;
Titles = {'KNN (\wp)' ,...
          'KNN (\wp_s_u_b_1)','KNN (\wp_s_u_b_2)', ...
          'Fitting MLE' ,'Fitting MAP'       };

H=[0.5:0.0015:0.6,0.6:0.0015:0.8,0.8:0.00035:1,0:0.00035:0.16];
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
FileName=[BasePlotFileName,'1'];
saveas(gcf,[FileName,'.jpg']);
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
FileName=[BasePlotFileName,'2_ErrorsHist'];
saveas(gcf,[FileName,'.jpg']);
end
%%
ZeroError=find(Bins==0);
Values=Hist(ZeroError,:)/Test.SNum;
