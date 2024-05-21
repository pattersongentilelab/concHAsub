function [T, notesText] = headacheQ_preProcess_redcap(spreadSheetName)
% Cleans and organizes data from a raw POEM responses spreadsheet
%
% Syntax:
%  [T, notesText] = poemAnalysis_preProcess_redcap(spreadSheetName)
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

%% Clean and Sanity check the table of initial headache responses
% Keep Time point 1 when data were collected (Headache Substudy), remove Administrative, and Time points 2 and 3
T1 = T(categorical(T.EventName)=='Time point 1',[1 136:272]);

% convert into categorical, and condense questions
HA = T1(:,1);
HA.RecordID_ = categorical(T1.RecordID_);
HA.priorHAfreq = categorical(T1.HowOftenDidYouGetHeadachesBeforeTheConcussion_);
HA.priorHAfreq = reordercats(HA.priorHAfreq,{'Never','Less than 1 per week','1 per week','2 to 3 per week'});
HA.noChange = categorical(T1.HowHaveHeadachesChanged_selectAllThatApply___choice_noChange_);
HA.moreFreq = categorical(T1.HowHaveHeadachesChanged_selectAllThatApply___choice_moreFrequen);
HA.moreSevere = categorical(T1.HowHaveHeadachesChanged_selectAllThatApply___choice_moreSevere_);
HA.worseFx = categorical(T1.HowHaveHeadachesChanged_selectAllThatApply___choice_lessAbleToD);
HA.othChange = categorical(T1.HowHaveHeadachesChanged_selectAllThatApply___choice_other_);
HA.pattern = categorical(T1.WhatIsTheCurrentPatternOfYourHeadaches_);
HA.Freq_epi = categorical(T1.HowOftenAreTheHeadaches_);
HA.Freq_epi = reordercats(HA.Freq_epi,{'Less than 1 per week','2 to 3 per week','More than 3 per week','Daily','Multiple times a day'});
HA.Freq_disable = categorical(T1.HowOftenDoTheHeadachesGetInTheWayOfWhatYouWantToDo_);
HA.Freq_disable = reordercats(HA.Freq_disable,{'Never','Less than 1 per week','1 per week','2 to 3 per week','More than 3 per week','Daily','Multiple times a day'});

HA.quality_throbbing = NaN*ones(height(HA),1);
HA.quality_throbbing(categorical(T1.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__ch)=='Checked'|...
    categorical(T1.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__1)=='Checked'|categorical(T1.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__10)=='Checked') = 1;
HA.quality_throbbing(categorical(T1.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__ch)=='Unchecked' &...
    categorical(T1.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__1)=='Unchecked' & categorical(T1.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__10)=='Unchecked') = 0;
HA.quality_throbbing = categorical(HA.quality_throbbing,[0 1],{'Unchecked','Checked'});

HA.quality_neuralgia = NaN*ones(height(HA),1);
HA.quality_neuralgia(categorical(T1.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__2)=='Checked'|...
    categorical(T1.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__6)=='Checked'|categorical(T1.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__7)=='Checked' | ...
    categorical(T1.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__9)=='Checked') = 1;
HA.quality_neuralgia(categorical(T1.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__2)=='Unchecked'& ...
    categorical(T1.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__6)=='Unchecked' & categorical(T1.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__7)=='Unchecked' & ...
    categorical(T1.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__9)=='Unchecked') = 0;
HA.quality_neuralgia = categorical(HA.quality_neuralgia,[0 1],{'Unchecked','Checked'});

HA.quality_pressure = NaN*ones(height(HA),1);
HA.quality_pressure(categorical(T1.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__3)=='Checked'|...
    categorical(T1.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__4)=='Checked'|categorical(T1.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__5)=='Checked' | ...
    categorical(T1.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__8)=='Checked') = 1;
HA.quality_pressure(categorical(T1.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__3)=='Unchecked'& ...
    categorical(T1.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__4)=='Unchecked' & categorical(T1.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__5)=='Unchecked' & ...
    categorical(T1.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__8)=='Unchecked') = 0;
HA.quality_pressure = categorical(HA.quality_pressure,[0 1],{'Unchecked','Checked'});

HA.quality_oth = NaN*ones(height(HA),1);
HA.quality_oth(categorical(T1.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__11)=='Checked'|...
    categorical(T1.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__12)=='Checked') = 1;
HA.quality_oth(categorical(T1.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__11)=='Unchecked'&...
    categorical(T1.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__12)=='Unchecked') = 0;
HA.quality_oth = categorical(HA.quality_oth,[0 1],{'Unchecked','Checked'});

HA.painLoc_front = categorical(T1.WhereOnYourHeadDoYouFeelPain__choice_Front_Forehead_);
HA.painLoc_top = categorical(T1.WhereOnYourHeadDoYouFeelPain__choice_Top_);
HA.painLoc_neck = categorical(T1.WhereOnYourHeadDoYouFeelPain__choice_Neck_);
HA.painLoc_peri_orbit = categorical(T1.WhereOnYourHeadDoYouFeelPain__choice_AroundEyes_);
HA.painLoc_retro_orbit = categorical(T1.WhereOnYourHeadDoYouFeelPain__choice_BehindTheEyes_);
HA.painLoc_holocephalic = categorical(T1.WhereOnYourHeadDoYouFeelPain__choice_AllOver_);
HA.painLoc_other = categorical(T1.WhereOnYourHeadDoYouFeelPain__choice_Other_);
HA.painLoc_cantdesc = categorical(T1.WhereOnYourHeadDoYouFeelPain__choice_UnableToDescribe_);

HA.severity = categorical(T1.Overall_HowBadAreTheHeadaches_);

HA.trig_none = categorical(T1.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Non);
HA.trig_menses = categorical(T1.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Men);
HA.trig_sleepmore = categorical(T1.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Too);
HA.trig_sleepless = categorical(T1.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_T_1);
HA.trig_fatigue = categorical(T1.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Fat);
% Transpose the notesText for ease of subsequent display
notesText=notesText';

end % function