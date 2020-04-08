function [Obj]= DawAgentsObjectiveFun(ASARCMat,Params,ParamMethod,ObjectiveMethod,CalculateFlag)


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

TrialNum=size(ASARCMat,1);

% Get Params
switch ParamMethod
    case 'Daw3ParamV1'
        W           = Params(1);    % combination wight
        Alpha1      = Params(2);    % Learning Rate 1
        Alpha2      = Params(2);    % Learning Rate 2
        Beta1       = Params(3);    % Beta 1
        Beta2       = Params(3);    % Beta 2
        Lambda      = 1;            % Eligibility Trace <- differnt in V1 and V2
        StickToAct1 = 0;            % Stickness to repeat the same first state
        StickToAct2 = 0;            % Stickness to repeat the same second state
    case 'Daw3ParamV2'
        W           = Params(1);    % combination wight
        Alpha1      = Params(2);    % Learning Rate 1
        Alpha2      = Params(2);    % Learning Rate 2
        Beta1       = Params(3);    % Beta 1
        Beta2       = Params(3);    % Beta 2
        Lambda      = 0;            % Eligibility Trace <- differnt in V1 and V2
        StickToAct1 = 0;            % Stickness to repeat the same first state
        StickToAct2 = 0;            % Stickness to repeat the same second state
    case 'Daw4Param'
        W           = Params(1);    % combination wight
        Alpha1      = Params(2);    % Learning Rate 1
        Alpha2      = Params(2);    % Learning Rate 2
        Beta1       = Params(3);    % Beta 1
        Beta2       = Params(3);    % Beta 2
        Lambda      = Params(4);    % Eligibility Trace
        StickToAct1 = 0;            % Stickness to repeat the same first state
        StickToAct2 = 0;            % Stickness to repeat the same second state
    case 'Daw5ParamV0'
        W           = Params(1);    % combination wight
        Alpha1      = Params(2);    % Learning Rate 1
        Alpha2      = Params(2);    % Learning Rate 2
        Beta1       = Params(3);    % Beta 1
        Beta2       = Params(3);    % Beta 2
        Lambda      = Params(4);    % Eligibility Trace
        StickToAct1 = Params(5);    % Stickness to repeat the same first state
        StickToAct2 = 0;            % Stickness to repeat the same second state
    case 'Daw5ParamV1'
        W           = Params(1);    % combination wight
        Alpha1      = Params(2);    % Learning Rate 1
        Alpha2      = Params(3);    % Learning Rate 2
        Beta1       = Params(4);    % Beta 1
        Beta2       = Params(5);    % Beta 2
        Lambda      = 1;                          % Eligibility Trace
        StickToAct1 = 0;            % Stickness to repeat the same first state
        StickToAct2 = 0;            % Stickness to repeat the same second state
    case 'Daw5ParamV2'
        W           = Params(1);    % combination wight
        Alpha1      = Params(2);    % Learning Rate 1
        Alpha2      = Params(3);    % Learning Rate 2
        Beta1       = Params(4);    % Beta 1
        Beta2       = Params(5);    % Beta 2
        Lambda      = 0;                          % Eligibility Trace
        StickToAct1 = 0;            % Stickness to repeat the same first state
        StickToAct2 = 0;            % Stickness to repeat the same second state
    case 'Daw6Param'
        W           = Params(1);    % combination wight
        Alpha1      = Params(2);    % Learning Rate 1
        Alpha2      = Params(3);    % Learning Rate 2
        Beta1       = Params(4);    % Beta 1
        Beta2       = Params(5);    % Beta 2
        Lambda      = Params(6);    % Eligibility Trace
        StickToAct1 = 0;            % Stickness to repeat the same first state
        StickToAct2 = 0;            % Stickness to repeat the same second state
    case 'Daw7ParamV1'
        W           = Params(1);    % combination wight
        Alpha1      = Params(2);    % Learning Rate 1
        Alpha2      = Params(3);    % Learning Rate 2
        Beta1       = Params(4);    % Beta 1
        Beta2       = Params(5);    % Beta 2
        Lambda      = Params(6);    % Eligibility Trace
        StickToAct1 = Params(7);    % Stickness to repeat the same first state
        StickToAct2 = Params(7);    % Stickness to repeat the same second state
    case 'Daw7ParamV2'
        W           = Params(1);    % combination wight
        Alpha1      = Params(2);    % Learning Rate 1
        Alpha2      = Params(3);    % Learning Rate 2
        Beta1       = Params(4);    % Beta 1
        Beta2       = Params(5);    % Beta 2
        Lambda      = Params(6);    % Eligibility Trace
        StickToAct1 = Params(7);    % Stickness to repeat the same first state
        StickToAct2 = 0;                          % Stickness to repeat the same second state
    case 'Daw8Param'
        W           = Params(1);    % combination wight
        Alpha1      = Params(2);    % Learning Rate 1
        Alpha2      = Params(3);    % Learning Rate 2
        Beta1       = Params(4);    % Beta 1
        Beta2       = Params(5);    % Beta 2
        Lambda      = Params(6);    % Eligibility Trace
        StickToAct1 = Params(7);    % Stickness to repeat the same first state
        StickToAct2 = Params(8);    % Stickness to repeat the same second state
