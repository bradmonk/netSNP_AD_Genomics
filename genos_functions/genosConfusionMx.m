function [CX,OX] = genosConfusionMx(LAB,ACT,varargin)
%------------------------------------------------------------------
% THIS FUNCTION COMPUTES ALL THE CELLS OF A CONFUSION MATRIX.
% TO COMPUTE THE CELLS AND VISUALIZE THE CONFUSION MATRIX SET VARARGIN = 1
% TO SEE A CONFUSION MATRIX USE: confusionviz()
%------------------------------------------------------------------

% keyboard



% COUNT NUMBER OF TRUE CASES & CONTROLS
%-----------------------------------------------------------------
CACOn = numel(LAB);
CASEn = sum(LAB==1);
CTRLn = sum(LAB~=1);




PRED = ACT>0;
mean(LAB == PRED)



% COMPUTE AUC & OOT (OPTIMAL-OPERATING-THRESHOLD)
%-----------------------------------------------------------------

[X,Y,THRESH,AUC,OPTROCPT] = perfcurve(LAB,ACT,0);



[X,Y,THRESH,AUC,OPTROCPT] = perfcurve(LAB',ACT',1);
OOT = THRESH((X==OPTROCPT(1))&(Y==OPTROCPT(2)));






%-----------------------------------------------------------------
%% COMPUTE CONFUSION MATRIX STATS FOR STATIC THRESH==0
%-----------------------------------------------------------------
    PRED = ACT>0;

    PredPosIdx = PRED==1;
    PredNegIdx = PRED~=1;
    PCASEn     = sum(PRED==1);
    PCTRLn     = sum(PRED~=1);

    TP  = sum(LAB(PredPosIdx) == 1);
    FP  = sum(LAB(PredPosIdx) == 0);
    TN  = sum(LAB(PredNegIdx) == 0);
    FN  = sum(LAB(PredNegIdx) == 1);
    PRV = CASEn / CACOn;
    ACC = (TP+TN) / CACOn;
    TPR = TP / CASEn;
    FNR = FN / CASEn;
    FPR = FP / CTRLn;
    TNR = TN / CTRLn;
    PPV = TP / PCASEn;
    FDR = FP / PCASEn;
    FOR = FN / PCTRLn;
    NPV = TN / PCTRLn;
    PLR = TPR / FPR;
    NLR = FNR / TNR;
    DOR = PLR / NLR;
    F1  = ((PPV * TPR) / (PPV + TPR)) * 2;
    %MCC = (TP .* TN - FP * FN) / sqrt((TP + FP).*(TP + FN).*(TN+FP).*(TN+FN));


    CX = nan(5,5);
    CX(1,1) = CACOn;
    CX(2,1) = PCASEn;
    CX(3,1) = PCTRLn;
    CX(4,1) = AUC;
    CX(5,1) = OOT;
    CX(1,2) = CASEn;
    CX(2,2) = TP;
    CX(3,2) = FN;
    CX(4,2) = TPR;
    CX(5,2) = FNR;
    CX(1,3) = CTRLn;
    CX(2,3) = FP;
    CX(3,3) = TN;
    CX(4,3) = FPR;
    CX(5,3) = TNR;
    CX(1,4) = PRV;
    CX(2,4) = PPV;
    CX(3,4) = FOR;
    CX(4,4) = PLR;
    CX(5,4) = NLR;
    CX(1,5) = ACC;
    CX(2,5) = FDR;
    CX(3,5) = NPV;
    CX(4,5) = DOR;
    CX(5,5) = F1;
    %CX(5,5) = MCC;





%-----------------------------------------------------------------
%% COMPUTE CONFUSION MATRIX STATS USING THE OPTIMAL-OPERATING-THRESHOLD
%-----------------------------------------------------------------
clearvars -except LAB ACT CACOn CASEn CTRLn X Y THRESH AUC OPTROCPT OOT CX V



    PRED = ACT>OOT;

    PredPosIdx = PRED==1;
    PredNegIdx = PRED~=1;
    PCASEn     = sum(PRED==1);
    PCTRLn     = sum(PRED~=1);

    TP  = sum(LAB(PredPosIdx) == 1);
    FP  = sum(LAB(PredPosIdx) == 0);
    TN  = sum(LAB(PredNegIdx) == 0);
    FN  = sum(LAB(PredNegIdx) == 1);
    PRV = CASEn / CACOn;
    ACC = (TP+TN) / CACOn;
    TPR = TP / CASEn;
    FNR = FN / CASEn;
    FPR = FP / CTRLn;
    TNR = TN / CTRLn;
    PPV = TP / PCASEn;
    FDR = FP / PCASEn;
    FOR = FN / PCTRLn;
    NPV = TN / PCTRLn;
    PLR = TPR / FPR;
    NLR = FNR / TNR;
    DOR = PLR / NLR;
    F1  = ((PPV * TPR) / (PPV + TPR)) * 2;
    %MCC = (TP .* TN - FP * FN) / sqrt((TP + FP).*(TP + FN).*(TN+FP).*(TN+FN));


    OX = nan(5,5);
    OX(1,1) = CACOn;
    OX(2,1) = PCASEn;
    OX(3,1) = PCTRLn;
    OX(4,1) = AUC;
    OX(5,1) = OOT;
    OX(1,2) = CASEn;
    OX(2,2) = TP;
    OX(3,2) = FN;
    OX(4,2) = TPR;
    OX(5,2) = FNR;
    OX(1,3) = CTRLn;
    OX(2,3) = FP;
    OX(3,3) = TN;
    OX(4,3) = FPR;
    OX(5,3) = TNR;
    OX(1,4) = PRV;
    OX(2,4) = PPV;
    OX(3,4) = FOR;
    OX(4,4) = PLR;
    OX(5,4) = NLR;
    OX(1,5) = ACC;
    OX(2,5) = FDR;
    OX(3,5) = NPV;
    OX(4,5) = DOR;
    OX(5,5) = F1;
    %OX(5,5) = MCC;




end