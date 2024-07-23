% Organize VEP subject data and combine with VEP matlab files

%% select VEP data from headache substudy to match raw VEP file with HSS ID
data_path = getpref('concHAsub','concHAsubDataPath');
filepath = [data_path '/VEP'];

tbl1 = readtable([filepath '/KOP_07.16.2024.csv']);
tbl2 = readtable([filepath '/rawdataIDlink_07.16.2024.csv']);

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

% remove HSS-023 and HSS-024 who did not tolerate the study, and HSS-037 whoo has not yet completed the study
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

    match_ID.raw_vep{x} = cat(1,RawDataFrame_1,RawDataFrame_2,RawDataFrame_3,RawDataFrame_4,RawDataFrame_5,RawDataFrame_6,...
        RawDataFrame_7,RawDataFrame_8,RawDataFrame_9,RawDataFrame_10,RawDataFrame_11,RawDataFrame_12,RawDataFrame_13,...
        RawDataFrame_14,RawDataFrame_15);

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
    
    if ~isempty(temp)
        figure(10)
        plot(x_data,y_data(temp,:))
        title('bad trial')
        pause
        Raw_VEP.discarded_trials(x) = length(temp);
         y_data = y_data(temp2,:);
    end

    % Normalize pre-response to 0
    for y = 1:size(y_data,1)
        temp = mean(mean(y_data(:,1:51)));
        y_data(y,:) = y_data(y,:) - (temp*ones(size(y_data(y,:))));
    end
    
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

save([filepath '/vep_files.mat'],'Raw_VEP','vep','x_data')