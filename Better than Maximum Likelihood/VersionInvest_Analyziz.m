clc;
clearvars;
rng('shuffle')
% rng('default')

Data=load('Data\VersionInvest_Data.mat');
ParamNum=[3,3,4,5,5,6,7,7,8];
VersionsNum=length(Data.Methodes);
for m=1:VersionsNum
    Data.Methodes{m}=Data.Methodes{m}(4:end);
end
%%
BasePlotFileName='Plots\VersionInvest_Fig4_';
SavePlots=1;
TextSize=14;
%% Extract Abs Errors
MLEMAE=zeros(VersionsNum);
MLESTD=zeros(VersionsNum);
for fm=1:VersionsNum
for am=1:VersionsNum
    Erorrs=Data.MLEFittedW(:,am,fm)-Data.AgentW(:,am);
    Erorrs(isnan(Erorrs))=[];
    AE = abs(Erorrs);
    MLEMAE(am,fm)=mean(AE);
    MLESTD(am,fm)=std(AE);
end
end
MAPMAE=zeros(VersionsNum);
MAPSTD=zeros(VersionsNum);
for fm=1:VersionsNum
for am=1:VersionsNum
    Erorrs=Data.MAPFittedW(:,am,fm)-Data.AgentW(:,am);
    Erorrs(isnan(Erorrs))=[];
    AE = abs(Erorrs);
    MAPMAE(am,fm)=mean(AE);
    MAPSTD(am,fm)=std(AE);
end
end

%% Select the Fited Method By AIC
SNum=size(Data.AgentW,1);
AICMLE=zeros(SNum,VersionsNum,VersionsNum);
AICMAP=zeros(SNum,VersionsNum,VersionsNum);
for fm=1:VersionsNum
for am=1:VersionsNum
[AICMLE(:,am,fm)]=2*Data.MAPFittedNLL(:,am,fm)+2*ParamNum(fm);
[AICMAP(:,am,fm)]=2*Data.MLEFittedNLL(:,am,fm)+2*ParamNum(fm);
end
end
BestAICMLE=zeros(VersionsNum);
BestAICMAP=zeros(VersionsNum);
BestFittedMethodByAICMLE=zeros(SNum,VersionsNum);
BestFittedAICByAICMLE=zeros(SNum,VersionsNum);
BestFittedMethodByAICMAP=zeros(SNum,VersionsNum);
BestFittedAICByAICMAP=zeros(SNum,VersionsNum);
for am=1:VersionsNum
    [BestFittedAICByAICMLE(:,am),BestFittedMethodByAICMLE(:,am)]=min(AICMLE(:,am,:),[],3);
    [BestFittedAICByAICMAP(:,am),BestFittedMethodByAICMAP(:,am)]=min(AICMAP(:,am,:),[],3);
    BestAICMLE(:,am)=hist(BestFittedMethodByAICMLE(:,am),1:VersionsNum);
    BestAICMAP(:,am)=hist(BestFittedMethodByAICMAP(:,am),1:VersionsNum);
end
BestAICMLE=BestAICMLE/SNum*100;
BestAICMAP=BestAICMAP/SNum*100;
%% Tabel Data
Tabel1MLE_Fitting=cell(VersionsNum);
Tabel2MLE_AIC    =cell(VersionsNum);
Tabel1MAP_Fitting=cell(VersionsNum);
Tabel2MAP_AIC    =cell(VersionsNum);
for fm=1:VersionsNum
for am=1:VersionsNum
    Tabel1MLE_Fitting{am,fm}={num2str(MLEMAE(am,fm),'%5.3f')     ,['[±',num2str(MLESTD(am,fm),'%4.2f')        ,']']};
    Tabel2MLE_AIC    {am,fm}={num2str(BestAICMLE(am,fm),'%04.1f'),['(',num2str(BestFittedAICByAICMLE(am,fm),3),')']};
    Tabel1MAP_Fitting{am,fm}={num2str(MAPMAE(am,fm),'%5.3f')     ,['[±',num2str(MAPSTD(am,fm),'%4.2f')        ,']']};
    Tabel2MAP_AIC    {am,fm}={num2str(BestAICMAP(am,fm),'%04.1f'),['(',num2str(BestFittedAICByAICMAP(am,fm),3),')']};
end
end
%%
figure(1);
ExtendedTabel=MLEMAE;
ExtendedTabel(end+1,:)=ExtendedTabel(end,:);
ExtendedTabel(:,end+1)=ExtendedTabel(:,end);
mesh(ExtendedTabel,'FaceLighting','gouraud','LineWidth',1,'Facecolor','flat','EdgeColor','k')
Ztext=max(max(MLEMAE))+0.1;
for fm=1:VersionsNum
for am=1:VersionsNum
    text(fm+0.5,am+0.5,Ztext,Tabel1MLE_Fitting{am,fm},'fontsize',TextSize,'HorizontalAlignment','center');
