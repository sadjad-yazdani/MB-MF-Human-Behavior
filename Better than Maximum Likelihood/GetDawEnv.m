function Env=GetDawEnv(Method,RewardFileName)

% Make Environment Structure that contain data about the Traial Number and
% Reward Probability
% USAGE:
%       Env=GetEnv(Method)
%       Env=GetEnv(Method,RewardFileName)
%
% INPUTS:
%   Method :
%       Method of Reward probability which can be any of this value:
%           RandomWalk          : Totaly Random Walk
%           RandomWalkSelected  : Random Walks that seams to be Stabel
%           SinRandomWalk       : Sinouside Rewards with different phase
%           LoadReward          : loade a save Reward which is specified in
%                                 the RewardFileName
% RewardFileName: in case that method is LoadReward this input specified
%   the path to the file

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



Env.TNum = 201; % Number of Trial is 201 base on daw2011 and is 150 Based on Gaze ...


Env.PSSA = zeros(4,4,2);

CommonTransition=0.7;
ReareTransition =0.3;
%        S1  S2  A   Probability of Transition
Env.PSSA(1 , 2 , 1 )=CommonTransition;
Env.PSSA(1 , 3 , 1 )=ReareTransition;
Env.PSSA(1 , 3 , 2 )=CommonTransition;
Env.PSSA(1 , 2 , 2 )=ReareTransition;
Env.PSSA(2 , 4 , 1 )=1;
Env.PSSA(2 , 4 , 2 )=1;
Env.PSSA(3 , 4 , 1 )=1;
Env.PSSA(3 , 4 , 2 )=1;
switch Method
    case 'RandomWalk'
        % the range of random walks prob
        ProbRange = [0.25,0.75];
        % standard dev for random walk
        RandomWalkSD = 0.025;
        RewardProb = GusianRandomwalk(RandomWalkSD,ProbRange,4,Env.TNum);
        Env.TransitionRewardProb(2 , 4 , 1 ,:)=RewardProb(:,1);
        Env.TransitionRewardProb(2 , 4 , 2 ,:)=RewardProb(:,2);
        Env.TransitionRewardProb(3 , 4 , 1 ,:)=RewardProb(:,3);
        Env.TransitionRewardProb(3 , 4 , 2 ,:)=RewardProb(:,4);
    case 'RandomWalkSelected'
        % the range of random walks prob
        ProbRange = [0.25,0.75];
        % standard dev for random walk
        RandomWalkSD = 0.025;
        
        GoodRngSeed=[2 14 25 27 37 42 52 53 55 56 58 60 68 75 79 80];
        OldRng=rng();
        rng(randsample(GoodRngSeed,1));
        RewardProb = GusianRandomwalk(RandomWalkSD,ProbRange,4,Env.TNum);
        rng(OldRng);
        Env.TransitionRewardProb(2 , 4 , 1 ,:)=RewardProb(:,1);
        Env.TransitionRewardProb(2 , 4 , 2 ,:)=RewardProb(:,2);
        Env.TransitionRewardProb(3 , 4 , 1 ,:)=RewardProb(:,3);
        Env.TransitionRewardProb(3 , 4 , 2 ,:)=RewardProb(:,4);
    case 'SinRandomWalk'
        % the range of random walks prob
        ProbRange = [0.25,0.75];
        % standard dev for random walk
        RandomWalkSD = 0.25;
        RewardProb = SinGusianRandomwalk(RandomWalkSD,ProbRange,4,Env.TNum);
        Env.TransitionRewardProb(2 , 4 , 1 ,:)=RewardProb(:,1);
        Env.TransitionRewardProb(2 , 4 , 2 ,:)=RewardProb(:,2);
        Env.TransitionRewardProb(3 , 4 , 1 ,:)=RewardProb(:,3);
        Env.TransitionRewardProb(3 , 4 , 2 ,:)=RewardProb(:,4);
    case 'LoadReward'
        Loaded=load(RewardFileName);
        Env.TransitionRewardProb    = Loaded.TransitionRewardProb;
end



function Probability=GusianRandomwalk(RandomWalkSD,ProbRange,SNum,TNum)
Probability = normrnd(0,RandomWalkSD,[TNum, SNum]);
Probability = cumsum(Probability, 1);
Probability =(Probability-repmat(min(Probability),TNum,1))./repmat((max(Probability)-min(Probability)),TNum,1);
Probability = ProbRange(1) + Probability * (ProbRange(2)-ProbRange(1));

function Probability=SinGusianRandomwalk(RandomWalkSD,ProbRange,SNum,TNum)
t=linspace(0,2*pi,TNum)';
Phi=linspace(0,2*pi,SNum+1);
Phi(end)=[];
T=repmat(Phi,TNum,1)+repmat(t,1,SNum);
T=T+normrnd(0,RandomWalkSD,[TNum, SNum]);
Probability=sin(T);
Probability =(Probability-repmat(min(Probability),TNum,1))./repmat((max(Probability)-min(Probability)),TNum,1);
Probability = ProbRange(1) + Probability * (ProbRange(2)-ProbRange(1));


