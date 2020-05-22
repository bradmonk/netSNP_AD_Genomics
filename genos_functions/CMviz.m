function [] = CMviz()
%%


% close all;
figure('Units','pixels','Position',[10 50 1000 700],'Color','w');

%--Predicted
ax{1}  = axes('Units','pixels','Position',[15 300 35 300],'Color','none',...
    'XColor','none','YColor','none'); box off;
%--Total Population
ax{2}  = axes('Units','pixels','Position',[50 600 100  50],'Color',[.95 .95 .95],...
    'XTick',[],'YTick',[]); box on;
%--Pred+
ax{3}  = axes('Units','pixels','Position',[50 450 100 150],'Color',[.85 .98 .99],...
    'XTick',[],'YTick',[]); box on;
%--Pred-
ax{4}  = axes('Units','pixels','Position',[50 300 100 150],'Color',[.80 .95 .99],...
    'XTick',[],'YTick',[]); box on;
%--Condition
ax{5}  = axes('Units','pixels','Position',[150 640 400  40],'Color','none',...
    'XColor','none','YColor','none'); box off;
%--Cond+
ax{6}  = axes('Units','pixels','Position',[150 600 200  50],'Color',[.98 .98 .85],...
    'XTick',[],'YTick',[]); box on;
%--Cond-
ax{11} = axes('Units','pixels','Position',[350 600 200  50],'Color',[.94 .95 .88],...
    'XTick',[],'YTick',[]); box on;
%--TP
ax{7}  = axes('Units','pixels','Position',[150 450 200 150],'Color',[.92 .99 .92],...
    'XTick',[],'YTick',[]); box on;
%--FN
ax{8}  = axes('Units','pixels','Position',[150 300 200 150],'Color',[.99 .95 .95],...
    'XTick',[],'YTick',[]); box on;
%--TPR
ax{9}  = axes('Units','pixels','Position',[150 160 200 140],'Color',[.91 .99 .96],...
    'XTick',[],'YTick',[]); box on;
%--FNR
ax{10} = axes('Units','pixels','Position',[150  20 200 140],'Color',[.99 .96 .90],...
    'XTick',[],'YTick',[]); box on;
%--FP
ax{12} = axes('Units','pixels','Position',[350 450 200 150],'Color',[.99 .95 .95],...
    'XTick',[],'YTick',[]); box on;
%--TN
ax{13} = axes('Units','pixels','Position',[350 300 200 150],'Color',[.92 .99 .92],...
    'XTick',[],'YTick',[]); box on;
%--FPR
ax{14} = axes('Units','pixels','Position',[350 160 200 140],'Color',[.99 .96 .90],...
    'XTick',[],'YTick',[]); box on;
%--TNR
ax{15} = axes('Units','pixels','Position',[350  20 200 140],'Color',[.91 .99 .96],...
    'XTick',[],'YTick',[]); box on;
%--PREV
ax{16} = axes('Units','pixels','Position',[550 600 200  50],'Color',[.98 .98 .98],...
    'XTick',[],'YTick',[]); box on;
%--PPV
ax{17} = axes('Units','pixels','Position',[550 450 200 150],'Color',[.91 .99 .96],...
    'XTick',[],'YTick',[]); box on;
%--FOR
ax{18} = axes('Units','pixels','Position',[550 300 200 150],'Color',[.99 .96 .90],...
    'XTick',[],'YTick',[]); box on;
%--PLR
ax{19} = axes('Units','pixels','Position',[550 160 200 140],'Color',[.99 .99 .99],...
    'XTick',[],'YTick',[]); box on;
%--NLR
ax{20} = axes('Units','pixels','Position',[550  20 200 140],'Color',[.99 .99 .99],...
    'XTick',[],'YTick',[]); box on;
%--ACC
ax{21} = axes('Units','pixels','Position',[750 600 200  50],'Color',[.99 .99 .99],...
    'XTick',[],'YTick',[]); box on;
%--FDR
ax{22} = axes('Units','pixels','Position',[750 450 200 150],'Color',[.99 .96 .90],...
    'XTick',[],'YTick',[]); box on;
%--NPV
ax{23} = axes('Units','pixels','Position',[750 300 200 150],'Color',[.91 .99 .96],...
    'XTick',[],'YTick',[]); box on;
%--DOR
ax{24} = axes('Units','pixels','Position',[750 160 200 140],'Color',[.99 .99 .99],...
    'XTick',[],'YTick',[]); box on;
%--FOS
ax{25} = axes('Units','pixels','Position',[750  20 200 140],'Color',[.95 .95 .95],...
    'XTick',[],'YTick',[]); box on;
%--AUC
ax{26}  = axes('Units','pixels','Position',[50 160 100 140],'Color',[1 1 1],...
    'XTick',[],'YTick',[]); box on;
