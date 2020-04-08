function Regressor = KNNReg(Features,Labels,varargin)
Regressor.Type  = 'KNN';
Regressor.NX    = size(Features,1);
Regressor.DimX  = size(Features,2);
Regressor.NormalizeBias=-min(Features);
Regressor.NormalizeWight=1./(max(Features)-min(Features));
Regressor.X     = repmat(Regressor.NormalizeWight,Regressor.NX,1).*...
                  (Features+repmat(Regressor.NormalizeBias,Regressor.NX,1));
Regressor.Y     = Labels;
Regressor.K     = 2 ;
Regressor.RegresiorMethod = 'InverseDistance';
for i=1:2:length(varargin)
switch varargin{i}
    case 'NumNeighbors'
        Regressor.K = varargin{i+1};
    case 'RegresiorMethod'
        Regressor.RegresiorMethod=varargin{i+1};
    otherwise
        error('Not Recogonized variable!')
end
end
