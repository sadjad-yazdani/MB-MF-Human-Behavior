% Make Train Data Extract Feature Vectors
clc;
clearvars;
TotalDataFileName='Data\TestDataset68.mat';
SubjectNums=1000;
Runs=101:108;
RunNum=length(Runs);
SetNum=12;
TotalSubjectNums=SubjectNums*RunNum;
FittedW     = zeros(TotalSubjectNums,18,SetNum);
BestFittedW = zeros(TotalSubjectNums,2 ,SetNum);
Features    = zeros(TotalSubjectNums,39,SetNum);
Label       = zeros(TotalSubjectNums,SetNum);

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
tic
k=0;
PartBestFittedW=zeros(SubjectNums,2);
PartBestFittedAlpha=zeros(SubjectNums,2);
PartBestFittedBeta=zeros(SubjectNums,2);
NoiseRatio=zeros(SetNum,1);
for R=1:RunNum
    for S=1:SetNum
        fprintf('|Run %d |Set %d|\n',R,S)
        DataFileName=['Data\Test_FittingData_Part',num2str(S),'Run',num2str(Runs(R)),'.mat'];
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
        

        Label       ((k+1):(k+SubjectNums),  S    ) = Data.Params(:,1);
        BestFittedW ((k+1):(k+SubjectNums),  :  ,S) = PartBestFittedW;
        FittedW     ((k+1):(k+SubjectNums),  :  ,S) = ThisPartFittedW;
        Features    ((k+1):(k+SubjectNums), 1:27,S) = Stochastic;
        Features    ((k+1):(k+SubjectNums),28:33,S) = MBAndMFIndex;
        Features    ((k+1):(k+SubjectNums),34   ,S) = PartBestFittedW    (:,1);
        Features    ((k+1):(k+SubjectNums),35   ,S) = PartBestFittedAlpha(:,1);
        Features    ((k+1):(k+SubjectNums),36   ,S) = PartBestFittedBeta (:,1);
        Features    ((k+1):(k+SubjectNums),37   ,S) = PartBestFittedW    (:,2);
        Features    ((k+1):(k+SubjectNums),38   ,S) = PartBestFittedAlpha(:,2);
        Features    ((k+1):(k+SubjectNums),39   ,S) = PartBestFittedBeta (:,2);
        NoiseRatio(S)=Data.ThisPartNoiseRatio;
    end
        k=k+SubjectNums;
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
save(TotalDataFileName,'Label','Features','FittedW','BestFittedW','FeaturesName','Methodes','NoiseRatio')