function Priors=GetPriorKnowlageValues(Params,ParamMethod,PriorMethod)

switch PriorMethod
case 'GurshmanBetaPriors'
switch ParamMethod
    case {'Daw3ParamV2','Daw3ParamV1'}
        PriorW           = -log(max(betapdf(Params(:,1),1.2,1.2),1));       % combination wight
        PriorAlpha1      = -log(max(betapdf(Params(:,2),1.2,1.2),1));       % Learning Rate 1
        PriorAlpha2      = 0;                                        % Learning Rate 2
        PriorBeta1       = -log(max(betapdf((Params(:,3)-1)/9,1.2,1.2),1)); % Beta 1
        PriorBeta2       = 0;                                        % Beta 2
        PriorLambda      = 0;                                        % Eligibility Trace
        PriorStickToAct1 = 0;                                        % Stickness to repeat the same first state
        PriorStickToAct2 = 0;                                        % Stickness to repeat the same second state
    case 'Daw4Param'
        PriorW           = -log(betapdf(Params(:,1),1.2,1.2));       % combination wight
        PriorAlpha1      = -log(betapdf(Params(:,2),1.2,1.2));       % Learning Rate 1
        PriorAlpha2      = 0;                                        % Learning Rate 2
        PriorBeta1       = -log(betapdf((Params(:,3)-1)/9,1.2,1.2)); % Beta 1
        PriorBeta2       = 0;                                        % Beta 2
        PriorLambda      = -log(betapdf(Params(:,4),1.2,1.2));       % Eligibility Trace
        PriorStickToAct1 = 0;                                        % Stickness to repeat the same first state
        PriorStickToAct2 = 0;                                        % Stickness to repeat the same second state
    case 'Daw5ParamV0'
        PriorW           = -log(betapdf(Params(:,1),1.2,1.2));       % combination wight
        PriorAlpha1      = -log(betapdf(Params(:,2),1.2,1.2));       % Learning Rate 1
        PriorAlpha2      = 0;                                        % Learning Rate 2
        PriorBeta1       = -log(betapdf((Params(:,3)-1)/9,1.2,1.2)); % Beta 1
        PriorBeta2       = 0;                                        % Beta 2
        PriorLambda      = -log(betapdf(Params(:,4),1.2,1.2));       % Eligibility Trace
        PriorStickToAct1 = -log(betapdf(Params(:,5),1.2,1.2));       % Stickness to repeat the same first state
        PriorStickToAct2 = 0;                                        % Stickness to repeat the same second state
    case {'Daw5ParamV1','Daw5ParamV2'}
        PriorW           = -log(betapdf(Params(:,1),1.2,1.2));       % combination wight
        PriorAlpha1      = -log(betapdf(Params(:,2),1.2,1.2));       % Learning Rate 1
        PriorAlpha2      = -log(betapdf(Params(:,3),1.2,1.2));       % Learning Rate 2
        PriorBeta1       = -log(betapdf((Params(:,4)-1)/9,1.2,1.2)); % Beta 1
        PriorBeta2       = -log(betapdf((Params(:,5)-1)/9,1.2,1.2)); % Beta 2
        PriorLambda      = 0;                                        % Eligibility Trace
        PriorStickToAct1 = 0;                                        % Stickness to repeat the same first state
        PriorStickToAct2 = 0;                                        % Stickness to repeat the same second state
    case 'Daw6Param'
        PriorW           = -log(betapdf(Params(:,1),1.2,1.2));       % combination wight
        PriorAlpha1      = -log(betapdf(Params(:,2),1.2,1.2));       % Learning Rate 1
        PriorAlpha2      = -log(betapdf(Params(:,3),1.2,1.2));       % Learning Rate 2
        PriorBeta1       = -log(betapdf((Params(:,4)-1)/9,1.2,1.2)); % Beta 1
        PriorBeta2       = -log(betapdf((Params(:,5)-1)/9,1.2,1.2)); % Beta 2
        PriorLambda      = -log(betapdf(Params(:,6),1.2,1.2));       % Eligibility Trace
        PriorStickToAct1 = 0;                                        % Stickness to repeat the same first state
        PriorStickToAct2 = 0;                                        % Stickness to repeat the same second state
    case {'Daw7ParamV1','Daw7ParamV2'}
        PriorW           = -log(betapdf(Params(:,1),1.2,1.2));       % combination wight
        PriorAlpha1      = -log(betapdf(Params(:,2),1.2,1.2));       % Learning Rate 1
        PriorAlpha2      = -log(betapdf(Params(:,3),1.2,1.2));       % Learning Rate 2
        PriorBeta1       = -log(betapdf((Params(:,4)-1)/9,1.2,1.2)); % Beta 1
        PriorBeta2       = -log(betapdf((Params(:,5)-1)/9,1.2,1.2)); % Beta 2
        PriorLambda      = -log(betapdf(Params(:,6),1.2,1.2));       % Eligibility Trace
        PriorStickToAct1 = -log(betapdf(Params(:,7),1.2,1.2));       % Stickness to repeat the same first state
        PriorStickToAct2 = 0;                                        % Stickness to repeat the same second state
    case 'Daw8Param'
        PriorW           = -log(betapdf(Params(:,1),1.2,1.2));       % combination wight
        PriorAlpha1      = -log(betapdf(Params(:,2),1.2,1.2));       % Learning Rate 1
        PriorAlpha2      = -log(betapdf(Params(:,3),1.2,1.2));       % Learning Rate 2
        PriorBeta1       = -log(betapdf((Params(:,4)-1)/9,1.2,1.2)); % Beta 1
        PriorBeta2       = -log(betapdf((Params(:,5)-1)/9,1.2,1.2)); % Beta 2
        PriorLambda      = -log(betapdf(Params(:,6),1.2,1.2));       % Eligibility Trace
        PriorStickToAct1 = -log(betapdf(Params(:,7),1.2,1.2));       % Stickness to repeat the same first state
        PriorStickToAct2 = -log(betapdf(Params(:,8),1.2,1.2));       % Stickness to repeat the same second state
    otherwise
        error('unknown Param Method')
end    
Priors=PriorW+PriorAlpha1+PriorAlpha2+PriorBeta1+PriorBeta2+PriorLambda+PriorStickToAct1+PriorStickToAct2;
otherwise
        error('unknown Prior Method')
end
     