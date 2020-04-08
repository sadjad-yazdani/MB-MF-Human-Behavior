function [Best,FX1]=DawInteriorPointFitting(Observe,FittingBoundry,ParamMethod,ObjectiveMethod,StartNumber,MaxIter,DisplayMsg,Sofar,Total)
SNum=size(Observe.ASARCMat,3);
PNum=length(FittingBoundry.Low);
Best=zeros(SNum,PNum);
FX1=zeros(SNum,1);
OptimizerOptions = optimset('Display','off','MaxIter',MaxIter,'TolX',0.01,'Algorithm','interior-point');
for S=1:SNum
if mod(S,20)==0
% Display Iteration information
T=toc;
fprintf([DisplayMsg,'|',num2str(S/SNum*100,'%05.1f'),'%%|Elapsed: ',TimePrint(T),' |Remind: ',TimePrint((Total-Sofar+S)*T/(Sofar+S)),'\n'])
end
BestFitedObjectiveFunc=inf;
BestFitedParams=FittingBoundry.Low+(FittingBoundry.High-FittingBoundry.Low).*rand(1,PNum);
ObjectiveFunc=@(Params) DawAgentsObjectiveFun(Observe.ASARCMat(:,:,S),Params,ParamMethod,ObjectiveMethod,1);
for Start=1:StartNumber
    InitialParam=FittingBoundry.Low+(FittingBoundry.High-FittingBoundry.Low).*rand(1,PNum);
    try
        [FitedParams,BestNegLogLikelihood] = fmincon(ObjectiveFunc,InitialParam,[],[],[],[],FittingBoundry.Low,FittingBoundry.High,[],OptimizerOptions);
    catch
        BestNegLogLikelihood=inf;
        FitedParams=InitialParam;
    end
    if BestNegLogLikelihood<BestFitedObjectiveFunc
        BestFitedObjectiveFunc=BestNegLogLikelihood;
        BestFitedParams=FitedParams;
    end
end
Best(S,:)=BestFitedParams;
FX1(S) = BestFitedObjectiveFunc;
end
end
