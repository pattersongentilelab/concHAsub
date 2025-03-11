% Organize VEP subject data and combine with VEP matlab files excellent

%% select VEP data from headache substudy to match raw VEP file with HSS ID
data_path = getpref('concHAsub','concHAsubDataPath');
filepath = [data_path '/VEP'];
addpath '/Users/pattersonc/Documents/MATLAB/commonFx'

tbl1 = readtable([filepath '/KOP_03.07.2025.csv']);
tbl2 = readtable([filepath '/rawdataIDlink_03.07.2025.csv']);

tbl1 = tbl1(contains(tbl1.LastName,'HSS')==1,:);
tbl2 = tbl2(contains(tbl2.Var2,'HSS')==1,:);

% correct naming issues
tbl1.LastName = replace(tbl1.LastName,'HSS-020T3_final','HSS-020T3');
tbl1.FirstName = replace(tbl1.FirstName,'HSS-020T3_final','HSS-020T3');
tbl2.Var2 = replace(tbl2.Var2,'HSS-020T3_final','HSS-020T3');
tbl2.Var3 = replace(tbl2.Var3,'HSS-020T3_final','HSS-020T3');
tbl2.Var2 = replace(tbl2.Var2,'HSS-023','HSS-023T1');
tbl2.Var3 = replace(tbl2.Var3,'HSS-023','HSS-023T1');
tbl2.Var2 = replace(tbl2.Var2,'HSS-024','HSS-024T1');
tbl2.Var3 = replace(tbl2.Var3,'HSS-024','HSS-024T1');

% remove HSS-023 and HSS-024 who did not tolerate the study, and -037 who
% did not meet eligibility criteria
tbl1 = tbl1(contains(tbl1.LastName,'T1')==1|contains(tbl1.LastName,'T2')==1|contains(tbl1.LastName,'T3')==1,:);
tbl2 = tbl2(contains(tbl2.Var2,'T1')==1|contains(tbl2.Var2,'T2')==1|contains(tbl2.Var2,'T3')==1,:);

%% Compile IDs to match study ID with raw matlab file and create filename
match_ID = table(tbl1.LastName,tbl1.LastName,zeros(size(tbl1.TestID)),tbl1.TestID,tbl1.LastName,'VariableNames',{'StudyID','TimePoint','SessionID','TrialID','Filename'});
match_ID.TimePoint(contains(match_ID.TimePoint,'T1')==1) = {'T1'};
match_ID.TimePoint(contains(match_ID.TimePoint,'T2')==1) = {'T2'};
match_ID.TimePoint(contains(match_ID.TimePoint,'T3')==1) = {'T3'};
match_ID.StudyID = erase(match_ID.StudyID,'T1');
match_ID.StudyID = erase(match_ID.StudyID,'T2');
match_ID.StudyID = erase(match_ID.StudyID,'T3');

Participants = unique(match_ID.StudyID);

for x = 1:length(Participants)
    for y = 1:3
        T = {['T' num2str(y)]};
        temp = tbl2.Var1(contains(tbl2.Var2,Participants(x))==1 & contains(tbl2.Var2,T)==1);
        if ~isempty(temp)
            temp = temp(end);
            match_ID.SessionID(contains(match_ID.StudyID,Participants(x))==1 & contains(match_ID.TimePoint,T)==1) = temp;
        end
    end
end


for x = 1:height(match_ID)
    match_ID.Filename(x) = {['f00000' num2str(match_ID.SessionID(x)) '_0000' num2str(match_ID.TrialID(x)) '.m']};
end

clear temp x y

