function [CaN,CoN,CaU,CoU] = snpsum(CACU,CASESRR,CTRLSRR)


    sz = size(CACU,1);

    CaN = zeros(sz,1);
    CoN = zeros(sz,1);
    CaU = zeros(sz,1);
    CoU = zeros(sz,1);
    
    CASESRR = sort(CASESRR);
    CTRLSRR = sort(CTRLSRR);
    



    disp('Counting variants at each loci...')
    for nn = 1:sz


        % FOR SNP nn GET SRR & ALT (ALTREF=1; ALTALT=2; UNCALLED=0)
        SRR = CACU{nn}(:,1);
        ALT = CACU{nn}(:,2);


        % GET INDEX FOR CASES & CTRLS
        CASEi = builtin('_ismemberhelper',SRR,CASESRR);
        CTRLi = builtin('_ismemberhelper',SRR,CTRLSRR);

        
        % CASE COUNTS OF ALT ALLELES & UNCALLEDS
        CaN(nn) = sum( ALT(CASEi) );
        CaU(nn) = sum( ALT(CASEi)==0 );

        
        % CTRL COUNTS OF ALT ALLELES & UNCALLEDS
        CoN(nn) = sum( ALT(CTRLi) );
        CoU(nn) = sum( ALT(CTRLi)==0 );
        


        if ~mod(nn,10000); disp(nn/sz); end
    end
    disp('done.');





end