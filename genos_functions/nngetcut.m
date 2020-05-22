function cut = nngetcut(YL,ACT,C,varargin)
%==========================================================================
%% DETERMINE CLASSIFIER CUTOFF BASED ON POPULATION PERCENTAGES
%==========================================================================

% keyboard


CACOn = numel(YL);
CTRLn = sum(~YL);
CASEn = sum(YL);


% ACTUAL PROPORTION OF CASES & CTRLS
actualCASEp = mean(YL);
actualCTRLp = mean(~YL);


% GUESSED PROPORTION OF CASES & CTRLS AT CUT=C
guessCASEp = mean(ACT >  C);
guessCTRLp = mean(ACT <= C);


% GET CUTOFF TO MAKE ACTUAL & GUESSED PROPORTIONS MORE SIMILAR
CASEcut = quantile( ACT, actualCASEp );
CTRLcut = quantile( ACT, actualCTRLp );
cut = mean([CASEcut CTRLcut]);


% GUESSED PROPORTION OF CASES & CTRLS AT CUT=cut
guessCASEScut = mean(ACT >  cut);
guessCTRLScut = mean(ACT <= cut);



if nargin < 4
clc; disp(' ');
fprintf('\n CACO N: %.0f \n CTRL N: %.0f \n CASE N: %.0f \n', CACOn,CTRLn,CASEn)

fprintf('\n WHEN CUTOFF IS %.2f ...\n',0);
fprintf(' CTRL P(ACTUAL,GUESS): %.2f, %.2f \n', actualCTRLp, guessCTRLp)
fprintf(' CASE P(ACTUAL,GUESS): %.2f, %.2f \n', actualCASEp, guessCASEp)


fprintf('\n WHEN CUTOFF IS %.2f ...\n',cut);
fprintf(' CTRL P(ACTUAL,GUESS): %.2f, %.2f \n', actualCTRLp, guessCTRLScut)
fprintf(' CASE P(ACTUAL,GUESS): %.2f, %.2f \n', actualCASEp, guessCASEScut)
end

end