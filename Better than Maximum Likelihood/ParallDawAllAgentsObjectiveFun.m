function [Obj]= ParallDawAllAgentsObjectiveFun(Observe,Params,ParamMethod,ObjectiveMethod,CalculateFlag)


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
%       ParamMethod: sring name of param method 
%
% OUTPUTS:
%       Observe : the output observation of a behavior including this filds:
%           ASARCMat :the First Action ,second level State , Second Action 
%                 Trial Reward and Common Transition flag for each trial.  
%           Confidence : is the confidance of selected choise by agents
%               which means that its the probability of choose the chosen
%               action.
%           NoisyConfidence : due to model the meturment of confidence from
%               humans the real confidance alwayse add by a normal
%               distributed random number.
% see also : GetEnv , DawReinforcmenLearningAgent , ParallExtractDawPStay
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

if ~any(CalculateFlag)
    Obj=inf(size(Observe.ASARCMat,3),1);
    return
end
TrialNum=size(Observe.ASARCMat,1);

% Get Params
switch ParamMethod
    case 'Daw3ParamV1'
        W           = Params(CalculateFlag,1);    % combination wight
        Alpha1      = Params(CalculateFlag,2);    % Learning Rate 1
        Alpha2      = Params(CalculateFlag,2);    % Learning Rate 2
        Beta1       = Params(CalculateFlag,3);    % Beta 1
        Beta2       = Params(CalculateFlag,3);    % Beta 2
        Lambda      = 1;            % Eligibility Trace <- differnt in V1 and V2
        StickToAct1 = 0;            % Stickness to repeat the same first state
        StickToAct2 = 0;            % Stickness to repeat the same second state
    case 'Daw3ParamV2'
        W           = Params(CalculateFlag,1);    % combination wight
        Alpha1      = Params(CalculateFlag,2);    % Learning Rate 1
        Alpha2      = Params(CalculateFlag,2);    % Learning Rate 2
        Beta1       = Params(CalculateFlag,3);    % Beta 1
        Beta2       = Params(CalculateFlag,3);    % Beta 2
        Lambda      = 0;            % Eligibility Trace <- differnt in V1 and V2
        StickToAct1 = 0;            % Stickness to repeat the same first state
        StickToAct2 = 0;            % Stickness to repeat the same second state
    case 'Daw4Param'
        W           = Params(CalculateFlag,1);    % combination wight
        Alpha1      = Params(CalculateFlag,2);    % Learning Rate 1
        Alpha2      = Params(CalculateFlag,2);    % Learning Rate 2
        Beta1       = Params(CalculateFlag,3);    % Beta 1
        Beta2       = Params(CalculateFlag,3);    % Beta 2
        Lambda      = Params(CalculateFlag,4);    % Eligibility Trace
        StickToAct1 = 0;            % Stickness to repeat the same first state
        StickToAct2 = 0;            % Stickness to repeat the same second state
    case 'Daw5ParamV0'
        W           = Params(CalculateFlag,1);    % combination wight
        Alpha1      = Params(CalculateFlag,2);    % Learning Rate 1
        Alpha2      = Params(CalculateFlag,2);    % Learning Rate 2
        Beta1       = Params(CalculateFlag,3);    % Beta 1
        Beta2       = Params(CalculateFlag,3);    % Beta 2
        Lambda      = Params(CalculateFlag,4);    % Eligibility Trace
        StickToAct1 = Params(CalculateFlag,5);    % Stickness to repeat the same first state
        StickToAct2 = 0;            % Stickness to repeat the same second state
    case 'Daw5ParamV1'
        W           = Params(CalculateFlag,1);    % combination wight
        Alpha1      = Params(CalculateFlag,2);    % Learning Rate 1
        Alpha2      = Params(CalculateFlag,3);    % Learning Rate 2
        Beta1       = Params(CalculateFlag,4);    % Beta 1
        Beta2       = Params(CalculateFlag,5);    % Beta 2
        Lambda      = 1;                          % Eligibility Trace
        StickToAct1 = 0;            % Stickness to repeat the same first state
        StickToAct2 = 0;            % Stickness to repeat the same second state
    case 'Daw5ParamV2'
        W           = Params(CalculateFlag,1);    % combination wight
        Alpha1      = Params(CalculateFlag,2);    % Learning Rate 1
        Alpha2      = Params(CalculateFlag,3);    % Learning Rate 2
        Beta1       = Params(CalculateFlag,4);    % Beta 1
        Beta2       = Params(CalculateFlag,5);    % Beta 2
        Lambda      = 0;                          % Eligibility Trace
        StickToAct1 = 0;            % Stickness to repeat the same first state
        StickToAct2 = 0;            % Stickness to repeat the same second state
    case 'Daw6Param'
        W           = Params(CalculateFlag,1);    % combination wight
        Alpha1      = Params(CalculateFlag,2);    % Learning Rate 1
        Alpha2      = Params(CalculateFlag,3);    % Learning Rate 2
        Beta1       = Params(CalculateFlag,4);    % Beta 1
        Beta2       = Params(CalculateFlag,5);    % Beta 2
        Lambda      = Params(CalculateFlag,6);    % Eligibility Trace
        StickToAct1 = 0;            % Stickness to repeat the same first state
        StickToAct2 = 0;            % Stickness to repeat the same second state
    case 'Daw7ParamV1'
        W           = Params(CalculateFlag,1);    % combination wight
        Alpha1      = Params(CalculateFlag,2);    % Learning Rate 1
        Alpha2      = Params(CalculateFlag,3);    % Learning Rate 2
        Beta1       = Params(CalculateFlag,4);    % Beta 1
        Beta2       = Params(CalculateFlag,5);    % Beta 2
        Lambda      = Params(CalculateFlag,6);    % Eligibility Trace
        StickToAct1 = Params(CalculateFlag,7);    % Stickness to repeat the same first state
        StickToAct2 = Params(CalculateFlag,7);    % Stickness to repeat the same second state
    case 'Daw7ParamV2'
        W           = Params(CalculateFlag,1);    % combination wight
        Alpha1      = Params(CalculateFlag,2);    % Learning Rate 1
        Alpha2      = Params(CalculateFlag,3);    % Learning Rate 2
        Beta1       = Params(CalculateFlag,4);    % Beta 1
        Beta2       = Params(CalculateFlag,5);    % Beta 2
        Lambda      = Params(CalculateFlag,6);    % Eligibility Trace
        StickToAct1 = Params(CalculateFlag,7);    % Stickness to repeat the same first state
        StickToAct2 = 0;                          % Stickness to repeat the same second state
    case 'Daw8Param'
        W           = Params(CalculateFlag,1);    % combination wight
        Alpha1      = Params(CalculateFlag,2);    % Learning Rate 1
        Alpha2      = Params(CalculateFlag,3);    % Learning Rate 2
        Beta1       = Params(CalculateFlag,4);    % Beta 1
        Beta2       = Params(CalculateFlag,5);    % Beta 2
        Lambda      = Params(CalculateFlag,6);    % Eligibility Trace
        StickToAct1 = Params(CalculateFlag,7);    % Stickness to repeat the same first state
        StickToAct2 = Params(CalculateFlag,8);    % Stickness to repeat the same second state
