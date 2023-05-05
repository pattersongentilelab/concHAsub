% Organize VEP subject data and combine with VEP matlab files

data_path = getpref('concHAsub','concHAsubDataPath');

load([data_path '/blood biomarker/blood_biomarker_022023.mat'])

subject_info = readtable([data_path '/Forms/HSS QA Prelim Demographic Breakdown.csv']);

% Select mean concentration for each of the biomarkers
NFL_GFAP = table(GFAP_NFL_0223.VarName1,GFAP_NFL_0223.MeanConc,GFAP_NFL_0223.MeanConc1,'VariableNames',{'ID','NFL','GFAP'});
IL6_IL10 = table(IL6_IL10_0223.SubjectID,IL6_IL10_0223.VarName11,IL6_IL10_0223.VarName14,'VariableNames',{'ID','IL6','IL10'});
TNFa = table(TNFa_0223.SubjectID,TNFa_0223.VarName10,'VariableNames',{'ID','TNFa'});

% Select and organize hyperacute sample
NFL_GFAP_acute = NFL_GFAP(contains(NFL_GFAP.ID,'ACE')==1,:);
IL6_IL10_acute = IL6_IL10(contains(IL6_IL10.ID,'ACE')==1,:);
TNFa_acute = TNFa(contains(TNFa.ID,'ACE')==1,:);
TNFa_acute.ID = replace(TNFa_acute.ID,'ACED077','ACED057'); % Check to make sure this is correct
temp1 = join(NFL_GFAP_acute,IL6_IL10_acute,'Keys','ID');
biomarker_acute = join(temp1,TNFa_acute,'Keys','ID');

% Select and organize longitudinal sample
GN_T1 = NFL_GFAP(contains(NFL_GFAP.ID,'T1')==1,:);
GN_T1.Properties.VariableNames = {'ID','NFL_T1','GFAP_T1'};
GN_T1.ID = replace(GN_T1.ID,'T1-B','');
GN_T2 = NFL_GFAP(contains(NFL_GFAP.ID,'T2')==1,:);
GN_T2.Properties.VariableNames = {'ID','NFL_T2','GFAP_T2'};
GN_T2.ID = replace(GN_T2.ID,'T2-B','');
GN_T3 = NFL_GFAP(contains(NFL_GFAP.ID,'T3')==1,:);
GN_T3.Properties.VariableNames = {'ID','NFL_T3','GFAP_T3'};
GN_T3.ID = replace(GN_T3.ID,'T3-B','');
GN_T3.ID = replace(GN_T3.ID,'-02','-002');
biomarker_long = join(GN_T1,GN_T2,'Keys','ID');
biomarker_long = join(biomarker_long,GN_T3,'Keys','ID');
clear GN_T*

TNF_T1 = TNFa(contains(TNFa.ID,'T1')==1,:);
TNF_T1.Properties.VariableNames = {'ID','TNFa_T1'};
TNF_T1.ID = replace(TNF_T1.ID,'T1-B','');
TNF_T2 = TNFa(contains(TNFa.ID,'T2')==1,:);
TNF_T2.Properties.VariableNames = {'ID','TNFa_T2'};
TNF_T2.ID = replace(TNF_T1.ID,'T2-B','');
TNF_T3 = TNFa(contains(TNFa.ID,'T3')==1,:);
TNF_T3.Properties.VariableNames = {'ID','TNFa_T3'};
TNF_T3.ID = replace(TNF_T3.ID,'T3-B','');
biomarker_long = join(biomarker_long,TNF_T1,'Keys','ID');
biomarker_long = join(biomarker_long,TNF_T2,'Keys','ID');
biomarker_long = join(biomarker_long,TNF_T3,'Keys','ID');
clear TNF_T*

