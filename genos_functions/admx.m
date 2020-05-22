function [PVMX,varargout] = admx(CACO,PHE,varargin)

if nargin > 2
    ALLELES = varargin{1};
else
    ALLELES = [-1 0 1 2];
end



sz = size(CACO,1);

MX  = zeros( height(PHE) , sz ) - 1;


for nn = 1:sz

    CC = CACO{nn};
    
    if any(any(CC))
        CACOSRR = CC(:,1);
        CACOHH  = CC(:,2);
        [~,Aj] = ismember(PHE.SRR , CACOSRR );
        Af = Aj(Aj>0);
        MX(Aj>0,nn) = CACOHH(Af); 
    end

end


vMX = MX + 20;   % REF/REF: 19  NAN/NAN:20  REF/ALT:21  ALT/ALT:22
hMX = MX + 20;   % REF/REF: 19  NAN/NAN:20  REF/ALT:21  ALT/ALT:22




% MAKE vMX (ONE-COL-PER-SNP 'COOL' MX)
%----------------------------------------------
vMX(vMX==19) = ALLELES(1);  % REF/REF
vMX(vMX==20) = ALLELES(2);  % NAN/NAN
vMX(vMX==21) = ALLELES(3);  % REF/ALT
vMX(vMX==22) = ALLELES(4);  % ALT/ALT




% MAKE PVMX
%----------------------------------------------
PVMX = [zeros(size(vMX,1),9) vMX];
PVMX(: , 1)  =  PHE.SRR;        % COL1: ID
PVMX(: , 2)  =  PHE.AD;         % COL2: AD
PVMX(: , 3)  =  PHE.COHORTNUM;  % COL3: COHORT
PVMX(: , 4)  =  PHE.AGE;        % COL4: AGE
PVMX(: , 5)  =  PHE.APOE;       % COL5: APOE
PVMX(: , 6)  =  PHE.SEX;        % COL7: SEX
PVMX(: , 7)  =  PHE.BRAAK;      % COL6: BRAAK
PVMX(: , 8)  =  PHE.RACE;       % COL2: RACE
PVMX(: , 9)  =  PHE.SRR;        % COL6: RACE






%---- MAKE dMX (TWO-COL-PER-SNP 'HOT' MX)
%----------------------------------------------
%hMX: REF/REF: -1  NAN/NAN: 0  REF/ALT: 1  ALT/ALT: 2


iMX = hMX;
jMX = hMX;

iMX(iMX==19) = ALLELES(1);  % REF
iMX(iMX==20) = ALLELES(2);  % NAN
iMX(iMX==21) = ALLELES(3);  % ALT
iMX(iMX==22) = ALLELES(3);  % ALT

jMX(jMX==19) = ALLELES(1);  % REF
jMX(jMX==20) = ALLELES(2);  % NAN
jMX(jMX==21) = ALLELES(1);  % REF
jMX(jMX==22) = ALLELES(4);  % ALT


% MXj = jMX>ALLELES(2);
% iMX(MXj) = 0;


dMX = [hMX hMX];
dMX(:,1:2:end) = iMX;
dMX(:,2:2:end) = jMX;

ONEHOT = [PVMX(:,1:9) dMX];

% ONE HOT MATRIX
varargout = {ONEHOT};


end