function [] = cohcounts(PHETRCASE,PHETRCTRL,PHETECASE,PHETECTRL,varargin)

[G,COH] = findgroups([...
PHETRCASE.COHORTNUM;
PHETRCTRL.COHORTNUM;
PHETECASE.COHORTNUM;
PHETECTRL.COHORTNUM]);


[G,TRCASECOH] = findgroups(PHETRCASE.COHORTNUM);
TRCASEN = splitapply(@numel,PHETRCASE.COHORTNUM,G);

[G,TRCTRLCOH] = findgroups(PHETRCTRL.COHORTNUM);
TRCTRLN = splitapply(@numel,PHETRCTRL.COHORTNUM,G);

[G,TECASECOH] = findgroups(PHETECASE.COHORTNUM);
TECASEN = splitapply(@numel,PHETECASE.COHORTNUM,G);

[G,TECTRLCOH] = findgroups(PHETECTRL.COHORTNUM);
TECTRLN = splitapply(@numel,PHETECTRL.COHORTNUM,G);


[TRCASEi,~] = ismember(COH,TRCASECOH);
[TRCTRLi,~] = ismember(COH,TRCTRLCOH);
[TECASEi,~] = ismember(COH,TECASECOH);
[TECTRLi,~] = ismember(COH,TECTRLCOH);

COHORTN = zeros(numel(COH),4);
COHORTN(TRCASEi,1) = TRCASEN;
COHORTN(TRCTRLi,2) = TRCTRLN;
COHORTN(TECASEi,3) = TECASEN;
COHORTN(TECTRLi,4) = TECTRLN;


PTRCA = round(COHORTN(:,1)./sum(COHORTN(:,1)).*100);
PTRCO = round(COHORTN(:,2)./sum(COHORTN(:,2)).*100);
PTECA = round(COHORTN(:,3)./sum(COHORTN(:,3)).*100);
PTECO = round(COHORTN(:,4)./sum(COHORTN(:,4)).*100);
TRPCTCOL = [PTRCA PTRCO];
TEPCTCOL = [PTECA PTECO];


A = [COHORTN(:,1),COHORTN(:,2)];
S = sum(A,2);
TRPCTROW = round(A./S.*100);

A = [COHORTN(:,3),COHORTN(:,4)];
S = sum(A,2);
TEPCTROW = round(A./S.*100);

PCTROW = [TRPCTROW TEPCTROW];


TrCOH = COHORTN(:,1:2);
TeCOH = COHORTN(:,3:4);

T = table(COH,TrCOH,TRPCTROW,TRPCTCOL,TeCOH,TEPCTROW,TEPCTCOL);

V = T.Properties.VariableNames;

V{1} = 'Cohort';
V{2} = 'Tr_CASE_CTRL_N';
V{3} = 'Tr_CASE_CTRL_PctRow';
V{4} = 'Tr_CASE_CTRL_PctCol';
V{5} = 'Te_CASE_CTRL_N';
V{6} = 'Te_CASE_CTRL_PctRow';
V{7} = 'Te_CASE_CTRL_PctCol';

T.Properties.VariableNames = V;

TCASE = T(:,[1 2 3 4]);
TCTRL = T(:,[1 5 6 7]);

disp(TCASE); disp(' '); disp(TCTRL);






%###############################################################
%
%                 VARARGIN DO PLOTS
%
%###############################################################
if nargin > 4
doPlot = varargin{1};




% COHORT HISTOGRAMS
%---------------------------------------------------------------
if doPlot>=1

TRCASE = PHETRCASE.COHORTNUM;
TRCTRL = PHETRCTRL.COHORTNUM;
TECASE = PHETECASE.COHORTNUM;
TECTRL = PHETECTRL.COHORTNUM;






%% --------------------------------------
X = [TRCTRL; TRCASE; TECTRL; TECASE];
Y = [zeros(size(TRCTRL,1),1)+1;...
     zeros(size(TRCASE,1),1)+2;...
     zeros(size(TECTRL,1),1)+3;...
     zeros(size(TECASE,1),1)+4];


close all; 
fh10 = figure('Units','pixels','Position',[10 35 700 600],'Color','w');
ax10 = axes('Position',[.06 .06 .9 .9],'Color','none');

axes(ax10); 
p1=histogram2(X,Y,'FaceColor','flat');
p1.BinWidth = [.8 .4];
ax10.XTick = 1:24;
ax10.YTick = 1:4;
ax10.YTickLabels = {'TRCTRL','TRCASE','TECTRL','TECASE'};
ax10.PlotBoxAspectRatio = [1 .3 1];
view([-20 55]);


%%