IL_T1 = IL6_IL10(contains(IL6_IL10.ID,'T1')==1,:);
IL_T1.Properties.VariableNames = {'ID','IL6_T1','IL10_T1'};
IL_T1.ID = replace(IL_T1.ID,'T1-B','');
IL_T2 = IL6_IL10(contains(IL6_IL10.ID,'T2')==1,:);
IL_T2.Properties.VariableNames = {'ID','IL6_T2','IL10_T2'};
IL_T2.ID = replace(IL_T1.ID,'T2-B','');
IL_T3 = IL6_IL10(contains(IL6_IL10.ID,'T3')==1,:);
IL_T3.Properties.VariableNames = {'ID','IL6_T3','IL10_T3'};
IL_T3.ID = replace(IL_T1.ID,'T3-B','');
biomarker_long = join(biomarker_long,IL_T1,'Keys','ID');
biomarker_long = join(biomarker_long,IL_T2,'Keys','ID');
biomarker_long = join(biomarker_long,IL_T3,'Keys','ID');
clear IL_T*


figure
subplot(5,2,1)
title('GFAP')
hold on
ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XLim = [0 2]; ax.XTick = 1; ax.XTickLabels = {'acute'};
plot(1,biomarker_acute.GFAP,'ok','MarkerFaceColor','k')

subplot(5,2,3)
title('NF-L')
hold on
ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XLim = [0 2]; ax.XTick = 1; ax.XTickLabels = {'acute'};
plot(1,biomarker_acute.NFL,'ok','MarkerFaceColor','k')

subplot(5,2,5)
title('TNFa')
hold on
ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XLim = [0 2]; ax.XTick = 1; ax.XTickLabels = {'acute'};
plot(1,biomarker_acute.TNFa,'ok','MarkerFaceColor','k')

subplot(5,2,7)
title('IL-6')
hold on
ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XLim = [0 2]; ax.XTick = 1; ax.XTickLabels = {'acute'};
plot(1,biomarker_acute.IL6,'ok','MarkerFaceColor','k')

subplot(5,2,9)
title('IL-10')
hold on
ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XLim = [0 2]; ax.XTick = 1; ax.XTickLabels = {'acute'};
plot(1,biomarker_acute.IL10,'ok','MarkerFaceColor','k')

subplot(5,2,2)
title('GFAP')
hold on
ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XLim = [1 5]; ax.XTick = 2:4; ax.XTickLabels = {'T1','T2','T3'};
plot(2:4,[biomarker_long.GFAP_T1 biomarker_long.GFAP_T2 biomarker_long.GFAP_T3]','--ok','MarkerFaceColor','k')

subplot(5,2,4)
title('NF-L')
hold on
ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XLim = [1 5]; ax.XTick = 2:4; ax.XTickLabels = {'T1','T2','T3'};
plot(2:4,[biomarker_long.NFL_T1 biomarker_long.NFL_T2 biomarker_long.NFL_T3]','--ok','MarkerFaceColor','k')

subplot(5,2,6)
title('TNFa')
hold on
ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XLim = [1 5]; ax.XTick = 2:4; ax.XTickLabels = {'T1','T2','T3'};
plot(2:4,[biomarker_long.TNFa_T1 biomarker_long.TNFa_T2 biomarker_long.TNFa_T3]','--ok','MarkerFaceColor','k')

subplot(5,2,8)
title('IL-6')
hold on
ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XLim = [1 5]; ax.XTick = 2:4; ax.XTickLabels = {'T1','T2','T3'};
plot(2:4,[biomarker_long.IL6_T1 biomarker_long.IL6_T2 biomarker_long.IL6_T3]','--ok','MarkerFaceColor','k')

subplot(5,2,10)
title('IL-10')
hold on
ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XLim = [1 5]; ax.XTick = 2:4; ax.XTickLabels = {'T1','T2','T3'};
plot(2:4,[biomarker_long.IL10_T1 biomarker_long.IL6_T2 biomarker_long.IL10_T3]','--ok','MarkerFaceColor','k')