function [P,N]=ParallExtractStochasticFeatures(Observe,Env)

BestActs=zeros(Env.TNum,2);
RewardsProb=zeros(2);
RewardsProbMat=zeros(Env.TNum,2,2);
FirstLevelProbability=zeros(Env.TNum,2);
for t=1:Env.TNum
    RewardsProb(:)=Env.TransitionRewardProb(2:3,4,:,t);
    RewardsProbMat(t,:,:)=RewardsProb;
    FirstLevelProbability(t,:)=max(RewardsProb,[],2);
    [~,BestActs(t,1)]=max(FirstLevelProbability(t,:));
    [~,BestActs(t,2)]=max(RewardsProb(BestActs(t,1),:));
end
SubjectNums=size(Observe.ASARCMat,3);
%% Extract trials Value
    Stay=Observe.ASARCMat(1:end-1,1,:)==Observe.ASARCMat(2:end,1,:);
    Rewarded=Observe.ASARCMat(1:end-1,4,:)==1;
    Common  =Observe.ASARCMat(1:end-1,5,:)==1;
    BestSel1=Observe.ASARCMat(2:end,1,:)==repmat(BestActs(2:end,1),1,1,SubjectNums);
    BestSel2=Observe.ASARCMat(2:end,3,:)==repmat(BestActs(2:end,2),1,1,SubjectNums);
    BestSel = BestSel1&BestSel2;
    
%% Stochastic -----------------------------------------------------------------------------------------------
    P(:,1) = sum(Stay)                              ./size(Stay,1);                     N{1} ='P(S)';
    P(:,2) = sum(Stay& Rewarded)                    ./sum( Rewarded);                   N{2} ='P(S|Re)';
    P(:,3) = sum(Stay&~Rewarded)                    ./sum(~Rewarded);                   N{3} ='P(S|Ur)';
    P(:,4) = sum(Stay& Common  )                    ./sum( Common);                     N{4} ='P(S|C)';
    P(:,5) = sum(Stay&~Common  )                    ./sum(~Common);                     N{5} ='P(S|R)';
    P(:,6) = sum(Stay& BestSel )                    ./sum( BestSel);                    N{6} ='P(S|B)';
    P(:,7) = sum(Stay&~BestSel )                    ./sum(~BestSel);                    N{7} ='P(S|NB)';
    P(:,8) = sum(Stay& Rewarded& Common  )          ./sum( Rewarded& Common);           N{8} ='P(S|Re,C)'; 
    P(:,9) = sum(Stay& Rewarded&~Common  )          ./sum( Rewarded&~Common);           N{9} ='P(S|Re,R)';
    P(:,10)= sum(Stay&~Rewarded& Common  )          ./sum(~Rewarded& Common);           N{10}='P(S|Ur,C)';
    P(:,11)= sum(Stay&~Rewarded&~Common  )          ./sum(~Rewarded&~Common);           N{11}='P(S|Ur,R)';
    P(:,12)= sum(Stay& BestSel & Common  )          ./sum( BestSel & Common);           N{12}='P(S|B,C)';
    P(:,13)= sum(Stay& BestSel &~Common  )          ./sum( BestSel &~Common);           N{13}='P(S|B,R)';
    P(:,14)= sum(Stay&~BestSel & Common  )          ./sum(~BestSel & Common);           N{14}='P(S|NB,C)';
    P(:,15)= sum(Stay&~BestSel &~Common  )          ./sum(~BestSel &~Common);           N{15}='P(S|NB,R)';
    P(:,16)= sum(Stay& BestSel & Rewarded)          ./sum( BestSel & Rewarded);         N{16}='P(S|B,Re)';
    P(:,17)= sum(Stay& BestSel &~Rewarded)          ./sum( BestSel &~Rewarded);         N{17}='P(S|B,Ur)';
    P(:,18)= sum(Stay&~BestSel & Rewarded)          ./sum(~BestSel & Rewarded);         N{18}='P(S|NB,Re)';
    P(:,19)= sum(Stay&~BestSel &~Rewarded)          ./sum(~BestSel &~Rewarded);         N{19}='P(S|NB,Ur)';
    P(:,20)= sum(Stay& BestSel & Common  & Rewarded)./sum( BestSel& Common& Rewarded);  N{20}='P(S|B,C,Re)';
    P(:,21)= sum(Stay& BestSel & Common  &~Rewarded)./sum( BestSel& Common&~Rewarded);  N{21}='P(S|B,C,Ur)';
    P(:,22)= sum(Stay& BestSel &~Common  & Rewarded)./sum( BestSel&~Common& Rewarded);  N{22}='P(S|B,R,Re)';
    P(:,23)= sum(Stay& BestSel &~Common  &~Rewarded)./sum( BestSel&~Common&~Rewarded);  N{23}='P(S|B,R,Ur)';
    P(:,24)= sum(Stay&~BestSel & Common  & Rewarded)./sum(~BestSel& Common& Rewarded);  N{24}='P(S|NB,C,Re)';
    P(:,25)= sum(Stay&~BestSel & Common  &~Rewarded)./sum(~BestSel& Common&~Rewarded);  N{25}='P(S|NB,C,Ur)';
    P(:,26)= sum(Stay&~BestSel &~Common  & Rewarded)./sum(~BestSel&~Common& Rewarded);  N{26}='P(S|NB,R,Re)';
    P(:,27)= sum(Stay&~BestSel &~Common  &~Rewarded)./sum(~BestSel&~Common&~Rewarded);  N{27}='P(S|NB,R,Ur)';

    P(isnan(P))=0;
    


