function PStay=ParallExtractDawPStay(Observe,Label)
% Extract the probabillity of stay on doing the same action in 4 differnt
%       situation action from standard Parallel Observation Structure.
%
% USAGE:
%       PStay = ExtractDawPStay(Observe)
% INPUTS:
%       Observe : the output observation of agents behavior including the
%           ASARCMat fild which is the First Action ,second level State ,
%               Second Action , Trial Reward and Common Transition flag for
%               each trial.
%           Other fild like Confidence and NoisyConfidence did not used in
%               this function
% OUTPUTS:
%           PStay is an array (size:2x2xN) of Pstay in four different
%               condition : 
%               [  Rewarded_Common  Unrewarded_Common
%                  Rewarded_Rear    Unrewarded_Rear] x N
%               N is number of agents
% 
% The environment of task is:
%                           __________ 
%                          |          |
%                          |    S1    |
%                          |__________|
%                           /        \
%                        /             \
%                      /                 \
%            __________                    __________
%           |          |                  |          |
%           |    S2    |                  |    S3    |
%           |__________|                  |__________|
%             /     \                        /     \
%            /       \                      /       \
%    __________     __________     __________     __________
%   |          |   |          |   |          |   |          |
%   |    S4    |   |    S5    |   |    S6    |   |    S7    |
%   |__________|   |__________|   |__________|   |__________|
% 
% see also : ParallDawReinforcmenLearningAgents
% Sadjad yazdani, Feb 2017 (sajjad.yazdani@ut.ac.ir)

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

if nargin<2
    Label=true(size(Observe.ASARCMat,3),1);
end
Stay=Observe.ASARCMat(1:end-1,1,Label)==Observe.ASARCMat(2:end,1,Label);
Rewarded=Observe.ASARCMat(1:end-1,4,Label);
Common  =Observe.ASARCMat(1:end-1,5,Label);

PStay(1,1,:) = sum( Rewarded.* Common.*Stay)./sum( Rewarded.* Common);% ReC
PStay(1,2,:) = sum( Rewarded.*~Common.*Stay)./sum( Rewarded.*~Common);% ReR
PStay(2,1,:) = sum(~Rewarded.* Common.*Stay)./sum(~Rewarded.* Common);% UrC
PStay(2,2,:) = sum(~Rewarded.*~Common.*Stay)./sum(~Rewarded.*~Common);% UrR






