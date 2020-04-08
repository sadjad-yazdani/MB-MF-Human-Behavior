function Out=GetRegValue(Regressor,X)
NX=size(X,1);
X=repmat(Regressor.NormalizeWight,NX,1).*...
                  (X+repmat(Regressor.NormalizeBias,NX,1));
switch Regressor.Type
case {'KNN','Knn','knn'}
    MdlES = ExhaustiveSearcher(Regressor.X);
    [Naghbors,Distance]=knnsearch(MdlES,X,'K',Regressor.K);
    switch Regressor.RegresiorMethod
    case 'Averaging'
        Out=mean(Regressor.Y(Naghbors),2);
    case 'InverseDistance'
        M=2*max(max(Distance));
        Distance(Distance==0)=M;
        MinNZDis=min(Distance,[],2);
        MinNZDis=repmat(MinNZDis/10,1,Regressor.K);
        Distance((Distance==M))=MinNZDis((Distance==M));
        Weight=1./Distance;
        NormalizeWeight=Weight./repmat(sum(Weight,2),1,Regressor.K);
        if NX>1
            Out=sum(NormalizeWeight.*Regressor.Y(Naghbors),2);
        else
            Out=sum(NormalizeWeight.*Regressor.Y(Naghbors)',2);
        end
    case 'LocalWeightedRegression'
        Out=Regressor.LocalWeighte.*Distance.*Regressor.Y(Naghbors);
    otherwise
        error([ '\n%s is Unknown Regressor Method!',...
                '\nAvailabel Methodes are:',...
                '\n    Averaging',...
                '\n    LocalWeightedRegression'],...
                Regressor.RegresiorMethod );
            
    end
end