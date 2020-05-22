%% GENOS PROJECT OVERVIEW
%--------------------------------------
% 
% ADSP has combined sequencing data from 25 different consortium study 
% cohorts. Prelim evaluation indicates cohort is a major source of data
% stratification. Unfortunately some cohorts have very unequal numbers 
% of Alzheimer's Disease (AD) patients (CASE) and controls (CTRL).
% 
% 
% This pipeline prepares datasets for classifier training, validation,
% and testing, using a pseudorandom sampling method that aims to balance 
% random CASE-CTRL samples within cohort as much as possible, particularly
% within the training and validation sets (so that during training the
% classifier cannot rely on cohort-specific information to make better
% predictions). The table shows the participant count of each cohort.
% 
% 
% -----------------------------------------------------------------------
%   ID  STUDY   COHORT  CASE   CTRL   TOTAL  %CASE  %CTRL  EQUAL   LOSS
% -----------------------------------------------------------------------
%    1   DGC     ACT     323    945    1268    25     75     323    -622
%    2   ADGC    ADC    2438    817    3255    75     25     817    1621
%    3   CHARGE  ARIC     39     18      57    68     32      18      21
%    4   CHARGE  ASPS    121      5     126    96      4       5     116
%    5   ADGC    CHAP     27    204     231    12     88      27    -177
%    6   CHARGE  CHS     250    583     833    30     70     250    -333
%    7   ADGC    CUHS    160    171     331    48     52     160     -11
%    8   CHARGE  ERF      45      0      45   100      0       0      45
%    9   CHARGE  FHS     157    424     581    27     73     157    -267
%    10  ADGC    GDF     111     96     207    54     46      96      15
%    11  ADGC    LOAD    367    109     476    77     23     109     258
%    12  ADGC    MAP     138    277     415    33     67     138    -139
%    13  ADGC    MAYO    250     99     349    72     28      99     151
%    14  ADGC    MIA     186     14     200    93      7      14     172
%    15  ADGC    MIR     316     15     331    95      5      15     301
%    16  ADGC    MPD       0     20      20     0    100       0     -20
%    17  ADGC    NCRD    160      0     160   100      0       0     160
%    18  ADGC    RAS      46      0      46   100      0       0      46
%    19  ADGC    ROS     154    197     351    44     56     154     -43
%    20  CHARGE  RS      276    813    1089    25     75     276    -537
%    21  ADGC    TARC    132     12     144    92      8      12     120
%    22  ADGC    TOR       9      0       9   100      0       0       9
%    23  ADGC    VAN     210     26     236    89     11      26     184
%    24  ADGC    WCAP     34    116     150    23     77      34     -82
% -----------------------------------------------------------------------
% 
% 
% 
% 
% 
%==========================================================================
%% STEP-1: SET PROJECT FOLDER PATHS & LOAD THE DATASET
%==========================================================================
close all; clear; clc; rng('shuffle');
PROJECT_FOLDER_PATH = ...
    '/Users/bradleymonk/Documents/code/netSNP_AD_Genomics_PNAS_2020';
P.home  = PROJECT_FOLDER_PATH; cd(P.home);
P.funs  = [P.home filesep 'genos_scripts'];
P.funs  = [P.home filesep 'genos_functions'];
P.data  = [P.home filesep 'genos_data'];
P.mod   = [P.home filesep 'genos_netsnp'];
addpath(join(string(struct2cell(P)),pathsep,1))
cd(P.home); P.f = filesep;
set(groot,'defaultFigureColor','w')
set(groot,'defaultAxesFontSize',14)
set(groot,'defaultLineLineWidth',2)
set(groot,'defaultFigurePosition',[100 35 700 600])
%----------------------------------------------------



ADSP = load('GENOSDATA.mat');









%==========================================================================
%%   CARBON COPY MAIN VARIABLES FROM ADSP.STRUCT
%==========================================================================
clc; close all; clearvars -except P ADSP



LOCI = ADSP.LOCI;
CACU = ADSP.CACU;
PHEN = ADSP.PHEN(ADSP.PHEN.GOODCOH,:);





%==========================================================================
%% ASSESS THE AGES OF EACH COHORT
%==========================================================================
clc; close all; clearvars -except P ADSP LOCI CACU PHEN




AGE     = PHEN.AGE(PHEN.AD == 1);
COHORT  = PHEN.COHORTNUM(PHEN.AD == 1);



