% Organize VEP subject data and combine with VEP matlab files

%% select VEP data from headache substudy to match raw VEP file with HSS ID
data_path = getpref('concHAsub','concHAsubDataPath');
filepath = [data_path '/VEP'];

tbl1 = readtable([filepath '/excel_03.21.23.csv']);
tbl2 = readtable([filepath '/rawdataIDlink_03.21.23.csv']);

tbl1 = tbl1(contains(tbl1.LastName,'HSS')==1,:);
tbl2 = tbl2(contains(tbl2.Var2,'HSS')==1,:);

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
        match_ID.SessionID(contains(match_ID.StudyID,Participants(x))==1 & contains(match_ID.TimePoint,T)==1) = temp;
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


%% Filter and parse VEP

Fs = 1024; % Sampling rate
reversal = 2; % number of reversals
d1 = designfilt('bandstopiir','FilterOrder',20,'HalfPowerFrequency1',59,...
    'HalfPowerFrequency2',61,'SampleRate',Fs);  % Bandstop filter for 60Hz powerline noise in VEP signal
d2 = designfilt('bandstopiir','FilterOrder',20,'HalfPowerFrequency1',119,...
        'HalfPowerFrequency2',121,'SampleRate',Fs); % Bandstop filter for 120Hz noise harmonic in VEP signal

discarded_trials = 0;
total_trials = 0;

match_ID.x_data = cell(height(match_ID),1);
match_ID.cleaned_vep = cell(height(match_ID),1);

for x=1:height(match_ID)
    VEP=match_ID.raw_vep{x};
 
    dur = length(VEP)./Fs; % total duration of recording (in seconds)
    match_ID.x_data{x} = 1/Fs:1/Fs:1/reversal;

    VEP = filter(d1,VEP);
    VEP = filter(d2,VEP);
    

    y_data=reshape(VEP,[Fs/reversal,dur*reversal]);

    % remove trials where the absolute max voltage >1
    temp=find(max(abs(y_data),[],1)<1);
    temp2=find(max(abs(y_data),[],1)>=1);
    figure(10)
    plot(y_data(:,temp2))
    title('bad trial')
    pause
    bad_trials = size(y_data,2)-length(temp);
    discarded_trials = discarded_trials+bad_trials;
    total_trials = total_trials+size(y_data,2);
    disp(['number of discarded trials =' num2str(bad_trials)]);
    y_data=y_data(:,temp)';
    
    match_ID.cleaned_vep{x} = y_data;
    
    clear x_data y_data
end

disp(['proportion of discarded trials =' num2str(discarded_trials./total_trials)]);


%% Organize data by participant and session



% Normalize data
for x=1:length(cleaned_vep)
    y_data=cell2mat(cleaned_vep(x,4));
    
    
    % Normalize pre-response to 0
    for y=1:size(y_data,1)
        temp=mean(mean(y_data(y,1:51)));
        y_data(y,:)=y_data(y,:)-(temp*ones(size(y_data(y,:))));
    end
    
    cleaned_vep{x,4}=y_data;
end


clear *temp


save([filepath '/raw_vep_files.mat'],'match_ID')