end
WMat=repmat(W',2,1);
Beta1Mat=repmat(Beta1,2,1);
Beta2Mat=repmat(Beta2,1,2);

SNum = size(Params,1);

% Initialization
Q=zeros(4,2);
Q_MF=zeros(2,1);
Q_MB=zeros(2,1);
QFirstLevel=zeros(2,1);
PreviusAction=randi(2,2,1);
SelectedP=zeros(TrialNum,2);
NSSA=zeros(3,4,2);
% loop through trials
for Trial = 1: TrialNum
    Action(1) = ASARCMat(Trial,1);
    Action(2) = ASARCMat(Trial,3);
    State     = ASARCMat(Trial,2);
    Reward    = ASARCMat(Trial,4);
    
% FIRST LEVEL    
    % Add the value of stickness to first action (update Stick to action)
    QFirstLevel(PreviusAction(1)) = QFirstLevel(PreviusAction(1)) + StickToAct1;
    % Extract Policy
    P1 = exp(Beta1.*QFirstLevel(1))/sum(exp(Beta1Mat.*QFirstLevel),1);
    P1 = max(min(P1,1),0); % to avoide inf! or zero value cused by big Value or became nan
    P = [P1;1-P1];
    % First level
    SelectedP(Trial,1)=P(Action(1));
% SECOND LEVEL
    % Add the value of stickness to second action (update Stick to action)
    QHat=Q;
    QHat(State,PreviusAction(2))=QHat(State,PreviusAction(2))+StickToAct2;
    % Second Level Policy
    P2 = exp(Beta2.*QHat(State,1))./sum(exp(Beta2Mat.*QHat(State,:)));
    P2 = max(min(P2,1),0); % to avoide inf! or zero value cused by big Value or became nan
    P = [P2;1-P2];
    % Scond level
    SelectedP(Trial,2)=P(Action(2));
% LEARNING
    % Learn First level for MF
    Q_MF(Action(1))=Q_MF(Action(1))+Alpha2.*(Q(State,Action(2))-Q_MF(Action(1))) + ...
                      Lambda'.* Alpha2'.* (Reward- Q(State,Action(2)));
    % Learn second level options
    Q(State,Action(2))=Q(State,Action(2))+Alpha1'.*(Reward - Q(State,Action(2)));
    % Update NSSA and calqulate PSSA 
    NSSA(1,State,Action(1))=NSSA(1,State,Action(1))+1;
    PSSA=NSSA./repmat(sum(NSSA,3),1,1,2);
    PSSA(isnan(PSSA))=0;
    % Calqulation of Q Model Based
    MaxQ_S = max(Q(2:3,:),[],2);
    Q_MB(1) = PSSA(1,2,1)*MaxQ_S(1,1,:)+PSSA(1,3,1)*MaxQ_S(2,1,:); 
    Q_MB(2) = PSSA(1,2,2)*MaxQ_S(1,1,:)+PSSA(1,3,2)*MaxQ_S(2,1,:);
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
Obj=inf(size(ASARCMat,3),1);
Obj(CalculateFlag)=TempObj;
end
