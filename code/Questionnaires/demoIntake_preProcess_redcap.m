function [DEMO, notesText] = demoIntake_preProcess_redcap(spreadSheetName)
% Cleans and organizes demographic and clinical intake data
%
% Description:
%   Loads csv file into which Redcap migraine assessment data has been
%   stored. Cleans and organizes the data
%
% Inputs:
%   spreadSheetName       - String variable with the full path to the csv file
%
% Outputs:
%   T                     - The table
%   notesText             - A cell array with notes regarding the table conversion
%

%% Parse input and define variables
p = inputParser;

% required input
p.addRequired('spreadSheetName',@ischar);

% parse
p.parse(spreadSheetName)


%% Hardcoded variables and housekeeping
notesText = cellstr(spreadSheetName);

% This is the format of time stamps returned by Redcap
% dateTimeFormat = 'yyyy-MM-dd HH:mm:SS';

%% Read in the table. Suppress some routine warnings.
orig_state = warning;
warning('off','MATLAB:table:ModifiedAndSavedVarnames');
warning('off','MATLAB:table:ModifiedVarnames');
T = readtable(spreadSheetName,'DatetimeType','text');
warning(orig_state);

%% Stick the question text into the UserData field of the Table
T.Properties.UserData.QuestionText = table2cell(T(1,:));

% select time point 1 only
T = T(categorical(T.EventName)=='Time point 1',[1 6:end]);

% remove HSS--037, ineligible
T = T(categorical(T.RecordID_)~='HSS-037',:);

%% Clean and Sanity check the table of initial headache responses for timepoint 1
% Keep Time point 1 when data were collected (Headache Substudy), remove Administrative, and Time points 2 and 3


% convert into categorical, and condense questions
DEMO = T(:,1);
DEMO.RecordID_ = categorical(DEMO.RecordID_);
DEMO.Sex = categorical(T.Sex);
DEMO.Age = T.AgeAtTimeOfInjury;
DEMO.Race = categorical(T.Race);
DEMO.Ethnicity = categorical(T.Ethnicity);
DEMO.ConcDx = categorical(T.WasSubjectGivenAConcussionDiagnosis_);
DEMO.MOI = categorical(T.MechanismOfInjury_);
DEMO.SRC = categorical(T.Sports_relatedInjury_);
DEMO.Missed_school = categorical(T.HowManyFullSchoolDaysHasThePatientMissedBecauseOfHis_herInjury_);
DEMO.School_return = categorical(T.HasThePatientReturnedToSchoolSinceTheInjury_);
DEMO.Exc_return = categorical(T.HasThePatientReturnedToExerciseSinceTheInjury_);
DEMO.Motion_sick = categorical(T.HasThePatientHadMotionSicknessInTheCarSinceTheInjury_);
DEMO.NoPMH = categorical(T.PastMedicalHistory_Physician_DiagnosedBeforeTheInjury__choice_N);
DEMO.NoPMH = renamecats(DEMO.NoPMH,{'Unchecked','Checked'},{'No','Yes'});
DEMO.Migraine = categorical(T.PastMedicalHistory_Physician_DiagnosedBeforeTheInjury__choice_M);
DEMO.Migraine = renamecats(DEMO.Migraine,{'Unchecked','Checked'},{'No','Yes'});
DEMO.ChronicHA = categorical(T.PastMedicalHistory_Physician_DiagnosedBeforeTheInjury__choice_C);
DEMO.ChronicHA = renamecats(DEMO.ChronicHA,{'Unchecked','Checked'},{'No','Yes'});
DEMO.Anxiety = categorical(T.PastMedicalHistory_Physician_DiagnosedBeforeTheInjury__choice_A);
DEMO.Anxiety = renamecats(DEMO.Anxiety,{'Unchecked','Checked'},{'No','Yes'});
DEMO.Depress = categorical(T.PastMedicalHistory_Physician_DiagnosedBeforeTheInjury__choice_D);
DEMO.Depress = renamecats(DEMO.Depress,{'Unchecked','Checked'},{'No','Yes'});
DEMO.FamHxMig = categorical(T.FamilyMedicalHistory_Physician_Diagnosed__choice_Migraines_);
DEMO.FamHxMig = renamecats(DEMO.FamHxMig,{'Unchecked','Checked'},{'No','Yes'});
DEMO.FamHxCHA = categorical(T.FamilyMedicalHistory_Physician_Diagnosed__choice_ChronicHeadach);
DEMO.FamHxCHA = renamecats(DEMO.FamHxCHA,{'Unchecked','Checked'},{'No','Yes'});

end % function