end
WMat=repmat(W',2,1);
Beta1Mat=repmat(Beta1',2,1);
Beta2Mat=repmat(Beta2',2,1);

SNum = sum(CalculateFlag);

% Initialization
Q=zeros(4,2,SNum);
Q_MF=zeros(2,SNum);
QFirstLevel=zeros(2,SNum);
PreviusAction=randi(2,2,SNum);
% PreviusAction=ones(2,SNum);
SelectedP=zeros(TrialNum,2,SNum);
Action=zeros(2,SNum);
State =zeros(1,SNum);
Reward=zeros(1,SNum);
NSSA=zeros(3,4,2,SNum);
% loop through trials
for Trial = 1: TrialNum
    Action(1,:) = Observe.ASARCMat(Trial,1,CalculateFlag);
    Action(2,:) = Observe.ASARCMat(Trial,3,CalculateFlag);
    State(:)    = Observe.ASARCMat(Trial,2,CalculateFlag);
    Reward(:)   = Observe.ASARCMat(Trial,4,CalculateFlag);
    
% FIRST LEVEL    
    % Add the value of stickness to first action (update Stick to action)
    Index = 2*(0:(SNum-1)) + PreviusAction(1,:);%sub2ind([2,SNum],PreviusAction(1,:),1:SNum);
    QFirstLevel(Index) = QFirstLevel(Index) + StickToAct1';
    % Extract Policy
    P1 = exp(Beta1'.*QFirstLevel(1,:))./sum(exp(Beta1Mat.*QFirstLevel),1);
    P1 = max(min(P1,1),0); % to avoide inf! or zero value cused by big Value or became nan
    P = [P1;1-P1];
    % First level
    Index = 2*(0:(SNum-1)) + Action(1,:);%sub2ind([2,SNum],Action(1,:),1:SNum);
    SelectedP(Trial,1,:)=P(Index);
% SECOND LEVEL
    % Add the value of stickness to second action (update Stick to action)
    QHat=Q;
    Index=8*(0:(SNum-1)) + 4*(PreviusAction(2,:)-1) + State;%sub2ind([4,2,SNum],State,PreviusAction(2,:),1:SNum);
    QHat(Index)=QHat(Index)+StickToAct2';
    % Second Level Policy
    Index=8*(0:(SNum-1)) + State;%sub2ind([4,2,SNum],State,ones(1,SNum),1:SNum);
    P2 = exp(Beta2'.*QHat(Index))./sum(exp(Beta2Mat.*QHat([Index;Index+4])));
    P2 = max(min(P2,1),0); % to avoide inf! or zero value cused by big Value or became nan
    P = [P2;1-P2];
    % Scond level
    Index = 2*(0:(SNum-1)) + Action(2,:);%sub2ind([2,SNum],Action(2,:),1:SNum);
    SelectedP(Trial,2,:)=P(Index);
% LEARNING
    % Learn First level for MF
    Index1=2*(0:(SNum-1)) + Action(1,:);%sub2ind([2,SNum],Action(1,:),1:SNum);
    Index2=8*(0:(SNum-1)) + 4*(Action(2,:)-1) + State;%sub2ind([4,2,SNum],State,Action(2,:),1:SNum);
    Q_MF(Index1)=Q_MF(Index1)+Alpha2'.*(Q(Index2)-Q_MF(Index1)) + ...
                      Lambda'.* Alpha2'.* (Reward- Q(Index2));
    % Learn second level options
    Q(Index2)=Q(Index2)+Alpha1'.*(Reward - Q(Index2));
    % Update NSSA and calqulate PSSA 
    Index=24*(0:(SNum-1))+12*(Action(1,:)-1)+3*(State-1)+1;%sub2ind([3,4,2,SNum],ones(1,SNum),State,Action(1,:),1:SNum);
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
    PreviusAction=Action;
end

switch ObjectiveMethod
    case 'MLE'
        TempObj= - sum(log(SelectedP(:,1,:)),1)-sum(log(SelectedP(:,2,:)),1);
        TempObj=TempObj(:);
    case 'MAP'
        Priors=GetPriorKnowlageValues(Params(CalculateFlag,:),ParamMethod,'GurshmanBetaPriors');
        TempObj= - sum(log(SelectedP(:,1,:)),1)-sum(log(SelectedP(:,2,:)),1);
        TempObj=TempObj(:)+Priors(:);
    case 'MAP2'
        Priors=GetPriorKnowlageValues(Params(CalculateFlag,:),ParamMethod,'GurshmanBetaPriors');
        TempObj= - sum(log(SelectedP(:,1,:)),1)-sum(log(SelectedP(:,2,:)),1);
        TempObj=TempObj(:)+Priors(:)*TrialNum;
    case 'FirstStepMLE'
        TempObj= - sum(log(SelectedP(:,1,:)),1);
        TempObj=TempObj(:);
    case 'FirstStepMAP'
        Priors=GetPriorKnowlageValues(Params(CalculateFlag,:),ParamMethod,'GurshmanBetaPriors');
        TempObj= - sum(log(SelectedP(:,1,:)),1);
        TempObj=TempObj(:)+Priors(:);
    case 'FirstStepMAP2'
        Priors=GetPriorKnowlageValues(Params(CalculateFlag,:),ParamMethod,'GurshmanBetaPriors');
        TempObj= - sum(log(SelectedP(:,1,:)),1);
        TempObj=TempObj(:)+Priors(:)*TrialNum;
    otherwise
        error('unknown Objective Method!!')
end
Obj=inf(size(Observe.ASARCMat,3),1);
Obj(CalculateFlag)=TempObj;
end
