% Organize VEP subject data and combine with VEP matlab files

data_path = getpref('concHAsub','concHAsubDataPath');

subject_info = readtable([data_path '/Forms/HeadacheSubstudy-DemographicsAndIntak_DATA_LABELS_2025-03-10_1300.csv']);

biomarker = readtable([data_path '/blood biomarker/combinedPrelimCytokines_031425.xlsx']);
RecordID = split(biomarker.RecordID,' ');
biomarker.Timepoint = categorical(RecordID(:,2));
biomarker.RecordID = categorical(RecordID(:,1));
biomarker.Group = categorical(repmat({'case'},[height(biomarker) 1]));
biomarker.Group(contains(string(biomarker.RecordID),'Control')) = 'control';
clear RecordID

%% Plot biomarkers across time

% IL6
subplot(2,3,1)
jtr = 0.1*rand([height(biomarker.IL6(biomarker.Group=='case' & biomarker.Timepoint=='T1')) 1])-0.05;
jtr2 = 0.1*rand([height(biomarker.IL6(biomarker.Group=='control')) 1])-0.05;
x = [ones(height(biomarker.IL6(biomarker.Group=='case' & biomarker.Timepoint=='T1')),1)+jtr...
    2*ones(height(biomarker.IL6(biomarker.Group=='case' & biomarker.Timepoint=='T1')),1)+jtr... 
    3*ones(height(biomarker.IL6(biomarker.Group=='case' & biomarker.Timepoint=='T1')),1)+jtr];
y = [biomarker.IL6(biomarker.Group=='case' & biomarker.Timepoint=='T1') biomarker.IL6(biomarker.Group=='case'...
    & biomarker.Timepoint=='T2') biomarker.IL6(biomarker.Group=='case' & biomarker.Timepoint=='T3')];
plot(x',y','--o','Color',[0.8 0.8 0.8],'MarkerFaceColor',[0.5 0.5 1])
hold on
plot(1:3,nanmean(y,1),'-xb')
plot(4*ones(size(jtr2))+jtr2,biomarker.IL6(biomarker.Group=='control'),'o','Color',[0.8 0.8 0.8],'MarkerFaceColor',[0.5 0.5 0.5])
plot(4,nanmean(biomarker.IL6(biomarker.Group=='control')),'xb')
title('IL6')
xlabel('Timepoint')
ax=gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XLim = [0.5 4.5]; ax.YLim = [0 max(max(y))*1.1];
ax.XTick = 1:4; ax.XTickLabel = {'<2 weeks','3 weeks','5 weeks','control'};

% IL10
subplot(2,3,2)
jtr = 0.1*rand([height(biomarker.IL10(biomarker.Group=='case' & biomarker.Timepoint=='T1')) 1])-0.05;
jtr2 = 0.1*rand([height(biomarker.IL10(biomarker.Group=='control')) 1])-0.05;
x = [ones(height(biomarker.IL10(biomarker.Group=='case' & biomarker.Timepoint=='T1')),1)+jtr...
    2*ones(height(biomarker.IL10(biomarker.Group=='case' & biomarker.Timepoint=='T1')),1)+jtr... 
    3*ones(height(biomarker.IL10(biomarker.Group=='case' & biomarker.Timepoint=='T1')),1)+jtr];
y = [biomarker.IL10(biomarker.Group=='case' & biomarker.Timepoint=='T1') biomarker.IL10(biomarker.Group=='case'...
    & biomarker.Timepoint=='T2') biomarker.IL10(biomarker.Group=='case' & biomarker.Timepoint=='T3')];
plot(x',y','--o','Color',[0.8 0.8 0.8],'MarkerFaceColor',[1 0.5 1])
hold on
plot(1:3,nanmean(y,1),'-xm')
plot(4*ones(size(jtr2))+jtr2,biomarker.IL10(biomarker.Group=='control'),'o','Color',[0.8 0.8 0.8],'MarkerFaceColor',[0.5 0.5 0.5])
plot(4,nanmean(biomarker.IL10(biomarker.Group=='control')),'xm')
title('IL10')
xlabel('Timepoint')
ax=gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XLim = [0.5 4.5]; ax.YLim = [0 max(max(y))*1.1];
ax.XTick = 1:4; ax.XTickLabel = {'<2 weeks','3 weeks','5 weeks','control'};

% TNFa
subplot(2,3,3)
jtr = 0.1*rand([height(biomarker.TNFa(biomarker.Group=='case' & biomarker.Timepoint=='T1')) 1])-0.05;
jtr2 = 0.1*rand([height(biomarker.TNFa(biomarker.Group=='control')) 1])-0.05;
x = [ones(height(biomarker.TNFa(biomarker.Group=='case' & biomarker.Timepoint=='T1')),1)+jtr...
    2*ones(height(biomarker.TNFa(biomarker.Group=='case' & biomarker.Timepoint=='T1')),1)+jtr... 
    3*ones(height(biomarker.TNFa(biomarker.Group=='case' & biomarker.Timepoint=='T1')),1)+jtr];