%--OOP
ax{27}  = axes('Units','pixels','Position',[50  20 100 140],'Color',[1 1 1],...
    'XTick',[],'YTick',[]); box on;


% －
% FULLWIDTH HYPHEN-MINUS
% Unicode: U+FF0D, UTF-8: EF BC 8D
% ＋
% FULLWIDTH PLUS SIGN
% Unicode: U+FF0B, UTF-8: EF BC 8B
% ❨
% MEDIUM LEFT PARENTHESIS ORNAMENT
% Unicode: U+2768, UTF-8: E2 9D A8
% ❩
% MEDIUM RIGHT PARENTHESIS ORNAMENT
% Unicode: U+2769, UTF-8: E2 9D A9



tx{ 1}=text(ax{ 1},.5,.5,'Predicted','Visible','off','Rotation',90);
tx{ 2}=text(ax{ 2},.5,.5,{'Total','($$Pop$$)ulation'},'Visible','off');
tx{ 3}=text(ax{ 3},.5,.5,{'$$N Pred(+)$$'},'Visible','off');
tx{ 4}=text(ax{ 4},.5,.5,{'$$N Pred(-)$$'},'Visible','off');
tx{ 5}=text(ax{ 5},.5,.5,{'Condition'},'Visible','off');
tx{ 6}=text(ax{ 6},.5,.5,{'$$N Cond(+)$$'},'Visible','off');
tx{ 7}=text(ax{ 7},.5,.5,{'True Positive','$$TP$$'},'Visible','off');
tx{ 8}=text(ax{ 8},.5,.5,{'False Negative','$$FN$$'},'Visible','off');
tx{ 9}=text(ax{ 9},.5,.5,{'True Positive Rate','','$$TPR = \frac{TP}{Cond(+)}$$'},'Visible','off');
tx{10}=text(ax{10},.5,.5,{'False Negative Rate','','$$FNR = \frac{FN}{Cond(+)}$$'},'Visible','off');
tx{11}=text(ax{11},.5,.5,{'$$N Cond(-)$$'},'Visible','off');
tx{12}=text(ax{12},.5,.5,{'False Positive','$$FP$$'},'Visible','off');
tx{13}=text(ax{13},.5,.5,{'True Negative','$$TN$$'},'Visible','off');
tx{14}=text(ax{14},.5,.5,{'False Positive Rate','','$$FPR = \frac{FP}{Cond(-)}$$'},'Visible','off');
tx{15}=text(ax{15},.5,.5,{'True Negative Rate' ,'','$$TNR = \frac{TN}{Cond(-)}$$'},'Visible','off');
tx{16}=text(ax{16},.5,.5,{'$$(Prev)alence = \frac{Cond(+)}{Pop}$$'},'Visible','off');
tx{17}=text(ax{17},.5,.5,{'Positive Predictive Value','','$$PPV = \frac{TP}{Pred(+)}$$'},'Visible','off');
tx{18}=text(ax{18},.5,.5,{'False Omission Rate','','$$FOR = \frac{FN}{Pred(-)}$$'},'Visible','off');
tx{19}=text(ax{19},.5,.5,{'Positive Likelihood Ratio','','$$PLR = \frac{TPR}{FPR}$$'},'Visible','off');
tx{20}=text(ax{20},.5,.5,{'Negative Likelihood Ratio','','$$NLR = \frac{FNR}{TNR}$$'},'Visible','off');
tx{21}=text(ax{21},.5,.5,{'$$(Acc)uracy = \frac{(TP + TN)}{Pop}$$'},'Visible','off');
tx{22}=text(ax{22},.5,.5,{'False Discovery Rate','','$$FDR = \frac{FP}{Pred(+)}$$'},'Visible','off');
tx{23}=text(ax{23},.5,.5,{'Negative Predictive Value','','$$NPV = \frac{TN}{Pred(-)}$$'},'Visible','off');
tx{24}=text(ax{24},.5,.5,{'Diagnostic Odds Ratio','','$$DOR = \frac{PLR}{NLR}$$'},'Visible','off');
tx{25}=text(ax{25},.5,.5,{'F1-Score','','$$FOS = 2*\frac{PPV*TPR}{(PPV+TPR)}$$'},'Visible','off');
tx{26}=text(ax{26},.5,.5,{'AUC'},'Visible','off');
tx{27}=text(ax{27},.5,.5,{'OOP'},'Visible','off');


for i=1:27
    tx{i}.FontSize = 14;
    tx{i}.HorizontalAlignment = 'center';
    tx{i}.Interpreter = 'latex';
    tx{i}.Visible = 'on';
end

tx{1}.FontSize = 18;
tx{5}.FontSize = 18;


%%
end