[Cohort,~,ic] = unique(COHORT,'sorted');
AGEmu = accumarray(ic,AGE,[],@mean);
AGEsd = accumarray(ic,AGE,[],@std);
disp([Cohort, AGEmu, AGEsd])



boxchart(categorical(COHORT), AGE); 
    ylim([0 100])
    xlabel('Cohort');
    ylabel('Age');
    pause(1)



% DISPLAY COHORT STATISTICS
cohhist(PHEN);






%==========================================================================
%%   GENERATE TRAINING/HOLDOUT SUBSETS - COUNTERBALANCE COHORTS
%==========================================================================
% 
% THIS IS SOMEWHAT CONVOLUTED, BUT IT WORKS. PROBABLY NOT
% WORTH TRYING TO UNDERSTAND EACH LINE; IF ANYTHING, JUST CHECK
% TO SEE THAT THE OUTPUTS ARE BALANCED. IN FACT, IF YOU RUN
% THIS SECTION, THE FINAL TALLY WILL PRINT TO THE CONSOLE
% AND YOU WILL SEE FOR EXAMPLE THAT 
% 
%   Tr_CASE_CTRL_PctRow
% 
% SHOULD EACH BE 50:50 CASE:CTRL. IN THE SECTION THAT FOLLOWS
% WE BREAK SOME OF THAT PERFECT SYMMETRY, OTHERWISE THERE
% JUST ISN'T ENOUGH TRAINING DATA...
%-------------------------------------------------------------
clc; close all; clearvars -except P ADSP LOCI CACU PHEN




% RANDOMLY SHUFFLE TABLE ROWS TO ENSURE UNIQUE SUBSET EACH RUN
%-------------------------------------------------------------

COHSET = PHEN;

COHSET = COHSET(randperm(size(COHSET,1)),:);




% COUNT NUMBER OF CASE AND CTRL IN EACH COHORT
%-------------------------------------------------------------
cohNums = unique(COHSET.COHORTNUM);

nCA=[];nCO=[];
for nn = 1:numel(cohNums)
    nCA(nn) = sum(  (COHSET.COHORTNUM==cohNums(nn)) & (COHSET.AD==1)  );
    nCO(nn) = sum(  (COHSET.COHORTNUM==cohNums(nn)) & (COHSET.AD==0)  );
end

nCACO = [nCA' nCO'];
minCACO = min(nCACO,[],2);





% REMOVE ANY COHORT WITH LESS THAN 10 CASES AND 10 CTRLS
%-------------------------------------------------------------
cohNums(minCACO < 5) = [];
nCACO(minCACO < 5,:) = [];
minCACO(minCACO < 5) = [];




% CREATE PHENOTYPE TABLE FOR EACH COHORT
%-------------------------------------------------------------
COHCASE={};COHCTRL={};
for nn = 1:numel(cohNums)
    COHCASE{nn} = COHSET( (COHSET.COHORTNUM==cohNums(nn)) & (COHSET.AD==1) ,:);
    COHCTRL{nn} = COHSET( (COHSET.COHORTNUM==cohNums(nn)) & (COHSET.AD==0) ,:);
end



% GET RANDOM PARTICIPANT SET FROM EACH COHORT
%
% Get random permutation of M values between 1:N-5
%    where  M = min CASE\CTRL group size per cohort
%           N = total cohort size
%-------------------------------------------------------------
rca={};rco={};
for nn = 1:numel(cohNums)
    rca{nn} = randperm( nCACO(nn,1)  , round(minCACO(nn) * .7));
    rco{nn} = randperm( nCACO(nn,2)  , round(minCACO(nn) * .7));
end





% GET ROW INDEX NUMBER FOR PEOPLE NOT CHOSEN ABOVE
%
% Get index locations for people not part of the training subgroup
%-------------------------------------------------------------
ica={};ico={};
for nn = 1:numel(cohNums)
    [ia,ib] = ismember(  (1:nCACO(nn,1)) , rca{nn});
    [ic,id] = ismember(  (1:nCACO(nn,2)) , rco{nn});
    ica{nn} = find(~ia);
    ico{nn} = find(~ic);
end




% CREATE PHEN TABLES FOR TRAINING CASE/CTRL & TESTING CASE/CTRL
%-------------------------------------------------------------
COHTRANCA={};COHTRANCO={};
COHTESTCA={};COHTESTCO={};
for nn = 1:numel(cohNums)
    COHTRANCA{nn} = COHCASE{nn}(rca{nn},:);
    COHTRANCO{nn} = COHCTRL{nn}(rco{nn},:);

    COHTESTCA{nn} = COHCASE{nn}(ica{nn},:);
    COHTESTCO{nn} = COHCTRL{nn}(ico{nn},:);