%% Extract VEP files
match_ID.raw_vep = cell(height(match_ID),1);
for x=1:height(match_ID)
    

    run([filepath '/' char(match_ID.Filename(x))]);

    if exist('RawDataFrame_15')==1
    match_ID.raw_vep{x} = cat(1,RawDataFrame_1,RawDataFrame_2,RawDataFrame_3,RawDataFrame_4,RawDataFrame_5,RawDataFrame_6,...
        RawDataFrame_7,RawDataFrame_8,RawDataFrame_9,RawDataFrame_10,RawDataFrame_11,RawDataFrame_12,RawDataFrame_13,...
        RawDataFrame_14,RawDataFrame_15);
    end

    if exist('RawDataFrame_15')==0 && exist('RawDataFrame_13')==1
            match_ID.raw_vep{x} = cat(1,RawDataFrame_1,RawDataFrame_2,RawDataFrame_3,RawDataFrame_4,RawDataFrame_5,RawDataFrame_6,...
        RawDataFrame_7,RawDataFrame_8,RawDataFrame_9,RawDataFrame_10,RawDataFrame_11,RawDataFrame_12,RawDataFrame_13,...
        RawDataFrame_14);
    end
    
    if exist('RawDataFrame_13')==0
    match_ID.raw_vep{x} = cat(1,RawDataFrame_1,RawDataFrame_2,RawDataFrame_3,RawDataFrame_4,RawDataFrame_5,RawDataFrame_6,...
        RawDataFrame_7,RawDataFrame_8,RawDataFrame_9,RawDataFrame_10,RawDataFrame_11,RawDataFrame_12);
    end

    clear Raw*
end

Raw_VEP = match_ID;
clear match_ID

%% Filter and parse VEP

Fs = 1024; % Sampling rate
reversal = 2; % number of reversals
d1 = designfilt('bandstopiir','FilterOrder',20,'HalfPowerFrequency1',59,...
    'HalfPowerFrequency2',61,'SampleRate',Fs);  % Bandstop filter for 60Hz powerline noise in VEP signal
d2 = designfilt('bandstopiir','FilterOrder',20,'HalfPowerFrequency1',119,...
        'HalfPowerFrequency2',121,'SampleRate',Fs); % Bandstop filter for 120Hz noise harmonic in VEP signal

Raw_VEP.x_data = cell(height(Raw_VEP),1);
Raw_VEP.cleaned_vep = cell(height(Raw_VEP),1);
Raw_VEP.discarded_trials = zeros(height(Raw_VEP),1);

for x = 1:height(Raw_VEP)
    VEP = Raw_VEP.raw_vep{x};
 
    dur = length(VEP)./Fs; % total duration of recording (in seconds)
    x_data = 1/Fs:1/Fs:1/reversal;
 
    VEP = filter(d1,VEP);
    VEP = filter(d2,VEP);
    
    y_data = reshape(VEP,[Fs/reversal,dur*reversal])';

    % remove trials where the absolute max voltage >1
    temp = find(max(abs(y_data),[],2)>=1);
    temp2 = find(max(abs(y_data),[],2)<1);
    
    % if ~isempty(temp)
    %     figure(10)
    %     plot(x_data,y_data(temp,:))
    %     title('bad trial')
    %     xlabel(num2str(x))
    %     pause(0.5)
    %     Raw_VEP.discarded_trials(x) = length(temp);
    %      y_data = y_data(temp2,:);
    % end

    % Normalize pre-response to 0
    for y = 1:size(y_data,1)
        temp = mean(mean(y_data(:,1:51)));
        y_data(y,:) = y_data(y,:) - (temp*ones(size(y_data(y,:))));
    end
    
    y_data = y_data.*100; % correct for amplification error, convert to microV
    
    max_ydata = NaN*ones(height(y_data),1);

    Raw_VEP.cleaned_vep{x} = y_data;
    Raw_VEP.x_data{x} = x_data;
    
    clear y_data
end


%% Organize data by participant and session