% bins=.5:1:24.5;
% %--------------------------------------
% close all
% fh01 = figure('Units','normalized','OuterPosition',[.01 .05 .45 .90],...
%               'Color','w','MenuBar','none');
% ax10 = axes('Position',[.06 .56 .8 .4],'Color','none');
% ax20 = axes('Position',[.06 .06 .8 .4],'Color','none');
% % ax11 = axes('Position',[.06 .56 .8 .4],'Color','none');
% % ax21 = axes('Position',[.06 .06 .8 .4],'Color','none');
% 
% 
% axes(ax10); p1=histogram(TRCTRL,bins); 
%     xlabel('Training set N people from cohort (case=red, ctrl=blue)');hold on;
% axes(ax10); p2=histogram(TRCASE,bins);
% axes(ax20); p3=histogram(TECTRL,bins); 
%     xlabel('Validation set N people from cohort (case=red, ctrl=blue)');hold on;
% axes(ax20); p4=histogram(TECASE,bins);
% 
% ax10.XTick = [1:24];
% ax20.XTick = [1:24];
% pause(1)
%---------------------------------------------------------------


%%
TRPHE = [PHETRCASE; PHETRCTRL];
TEPHE = [PHETECASE; PHETECTRL];

TRCOHID = unique(TRPHE.COHORTNUM);
TRnCA=sum((TRPHE.COHORTNUM==TRCOHID') & (TRPHE.AD==1));
TRnCO=sum((TRPHE.COHORTNUM==TRCOHID') & (TRPHE.AD==0));
TRnCACO = [TRnCA' TRnCO'];


TECOHID = unique(TEPHE.COHORTNUM);
TEnCA=sum((TEPHE.COHORTNUM==TECOHID') & (TEPHE.AD==1));
TEnCO=sum((TEPHE.COHORTNUM==TECOHID') & (TEPHE.AD==0));
TEnCACO = [TEnCA' TEnCO'];

TRTECACO = [TRnCA' TRnCO' TEnCA' TEnCO'];


figure('Units','normalized','Position',[.05 .04 .6 .5],'Color','w');
ax1=subplot(1,2,1);
bar(TRnCACO); 
ax1.XTickLabel=TRCOHID; 
xlabel('Training Cohorts'); ylabel('People');
ax2=subplot(1,2,2);
bar(TEnCACO); 
ax2.XTickLabel=TECOHID; 
xlabel('Testing Cohorts'); ylabel('People');

figure('Units','normalized','Position',[.15 .14 .6 .5],'Color','w');
ax1=axes;
bp1=bar(TRTECACO); 
ax1.XTickLabel=TRCOHID; 
xlabel('Cohorts'); ylabel('People');
legend('CASE TRAIN','CTRL TRAIN','CASE TEST','CTRL TEST')


%%

% fprintf('\n\n\tCOHORT:\t TRCASES:\t   TRCTRLS: \t TECASES:\t   TECTRLS:\n'); 
% disp([TRCOHID TRnCACO TEnCACO])




%---------------------------------------------------------------
%---------------------------------------------------------------
end
%---------------------------------------------------------------
%---------------------------------------------------------------







% AGE HISTOGRAMS
%---------------------------------------------------------------
%---------------------------------------------------------------
if doPlot>=2
%---------------------------------------------------------------
%---------------------------------------------------------------

TRCASE = PHETRCASE.AGE;
TRCTRL = PHETRCTRL.AGE;
TECASE = PHETECASE.AGE;
TECTRL = PHETECTRL.AGE;

bins=19;

bins=50.5:1:90.5;
%------------------------------------------

%--------------------------------------
fh01 = figure('Units','normalized','OuterPosition',[.01 .05 .45 .90],...
              'Color','w','MenuBar','none');
ax01 = axes('Position',[.06 .56 .8 .4],'Color','none');
ax02 = axes('Position',[.06 .06 .8 .4],'Color','none');

axes(ax01); p1=histogram(TRCTRL,bins); 
    xlabel('Age distribution Training set (case=red, ctrl=blue)');hold on;
axes(ax01); p2=histogram(TRCASE,bins);
axes(ax02); p3=histogram(TECTRL,bins); 
    xlabel('Age distribution Validation set (case=red, ctrl=blue)');hold on;
axes(ax02); p4=histogram(TECASE,bins); 

pause(1)
% fh01 = figure('Units','normalized','OuterPosition',[.01 .05 .95 .90],...
%               'Color','w','MenuBar','none');
% ax01 = axes('Position',[.06 .56 .4 .4],'Color','none');
% ax02 = axes('Position',[.56 .56 .4 .4],'Color','none');
% ax03 = axes('Position',[.06 .06 .4 .4],'Color','none');
% ax04 = axes('Position',[.56 .06 .4 .4],'Color','none');
% 
% axes(ax01); p1=histogram(TRCASE,bins); 
%     xlabel('TR CASE'); hold on;
% axes(ax02); p2=histogram(TRCTRL,bins); 
%     xlabel('TR CTRL'); hold on;
% axes(ax03); p3=histogram(TECASE,bins); 
%     xlabel('TE CASE'); hold on;
% axes(ax04); p4=histogram(TECTRL,bins); 
%     xlabel('TE CTRL'); hold on;
% pause(1)
% end
%---------------------------------------------------------------
%---------------------------------------------------------------
end
%---------------------------------------------------------------
%---------------------------------------------------------------













end