y = [biomarker.TNFa(biomarker.Group=='case' & biomarker.Timepoint=='T1') biomarker.TNFa(biomarker.Group=='case'...
    & biomarker.Timepoint=='T2') biomarker.TNFa(biomarker.Group=='case' & biomarker.Timepoint=='T3')];
plot(x',y','--o','Color',[0.8 0.8 0.8],'MarkerFaceColor',[1 0.5 0.5])
hold on
plot(1:3,nanmean(y,1),'-xr')
plot(4*ones(size(jtr2))+jtr2,biomarker.TNFa(biomarker.Group=='control'),'o','Color',[0.8 0.8 0.8],'MarkerFaceColor',[0.5 0.5 0.5])
plot(4,nanmean(biomarker.TNFa(biomarker.Group=='control')),'xr')
title('TNFa')
xlabel('Timepoint')
ax=gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XLim = [0.5 4.5]; ax.YLim = [0 max(max(y))*1.1];
ax.XTick = 1:4; ax.XTickLabel = {'<2 weeks','3 weeks','5 weeks','control'};

% GFAP
subplot(2,3,4)
jtr = 0.1*rand([height(biomarker.GFAP(biomarker.Group=='case' & biomarker.Timepoint=='T1')) 1])-0.05;
jtr2 = 0.1*rand([height(biomarker.GFAP(biomarker.Group=='control')) 1])-0.05;
x = [ones(height(biomarker.GFAP(biomarker.Group=='case' & biomarker.Timepoint=='T1')),1)+jtr...
    2*ones(height(biomarker.GFAP(biomarker.Group=='case' & biomarker.Timepoint=='T1')),1)+jtr... 
    3*ones(height(biomarker.GFAP(biomarker.Group=='case' & biomarker.Timepoint=='T1')),1)+jtr];
y = [biomarker.GFAP(biomarker.Group=='case' & biomarker.Timepoint=='T1') biomarker.GFAP(biomarker.Group=='case'...
    & biomarker.Timepoint=='T2') biomarker.GFAP(biomarker.Group=='case' & biomarker.Timepoint=='T3')];
plot(x',y','--o','Color',[0.8 0.8 0.8],'MarkerFaceColor',[0.5 1 0.5])
hold on
plot(1:3,nanmean(y,1),'-xg')
plot(4*ones(size(jtr2))+jtr2,biomarker.GFAP(biomarker.Group=='control'),'o','Color',[0.8 0.8 0.8],'MarkerFaceColor',[0.5 0.5 0.5])
plot(4,nanmean(biomarker.GFAP(biomarker.Group=='control')),'xg')
title('GFAP')
xlabel('Timepoint')
ax=gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XLim = [0.5 4.5]; ax.YLim = [0 max(max(y))*1.1];
ax.XTick = 1:4; ax.XTickLabel = {'<2 weeks','3 weeks','5 weeks','control'};

% NFL
subplot(2,3,5)
jtr = 0.1*rand([height(biomarker.NFL(biomarker.Group=='case' & biomarker.Timepoint=='T1')) 1])-0.05;
jtr2 = 0.1*rand([height(biomarker.NFL(biomarker.Group=='control')) 1])-0.05;
x = [ones(height(biomarker.NFL(biomarker.Group=='case' & biomarker.Timepoint=='T1')),1)+jtr...
    2*ones(height(biomarker.NFL(biomarker.Group=='case' & biomarker.Timepoint=='T1')),1)+jtr... 
    3*ones(height(biomarker.NFL(biomarker.Group=='case' & biomarker.Timepoint=='T1')),1)+jtr];
y = [biomarker.NFL(biomarker.Group=='case' & biomarker.Timepoint=='T1') biomarker.NFL(biomarker.Group=='case'...
    & biomarker.Timepoint=='T2') biomarker.NFL(biomarker.Group=='case' & biomarker.Timepoint=='T3')];
plot(x',y','--o','Color',[0.8 0.8 0.8],'MarkerFaceColor',[1 1 0.5])
hold on
plot(1:3,nanmean(y,1),'-xy')
plot(4*ones(size(jtr2))+jtr2,biomarker.NFL(biomarker.Group=='control'),'o','Color',[0.8 0.8 0.8],'MarkerFaceColor',[0.5 0.5 0.5])
plot(4,nanmean(biomarker.NFL(biomarker.Group=='control')),'xy')
title('NFL')
xlabel('Timepoint')
ax=gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XLim = [0.5 4.5]; ax.YLim = [0 max(max(y))*1.1];
ax.XTick = 1:4; ax.XTickLabel = {'<2 weeks','3 weeks','5 weeks','control'};