end



% TRAINING & TESTING VARS ABOVE ARE CELL ARRAYS OF PHEN TABLES
% OF THE SELECTED INDIVIDUALS REPRESENTING EACH COHORT. 
% HERE THE CODE MERGES THESE INTO A TABLE FOR:
% (1) TRAINING-CASE 
% (2) TRAINING-CTRL 
% (3) TESTING-CASE 
% (4) TESTING-CTRL
%-------------------------------------------------------------
PHETRCASE = vertcat(COHTRANCA{:});
PHETRCTRL = vertcat(COHTRANCO{:});

PHETECASE = vertcat(COHTESTCA{:});
PHETECTRL = vertcat(COHTESTCO{:});




% RANDOMIZE PHENOTYPE TABLE
%-------------------------------------------------------------
NVARS      = size(PHETRCASE,1);     % Total number of people
k          = randperm(NVARS)';      % Get N random ints in range 1:N
PHETRCASE  = PHETRCASE(k,:);        % Scramble Phenotype table

NVARS      = size(PHETECASE,1);     % Total number of people
k          = randperm(NVARS)';      % Get N random ints in range 1:N
PHETECASE  = PHETECASE(k,:);        % Scramble Phenotype table

NVARS      = size(PHETRCTRL,1);     % Total number of people
k          = randperm(NVARS)';      % Get N random ints in range 1:N
PHETRCTRL  = PHETRCTRL(k,:);        % Scramble Phenotype table

NVARS      = size(PHETECTRL,1);     % Total number of people
k          = randperm(NVARS)';      % Get N random ints in range 1:N
PHETECTRL  = PHETECTRL(k,:);        % Scramble Phenotype table





% SUPPLEMENT TEST GROUP
%-------------------------------------------------------------
szCA = round(size(PHETECASE,1)/2);
szCO = round(size(PHETECTRL,1)/2);

PHETRCASE = [PHETRCASE; PHETECASE(1:szCA,:)];
PHETRCTRL = [PHETRCTRL; PHETECTRL(1:szCO,:)];

PHETECASE(1:szCA,:) = [];
PHETECTRL(1:szCO,:) = [];



disp('--------------------'); disp('N TRAINING & TESTING EXAMPLES')
disp(' '); fprintf('PHETRCASE... %.0f \n',size(PHETRCASE,1));
disp(' '); fprintf('PHETRCTRL... %.0f \n',size(PHETRCTRL,1));
disp(' '); fprintf('PHETECASE... %.0f \n',size(PHETECASE,1));
disp(' '); fprintf('PHETECTRL... %.0f \n',size(PHETECTRL,1));
disp('--------------------');
cohcounts(PHETRCASE,PHETRCTRL,PHETECASE,PHETECTRL,1)














%==========================================================================
%%   REMOVE CASE & CTRL PARTICIPANTS BASED ON AGE
%==========================================================================
clc; close all; clearvars -except P ADSP LOCI CACU PHEN...
COHSET PHETRCASE PHETRCTRL PHETECASE PHETECTRL




% REMOVE CTRL PARTICIPANTS YOUNGER THAN...
PHETRCTRL(PHETRCTRL.AGE < 72 , :) = [];
PHETECTRL(PHETECTRL.AGE < 72 , :) = [];



% REMOVE CASE PARTICIPANTS OLDER THAN...
PHETRCASE(PHETRCASE.AGE > 90 , :) = [];
PHETECASE(PHETECASE.AGE > 90 , :) = [];




disp('--------------------'); disp('N TRAINING & TESTING EXAMPLES')
disp(' '); fprintf('PHETRCASE... %.0f \n',size(PHETRCASE,1));
disp(' '); fprintf('PHETRCTRL... %.0f \n',size(PHETRCTRL,1));
disp(' '); fprintf('PHETECASE... %.0f \n',size(PHETECASE,1));
disp(' '); fprintf('PHETECTRL... %.0f \n',size(PHETECTRL,1));
disp('--------------------');










%==========================================================================
%%  EXAMINE DISTRIBUTION OF PER-PERSON SNV COUNTS
%==========================================================================
clc; close all; clearvars -except P ADSP LOCI CACU PHEN...
COHSET PHETRCASE PHETRCTRL PHETECASE PHETECTRL


loq = .03;
hiq = .97;


