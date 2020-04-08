function [Observe]= ParallDawReinforcmenLearningAgents(Params,ParamMethod)
% Generate Observation Structure for some standard Daw Agent in parallel.
%
% USAGE:
%       Observe = ParallDawReinforcmenLearningAgents(Params,ParamMethod)
% INPUTS:
%       Params: is a matrix of Parameters by this colome order the number
%       of raw identifed the agents numbers.
%           w (Combination wight)
%           Learning Rate 1
%           Learning Rate 2
%           Beta 1
%           Beta 2
%           Eligibility Trace <- differnt in V1 and V2
%           Stickness to repeat the same first state
%           Stickness to repeat the same second state
%       ParamMethod: sring name of param method (Look at Tabel*** in
%       Article)
%
% OUTPUTS:
%       Observe : the output observation of a behavior including this filds:
%           ASARCMat :the First Action ,second level State , Second Action 
%                 Trial Reward and Common Transition flag for each trial.
%           No Timing or confidence in this version
% see also : GetDawEnv
% Sadjad yazdani, May 2017 (sajjad.yazdani@ut.ac.ir)

%  ____        
% | __ ) _   _ 
% |  _ \| | | |
% | |_) | |_| |
% |____/ \__, |
%        |___/ 
%  ____            _  _           _  __   __           _             _ 
% / ___|  __ _  __| |(_) __ _  __| | \ \ / /_ _ ______| | __ _ _ __ (_)
% \___ \ / _` |/ _` || |/ _` |/ _` |  \ V / _` |_  / _` |/ _` | '_ \| |
%  ___) | (_| | (_| || | (_| | (_| |   | | (_| |/ / (_| | (_| | | | | |
% |____/ \__,_|\__,_|/ |\__,_|\__,_|   |_|\__,_/___\__,_|\__,_|_| |_|_|
%                  |__/                                                
% sajjad.yazdani@ut.ac.ir

Env=GetDawEnv('RandomWalkSelected');
SNum = size(Params,1);
Observe.ASARCMat = zeros(Env.TNum,5,SNum);
% Get Params
switch ParamMethod
    case 'Daw3ParamV1'
        W           = Params(:,1);    % combination wight
        Alpha1      = Params(:,2);    % Learning Rate 1
        Alpha2      = Params(:,2);    % Learning Rate 2
        Beta1       = Params(:,3);    % Beta 1
        Beta2       = Params(:,3);    % Beta 2
        Lambda      = 1;            % Eligibility Trace <- differnt in V1 and V2
        StickToAct1 = 0;            % Stickness to repeat the same first state
        StickToAct2 = 0;            % Stickness to repeat the same second state
        NoiseProb1  = Params(:,4);    % Noise Ratio for first state
        NoiseProb2  = Params(:,4);    % Noise Ratio for first state
    case 'Daw3ParamV2'
        W           = Params(:,1);    % combination wight
        Alpha1      = Params(:,2);    % Learning Rate 1
        Alpha2      = Params(:,2);    % Learning Rate 2
        Beta1       = Params(:,3);    % Beta 1
        Beta2       = Params(:,3);    % Beta 2
        Lambda      = 0;            % Eligibility Trace <- differnt in V1 and V2
        StickToAct1 = 0;            % Stickness to repeat the same first state
        StickToAct2 = 0;            % Stickness to repeat the same second state
        NoiseProb1  = Params(:,4);    % Noise Ratio for first state
        NoiseProb2  = Params(:,4);    % Noise Ratio for first state
    case 'Daw4Param'
        W           = Params(:,1);    % combination wight
        Alpha1      = Params(:,2);    % Learning Rate 1
        Alpha2      = Params(:,2);    % Learning Rate 2
        Beta1       = Params(:,3);    % Beta 1
        Beta2       = Params(:,3);    % Beta 2
        Lambda      = Params(:,4);    % Eligibility Trace
        StickToAct1 = 0;            % Stickness to repeat the same first state
        StickToAct2 = 0;            % Stickness to repeat the same second state
        NoiseProb1  = Params(:,5);    % Noise Ratio for first state
        NoiseProb2  = Params(:,5);    % Noise Ratio for first state
    case 'Daw5ParamV1'
        W           = Params(:,1);    % combination wight
        Alpha1      = Params(:,2);    % Learning Rate 1
        Alpha2      = Params(:,3);    % Learning Rate 2
        Beta1       = Params(:,4);    % Beta 1
        Beta2       = Params(:,5);    % Beta 2
        Lambda      = 1;              % Eligibility Trace
        StickToAct1 = 0;            % Stickness to repeat the same first state
        StickToAct2 = 0;            % Stickness to repeat the same second state
        NoiseProb1  = Params(:,6);    % Noise Ratio for first state
        NoiseProb2  = Params(:,6);    % Noise Ratio for first state
    case 'Daw5ParamV2'
        W           = Params(:,1);    % combination wight
        Alpha1      = Params(:,2);    % Learning Rate 1
        Alpha2      = Params(:,3);    % Learning Rate 2
        Beta1       = Params(:,4);    % Beta 1
        Beta2       = Params(:,5);    % Beta 2
        Lambda      = 0;            % Eligibility Trace
        StickToAct1 = 0;            % Stickness to repeat the same first state
        StickToAct2 = 0;            % Stickness to repeat the same second state
        NoiseProb1  = Params(:,6);    % Noise Ratio for first state
        NoiseProb2  = Params(:,6);    % Noise Ratio for first state
    case 'Daw6Param'
        W           = Params(:,1);    % combination wight
        Alpha1      = Params(:,2);    % Learning Rate 1
        Alpha2      = Params(:,3);    % Learning Rate 2
        Beta1       = Params(:,4);    % Beta 1
        Beta2       = Params(:,5);    % Beta 2
        Lambda      = Params(:,6);    % Eligibility Trace
        StickToAct1 = 0;            % Stickness to repeat the same first state
        StickToAct2 = 0;            % Stickness to repeat the same second state
        NoiseProb1  = Params(:,7);    % Noise Ratio for first state
        NoiseProb2  = Params(:,7);    % Noise Ratio for first state
    case 'Daw7ParamV1'
        W           = Params(:,1);    % combination wight
        Alpha1      = Params(:,2);    % Learning Rate 1
        Alpha2      = Params(:,3);    % Learning Rate 2
        Beta1       = Params(:,4);    % Beta 1
        Beta2       = Params(:,5);    % Beta 2
        Lambda      = Params(:,6);    % Eligibility Trace
        StickToAct1 = Params(:,7);    % Stickness to repeat the same first state
        StickToAct2 = Params(:,7);    % Stickness to repeat the same second state
        NoiseProb1  = Params(:,8);    % Noise Ratio for first state
        NoiseProb2  = Params(:,8);    % Noise Ratio for first state
    case 'Daw7ParamV2'
        W           = Params(:,1);    % combination wight
        Alpha1      = Params(:,2);    % Learning Rate 1
        Alpha2      = Params(:,3);    % Learning Rate 2
        Beta1       = Params(:,4);    % Beta 1
        Beta2       = Params(:,5);    % Beta 2
        Lambda      = Params(:,6);    % Eligibility Trace
        StickToAct1 = Params(:,7);    % Stickness to repeat the same first state
        StickToAct2 = 0;              % Stickness to repeat the same second state
        NoiseProb1  = Params(:,8);    % Noise Ratio for first state
        NoiseProb2  = Params(:,8);    % Noise Ratio for first state
    case 'Daw8Param'
        W           = Params(:,1);    % combination wight
        Alpha1      = Params(:,2);    % Learning Rate 1
        Alpha2      = Params(:,3);    % Learning Rate 2
        Beta1       = Params(:,4);    % Beta 1
        Beta2       = Params(:,5);    % Beta 2
        Lambda      = Params(:,6);    % Eligibility Trace
        StickToAct1 = Params(:,7);    % Stickness to repeat the same first state
        StickToAct2 = Params(:,8);    % Stickness to repeat the same second state
        NoiseProb1  = Params(:,9);    % Noise Ratio for first state
        NoiseProb2  = Params(:,9);    % Noise Ratio for first state
end
WMat=repmat(W',2,1);
Beta1Mat=repmat(Beta1',2,1);
Beta2Mat=repmat(Beta2',2,1);
% Initialization
Q=zeros(4,2,SNum);
Q_MF=zeros(2,SNum);
QFirstLevel=zeros(2,SNum);
PreviusAction=randi(2,2,SNum);
% PreviusAction=ones(2,SNum);
SelectAction=zeros(2,SNum);
DoneAction=zeros(2,SNum);
NSSA=zeros(3,4,2,SNum);
CommonProbability=Env.PSSA(1 , 2 , 1 );
% loop through trials
for Trial = 1: Env.TNum
% FIRST LEVEL
    % Add the value of stickness to first action (update Stick to action)
    Index = 2*(0:(SNum-1)) + PreviusAction(1,:);%sub2ind([2,SNum],PreviusAction(1,:),1:SNum);
    QFirstLevel(Index) = QFirstLevel(Index) + StickToAct1';
    % Extract Policy
    P1 = exp(Beta1'.*QFirstLevel(1,:))./sum(exp(Beta1Mat.*QFirstLevel),1);
    P1 = max(min(P1,1),0); % to avoide inf! or zero value cused by big Value or became nan
    % Select First Level Action
    SelectAction(1,:)=1+(rand(1,SNum)>P1);
    %Add Noise to First Level
    NoiseFlag = rand(1,SNum)<NoiseProb1';
    DoneAction(1,:)= NoiseFlag.*3 + ((-1).^NoiseFlag).*SelectAction(1,:);
    % Do the action and change the state to second level
    CommonTrans=rand(1,SNum)<CommonProbability;
    State=DoneAction(1,:)+CommonTrans+(2*(DoneAction(1,:)==1).*(~CommonTrans));
% SECOND LEVEL
    % Add the value of stickness to second action (update Stick to action)
    QHat=Q;
    Index=8*(0:(SNum-1)) + 4*(PreviusAction(2,:)-1) + State;%sub2ind([4,2,SNum],State,PreviusAction(2,:),1:SNum);
    QHat(Index)=QHat(Index)+StickToAct2';
    % Second Level Policy
    Index=8*(0:(SNum-1)) + State;%sub2ind([4,2,SNum],State,ones(1,SNum),1:SNum);
    P2 = exp(Beta2'.*QHat(Index))./sum(exp(Beta2Mat.*QHat([Index;Index+4])));% Index+4 is index to second action in same state
    P2 = max(min(P2,1),0); % to avoide inf! or zero value cused by big Value or became nan
    % Select Second Level Action
    SelectAction(2,:)=1+(rand(1,SNum)>P2);
    %Add Noise to Second Level
    NoiseFlag = rand(1,SNum)<NoiseProb2';
    DoneAction(2,:)= NoiseFlag.*3 + ((-1).^NoiseFlag).*SelectAction(2,:);
    % Do the second action and get reward
    TrialTransitionRewardProb=Env.TransitionRewardProb(:,:,:,Trial);
    Index=(12*(DoneAction(2,:)-1)+(State-1)+10);%sub2ind([3,4,2],State,4*ones(1,SNum),DoneAction(2,:));
    RewardPro=TrialTransitionRewardProb(Index);
    Reward=rand(1,SNum)<RewardPro;
% LEARNING
    % Learn First level for MF
    Index1=2*(0:(SNum-1)) + DoneAction(1,:);%sub2ind([2,SNum],DoneAction(1,:),1:SNum);
    Index2=8*(0:(SNum-1)) + 4*(DoneAction(2,:)-1) + State;%sub2ind([4,2,SNum],State,DoneAction(2,:),1:SNum);
    Q_MF(Index1)=Q_MF(Index1)+Alpha2'.*(Q(Index2)-Q_MF(Index1)) + ...
                      Lambda'.* Alpha2'.* (Reward- Q(Index2));
    % Learn second level options
    Q(Index2)=Q(Index2)+Alpha1'.*(Reward - Q(Index2));
    % Update NSSA and calqulate PSSA 
    Index=24*(0:(SNum-1))+12*(DoneAction(1,:)-1)+3*(State-1)+1;%sub2ind([3,4,2,SNum],ones(1,SNum),State,DoneAction(1,:),1:SNum);
    NSSA(Index)=NSSA(Index)+1;
    PSSA=NSSA./repmat(sum(NSSA,3),1,1,2,1);
    PSSA(isnan(PSSA))=0;
    % Calqulation of Q Model Based
    MaxQ_S = max(Q(2:3,:,:),[],2);
    Q_MB(1,:) = PSSA(1,2,1)*MaxQ_S(1,1,:)+PSSA(1,3,1)*MaxQ_S(2,1,:); 
    Q_MB(2,:) = PSSA(1,2,2)*MaxQ_S(1,1,:)+PSSA(1,3,2)*MaxQ_S(2,1,:);
    % Combine the model based and model free
    QFirstLevel = WMat .* Q_MB + (1-WMat) .* Q_MF;

    % Save Previus action for stikness
    PreviusAction=SelectAction;
    % Stuff
    Observe.ASARCMat(Trial,:,:) = [DoneAction(1,:);State;DoneAction(2,:);Reward;CommonTrans];
end
end