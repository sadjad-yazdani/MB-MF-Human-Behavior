% Make Train Data Extract Feature Vectors
clc;
clearvars;
% TotalDataFileName='Data\TrainDataset.mat';
% TotalDataFileName='Data\TrainDataset_PureMB.mat';
TotalDataFileName='Data\TrainDataset_PureMF.mat';
SubjectNums=1000;
RunNum=4;
PartNum=10;
TotalSubjectNums=SubjectNums*RunNum*PartNum;
FittedW     = zeros(TotalSubjectNums,18);
BestFittedW = zeros(TotalSubjectNums,2);
Features    = zeros(TotalSubjectNums,39);
Label       = zeros(TotalSubjectNums,1);

%                   W   Alpha1  Alpha2  Beta1	Beta2	Lambda  P1  P2
ParamsIndex      = [1   1       0       1       0       0       0   0   %Daw3ParamV1
                    1   1       0       1       0       0       0   0   %Daw3ParamV2
                    1   1       0       1       0       1       0   0   %Daw4Param
                    1   1       1       1       1       0       0   0   %Daw5ParamV1
                    1   1       1       1       1       0       0   0   %Daw5ParamV2
                    1   1       1       1       1       1       0   0   %Daw6Param
                    1   1       1       1       1       1       1   0   %Daw7ParamV1
                    1   1       1       1       1       1       1   0   %Daw7ParamV2
                    1   1       1       1       1       1       1   1]; %Daw8Param

ParamNum=(sum(ParamsIndex,2))';
ParamNumMat=repmat(ParamNum,SubjectNums,1);
NR=zeros(SubjectNums,1);
k=0;
tic
PartBestFittedW=zeros(SubjectNums,2);
PartBestFittedAlpha=zeros(SubjectNums,2);
PartBestFittedBeta=zeros(SubjectNums,2);
for R=1:RunNum
    for P=1:PartNum
        fprintf('|Run %d |Part %d|\n',R,P)
%         DataFileName=['Data\FittingData_Part',num2str(P),'Run',num2str(R),'.mat'];
%         DataFileName=['Data\FittingData_PureMB_Part',num2str(P),'Run',num2str(R),'.mat'];
        DataFileName=['Data\FittingData_PureMF_Part',num2str(P),'Run',num2str(R),'.mat'];
        Data=load(DataFileName);
        rng(Data.ObserverRngState);
        [ObserveMat]= ParallDawReinforcmenLearningAgents([Data.Params,NR],'Daw8Param');
        rng(Data.ObserverRngState)
        Env=GetDawEnv('RandomWalkSelected');
        for s=1:SubjectNums
        for i=1:9:18
            [~,I]=min(2*ParamNum+2*Data.BestFittedNegLogLikelihood(s,i:i+8));
            BetaIndex=sum(ParamsIndex(I,1:4));
            I=I+i-1;
            PartBestFittedW    (s,ceil(i/9)) = Data.BestFittedParams(s,1,I);
            PartBestFittedAlpha(s,ceil(i/9)) = Data.BestFittedParams(s,2,I);
            PartBestFittedBeta (s,ceil(i/9)) = Data.BestFittedParams(s,BetaIndex,I);
        end
        end
        ThisPartFittedW=(shiftdim(Data.BestFittedParams(:,1,:),2))';
        [Stochastic,StochasticNames]=ParallExtractStochasticFeatures(ObserveMat,Env); % 27 Features
        PStay=ParallExtractDawPStay(ObserveMat);
        MBAndMFIndex(:,1 )= PStay(1,1,:)+PStay(1,2,:)-PStay(2,1,:)-PStay(2,2,:);IndexNames{1} ='I_M_F^P^S^t^a^y';
        MBAndMFIndex(:,2 )= PStay(1,1,:)-PStay(1,2,:)-PStay(2,1,:)+PStay(2,2,:);IndexNames{2} ='I_M_B^P^S^t^a^y';
        MBAndMFIndex(:,3 )= (1-PartBestFittedW(:,1)).*PartBestFittedBeta(:,1);  IndexNames{3} ='I_M_F^M^L^E';
        MBAndMFIndex(:,4 )=    PartBestFittedW(:,1) .*PartBestFittedBeta(:,1);  IndexNames{4} ='I_M_B^M^L^E';
        MBAndMFIndex(:,5 )= (1-PartBestFittedW(:,2)).*PartBestFittedBeta(:,2);  IndexNames{5} ='I_M_F^M^A^P';
        MBAndMFIndex(:,6 )=    PartBestFittedW(:,2) .*PartBestFittedBeta(:,2);  IndexNames{6} ='I_M_B^M^A^P';
        

        Label       ((k+1):(k+SubjectNums),  :  ) = Data.Params(:,1);
        BestFittedW ((k+1):(k+SubjectNums),  :  ) = PartBestFittedW;
        FittedW     ((k+1):(k+SubjectNums),  :  ) = ThisPartFittedW;
        Features    ((k+1):(k+SubjectNums), 1:27) = Stochastic;
        Features    ((k+1):(k+SubjectNums),28:33) = MBAndMFIndex;
        Features    ((k+1):(k+SubjectNums),34   ) = PartBestFittedW    (:,1);
        Features    ((k+1):(k+SubjectNums),35   ) = PartBestFittedAlpha(:,1);
        Features    ((k+1):(k+SubjectNums),36   ) = PartBestFittedBeta (:,1);
        Features    ((k+1):(k+SubjectNums),37   ) = PartBestFittedW    (:,2);
        Features    ((k+1):(k+SubjectNums),38   ) = PartBestFittedAlpha(:,2);
        Features    ((k+1):(k+SubjectNums),39   ) = PartBestFittedBeta (:,2);
        k=k+SubjectNums;

    end
end
toc
FittingFeaturesName={'W^M^L^E';
                     '\alpha_1^M^L^E';
                     '\beta_1^M^L^E';
                     'W^M^A^P';
                     '\alpha_1^M^A^P';
                     '\beta_1^M^A^P'};
Methodes=Data.Methodes;
FeaturesName = cell(1,39);
FeaturesName( 1:27)=StochasticNames(:);
FeaturesName(28:33)=IndexNames(:);
FeaturesName(34:39)=FittingFeaturesName(:);
[~,UniqueIndex,~]=unique([Features,Label],'rows','stable');
Label=Label(UniqueIndex);
Features=Features(UniqueIndex,:);
FittedW=FittedW(UniqueIndex,:);
BestFittedW=BestFittedW(UniqueIndex,:);
save(TotalDataFileName,'Label','Features','FittedW','BestFittedW','FeaturesName','Methodes')