Qlo = quantile(PHETRCASE.TOTvars,loq);
Qhi = quantile(PHETRCASE.TOTvars,hiq);
TRCASE  = PHETRCASE(((PHETRCASE.TOTvars > Qlo) & (PHETRCASE.TOTvars < Qhi)),:);


Qlo = quantile(PHETRCTRL.TOTvars,loq);
Qhi = quantile(PHETRCTRL.TOTvars,hiq);
TRCTRL  = PHETRCTRL(((PHETRCTRL.TOTvars > Qlo) & (PHETRCTRL.TOTvars < Qhi)),:);


Qlo = quantile(PHETECASE.TOTvars,loq);
Qhi = quantile(PHETECASE.TOTvars,hiq);
TECASE  = PHETECASE(((PHETECASE.TOTvars > Qlo) & (PHETECASE.TOTvars < Qhi)),:);


Qlo = quantile(PHETECTRL.TOTvars,loq);
Qhi = quantile(PHETECTRL.TOTvars,hiq);
TECTRL  = PHETECTRL(((PHETECTRL.TOTvars > Qlo) & (PHETECTRL.TOTvars < Qhi)),:);



clc; close all;
subplot(2,2,1), histogram(TRCASE.TOTvars,40); title('TRAIN CASE')
subplot(2,2,2), histogram(TRCTRL.TOTvars,40); title('TRAIN CTRL')
subplot(2,2,3), histogram(TECASE.TOTvars,40); title('TEST  CASE')
subplot(2,2,4), histogram(TECTRL.TOTvars,40); title('TEST  CTRL')
disp('------------------------------------')
disp('TOTAL VARIANTS PER-PERSON')
disp('                MIN    MAX')
fprintf('TRAINING CASE: %.0f  %.0f \n',min(TRCASE.TOTvars),  max(TRCASE.TOTvars))
fprintf('TRAINING CTRL: %.0f  %.0f \n',min(TRCTRL.TOTvars),  max(TRCTRL.TOTvars))
fprintf('TESTING  CASE: %.0f  %.0f \n',min(TECASE.TOTvars),  max(TECASE.TOTvars))
fprintf('TESTING  CTRL: %.0f  %.0f \n',min(TECTRL.TOTvars),  max(TECTRL.TOTvars))
disp('------------------------------------')
pause(1)


disp('--------------------'); disp('N TRAINING & TESTING EXAMPLES')
disp(' '); fprintf('PHETRCASE... %.0f \n',size(PHETRCASE,1));
disp(' '); fprintf('PHETRCTRL... %.0f \n',size(PHETRCTRL,1));
disp(' '); fprintf('PHETECASE... %.0f \n',size(PHETECASE,1));
disp(' '); fprintf('PHETECTRL... %.0f \n',size(PHETECTRL,1));
disp('--------------------');








%==========================================================================
%%          COUNT NUMBER OF VARIANTS PER LOCI
%==========================================================================
%
% The varsum() function will go through each known variant loci
% and check whether anyone's SRR ID from your subset of IDs match
% all known SRR IDs for that loci. It will then sum the total
% number of alleles (+1 for hetzy-alt, +2 for homzy-alt) for each
% loci and return the totals.
%-------------------------------------------------------------
clc; close all; clearvars -except P ADSP LOCI CACU PHEN...
COHSET PHETRCASE PHETRCTRL PHETECASE PHETECTRL


TRCASE = PHETRCASE;
TRCTRL = PHETRCTRL;
TECASE = PHETECASE;
TECTRL = PHETECTRL;


[CaN,CoN,CaU,CoU] = snpsum(CACU,TRCASE.SRR,TRCTRL.SRR);

LOCI.TRCASEREF = (numel(TRCASE.SRR)*2) - (CaU.*2) - CaN;
LOCI.TRCTRLREF = (numel(TRCTRL.SRR)*2) - (CoU.*2) - CoN;
LOCI.TRCASEALT = CaN;
LOCI.TRCTRLALT = CoN;



[CaN,CoN,CaU,CoU] = snpsum(CACU,TECASE.SRR,TECTRL.SRR);

LOCI.TECASEREF = (numel(TECASE.SRR)*2) - (CaU.*2) - CaN;
LOCI.TECTRLREF = (numel(TECTRL.SRR)*2) - (CoU.*2) - CoN;
LOCI.TECASEALT = CaN;
LOCI.TECTRLALT = CoN;