vep = table([Participants;Participants;Participants],[ones(length(Participants),1);2*ones(length(Participants),1);3*ones(length(Participants),1)],'VariableNames',{'StudyID','TimePoint'});
vep.baseline = cell(height(vep),1);
vep.response = cell(height(vep),1);
for x = 1:height(vep)
    P = vep.StudyID(x);
    T = {['T' num2str(vep.TimePoint(x))]};
    temp = Raw_VEP(contains(Raw_VEP.StudyID,P)==1 & contains(Raw_VEP.TimePoint,T)==1,:);
    i = height(temp);
    switch i
        case 0
            vep.baseline{x} = NaN;
            vep.response{x} = NaN;
        case 4
            vep.baseline(x) = temp.cleaned_vep(1);
            vep.response{x} = [temp.cleaned_vep{2};temp.cleaned_vep{3};temp.cleaned_vep{4}];
        case 5
            vep.baseline(x) = temp.cleaned_vep(1);
            vep.response{x} = [temp.cleaned_vep{2};temp.cleaned_vep{3};temp.cleaned_vep{4};temp.cleaned_vep{5}];
        case 6
            vep.baseline(x) = temp.cleaned_vep(1);
            vep.response{x} = [temp.cleaned_vep{2};temp.cleaned_vep{3};temp.cleaned_vep{4};temp.cleaned_vep{5};temp.cleaned_vep{6}];
        case 7
            vep.baseline(x) = temp.cleaned_vep(1);
            vep.response{x} = [temp.cleaned_vep{2};temp.cleaned_vep{3};temp.cleaned_vep{4};temp.cleaned_vep{5};temp.cleaned_vep{6};temp.cleaned_vep{7}];
        case 8
            vep.baseline(x) = temp.cleaned_vep(1);
            vep.response{x} = [temp.cleaned_vep{2};temp.cleaned_vep{3};temp.cleaned_vep{4};temp.cleaned_vep{5};temp.cleaned_vep{6};temp.cleaned_vep{7};temp.cleaned_vep{8}];
        case 9
            vep.baseline(x) = temp.cleaned_vep(1);
            vep.response{x} = [temp.cleaned_vep{2};temp.cleaned_vep{3};temp.cleaned_vep{4};temp.cleaned_vep{5};temp.cleaned_vep{6};temp.cleaned_vep{7};temp.cleaned_vep{8};temp.cleaned_vep{9}];
        case 10
            vep.baseline(x) = temp.cleaned_vep(1);
            vep.response{x} = [temp.cleaned_vep{2};temp.cleaned_vep{3};temp.cleaned_vep{4};temp.cleaned_vep{5};temp.cleaned_vep{6};temp.cleaned_vep{7};temp.cleaned_vep{8};temp.cleaned_vep{9};temp.cleaned_vep{10}];
    end
end

%% Fit to gamma model

time_end = 500; % determines the epoch looked at in ms from t = 0 being the alternating checkerboard
xdata_end = length(x_data(x_data<=time_end));
gammaC = {'b','r','m','g'};
mdl_x = 0:0.1:time_end;
nGamma = 4;
xdata = x_data(1:xdata_end)*1000;

r_val = NaN*ones(height(vep),1);
r_val300 = NaN*ones(height(vep),1);

% Determine fits on individual VEP data
mdl = NaN*ones(height(vep),3*nGamma);
gamma = NaN*ones(nGamma,length(mdl_x));
Gamma = NaN*ones(height(vep),nGamma,length(mdl_x));
yFit = NaN*ones(height(vep),length(xdata));
bandwidth = NaN*ones(height(vep),nGamma);

Amp75 = NaN*ones(height(vep),1);
Peak75 = NaN*ones(height(vep),1);
Bw75 = NaN*ones(height(vep),1);
Amp100 = NaN*ones(height(vep),1);
Peak100 = NaN*ones(height(vep),1);
Bw100 = NaN*ones(height(vep),1);
Amp135 = NaN*ones(height(vep),1);
Peak135 = NaN*ones(height(vep),1);
Bw135 = NaN*ones(height(vep),1);
Amp220 = NaN*ones(height(vep),1);
Peak220 = NaN*ones(height(vep),1);
Bw220 = NaN*ones(height(vep),1);