end
end
colormap('cool')
colorbar();
grid off
view(2);
xlim([1,10])
ylim([1,10])
set(gca,'FontSize',TextSize)
set(gca,'XTick',(1:VersionsNum)+0.5)
set(gca,'YTick',(1:VersionsNum)+0.5)
% set(gca,'XTickLabelRotation',90)
set(gca,'XTickLabel',Data.Methodes)
set(gca,'YTickLabel',Data.Methodes)
ylabel('Agent Model Version')
xlabel('Fitting Model Version')

set(gcf,'Position',[50,50,1200,850]);
if SavePlots
FileName=[BasePlotFileName,'A_MSEofVariouMethodByMLE'];
saveas(gcf,[FileName,'.jpg']);
saveas(gcf,[FileName,'.emf']);
end

%%
figure(2);
ExtendedMAPMAE=MAPMAE;
ExtendedMAPMAE(end+1,:)=ExtendedMAPMAE(end,:);
ExtendedMAPMAE(:,end+1)=ExtendedMAPMAE(:,end);
mesh(ExtendedMAPMAE,'FaceLighting','gouraud','LineWidth',1,'Facecolor','flat','EdgeColor','k')
Ztext=max(max(MAPMAE))+0.1;
for fm=1:VersionsNum
for am=1:VersionsNum
    text(fm+0.5,am+0.5,Ztext,Tabel1MAP_Fitting{am,fm},'fontsize',TextSize,'HorizontalAlignment','center');
end
end
colormap('cool')
colorbar();
grid off
view(2);
xlim([1,10])
ylim([1,10])
set(gca,'FontSize',TextSize)
set(gca,'XTick',(1:VersionsNum)+0.5)
set(gca,'YTick',(1:VersionsNum)+0.5)
% set(gca,'XTickLabelRotation',90)
set(gca,'XTickLabel',Data.Methodes)
set(gca,'YTickLabel',Data.Methodes)
ylabel('Agent Model Version')
xlabel('Fitting Model Version')

set(gcf,'Position',[50,50,1200,850]);
if SavePlots
FileName=[BasePlotFileName,'B_MSEofVariouMethodByMAP'];
saveas(gcf,[FileName,'.jpg']);
saveas(gcf,[FileName,'.emf']);
end

%%
figure(3);
ExtendedTabel=BestAICMLE;
ExtendedTabel(end+1,:)=ExtendedTabel(end,:);
ExtendedTabel(:,end+1)=ExtendedTabel(:,end);
mesh(ExtendedTabel,'FaceLighting','gouraud','LineWidth',1,'Facecolor','flat','EdgeColor','k')
Ztext=max(max(BestAICMLE))+0.1;
for fm=1:VersionsNum
for am=1:VersionsNum
    text(fm+0.5,am+0.5,Ztext,Tabel2MLE_AIC{am,fm},'fontsize',TextSize,'HorizontalAlignment','center');
end
end
colormap('cool')
colorbar();
grid off
view(2);
xlim([1,10])
ylim([1,10])
set(gca,'FontSize',TextSize)
set(gca,'XTick',(1:VersionsNum)+0.5)
set(gca,'YTick',(1:VersionsNum)+0.5)
% set(gca,'XTickLabelRotation',90)
set(gca,'XTickLabel',Data.Methodes)
set(gca,'YTickLabel',Data.Methodes)
ylabel('Agent Model Version')
xlabel('Fitting Model Version')

set(gcf,'Position',[50,50,1200,850]);
if SavePlots
FileName=[BasePlotFileName,'C_AICofVariouMethodByMLE'];
saveas(gcf,[FileName,'.jpg']);
saveas(gcf,[FileName,'.emf']);
end

%%
figure(4);
ExtendedTabel=BestAICMAP;
ExtendedTabel(end+1,:)=ExtendedTabel(end,:);
ExtendedTabel(:,end+1)=ExtendedTabel(:,end);
mesh(ExtendedTabel,'FaceLighting','gouraud','LineWidth',1,'Facecolor','flat','EdgeColor','k')
Ztext=max(max(BestAICMAP))+0.1;
for fm=1:VersionsNum
for am=1:VersionsNum
    text(fm+0.5,am+0.5,Ztext,Tabel2MAP_AIC{am,fm},'fontsize',TextSize,'HorizontalAlignment','center');
end
end
colormap('cool')
colorbar();
grid off
view(2);
xlim([1,10])
ylim([1,10])
set(gca,'FontSize',TextSize)
set(gca,'XTick',(1:VersionsNum)+0.5)
set(gca,'YTick',(1:VersionsNum)+0.5)
% set(gca,'XTickLabelRotation',90)
set(gca,'XTickLabel',Data.Methodes)
set(gca,'YTickLabel',Data.Methodes)
ylabel('Agent Model Version')
xlabel('Fitting Model Version')

set(gcf,'Position',[50,50,1200,850]);
if SavePlots
FileName=[BasePlotFileName,'D_AICofVariouMethodByMAP'];
saveas(gcf,[FileName,'.jpg']);
saveas(gcf,[FileName,'.emf']);
end