%==========================================================================
%%               COMPUTE FISHER'S P-VALUE
%==========================================================================
clc; close all; clearvars -except P ADSP LOCI CACU PHEN...
COHSET PHETRCASE PHETRCTRL PHETECASE PHETECTRL





% COMPUTE FISHERS STATISTICS FOR THE TRAINING GROUP
[FISHP, FISHOR] = fishp_mex(LOCI.TRCASEREF,LOCI.TRCASEALT,...
                            LOCI.TRCTRLREF,LOCI.TRCTRLALT);

LOCI.TRFISHP  = FISHP;
LOCI.TRFISHOR = FISHOR;




% COMPUTE FISHERS STATISTICS FOR THE TRAINING GROUP
[FISHP, FISHOR] = fishp_mex(LOCI.TECASEREF, LOCI.TECASEALT,...
                            LOCI.TECTRLREF, LOCI.TECTRLALT);

LOCI.TEFISHP  = FISHP;
LOCI.TEFISHOR = FISHOR;







%==========================================================================
%% P-VALUE HISTOGRAM & MANHATTAN
%==========================================================================
clc; close all; clearvars -except P ADSP LOCI CACU PHEN...
COHSET PHETRCASE PHETRCTRL PHETECASE PHETECTRL




a = LOCI.TRFISHP;
b = LOCI.TEFISHP;
qa = quantile(a,[.001,.999]);
qb = quantile(b,[.001,.999]);

x = -log(a);
y = -log(b);
qx = quantile(x,[.001,.999]);
qy = quantile(y,[.001,.999]);

x = x(x>qx(1)&x<qx(2));
y = y(y>qy(1)&y<qy(2));



close all
fh01 = figure('Units','normalized','OuterPosition',[.01 .05 .95 .90],...
              'Color','w','MenuBar','none');
ax01 = axes('Position',[.06 .56 .4 .4],'Color','none');
ax02 = axes('Position',[.56 .56 .4 .4],'Color','none');
ax03 = axes('Position',[.06 .06 .4 .4],'Color','none');
ax04 = axes('Position',[.56 .06 .4 .4],'Color','none');

axes(ax01); histogram(a);
title('TRAINING SET FISHERS P-VALUE DISTRIBUTION')
axes(ax02); histogram(b);
title('TESTING SET FISHERS P-VALUE DISTRIBUTION')

axes(ax03); histogram(x);
title('TRAINING SET quantile(-log(FISHP),[.001 .999])')
axes(ax04); histogram(y);
title('TESTING SET quantile(-log(FISHP),[.001 .999])')







%==========================================================================
%==========================================================================
%==========================================================================
%%
%
% PREPARE DATA FOR NEURAL NET CLASSIFIER SUPERVISED LEARNING
%
%==========================================================================
%==========================================================================
%==========================================================================
clc; close all; clearvars -except P ADSP LOCI CACU PHEN...
COHSET PHETRCASE PHETRCTRL PHETECASE PHETECTRL









%==========================================================================
%% STORE VARIABLES FOR NEURAL NETWORK TRAINING AS 'VLOCI'
%==========================================================================
clc; close all; clearvars -except P ADSP LOCI CACU PHEN...
COHSET PHETRCASE PHETRCTRL PHETECASE PHETECTRL




VLOCI     = LOCI;
VCACU     = CACU;


VTRCASE   = PHETRCASE;
VTRCTRL   = PHETRCTRL;
VTECASE   = PHETECASE;
VTECTRL   = PHETECTRL;


% SET MAIN FISHP TO TRAINING GROUP FISHP
VLOCI.FISHP      = VLOCI.TRFISHP;
VLOCI.FISHOR     = VLOCI.TRFISHOR;
VLOCI.CASEREF    = VLOCI.TRCASEREF;
VLOCI.CASEALT    = VLOCI.TRCASEALT;
VLOCI.CTRLREF    = VLOCI.TRCTRLREF;
VLOCI.CTRLALT    = VLOCI.TRCTRLALT;



% SORT VARIANTS BY TRFISHP
[~,i]  = sort(VLOCI.TRFISHP);
VLOCI  = VLOCI(i,:);
VCACU  = VCACU(i);


% USE EXACTLY N VARIANTS
SNPn = 50;


% EXTRACT TOP-N NUMBER OF VARIANTS
VLOCI  = VLOCI(1:SNPn,:);
VCACU  = VCACU(1:SNPn);


% disp(VLOCI(1:9,:))
fprintf('\n LOCI COUNT FOR FEATURE MATRIX: %.0f \n\n',size(VLOCI,1))