for i = 1:height(vep)
        ydata = vep.response{i};
        if ~isempty(ydata)
            if ~isnan(ydata)
                ydata = mean(ydata,1)./max(abs(mean(ydata))); % normalize by maximum response
                diffY = diff([min(ydata) max(ydata)]);
                min_loc = islocalmin(ydata,'MinProminence',diffY*.2);
                min_peak = xdata(min_loc==1);
                max_loc = islocalmax(ydata,'MinProminence',diffY*.2);
                max_peak = xdata(max_loc==1);

                x = sum(min_loc(xdata>60 & xdata<90));
                switch x
                    case 0
                        amp75 = min(ydata(xdata>60 & xdata<90));
                        peak75 = xdata(ydata==amp75);
                        peak75 = peak75(1);
                    case 1
                        peak75 = min_peak(min_peak>60 & min_peak<90);
                        amp75 = ydata(xdata==peak75);
                    otherwise
                        peak75 = min_peak(min_peak>60 & min_peak<90);
                        peak75 = peak75(1);
                        amp75 = ydata(xdata==peak75);
                end
                if amp75>-0.01
                    amp75 = -0.01;
                end

                 x = sum(max_loc(xdata>peak75+5 & xdata<130));
                switch x
                    case 0
                        amp100 = max(ydata(xdata>peak75+5 & xdata<130));
                        peak100 = xdata(ydata==amp100);
                        peak100 = peak100(1);
                    case 1
                        peak100 = max_peak(max_peak>peak75+5 & max_peak<130);
                        amp100 = ydata(xdata==peak100);
                    otherwise
                        peak100 = max_peak(max_peak>peak75+5 & max_peak<130);
                        peak100 = peak100(1);
                        amp100 = ydata(xdata==peak100);
                end

                if amp100<0.01
                    amp100 = 0.01;
                end

                x = sum(min_loc(xdata>peak100+5 & xdata<200));
                switch x
                    case 0
                        amp135 = min(ydata(xdata>peak100+5 & xdata<200));
                        peak135 = xdata(ydata==amp135);
                        peak135 = peak135(1);
                    case 1
                        peak135 = min_peak(min_peak>peak100+5 & min_peak<200);
                        amp135 = ydata(xdata==peak135);
                    otherwise
                        peak135 = min_peak(min_peak>peak100+5 & min_peak<200);
                        peak135 = peak135(1);
                        amp135 = ydata(xdata==peak135);
                end

                if amp135>-0.01
                    amp135 = -0.01;
                end

               x = sum(max_loc(xdata>peak135+30 & xdata<350));
                switch x
                    case 0
                        amp220 = max(ydata(xdata>peak135+30 & xdata<350));
                        peak220 = xdata(ydata==amp220);
                        peak220 = peak220(1);
                    case 1
                        peak220 = max_peak(max_peak>peak135+30 & max_peak<350);
                        amp220 = ydata(xdata==peak220);
                    otherwise
                        peak220 = max_peak(max_peak>peak135+30 & max_peak<350);
                        peak220 = peak220(1);
                        amp220 = ydata(xdata==peak220);
                end

                if amp220<0.01
                    amp220 = 0.01;
                end

                bw75 = 10^((80-abs(diff([peak75 peak100])))/30);

                if bw75 < 30
                    bw75 = 30;
                end
                if bw75 > 80
                    bw75 = 80;
                end
                bw100 = 10^((100-(0.5*abs(diff([peak75 peak135]))))/40);
                if bw100 < 20
                    bw100 = 20;
                end
                if bw100 > 80
                    bw100 = 80;
                end
                bw135 = 10^((150-(0.5*abs(diff([peak100 peak220]))))/60);
                if bw135 < 20
                    bw135 = 20;
                end
                if bw135 > 80
                    bw135 = 80;
                end
                bw220 = 10^((200-abs(diff([peak135 peak220])))/80);
                if bw220 < 10
                    bw220 = 10;
                end
                if bw220 > 80
                    bw220 = 80;
                end

                Amp75(i,:) = amp75;
                Peak75(i,:) = peak75;
                Bw75(i,:) = bw75;
                Amp100(i,:) = amp100;
                Peak100(i,:) = peak100;
                Bw100(i,:) = bw100;
                Amp135(i,:) = amp135;
                Peak135(i,:) = peak135;
                Bw135(i,:) = bw135;
                Amp220(i,:) = amp220;
                Peak220(i,:) = peak220;
                Bw220(i,:) = bw220;
            end
        end
