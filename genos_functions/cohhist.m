function [varargout] = cohhist(PHEN,varargin)


% keyboard



COHORTS = unique(PHEN.COHORTNUM);

nCA=sum((PHEN.COHORTNUM==COHORTS') & (PHEN.AD==1));
nCO=sum((PHEN.COHORTNUM==COHORTS') & (PHEN.AD==0));

COUNTS = [nCA' nCO'];





fprintf('\tCOHORT:\t\t CASES:\t   CTRLS:\n'); 
disp([COHORTS COUNTS])


% keyboard


fh=figure; 
ax=axes;
ph=bar(COUNTS,'group');

ax.XTick = 1:numel(COHORTS); 
ax.XTickLabel=COHORTS; 
xlabel('Cohort'); 
ylabel('People');
legend(ax,'Case','Control')



varargout = {COUNTS,COHORTS};
end