%==========================================================================
%% PREPARE RECTANGULAR MATRICES FOR CLASSIFIER TRAINING
%==========================================================================
clc; close all; clearvars -except P ADSP LOCI CACU PHEN...
COHSET PHETRCASE PHETRCTRL PHETECASE PHETECTRL VLOCI VCACU


VLOCI  = LOCI;
VCACU  = CACU;


% SET MAIN FISHP TO TRAINING GROUP FISHP
VLOCI.FISHP      = VLOCI.TRFISHP;
VLOCI.FISHOR     = VLOCI.TRFISHOR;
VLOCI.CASEREF    = VLOCI.TRCASEREF;
VLOCI.CASEALT    = VLOCI.TRCASEALT;
VLOCI.CTRLREF    = VLOCI.TRCTRLREF;
VLOCI.CTRLALT    = VLOCI.TRCTRLALT;



% SORT VARIANTS BY TRFISHP
[~,i]  = sort(VLOCI.TRFISHP);
VLOCI  = VLOCI(i,:);
VCACU  = VCACU(i);


% USE EXACTLY N VARIANTS
SNPn = 50;


% EXTRACT TOP-N NUMBER OF VARIANTS
VLOCI  = VLOCI(1:SNPn,:);
VCACU  = VCACU(1:SNPn);




TRPHE  = [PHETRCASE; PHETRCTRL];
HOPHE  = [PHETECASE; PHETECTRL];
TRPHE  = TRPHE(randperm(height(TRPHE)),:);
HOPHE  = HOPHE(randperm(height(HOPHE)),:);


[PVTR,HOTTR] = admx(VCACU,TRPHE,[-1 0 2 3]);
[PVHO,HOTHO] = admx(VCACU,HOPHE,[-1 0 2 3]);









%==========================================================================
%==========================================================================
%==========================================================================
%
%%                      NEURAL NETWORK MODEL
%
%==========================================================================
%==========================================================================
%==========================================================================
clc; close all; clearvars -except P ADSP LOCI CACU PHEN...
PHETRCASE PHETRCTRL PHETECASE PHETECTRL VLOCI VCACU PVTR PVHO HOTTR HOTHO



% Xt = PVTR(:,10:end);
% Yt = PVTR(:,2);
% 
% Xh = PVHO(:,10:end);
% Yh = PVHO(:,2);



% Xt = HOTTR(:,10:end);
% Yt = HOTTR(:,2);
% 
% Xh = HOTHO(:,10:end);
% Yh = HOTHO(:,2);




%======================================================================
% TRAIN NETS AND KEEP BEST PERFORMER
%-----------------------------------------------
NN = patternnet([50,20],'trainscg','crossentropy');
NN.trainParam.max_fail = 20;
NN.trainParam.showWindow = 0;
NN.performParam.regularization = 0.1;
NN.divideFcn = 'dividerand';
%NN.performParam.normalization = 'none';
% [TRX,TRL,TEX,TEL,...
%  TRi,VAi,TEi] = validmx(MX.PBTRX, MX.LPTR, MX.PBTEX, MX.LPTE, RATIO, NHOLD);
%-------- divideFcn
% NN.divideFcn = 'divideind';
% NN.divideParam.trainInd = TRi;
% NN.divideParam.valInd = VAi;
% NN.divideParam.testInd = TEi;

view(NN)


NN.trainParam.showWindow = 1;
net = train(NN,Xt',Yt');





%==========================================================================
%% BUILD CONFUSION MATRICES (CONMX)
%==========================================================================
%  %CORRECT     NCASE_ACTUAL   NCTRL_ACTUAL   %CASE_ACTUAL
%  NCASE_PRED       TP             FP             PPV
%  NCTRL_PRED       FN             TN             NPV
%  %CASE_PRED      TPR            FPR              J
%------------------------------------------------------------------
clc; close all; clearvars -except P ADSP LOCI CACU PHEN...
PHETRCASE PHETRCTRL PHETECASE PHETECTRL VLOCI VCACU...
PVTR PVHO HOTTR HOTHO net Xt Yt Xh Yh



YLABS = [Yt;Yh];
XACTS = net([Xt;Xh]')' - .5;
PREDS = XACTS > 0;

mean(YLABS == PREDS)


[CONMX, MU, XYAREA] = confusionmx(Yh,Xh,net);
disp(table(CONMX))

[CX,OX] = genosConfusionMx(YLABS,XACTS);
disp(table(CX))
disp(table(OX))
CMviz