end

for i = 1:height(vep)

    ydata = vep.response{i};
    ydata = mean(ydata,1)./max(abs(mean(ydata)));

    if ~isnan(Peak75(i,:))
        p0 = [Bw75(i,:) Peak75(i,:) Amp75(i,:) Bw100(i,:) Peak100(i,:) Amp100(i,:) Bw135(i,:) Peak135(i,:) Amp135(i,:) Bw220(i,:) Peak220(i,:) Amp220(i,:)];
        lb = [max([30 Bw75(i,:)-5]) Peak75(i,:)-2 Amp75(i,:)*1.1 max([20 Bw100(i,:)-5]) Peak100(i,:)-3 Amp100(i,:)*0.9 max([15 Bw135(i,:)-5]) Peak135(i,:)-5 Amp135(i,:)*1.1 max([15 Bw220(i,:)-5]) Peak220(i,:)-5 Amp220(i,:)*0.9]; 
        ub = [min([110 Bw75(i,:)+5]) Peak75(i,:)+2 Amp75(i,:)*0.9 min([110 Bw100(i,:)+5]) Peak100(i,:)+3 Amp100(i,:)*1.1 min([110 Bw135(i,:)+5]) Peak135(i,:)+5 -Amp135(i,:)*0.9 min([100 Bw220(i,:)+5]) Peak220(i,:)+5 Amp220(i,:)*1.1];

        myFx = @(p) sqrt(sum((ydata - gammaVEP_model(xdata,p,nGamma)).^2));
        mdl(i,:) = fmincon(myFx,p0,[],[],[],[],lb,ub);
        [vep_fit,gamma] = gammaVEP_model(mdl_x,mdl(i,:),nGamma);
        Gamma(i,:,:) = gamma;

        for z = 1:nGamma
            bandwidth(i,z,:) = gamma_bandwidth(mdl_x,gamma(z,:));
        end

        [yFit(i,:)] = gammaVEP_model(xdata,mdl(i,:),nGamma);
        r = corrcoef(ydata,yFit(i,:));
        r_val(i,:) = r(1,2);
        r = corrcoef(ydata(1,1:307),yFit(i,1:307));
        r_val300(i,:) = r(1,2);
        
        figure
        subplot(1,2,1)
        plot(xdata,ydata,'-','Color',[0.5 0.5 0.5])
        hold on
        plot(xdata,yFit(i,:),'-k','LineWidth',2)
        ax=gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XLim = [0 time_end]; ax.YLim = [-1.2 1.2];
        xlabel(sprintf('r = %2.2f',r_val(i)))
        title([vep.StudyID(i) vep.TimePoint(i)])
        subplot(1,2,2)
        hold on
        for X = 1:nGamma
             plot(mdl_x,gamma(X,:),['-' gammaC{X}])
        end
        ax=gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.YLim = [-1.2 1.2]; ax.XLim = [0 time_end];
    end
end

peak = mdl(:,2:3:end);
amp = mdl(:,3:3:end);

for i = 1:height(vep)
    vep.mdl(i) = {mdl(i,:)};
    vep.Gamma(i) = {squeeze(Gamma(i,:,:))};
    vep.yFit(i) = {yFit(i,:)};
    vep.peak1(i) = peak(i,1);
    vep.amp1(i) = amp(i,1);
    vep.bandwidth1(i) = bandwidth(i,1);
    vep.peak2(i) = peak(i,2);
    vep.amp2(i) = amp(i,2);
    vep.bandwidth2(i) = bandwidth(i,2);
    vep.peak3(i) = peak(i,3);
    vep.amp3(i) = amp(i,3);
    vep.bandwidth3(i) = bandwidth(i,3);
    vep.peak4(i) = peak(i,4);
    vep.amp4(i) = amp(i,4);
    vep.bandwidth4(i) = bandwidth(i,4);
    vep.R(i) = r_val(i);
    vep.R300(i) = r_val300(i);
end

save([filepath '/vep_files.mat'],'Raw_VEP','vep','xdata','mdl_x')