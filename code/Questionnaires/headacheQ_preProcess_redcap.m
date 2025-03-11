function [HA,MEDS,PCSI, notesText] = headacheQ_preProcess_redcap(spreadSheetName)
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

% select only completed participants
T = T(1:236,:);

% remove HSS--037, ineligible
T = T(categorical(T.RecordID_)~='HSS-037',:);

%% Clean and Sanity check the table of initial headache responses for timepoint 1
% Keep Time point 1 when data were collected (Headache Substudy), remove Administrative, and Time points 2 and 3
T1 = T(categorical(T.EventName)=='Time point 1',[1 136:294]);
T2 = T(categorical(T.EventName)=='Time point 2',[1 324:349 357:443]);
T3 = T(categorical(T.EventName)=='Time point 3',[1 324:443]);

%add placeholders for missing data
dummy_pt2 = T2(2,:); % participant 2 has no headaches and unchecked values
dummy_pt2.RecordID_ = 'Missing';
dummy_pt2.DoAnyOfTheFollowingHurt__choice_None__1 = '"'; %convert all variables into undefined
dummy_pt2.DoAnyOfTheFollowingHurt__choice_WearingYourHairInAPonytail__1 = '"';
dummy_pt2.DoAnyOfTheFollowingHurt__choice_CombingOrBrushingYourHair__1 = '"';
dummy_pt2.DoAnyOfTheFollowingHurt__choice_WearingAHat__1 = '"';
dummy_pt2.DoAnyOfTheFollowingHurt__choice_WearingHeadphones__1 = '"';
dummy_pt2.OtherSymptoms__choice_None__1 = '"';
dummy_pt2.OtherSymptoms__choice_Nausea__1 = '"';
dummy_pt2.OtherSymptoms__choice_Vomiting__1 = '"';
dummy_pt2.OtherSymptoms__choice_SensitivityToLight__1 = '"';
dummy_pt2.OtherSymptoms__choice_SensitivityToSmells__1 = '"';
dummy_pt2.OtherSymptoms__choice_SensitivityToSounds__1 = '"';
dummy_pt2.OtherSymptoms__choice_Lightheadness__1 = '"';
dummy_pt2.OtherSymptoms__choice_SpinningSensation__1 = '"';
dummy_pt2.OtherSymptoms__choice_BalanceProblems__1 = '"';
dummy_pt2.OtherSymptoms__choice_TroubleHearing__1 = '"';
dummy_pt2.OtherSymptoms__choice_RingingInEar__1 = '"';
dummy_pt2.OtherSymptoms__choice_Unresponsive__1 = '"';
dummy_pt2.OtherSymptoms__choice_NeckPainOrStiffness__1 = '"';
dummy_pt2.OtherSymptoms__choice_TroubleThinking__1 = '"';
dummy_pt2.OtherSymptoms__choice_TroubleTalking__1 = '"';
dummy_pt2.OtherSymptoms__choice_Other__1 = '"';
dummy_pt2.MedicationsToSTOPHeadaches_choice_None__1 = '"';
dummy_pt2.OtherSymptoms__choice_RingingInEar__1 = '"';
dummy_pt2.OtherSymptoms__choice_RingingInEar__1 = '"';

dummy_pt3 = T3(2,:); % participant 2 has no headaches and unchecked values
dummy_pt3.RecordID_ = 'Missing';
dummy_pt3.DoAnyOfTheFollowingHurt__choice_None__1 = '"'; %convert all variables into undefined
dummy_pt3.DoAnyOfTheFollowingHurt__choice_WearingYourHairInAPonytail__1 = '"';
dummy_pt3.DoAnyOfTheFollowingHurt__choice_CombingOrBrushingYourHair__1 = '"';
dummy_pt3.DoAnyOfTheFollowingHurt__choice_WearingAHat__1 = '"';
dummy_pt3.DoAnyOfTheFollowingHurt__choice_WearingHeadphones__1 = '"';
dummy_pt3.OtherSymptoms__choice_None__1 = '"';
dummy_pt3.OtherSymptoms__choice_Nausea__1 = '"';
dummy_pt3.OtherSymptoms__choice_Vomiting__1 = '"';
dummy_pt3.OtherSymptoms__choice_SensitivityToLight__1 = '"';
dummy_pt3.OtherSymptoms__choice_SensitivityToSmells__1 = '"';
dummy_pt3.OtherSymptoms__choice_SensitivityToSounds__1 = '"';
dummy_pt3.OtherSymptoms__choice_Lightheadness__1 = '"';
dummy_pt3.OtherSymptoms__choice_SpinningSensation__1 = '"';
dummy_pt3.OtherSymptoms__choice_BalanceProblems__1 = '"';
dummy_pt3.OtherSymptoms__choice_TroubleHearing__1 = '"';
dummy_pt3.OtherSymptoms__choice_RingingInEar__1 = '"';
dummy_pt3.OtherSymptoms__choice_Unresponsive__1 = '"';
dummy_pt3.OtherSymptoms__choice_NeckPainOrStiffness__1 = '"';
dummy_pt3.OtherSymptoms__choice_TroubleThinking__1 = '"';
dummy_pt3.OtherSymptoms__choice_TroubleTalking__1 = '"';
dummy_pt3.OtherSymptoms__choice_Other__1 = '"';
dummy_pt3.MedicationsToSTOPHeadaches_choice_None__1 = '"';
dummy_pt3.OtherSymptoms__choice_RingingInEar__1 = '"';
dummy_pt3.OtherSymptoms__choice_RingingInEar__1 = '"';

T2 = [T2(1:4,:);dummy_pt2;T2(5:6,:);dummy_pt2;T2(7:19,:);dummy_pt2;dummy_pt2;T2(20,:);dummy_pt2;T2(21:27,:);dummy_pt2;...
    T2(28:end,:)]; % HSS-005, -008, -022, -023, -025, -033
T3 = [T3(1:20,:);dummy_pt3;dummy_pt3;T3(21:29,:);dummy_pt3;T3(30:end,:);dummy_pt3]; % HSS-021, -022, -032, -057

clear dummy_pt*
% convert into categorical, and condense questions
HA = T1(:,1);
HA.RecordID_ = categorical(T1.RecordID_);
HA.recordID_T2 = categorical(T2.RecordID_);
HA.recordID_T3 = categorical(T3.RecordID_);
HA.priorHAfreq = categorical(T1.HowOftenDidYouGetHeadachesBeforeTheConcussion_);
HA.priorHAfreq = reordercats(HA.priorHAfreq,{'Never','Less than 1 per week','1 per week','2 to 3 per week'});
HA.noChange = categorical(T1.HowHaveHeadachesChanged_selectAllThatApply___choice_noChange_);
HA.moreFreq = categorical(T1.HowHaveHeadachesChanged_selectAllThatApply___choice_moreFrequen);
HA.moreSevere = categorical(T1.HowHaveHeadachesChanged_selectAllThatApply___choice_moreSevere_);
HA.worseFx = categorical(T1.HowHaveHeadachesChanged_selectAllThatApply___choice_lessAbleToD);
HA.othChange = categorical(T1.HowHaveHeadachesChanged_selectAllThatApply___choice_other_);
HA.pattern = categorical(T1.WhatIsTheCurrentPatternOfYourHeadaches_);
HA.pattern(isundefined(HA.pattern)) = 'no headache';
HA.patternT2 = categorical(T2.WhatIsTheCurrentPatternOfYourHeadaches__1);
HA.patternT2(isundefined(HA.patternT2)) = 'no headache';
HA.patternT3 = categorical(T3.WhatIsTheCurrentPatternOfYourHeadaches__1);
HA.patternT3(isundefined(HA.patternT3)) = 'no headache';
HA.Freq_epi = categorical(T1.HowOftenAreTheHeadaches_);
HA.Freq_epi = reordercats(HA.Freq_epi,{'Never','Less than 1 per week','1 per week','2 to 3 per week','More than 3 per week','Daily','Multiple times a day'});
HA.Freq_epiT2 = categorical(T2.HowOftenAreTheHeadaches__1);
HA.Freq_epiT2 = reordercats(HA.Freq_epiT2,{'Never','1 per week','2 to 3 per week','More than 3 per week','Daily','Multiple times a day'});
HA.Freq_epiT3 = categorical(T2.HowOftenAreTheHeadaches__1);
HA.Freq_epiT3 = reordercats(HA.Freq_epiT3,{'Never','1 per week','2 to 3 per week','More than 3 per week','Daily','Multiple times a day'});
HA.Freq_disable = categorical(T1.HowOftenDoTheHeadachesGetInTheWayOfWhatYouWantToDo_);
HA.Freq_disable = reordercats(HA.Freq_disable,{'Never','Less than 1 per week','1 per week','2 to 3 per week','More than 3 per week','Daily','Multiple times a day'});
HA.Freq_disableT2 = categorical(T2.HowOftenDoTheHeadachesGetInTheWayOfWhatYouWantToDo__1);
HA.Freq_disableT2 = reordercats(HA.Freq_disableT2,{'Never','Less than 1 per week','1 per week','2 to 3 per week','More than 3 per week','Daily'});
HA.Freq_disableT3 = categorical(T3.HowOftenDoTheHeadachesGetInTheWayOfWhatYouWantToDo__1);
HA.Freq_disableT3 = reordercats(HA.Freq_disableT3,{'Never','Less than 1 per week','1 per week','2 to 3 per week','More than 3 per week','Daily'});
HA.pedmidasT3 = T3.TotalPedMIDASScore;
HA.pedmidasT3(isnan(HA.pedmidasT3)) = 0; %all those filled out the form, but indicated they did not have headache

% pain features
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
HA.painLoc_sides = categorical(T1.WhereOnYourHeadDoYouFeelPain__choice_Temples_sides_);
HA.painLoc_occiput = categorical(T1.WhereOnYourHeadDoYouFeelPain__choice_BackOfHead_);
HA.painLoc_neck = categorical(T1.WhereOnYourHeadDoYouFeelPain__choice_Neck_);
HA.painLoc_peri_orbit = categorical(T1.WhereOnYourHeadDoYouFeelPain__choice_AroundEyes_);
HA.painLoc_retro_orbit = categorical(T1.WhereOnYourHeadDoYouFeelPain__choice_BehindTheEyes_);
HA.painLoc_holocephalic = categorical(T1.WhereOnYourHeadDoYouFeelPain__choice_AllOver_);
HA.painLoc_other = categorical(T1.WhereOnYourHeadDoYouFeelPain__choice_Other_);
HA.painLoc_cantdesc = categorical(T1.WhereOnYourHeadDoYouFeelPain__choice_UnableToDescribe_);

HA.severity = categorical(T1.Overall_HowBadAreTheHeadaches_);
HA.severityT2 = categorical(T2.Overall_HowBadAreTheHeadaches__1);
HA.severityT3 = categorical(T3.Overall_HowBadAreTheHeadaches__1);

% triggers
HA.trig_none = categorical(T1.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Non);
HA.trig_menses = categorical(T1.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Men);
HA.trig_sleepmore = categorical(T1.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Too);
HA.trig_sleepless = categorical(T1.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_T_1);
HA.trig_fatigue = categorical(T1.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Fat);
HA.trig_exercise = categorical(T1.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Exe);
HA.trig_overheat = categorical(T1.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Bec);
HA.trig_dehydrate = categorical(T1.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Deh);
HA.trig_skipmeal = categorical(T1.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Ski);
HA.trig_foods = categorical(T1.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Spe);
HA.trig_meds = categorical(T1.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Med);
HA.trig_chew = categorical(T1.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Che);
HA.trig_stress = categorical(T1.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Str);
HA.trig_letdown = categorical(T1.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_S_1);
HA.trig_screen = categorical(T1.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Scr);
HA.trig_reading = categorical(T1.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Rea);
HA.trig_light = categorical(T1.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Lig);
HA.trig_noise = categorical(T1.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Noi);
HA.trig_smoking = categorical(T1.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Smo);
HA.trig_weather = categorical(T1.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Wea);
HA.trig_hiAlt = categorical(T1.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Hig);
HA.trig_other = categorical(T1.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Oth);

% associated symptoms
% T1
HA.vis_none = categorical(T1.ChangesInVision__choice_None_);
HA.vis_spots = categorical(T1.ChangesInVision__choice_Spots_);
HA.vis_stars = categorical(T1.ChangesInVision__choice_Stars_);
HA.vis_zigzag = categorical(T1.ChangesInVision__choice_ZigzagLines_);
HA.vis_blurred = categorical(T1.ChangesInVision__choice_BlurredVision_);
HA.vis_double = categorical(T1.ChangesInVision__choice_DoubleVision_);
HA.vis_heatwave = categorical(T1.ChangesInVision__choice_HeatWaves_);
HA.vis_loss = categorical(T1.ChangesInVision__choice_LossOfVision_);
HA.vis_cantdesc = categorical(T1.ChangesInVision__choice_UnableToDescribe_);

HA.uni_none = categorical(T1.DoYouExperienceAnyOfTheseSymptomsOnONESIDEOfYourBody__choice_No);
HA.uni_weak = categorical(T1.DoYouExperienceAnyOfTheseSymptomsOnONESIDEOfYourBody__choice_We);
HA.uni_numb = categorical(T1.DoYouExperienceAnyOfTheseSymptomsOnONESIDEOfYourBody__choice_Nu);
HA.uni_tingle = categorical(T1.DoYouExperienceAnyOfTheseSymptomsOnONESIDEOfYourBody__choice_Ti);
HA.uni_noserun = categorical(T1.DoYouExperienceAnyOfTheseSymptomsOnONESIDEOfYourBody__choice_Ru);
HA.uni_eyetear = categorical(T1.DoYouExperienceAnyOfTheseSymptomsOnONESIDEOfYourBody__choice_Ey);
HA.uni_ptosis = categorical(T1.DoYouExperienceAnyOfTheseSymptomsOnONESIDEOfYourBody__choice_Dr);
HA.uni_eyered = categorical(T1.DoYouExperienceAnyOfTheseSymptomsOnONESIDEOfYourBody__choice_Re);
HA.uni_eyepuff = categorical(T1.DoYouExperienceAnyOfTheseSymptomsOnONESIDEOfYourBody__choice_Pu);
HA.uni_anisocoria = categorical(T1.DoYouExperienceAnyOfTheseSymptomsOnONESIDEOfYourBody__choice_On);
HA.uni_none = categorical(T1.DoYouExperienceAnyOfTheseSymptomsOnONESIDEOfYourBody__choice_No);
HA.uni_flush = categorical(T1.DoYouExperienceAnyOfTheseSymptomsOnONESIDEOfYourBody__choice_Fo);

HA.allodynia = NaN*ones(height(HA),1);
HA.allodynia(categorical(T1.DoAnyOfTheFollowingHurt__choice_None_)=='Checked') = 0;
HA.allodynia(categorical(T1.DoAnyOfTheFollowingHurt__choice_WearingYourHairInAPonytail_)=='Checked') = 1;
HA.allodynia(categorical(T1.DoAnyOfTheFollowingHurt__choice_CombingOrBrushingYourHair_)=='Checked') = 1;
HA.allodynia(categorical(T1.DoAnyOfTheFollowingHurt__choice_WearingAHat_)=='Checked') = 1;
HA.allodynia(categorical(T1.DoAnyOfTheFollowingHurt__choice_WearingHeadphones_)=='Checked') = 1;
HA.allodynia = categorical(HA.allodynia,[0 1],{'Unchecked','Checked'});
HA.othSx_none = categorical(T1.OtherSymptoms__choice_None_);
HA.othSx_nausea = categorical(T1.OtherSymptoms__choice_Nausea_);
HA.othSx_vomiting = categorical(T1.OtherSymptoms__choice_Vomiting_);
HA.othSx_lightsens = categorical(T1.OtherSymptoms__choice_SensitivityToLight_);
HA.othSx_smellsens = categorical(T1.OtherSymptoms__choice_SensitivityToSmells_);
HA.othSx_soundsens = categorical(T1.OtherSymptoms__choice_SensitivityToSounds_);
HA.othSx_lighthead = categorical(T1.OtherSymptoms__choice_Lightheadness_);
HA.othSx_spinning = categorical(T1.OtherSymptoms__choice_SpinningSensation_);
HA.othSx_balance = categorical(T1.OtherSymptoms__choice_BalanceProblems_);
HA.othSx_hearing = categorical(T1.OtherSymptoms__choice_TroubleHearing_);
HA.othSx_ringing = categorical(T1.OtherSymptoms__choice_RingingInEar_);
HA.othSx_unresponsive = categorical(T1.OtherSymptoms__choice_Unresponsive_);
HA.othSx_neckpain = categorical(T1.OtherSymptoms__choice_NeckPainOrStiffness_);
HA.othSx_thinking = categorical(T1.OtherSymptoms__choice_TroubleThinking_);
HA.othSx_talking = categorical(T1.OtherSymptoms__choice_TroubleTalking_);
HA.othSx_oth = categorical(T1.OtherSymptoms__choice_Other_);

%T2
HA.allodyniaT2 = NaN*ones(height(HA),1);
HA.allodyniaT2(categorical(T2.DoAnyOfTheFollowingHurt__choice_None__1)=='Checked') = 0;
HA.allodyniaT2(categorical(T2.DoAnyOfTheFollowingHurt__choice_WearingYourHairInAPonytail__1)=='Checked') = 1;
HA.allodyniaT2(categorical(T2.DoAnyOfTheFollowingHurt__choice_CombingOrBrushingYourHair__1)=='Checked') = 1;
HA.allodyniaT2(categorical(T2.DoAnyOfTheFollowingHurt__choice_WearingAHat__1)=='Checked') = 1;
HA.allodyniaT2(categorical(T2.DoAnyOfTheFollowingHurt__choice_WearingHeadphones__1)=='Checked') = 1;
HA.allodyniaT2 = categorical(HA.allodyniaT2,[0 1],{'Unchecked','Checked'});
HA.othSx_noneT2 = categorical(T2.OtherSymptoms__choice_None__1);
HA.othSx_noneT2 = removecats(HA.othSx_noneT2,{'"'});
HA.othSx_nauseaT2 = categorical(T2.OtherSymptoms__choice_Nausea__1);
HA.othSx_nauseaT2 = removecats(HA.othSx_nauseaT2,{'"'});
HA.othSx_vomitingT2 = categorical(T2.OtherSymptoms__choice_Vomiting__1);
HA.othSx_vomitingT2 = removecats(HA.othSx_vomitingT2,{'"'});
HA.othSx_lightsensT2 = categorical(T2.OtherSymptoms__choice_SensitivityToLight__1);
HA.othSx_lightsensT2 = removecats(HA.othSx_lightsensT2,{'"'});
HA.othSx_smellsensT2 = categorical(T2.OtherSymptoms__choice_SensitivityToSmells__1);
HA.othSx_smellsensT2 = removecats(HA.othSx_smellsensT2,{'"'});
HA.othSx_soundsensT2 = categorical(T2.OtherSymptoms__choice_SensitivityToSounds__1);
HA.othSx_soundsensT2 = removecats(HA.othSx_soundsensT2,{'"'});
HA.othSx_lightheadT2 = categorical(T2.OtherSymptoms__choice_Lightheadness__1);
HA.othSx_lightheadT2 = removecats(HA.othSx_lightheadT2,{'"'});
HA.othSx_spinningT2 = categorical(T2.OtherSymptoms__choice_SpinningSensation__1);
HA.othSx_spinningT2 = removecats(HA.othSx_spinningT2,{'"'});
HA.othSx_balanceT2 = categorical(T2.OtherSymptoms__choice_BalanceProblems__1);
HA.othSx_balanceT2 = removecats(HA.othSx_balanceT2,{'"'});
HA.othSx_hearingT2 = categorical(T2.OtherSymptoms__choice_TroubleHearing__1);
HA.othSx_hearingT2 = removecats(HA.othSx_hearingT2,{'"'});
HA.othSx_ringingT2 = categorical(T2.OtherSymptoms__choice_RingingInEar__1);
HA.othSx_ringingT2 = removecats(HA.othSx_ringingT2,{'"'});
HA.othSx_unresponsiveT2 = categorical(T2.OtherSymptoms__choice_Unresponsive__1);
HA.othSx_unresponsiveT2 = removecats(HA.othSx_unresponsiveT2,{'"'});
HA.othSx_neckpainT2 = categorical(T2.OtherSymptoms__choice_NeckPainOrStiffness__1);
HA.othSx_neckpainT2 = removecats(HA.othSx_neckpainT2,{'"'});
HA.othSx_thinkingT2 = categorical(T2.OtherSymptoms__choice_TroubleThinking__1);
HA.othSx_thinkingT2 = removecats(HA.othSx_thinkingT2,{'"'});
HA.othSx_talkingT2 = categorical(T2.OtherSymptoms__choice_TroubleTalking__1);
HA.othSx_talkingT2 = removecats(HA.othSx_talkingT2,{'"'});
HA.othSx_othT2 = categorical(T2.OtherSymptoms__choice_Other__1);
HA.othSx_othT2 = removecats(HA.othSx_othT2,{'"'});

%T3
HA.allodyniaT3 = NaN*ones(height(HA),1);
HA.allodyniaT3(categorical(T3.DoAnyOfTheFollowingHurt__choice_None__1)=='Checked') = 0;
HA.allodyniaT3(categorical(T3.DoAnyOfTheFollowingHurt__choice_WearingYourHairInAPonytail__1)=='Checked') = 1;
HA.allodyniaT3(categorical(T3.DoAnyOfTheFollowingHurt__choice_CombingOrBrushingYourHair__1)=='Checked') = 1;
HA.allodyniaT3(categorical(T3.DoAnyOfTheFollowingHurt__choice_WearingAHat__1)=='Checked') = 1;
HA.allodyniaT3(categorical(T3.DoAnyOfTheFollowingHurt__choice_WearingHeadphones__1)=='Checked') = 1;
HA.allodyniaT3 = categorical(HA.allodyniaT3,[0 1],{'Unchecked','Checked'});
HA.othSx_noneT3 = categorical(T3.OtherSymptoms__choice_None__1);
HA.othSx_noneT3 = removecats(HA.othSx_noneT3,{'"'});
HA.othSx_nauseaT3 = categorical(T3.OtherSymptoms__choice_Nausea__1);
HA.othSx_nauseaT3 = removecats(HA.othSx_nauseaT3,{'"'});
HA.othSx_vomitingT3 = categorical(T3.OtherSymptoms__choice_Vomiting__1);
HA.othSx_vomitingT3 = removecats(HA.othSx_vomitingT3,{'"'});
HA.othSx_lightsensT3 = categorical(T3.OtherSymptoms__choice_SensitivityToLight__1);
HA.othSx_lightsensT3 = removecats(HA.othSx_lightsensT3,{'"'});
HA.othSx_smellsensT3 = categorical(T3.OtherSymptoms__choice_SensitivityToSmells__1);
HA.othSx_smellsensT3 = removecats(HA.othSx_smellsensT3,{'"'});
HA.othSx_soundsensT3 = categorical(T3.OtherSymptoms__choice_SensitivityToSounds__1);
HA.othSx_soundsensT3 = removecats(HA.othSx_soundsensT3,{'"'});
HA.othSx_lightheadT3 = categorical(T3.OtherSymptoms__choice_Lightheadness__1);
HA.othSx_lightheadT3 = removecats(HA.othSx_lightheadT3,{'"'});
HA.othSx_spinningT3 = categorical(T3.OtherSymptoms__choice_SpinningSensation__1);
HA.othSx_spinningT3 = removecats(HA.othSx_spinningT3,{'"'});
HA.othSx_balanceT3 = categorical(T3.OtherSymptoms__choice_BalanceProblems__1);
HA.othSx_balanceT3 = removecats(HA.othSx_balanceT3,{'"'});
HA.othSx_hearingT3 = categorical(T3.OtherSymptoms__choice_TroubleHearing__1);
HA.othSx_hearingT3 = removecats(HA.othSx_hearingT3,{'"'});
HA.othSx_ringingT3 = categorical(T3.OtherSymptoms__choice_RingingInEar__1);
HA.othSx_ringingT3 = removecats(HA.othSx_ringingT3,{'"'});
HA.othSx_unresponsiveT3 = categorical(T3.OtherSymptoms__choice_Unresponsive__1);
HA.othSx_unresponsiveT3 = removecats(HA.othSx_unresponsiveT3,{'"'});
HA.othSx_neckpainT3 = categorical(T3.OtherSymptoms__choice_NeckPainOrStiffness__1);
HA.othSx_neckpainT3 = removecats(HA.othSx_neckpainT3,{'"'});
HA.othSx_thinkingT3 = categorical(T3.OtherSymptoms__choice_TroubleThinking__1);
HA.othSx_thinkingT3 = removecats(HA.othSx_thinkingT3,{'"'});
HA.othSx_talkingT3 = categorical(T3.OtherSymptoms__choice_TroubleTalking__1);
HA.othSx_talkingT3 = removecats(HA.othSx_talkingT3,{'"'});
HA.othSx_othT3 = categorical(T3.OtherSymptoms__choice_Other__1);
HA.othSx_othT3 = removecats(HA.othSx_othT3,{'"'});


%% Medications to treat headaches

% Acute
MEDS = T1(:,1);
MEDS.acute_none = categorical(T1.MedicationsToSTOPHeadaches_choice_None_);
MEDS.acute_tylenol = categorical(T1.MedicationsToSTOPHeadaches_choice_Acetaminophen_Tylenol__);
MEDS.acute_motrin = categorical(T1.MedicationsToSTOPHeadaches_choice_Ibuprofen_Motrin_Advil__);
MEDS.acute_naproxen = categorical(T1.MedicationsToSTOPHeadaches_choice_Naproxen_Aleve_Naprosyn__);
MEDS.acute_aspirin = categorical(T1.MedicationsToSTOPHeadaches_choice_Aspirin_);
MEDS.acute_toradol = categorical(T1.MedicationsToSTOPHeadaches_choice_Ketorolac_Toradol_Sprix__);
MEDS.acute_ketoprofen = categorical(T1.MedicationsToSTOPHeadaches_choice_Ketoprofen_Relafen__);
MEDS.acute_diclofenac = categorical(T1.MedicationsToSTOPHeadaches_choice_Diclofenac_Voltaren__);
MEDS.acute_celebrex = categorical(T1.MedicationsToSTOPHeadaches_choice_Celecoxib_Celebrex__);
MEDS.acute_excedrin = categorical(T1.MedicationsToSTOPHeadaches_choice_Excedrin_ExcedrinMigraine_Exc);
MEDS.acute_fioricet = categorical(T1.MedicationsToSTOPHeadaches_choice_Butalbital_Fioricet_Fiorinal_);
MEDS.acute_midrin = categorical(T1.MedicationsToSTOPHeadaches_choice_Midrin_);
MEDS.acute_medrol = categorical(T1.MedicationsToSTOPHeadaches_choice_Methylprednisolone_MedrolPack);
MEDS.acute_pred = categorical(T1.MedicationsToSTOPHeadaches_choice_Prednisone_Prednisolone_);
MEDS.acute_suma = categorical(T1.MedicationsToSTOPHeadaches_choice_Sumatriptan_Imitrex_Treximet_);
MEDS.acute_riza = categorical(T1.MedicationsToSTOPHeadaches_choice_Rizatriptan_Maxalt__);
MEDS.acute_nara = categorical(T1.MedicationsToSTOPHeadaches_choice_Naratriptan_Amerge__);
MEDS.acute_almo = categorical(T1.MedicationsToSTOPHeadaches_choice_Almotriptan_Axert__);
MEDS.acute_frova = categorical(T1.MedicationsToSTOPHeadaches_choice_Frovatriptan_Frova__);
MEDS.acute_ele = categorical(T1.MedicationsToSTOPHeadaches_choice_Eletriptan_Relpax__);
MEDS.acute_zom = categorical(T1.MedicationsToSTOPHeadaches_choice_Zolmitriptan_Zomig__);
MEDS.acute_meto = categorical(T1.MedicationsToSTOPHeadaches_choice_Metoclopramide_Reglan__);
MEDS.acute_prochlor = categorical(T1.MedicationsToSTOPHeadaches_choice_Prochlorperazine_Compazine__);
MEDS.acute_prometh = categorical(T1.MedicationsToSTOPHeadaches_choice_Promethazine_Phenergan__);
MEDS.acute_zofran = categorical(T1.MedicationsToSTOPHeadaches_choice_Ondansetron_Zofran__);
MEDS.acute_diphen = categorical(T1.MedicationsToSTOPHeadaches_choice_Diphenhydramine_Benadryl__);
MEDS.acute_dhe = categorical(T1.MedicationsToSTOPHeadaches_choice_DHE_Migranal__);
MEDS.acute_tram = categorical(T1.MedicationsToSTOPHeadaches_choice_Tramadol_Ultram_Ultracet__);
MEDS.acute_tycod = categorical(T1.MedicationsToSTOPHeadaches_choice_Tylenol_3_TylenolWithCodeine_);
MEDS.acute_morph = categorical(T1.MedicationsToSTOPHeadaches_choice_Morphine_);
MEDS.acute_hydro = categorical(T1.MedicationsToSTOPHeadaches_choice_Hydromorphone_Dilaudid__);
MEDS.acute_nerveblock = categorical(T1.MedicationsToSTOPHeadaches_choice_NerveBlockOrTriggerPointInjec);
MEDS.acute_oth = categorical(T1.MedicationsToSTOPHeadaches_choice_Other_);

MEDS.acute_nsaid = zeros(height(MEDS),1);
MEDS.acute_nsaid(MEDS.acute_motrin=='Checked'|MEDS.acute_naproxen=='Checked'|...
    MEDS.acute_aspirin=='Checked'|MEDS.acute_aspirin=='Checked'|MEDS.acute_toradol=='Checked'|...
    MEDS.acute_ketoprofen=='Checked'|MEDS.acute_diclofenac=='Checked'|MEDS.acute_celebrex=='Checked') = 1;
MEDS.acute_nsaid = categorical(MEDS.acute_nsaid,[0 1],{'Unchecked','Checked'});

MEDS.acute_triptan = zeros(height(MEDS),1);
MEDS.acute_triptan(MEDS.acute_suma=='Checked'|MEDS.acute_riza=='Checked'|...
    MEDS.acute_nara=='Checked'|MEDS.acute_almo=='Checked'|MEDS.acute_frova=='Checked'|...
    MEDS.acute_ele=='Checked'|MEDS.acute_zom=='Checked') = 1;
MEDS.acute_triptan = categorical(MEDS.acute_triptan,[0 1],{'Unchecked','Checked'});

MEDS.acute_steroid = zeros(height(MEDS),1);
MEDS.acute_steroid(MEDS.acute_medrol=='Checked'|MEDS.acute_pred=='Checked') = 1;
MEDS.acute_steroid = categorical(MEDS.acute_steroid,[0 1],{'Unchecked','Checked'});

MEDS.acute_da = zeros(height(MEDS),1);
MEDS.acute_da(MEDS.acute_meto=='Checked'|MEDS.acute_prochlor=='Checked'|...
    MEDS.acute_prometh=='Checked') = 1;
MEDS.acute_da = categorical(MEDS.acute_da,0,{'Unchecked'});

MEDS.acute_freq = categorical(T1.HowOftenDoYouTakeAMedicationToStopAHeadache_);
MEDS.acute_HiFreqDur = categorical(T1.ForHowLongHaveYouBeenTakingAnAcuteMedicineMoreThan3DaysPerWeek_);

%T2
MEDS.acute_noneT2 = categorical(T2.MedicationsToSTOPHeadaches_choice_None__1);
MEDS.acute_tylenolT2 = categorical(T2.MedicationsToSTOPHeadaches_choice_Acetaminophen_Tylenol___1);
MEDS.acute_motrinT2 = categorical(T2.MedicationsToSTOPHeadaches_choice_Ibuprofen_Motrin_Advil___1);
MEDS.acute_naproxenT2 = categorical(T2.MedicationsToSTOPHeadaches_choice_Naproxen_Aleve_Naprosyn___1);
MEDS.acute_aspirinT2 = categorical(T2.MedicationsToSTOPHeadaches_choice_Aspirin__1);
MEDS.acute_toradolT2 = categorical(T2.MedicationsToSTOPHeadaches_choice_Ketorolac_Toradol_Sprix___1);
MEDS.acute_ketoprofenT2 = categorical(T2.MedicationsToSTOPHeadaches_choice_Ketoprofen_Relafen___1);
MEDS.acute_diclofenacT2 = categorical(T2.MedicationsToSTOPHeadaches_choice_Diclofenac_Voltaren___1);
MEDS.acute_celebrexT2 = categorical(T2.MedicationsToSTOPHeadaches_choice_Celecoxib_Celebrex___1);
MEDS.acute_excedrinT2 = categorical(T2.MedicationsToSTOPHeadaches_choice_Excedrin_ExcedrinMigraine_E_1);
MEDS.acute_fioricetT2 = categorical(T2.MedicationsToSTOPHeadaches_choice_Butalbital_Fioricet_Fiorina_1);
MEDS.acute_midrinT2 = categorical(T2.MedicationsToSTOPHeadaches_choice_Midrin__1);
MEDS.acute_medrolT2 = categorical(T2.MedicationsToSTOPHeadaches_choice_Methylprednisolone_MedrolPa_1);
MEDS.acute_predT2 = categorical(T2.MedicationsToSTOPHeadaches_choice_Prednisone_Prednisolone__1);
MEDS.acute_sumaT2 = categorical(T2.MedicationsToSTOPHeadaches_choice_Sumatriptan_Imitrex_Trexime_1);
MEDS.acute_rizaT2 = categorical(T2.MedicationsToSTOPHeadaches_choice_Rizatriptan_Maxalt___1);
MEDS.acute_naraT2 = categorical(T2.MedicationsToSTOPHeadaches_choice_Naratriptan_Amerge___1);
MEDS.acute_almoT2 = categorical(T2.MedicationsToSTOPHeadaches_choice_Almotriptan_Axert___1);
MEDS.acute_frovaT2 = categorical(T2.MedicationsToSTOPHeadaches_choice_Frovatriptan_Frova___1);
MEDS.acute_eleT2 = categorical(T2.MedicationsToSTOPHeadaches_choice_Eletriptan_Relpax___1);
MEDS.acute_zomT2 = categorical(T2.MedicationsToSTOPHeadaches_choice_Zolmitriptan_Zomig___1);
MEDS.acute_metoT2 = categorical(T2.MedicationsToSTOPHeadaches_choice_Metoclopramide_Reglan___1);
MEDS.acute_prochlorT2 = categorical(T2.MedicationsToSTOPHeadaches_choice_Prochlorperazine_Compazine__1);
MEDS.acute_promethT2 = categorical(T2.MedicationsToSTOPHeadaches_choice_Promethazine_Phenergan___1);
MEDS.acute_zofranT2 = categorical(T2.MedicationsToSTOPHeadaches_choice_Ondansetron_Zofran___1);
MEDS.acute_diphenT2 = categorical(T2.MedicationsToSTOPHeadaches_choice_Diphenhydramine_Benadryl___1);
MEDS.acute_dheT2 = categorical(T2.MedicationsToSTOPHeadaches_choice_DHE_Migranal___1);
MEDS.acute_tramT2 = categorical(T2.MedicationsToSTOPHeadaches_choice_Tramadol_Ultram_Ultracet___1);
MEDS.acute_tycodT2 = categorical(T2.MedicationsToSTOPHeadaches_choice_Tylenol_3_TylenolWithCodein_1);
MEDS.acute_morphT2 = categorical(T2.MedicationsToSTOPHeadaches_choice_Morphine__1);
MEDS.acute_hydroT2 = categorical(T2.MedicationsToSTOPHeadaches_choice_Hydromorphone_Dilaudid___1);
MEDS.acute_nerveblockT2 = categorical(T2.MedicationsToSTOPHeadaches_choice_NerveBlockOrTriggerPointInj_1);
MEDS.acute_othT2 = categorical(T2.MedicationsToSTOPHeadaches_choice_Other__1);

MEDS.acute_nsaidT2 = zeros(height(MEDS),1);
MEDS.acute_nsaidT2(MEDS.acute_motrinT2=='Checked'|MEDS.acute_naproxenT2=='Checked'|...
    MEDS.acute_aspirinT2=='Checked'|MEDS.acute_aspirinT2=='Checked'|MEDS.acute_toradolT2=='Checked'|...
    MEDS.acute_ketoprofenT2=='Checked'|MEDS.acute_diclofenacT2=='Checked'|MEDS.acute_celebrexT2=='Checked') = 1;
MEDS.acute_nsaidT2 = categorical(MEDS.acute_nsaidT2,[0 1],{'Unchecked','Checked'});

MEDS.acute_triptanT2 = zeros(height(MEDS),1);
MEDS.acute_triptanT2(MEDS.acute_sumaT2=='Checked'|MEDS.acute_rizaT2=='Checked'|...
    MEDS.acute_naraT2=='Checked'|MEDS.acute_almoT2=='Checked'|MEDS.acute_frovaT2=='Checked'|...
    MEDS.acute_eleT2=='Checked'|MEDS.acute_zomT2=='Checked') = 1;
MEDS.acute_triptanT2 = categorical(MEDS.acute_triptanT2,[0 1],{'Unchecked','Checked'});

MEDS.acute_steroidT2 = zeros(height(MEDS),1);
MEDS.acute_steroidT2(MEDS.acute_medrolT2=='Checked'|MEDS.acute_predT2=='Checked') = 1;
MEDS.acute_steroidT2 = categorical(MEDS.acute_steroidT2,[0 1],{'Unchecked','Checked'});

MEDS.acute_daT2 = zeros(height(MEDS),1);
MEDS.acute_daT2(MEDS.acute_metoT2=='Checked'|MEDS.acute_prochlorT2=='Checked'|...
    MEDS.acute_promethT2=='Checked') = 1;
MEDS.acute_daT2 = categorical(MEDS.acute_daT2,0,{'Unchecked'});

MEDS.acute_freqT2 = categorical(T2.HowOftenDoYouTakeAMedicationToStopAHeadache__1);
MEDS.acute_HiFreqDurT2 = categorical(T2.ForHowLongHaveYouBeenTakingAnAcuteMedicineMoreThan3DaysPerWee_1);

%T3
MEDS.acute_noneT3 = categorical(T3.MedicationsToSTOPHeadaches_choice_None__1);
MEDS.acute_tylenolT3 = categorical(T3.MedicationsToSTOPHeadaches_choice_Acetaminophen_Tylenol___1);
MEDS.acute_motrinT3 = categorical(T3.MedicationsToSTOPHeadaches_choice_Ibuprofen_Motrin_Advil___1);
MEDS.acute_naproxenT3 = categorical(T3.MedicationsToSTOPHeadaches_choice_Naproxen_Aleve_Naprosyn___1);
MEDS.acute_aspirinT3 = categorical(T3.MedicationsToSTOPHeadaches_choice_Aspirin__1);
MEDS.acute_toradolT3 = categorical(T3.MedicationsToSTOPHeadaches_choice_Ketorolac_Toradol_Sprix___1);
MEDS.acute_ketoprofenT3 = categorical(T3.MedicationsToSTOPHeadaches_choice_Ketoprofen_Relafen___1);
MEDS.acute_diclofenacT3 = categorical(T3.MedicationsToSTOPHeadaches_choice_Diclofenac_Voltaren___1);
MEDS.acute_celebrexT3 = categorical(T3.MedicationsToSTOPHeadaches_choice_Celecoxib_Celebrex___1);
MEDS.acute_excedrinT3 = categorical(T3.MedicationsToSTOPHeadaches_choice_Excedrin_ExcedrinMigraine_E_1);
MEDS.acute_fioricetT3 = categorical(T3.MedicationsToSTOPHeadaches_choice_Butalbital_Fioricet_Fiorina_1);
MEDS.acute_midrinT3 = categorical(T3.MedicationsToSTOPHeadaches_choice_Midrin__1);
MEDS.acute_medrolT3 = categorical(T3.MedicationsToSTOPHeadaches_choice_Methylprednisolone_MedrolPa_1);
MEDS.acute_predT3 = categorical(T3.MedicationsToSTOPHeadaches_choice_Prednisone_Prednisolone__1);
MEDS.acute_sumaT3 = categorical(T3.MedicationsToSTOPHeadaches_choice_Sumatriptan_Imitrex_Trexime_1);
MEDS.acute_rizaT3 = categorical(T3.MedicationsToSTOPHeadaches_choice_Rizatriptan_Maxalt___1);
MEDS.acute_naraT3 = categorical(T3.MedicationsToSTOPHeadaches_choice_Naratriptan_Amerge___1);
MEDS.acute_almoT3 = categorical(T3.MedicationsToSTOPHeadaches_choice_Almotriptan_Axert___1);
MEDS.acute_frovaT3 = categorical(T3.MedicationsToSTOPHeadaches_choice_Frovatriptan_Frova___1);
MEDS.acute_eleT3 = categorical(T3.MedicationsToSTOPHeadaches_choice_Eletriptan_Relpax___1);
MEDS.acute_zomT3 = categorical(T3.MedicationsToSTOPHeadaches_choice_Zolmitriptan_Zomig___1);
MEDS.acute_metoT3 = categorical(T3.MedicationsToSTOPHeadaches_choice_Metoclopramide_Reglan___1);
MEDS.acute_prochlorT3 = categorical(T3.MedicationsToSTOPHeadaches_choice_Prochlorperazine_Compazine__1);
MEDS.acute_promethT3 = categorical(T3.MedicationsToSTOPHeadaches_choice_Promethazine_Phenergan___1);
MEDS.acute_zofranT3 = categorical(T3.MedicationsToSTOPHeadaches_choice_Ondansetron_Zofran___1);
MEDS.acute_diphenT3 = categorical(T3.MedicationsToSTOPHeadaches_choice_Diphenhydramine_Benadryl___1);
MEDS.acute_dheT3 = categorical(T3.MedicationsToSTOPHeadaches_choice_DHE_Migranal___1);
MEDS.acute_tramT3 = categorical(T3.MedicationsToSTOPHeadaches_choice_Tramadol_Ultram_Ultracet___1);
MEDS.acute_tycodT3 = categorical(T3.MedicationsToSTOPHeadaches_choice_Tylenol_3_TylenolWithCodein_1);
MEDS.acute_morphT3 = categorical(T3.MedicationsToSTOPHeadaches_choice_Morphine__1);
MEDS.acute_hydroT3 = categorical(T3.MedicationsToSTOPHeadaches_choice_Hydromorphone_Dilaudid___1);
MEDS.acute_nerveblockT3 = categorical(T3.MedicationsToSTOPHeadaches_choice_NerveBlockOrTriggerPointInj_1);
MEDS.acute_othT3 = categorical(T3.MedicationsToSTOPHeadaches_choice_Other__1);

MEDS.acute_nsaidT3 = zeros(height(MEDS),1);
MEDS.acute_nsaidT3(MEDS.acute_motrinT3=='Checked'|MEDS.acute_naproxenT3=='Checked'|...
    MEDS.acute_aspirinT3=='Checked'|MEDS.acute_aspirinT3=='Checked'|MEDS.acute_toradolT3=='Checked'|...
    MEDS.acute_ketoprofenT3=='Checked'|MEDS.acute_diclofenacT3=='Checked'|MEDS.acute_celebrexT3=='Checked') = 1;
MEDS.acute_nsaidT3 = categorical(MEDS.acute_nsaidT3,[0 1],{'Unchecked','Checked'});

MEDS.acute_triptanT3 = zeros(height(MEDS),1);
MEDS.acute_triptanT3(MEDS.acute_sumaT3=='Checked'|MEDS.acute_rizaT3=='Checked'|...
    MEDS.acute_naraT3=='Checked'|MEDS.acute_almoT3=='Checked'|MEDS.acute_frovaT3=='Checked'|...
    MEDS.acute_eleT3=='Checked'|MEDS.acute_zomT3=='Checked') = 1;
MEDS.acute_triptanT3 = categorical(MEDS.acute_triptanT3,[0 1],{'Unchecked','Checked'});

MEDS.acute_steroidT3 = zeros(height(MEDS),1);
MEDS.acute_steroidT3(MEDS.acute_medrolT3=='Checked'|MEDS.acute_predT3=='Checked') = 1;
MEDS.acute_steroidT3 = categorical(MEDS.acute_steroidT3,[0 1],{'Unchecked','Checked'});

MEDS.acute_daT3 = zeros(height(MEDS),1);
MEDS.acute_daT3(MEDS.acute_metoT3=='Checked'|MEDS.acute_prochlorT3=='Checked'|...
    MEDS.acute_promethT3=='Checked') = 1;
MEDS.acute_daT3 = categorical(MEDS.acute_daT3,0,{'Unchecked'});

MEDS.acute_freqT3 = categorical(T3.HowOftenDoYouTakeAMedicationToStopAHeadache__1);
MEDS.acute_HiFreqDurT3 = categorical(T3.ForHowLongHaveYouBeenTakingAnAcuteMedicineMoreThan3DaysPerWee_1);


% Preventive
%T1
MEDS.prev_noCGRP = categorical(T1.CGRPBlockingAgents_choice_None_);
MEDS.prev_Eren = categorical(T1.CGRPBlockingAgents_choice_Erenumab_aooe_Aimovig__);
MEDS.prev_Frem = categorical(T1.CGRPBlockingAgents_choice_Fremanezumab_vfrm_Ajovy__);
MEDS.prev_Gal = categorical(T1.CGRPBlockingAgents_choice_Galcanezumab_gnlm_Emgality__);
MEDS.prev_Atog = categorical(T1.CGRPBlockingAgents_choice_Atogepant_Qulipta__);
MEDS.prev_Rime = categorical(T1.CGRPBlockingAgents_choice_Rimegepant_NurtecODT__);
MEDS.prev_Ubro = categorical(T1.CGRPBlockingAgents_choice_Ubrogepant_Ubrelvy__);
MEDS.prev_noBeta = categorical(T1.Beta_blockers_choice_None_);
MEDS.prev_Prop = categorical(T1.Beta_blockers_choice_Propanolol_);
MEDS.prev_Meto = categorical(T1.Beta_blockers_choice_Metoprolol_);
MEDS.prev_Aten = categorical(T1.Beta_blockers_choice_Atenolol_);
MEDS.prev_noHTN = categorical(T1.OtherAnti_hypertensives_choice_None_);
MEDS.prev_Cand = categorical(T1.OtherAnti_hypertensives_choice_Candesartan_);
MEDS.prev_Losa = categorical(T1.OtherAnti_hypertensives_choice_Losartan_);
MEDS.prev_othPrev = categorical(T1.AdditionalMigraine_headacheTreatments_choice_None_);
MEDS.prev_Botox = categorical(T1.AdditionalMigraine_headacheTreatments_choice_Botox_);
MEDS.prev_Oth = categorical(T1.AdditionalMigraine_headacheTreatments_choice_Other_);
MEDS.prev_Losa = categorical(T1.OtherAnti_hypertensives_choice_Losartan_);

%T2
MEDS.prevNone_T2 = categorical(T2.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSever);
MEDS.prevDia_T2 = categorical(T2.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_1);
MEDS.prevAmit_T2 = categorical(T2.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_2);
MEDS.prevAteno_T2 = categorical(T2.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_3);
MEDS.prevBotox_T2 = categorical(T2.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_4);
MEDS.prevCef_T2 = categorical(T2.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_5);
MEDS.prevCypro_T2 = categorical(T2.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_6);
MEDS.prevDoxy_T2 = categorical(T2.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_7);
MEDS.prevDulox_T2 = categorical(T2.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_8);
MEDS.prevFluox_T2 = categorical(T2.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_9);
MEDS.prevGaba_T2 = categorical(T2.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_10);
MEDS.prevLamo_T2 = categorical(T2.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_11);
MEDS.prevLisin_T2 = categorical(T2.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_12);
MEDS.prevKep_T2 = categorical(T2.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_13);
MEDS.prevMetop_T2 = categorical(T2.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_14);
MEDS.prevMino_T2 = categorical(T2.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_15);
MEDS.prevNB_T2 = categorical(T2.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_16);
MEDS.prevNebi_T2 = categorical(T2.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_17);
MEDS.prevNortr_T2 = categorical(T2.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_18);
MEDS.prevPregab_T2 = categorical(T2.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_19);
MEDS.prevProp_T2 = categorical(T2.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_20);
MEDS.prevSert_T2 = categorical(T2.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_21);
MEDS.prevTopa_T2 = categorical(T2.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_22);
MEDS.prevVPA_T2 = categorical(T2.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_23);
MEDS.prevVenla_T2 = categorical(T2.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_24);
MEDS.prevVerap_T2 = categorical(T2.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_25);
MEDS.prevZonis_T2 = categorical(T2.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_26);
MEDS.prevOth_T2 = categorical(T2.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_27);

MEDS.suppNone_T2 = categorical(T2.VitaminsAndSupplements_choice_None_);
MEDS.suppB2_T2 = categorical(T2.VitaminsAndSupplements_choice_VitaminB2_Riboflavin__);
MEDS.suppD_T2 = categorical(T2.VitaminsAndSupplements_choice_VitaminD_);
MEDS.suppMg_T2 = categorical(T2.VitaminsAndSupplements_choice_Magnesium_);
MEDS.suppFO_T2 = categorical(T2.VitaminsAndSupplements_choice_FishOil_);
MEDS.suppQ10_T2 = categorical(T2.VitaminsAndSupplements_choice_CoEnzymeQ10_);
MEDS.suppFev_T2 = categorical(T2.VitaminsAndSupplements_choice_Feverfew_);
MEDS.suppMel_T2 = categorical(T2.VitaminsAndSupplements_choice_Melatonin_);
MEDS.suppBut_T2 = categorical(T2.VitaminsAndSupplements_choice_Butterbur_Petadolex__);
MEDS.suppOth_T2 = categorical(T2.VitaminsAndSupplements_choice_Other_);

MEDS.imNone_T2 = categorical(T2.Intravenous_IV_OrIntramuscular_IM_Medications__choice_None_);
MEDS.imKet_T2 = categorical(T2.Intravenous_IV_OrIntramuscular_IM_Medications__choice_Ketorolac);
MEDS.imMet_T2 = categorical(T2.Intravenous_IV_OrIntramuscular_IM_Medications__choice_Metoclopr);
MEDS.imProc_T2 = categorical(T2.Intravenous_IV_OrIntramuscular_IM_Medications__choice_Prochlorp);
MEDS.imMp_T2 = categorical(T2.Intravenous_IV_OrIntramuscular_IM_Medications__choice_Methylpre);
MEDS.imDex_T2 = categorical(T2.Intravenous_IV_OrIntramuscular_IM_Medications__choice_Dexametha);
MEDS.imMg_T2 = categorical(T2.Intravenous_IV_OrIntramuscular_IM_Medications__choice_Magnesium);
MEDS.imVPA_T2 = categorical(T2.Intravenous_IV_OrIntramuscular_IM_Medications__choice_ValproicA);
MEDS.imDiph_T2 = categorical(T2.Intravenous_IV_OrIntramuscular_IM_Medications__choice_Diphenhyd);
MEDS.imOpioid_T2 = categorical(T2.Intravenous_IV_OrIntramuscular_IM_Medications__choice_Opioids_M);
MEDS.imKep_T2 = categorical(T2.Intravenous_IV_OrIntramuscular_IM_Medications__choice_Levetirac);
MEDS.imDHE_T2 = categorical(T2.Intravenous_IV_OrIntramuscular_IM_Medications__choice_DHE_Dihyd);
MEDS.imZof_T2 = categorical(T2.Intravenous_IV_OrIntramuscular_IM_Medications__choice_Ondansetr);
MEDS.imOth_T2 = categorical(T2.Intravenous_IV_OrIntramuscular_IM_Medications__choice_Other_);

%T3
MEDS.prevNone_T3 = categorical(T3.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSever);
MEDS.prevDia_T3 = categorical(T3.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_1);
MEDS.prevAmit_T3 = categorical(T3.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_2);
MEDS.prevAteno_T3 = categorical(T3.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_3);
MEDS.prevBotox_T3 = categorical(T3.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_4);
MEDS.prevCef_T3 = categorical(T3.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_5);
MEDS.prevCypro_T3 = categorical(T3.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_6);
MEDS.prevDoxy_T3 = categorical(T3.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_7);
MEDS.prevDulox_T3 = categorical(T3.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_8);
MEDS.prevFluox_T3 = categorical(T3.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_9);
MEDS.prevGaba_T3 = categorical(T3.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_10);
MEDS.prevLamo_T3 = categorical(T3.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_11);
MEDS.prevLisin_T3 = categorical(T3.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_12);
MEDS.prevKep_T3 = categorical(T3.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_13);
MEDS.prevMetop_T3 = categorical(T3.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_14);
MEDS.prevMino_T3 = categorical(T3.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_15);
MEDS.prevNB_T3 = categorical(T3.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_16);
MEDS.prevNebi_T3 = categorical(T3.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_17);
MEDS.prevNortr_T3 = categorical(T3.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_18);
MEDS.prevPregab_T3 = categorical(T3.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_19);
MEDS.prevProp_T3 = categorical(T3.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_20);
MEDS.prevSert_T3 = categorical(T3.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_21);
MEDS.prevTopa_T3 = categorical(T3.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_22);
MEDS.prevVPA_T3 = categorical(T3.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_23);
MEDS.prevVenla_T3 = categorical(T3.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_24);
MEDS.prevVerap_T3 = categorical(T3.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_25);
MEDS.prevZonis_T3 = categorical(T3.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_26);
MEDS.prevOth_T3 = categorical(T3.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSe_27);

MEDS.suppNone_T3 = categorical(T3.VitaminsAndSupplements_choice_None_);
MEDS.suppB2_T3 = categorical(T3.VitaminsAndSupplements_choice_VitaminB2_Riboflavin__);
MEDS.suppD_T3 = categorical(T3.VitaminsAndSupplements_choice_VitaminD_);
MEDS.suppMg_T3 = categorical(T3.VitaminsAndSupplements_choice_Magnesium_);
MEDS.suppFO_T3 = categorical(T3.VitaminsAndSupplements_choice_FishOil_);
MEDS.suppQ10_T3 = categorical(T3.VitaminsAndSupplements_choice_CoEnzymeQ10_);
MEDS.suppFev_T3 = categorical(T3.VitaminsAndSupplements_choice_Feverfew_);
MEDS.suppMel_T3 = categorical(T3.VitaminsAndSupplements_choice_Melatonin_);
MEDS.suppBut_T3 = categorical(T3.VitaminsAndSupplements_choice_Butterbur_Petadolex__);
MEDS.suppOth_T3 = categorical(T3.VitaminsAndSupplements_choice_Other_);

MEDS.imNone_T3 = categorical(T3.Intravenous_IV_OrIntramuscular_IM_Medications__choice_None_);
MEDS.imKet_T3 = categorical(T3.Intravenous_IV_OrIntramuscular_IM_Medications__choice_Ketorolac);
MEDS.imMet_T3 = categorical(T3.Intravenous_IV_OrIntramuscular_IM_Medications__choice_Metoclopr);
MEDS.imProc_T3 = categorical(T3.Intravenous_IV_OrIntramuscular_IM_Medications__choice_Prochlorp);
MEDS.imMp_T3 = categorical(T3.Intravenous_IV_OrIntramuscular_IM_Medications__choice_Methylpre);
MEDS.imDex_T3 = categorical(T3.Intravenous_IV_OrIntramuscular_IM_Medications__choice_Dexametha);
MEDS.imMg_T3 = categorical(T3.Intravenous_IV_OrIntramuscular_IM_Medications__choice_Magnesium);
MEDS.imVPA_T3 = categorical(T3.Intravenous_IV_OrIntramuscular_IM_Medications__choice_ValproicA);
MEDS.imDiph_T3 = categorical(T3.Intravenous_IV_OrIntramuscular_IM_Medications__choice_Diphenhyd);
MEDS.imOpioid_T3 = categorical(T3.Intravenous_IV_OrIntramuscular_IM_Medications__choice_Opioids_M);
MEDS.imKep_T3 = categorical(T3.Intravenous_IV_OrIntramuscular_IM_Medications__choice_Levetirac);
MEDS.imDHE_T3 = categorical(T3.Intravenous_IV_OrIntramuscular_IM_Medications__choice_DHE_Dihyd);
MEDS.imZof_T3 = categorical(T3.Intravenous_IV_OrIntramuscular_IM_Medications__choice_Ondansetr);
MEDS.imOth_T3 = categorical(T3.Intravenous_IV_OrIntramuscular_IM_Medications__choice_Other_);

%% Clean and Sanity check the table of initial headache responses PCSI

% Keep Time point 1 when data were collected (Headache Substudy), remove Administrative, and Time points 2 and 3
pcsiT1 = T(categorical(T.EventName)=='Time point 1',[1 296:318 510:531]);
pcsiT2 = T(categorical(T.EventName)=='Time point 2',[1 296:318]);
pcsiT3 = T(categorical(T.EventName)=='Time point 3',[1 296:318]);

%add placeholders for missing data
dummy_pt2 = pcsiT2(2,:); % participant 2, then switch everything to missing
dummy_pt2.RecordID_ = {'Missing'};
dummy_pt2.Headache = NaN;
dummy_pt2.Nausea = NaN;
dummy_pt2.BalanceProblems = NaN;
dummy_pt2.Dizziness = NaN;
dummy_pt2.Fatigue = NaN;
dummy_pt2.SleepMoreThanUsual = NaN;
dummy_pt2.Drowsiness = NaN;
dummy_pt2.SensitivityToLight = NaN;
dummy_pt2.SensitivityToNoise = NaN;
dummy_pt2.Irritability = NaN;
dummy_pt2.Sadness = NaN;
dummy_pt2.Nervousness = NaN;
dummy_pt2.FeelingMoreEmotional = NaN;
dummy_pt2.FeelingSlowedDown = NaN;
dummy_pt2.FeelingMentally_foggy_ = NaN;
dummy_pt2.DifficultyConcentrating = NaN;
dummy_pt2.DifficultyRemembering = NaN;
dummy_pt2.VisualProblems_doubleVision_Blurring_ = NaN;
dummy_pt2.GetConfusedWithDirectionsOrTasks = NaN;
dummy_pt2.MoveInAClumsyManner = NaN;
dummy_pt2.AnswerQuestionsMoreSlowlyThanUsual = NaN;
dummy_pt2.InGeneral_ToWhatDegreeDoesThePatientFeel_differently_ThanBefore = NaN;
dummy_pt2.PCSICurrent_Teen_TotalSymptomScore = NaN;


pcsiT2 = [pcsiT2(1:4,:);dummy_pt2;pcsiT2(5:6,:);dummy_pt2;pcsiT2(7:19,:);dummy_pt2;dummy_pt2;pcsiT2(20,:);dummy_pt2;pcsiT2(21:27,:);dummy_pt2;...
    pcsiT2(28:end,:)]; % HSS-005, -008, -022, -023, -025, -033
pcsiT3 = [pcsiT3(1:20,:);dummy_pt2;dummy_pt2;pcsiT3(21:29,:);dummy_pt2;pcsiT3(30:end,:);dummy_pt2]; % HSS-021, -022, -032, -057

PCSI = T1(:,1);
PCSI.headache_preinj = pcsiT1.Headache_2;
PCSI.nausea_preinj = pcsiT1.Nausea_2;
PCSI.balance_preinj = pcsiT1.BalanceProblems_2;
PCSI.dizziness_preinj = pcsiT1.Dizziness_2;
PCSI.fatigue_preinj = pcsiT1.Fatigue_2;
PCSI.sleepmore_preinj = pcsiT1.SleepMoreThanUsual_2;
PCSI.drowsiness_preinj = pcsiT1.Drowsiness_2;
PCSI.lightsens_preinj = pcsiT1.SensitivityToLight_2;
PCSI.soundsens_preinj = pcsiT1.SensitivityToNoise_2;
PCSI.irrit_preinj = pcsiT1.Irritability_2;
PCSI.sadness_preinj = pcsiT1.Sadness_2;
PCSI.nervous_preinj = pcsiT1.Nervousness_2;
PCSI.emotional_preinj = pcsiT1.FeelingMoreEmotional_2;
PCSI.slowed_preinj = pcsiT1.FeelingSlowedDown_2;
PCSI.foggy_preinj = pcsiT1.FeelingMentally_foggy__2;
PCSI.concentrate_preinj = pcsiT1.DifficultyConcentrating_2;
PCSI.remember_preinj = pcsiT1.DifficultyRemembering_2;
PCSI.visualprob_preinj = pcsiT1.VisualProblems_doubleVision_Blurring__2;
PCSI.confused_preinj = pcsiT1.GetConfusedWithDirectionsOrTasks_2;
PCSI.clumsy_preinj = pcsiT1.MoveInAClumsyManner_2;
PCSI.ansslow_preinj = pcsiT1.AnswerQuestionsMoreSlowlyThanUsual_2;
PCSI.total_preinj = pcsiT1.PCSIPre_InjuryTotalSymptomScore;

PCSI.headache_T1 = pcsiT1.Headache;
PCSI.nausea_T1 = pcsiT1.Nausea;
PCSI.balance_T1 = pcsiT1.BalanceProblems;
PCSI.dizziness_T1 = pcsiT1.Dizziness;
PCSI.fatigue_T1 = pcsiT1.Fatigue;
PCSI.sleepmore_T1 = pcsiT1.SleepMoreThanUsual;
PCSI.drowsiness_T1 = pcsiT1.Drowsiness;
PCSI.lightsens_T1 = pcsiT1.SensitivityToLight;
PCSI.soundsens_T1 = pcsiT1.SensitivityToNoise;
PCSI.irrit_T1 = pcsiT1.Irritability;
PCSI.sadness_T1 = pcsiT1.Sadness;
PCSI.nervous_T1 = pcsiT1.Nervousness;
PCSI.emotional_T1 = pcsiT1.FeelingMoreEmotional;
PCSI.slowed_T1 = pcsiT1.FeelingSlowedDown;
PCSI.foggy_T1 = pcsiT1.FeelingMentally_foggy_;
PCSI.concentrate_T1 = pcsiT1.DifficultyConcentrating;
PCSI.remember_T1 = pcsiT1.DifficultyRemembering;
PCSI.visualprob_T1 = pcsiT1.VisualProblems_doubleVision_Blurring_;
PCSI.confused_T1 = pcsiT1.GetConfusedWithDirectionsOrTasks;
PCSI.clumsy_T1 = pcsiT1.MoveInAClumsyManner;
PCSI.ansslow_T1 = pcsiT1.AnswerQuestionsMoreSlowlyThanUsual;
PCSI.total_T1 = pcsiT1.PCSICurrent_Teen_TotalSymptomScore;

PCSI.headache_T2 = pcsiT2.Headache;
PCSI.nausea_T2 = pcsiT2.Nausea;
PCSI.balance_T2 = pcsiT2.BalanceProblems;
PCSI.dizziness_T2 = pcsiT2.Dizziness;
PCSI.fatigue_T2 = pcsiT2.Fatigue;
PCSI.sleepmore_T2 = pcsiT2.SleepMoreThanUsual;
PCSI.drowsiness_T2 = pcsiT2.Drowsiness;
PCSI.lightsens_T2 = pcsiT2.SensitivityToLight;
PCSI.soundsens_T2 = pcsiT2.SensitivityToNoise;
PCSI.irrit_T2 = pcsiT2.Irritability;
PCSI.sadness_T2 = pcsiT2.Sadness;
PCSI.nervous_T2 = pcsiT2.Nervousness;
PCSI.emotional_T2 = pcsiT2.FeelingMoreEmotional;
PCSI.slowed_T2 = pcsiT2.FeelingSlowedDown;
PCSI.foggy_T2 = pcsiT2.FeelingMentally_foggy_;
PCSI.concentrate_T2 = pcsiT2.DifficultyConcentrating;
PCSI.remember_T2 = pcsiT2.DifficultyRemembering;
PCSI.visualprob_T2 = pcsiT2.VisualProblems_doubleVision_Blurring_;
PCSI.confused_T2 = pcsiT2.GetConfusedWithDirectionsOrTasks;
PCSI.clumsy_T2 = pcsiT2.MoveInAClumsyManner;
PCSI.ansslow_T2 = pcsiT2.AnswerQuestionsMoreSlowlyThanUsual;
PCSI.total_T2 = pcsiT2.PCSICurrent_Teen_TotalSymptomScore;

PCSI.headache_T3 = pcsiT3.Headache;
PCSI.nausea_T3 = pcsiT3.Nausea;
PCSI.balance_T3 = pcsiT3.BalanceProblems;
PCSI.dizziness_T3 = pcsiT3.Dizziness;
PCSI.fatigue_T3 = pcsiT3.Fatigue;
PCSI.sleepmore_T3 = pcsiT3.SleepMoreThanUsual;
PCSI.drowsiness_T3 = pcsiT3.Drowsiness;
PCSI.lightsens_T3 = pcsiT3.SensitivityToLight;
PCSI.soundsens_T3 = pcsiT3.SensitivityToNoise;
PCSI.irrit_T3 = pcsiT3.Irritability;
PCSI.sadness_T3 = pcsiT3.Sadness;
PCSI.nervous_T3 = pcsiT3.Nervousness;
PCSI.emotional_T3 = pcsiT3.FeelingMoreEmotional;
PCSI.slowed_T3 = pcsiT3.FeelingSlowedDown;
PCSI.foggy_T3 = pcsiT3.FeelingMentally_foggy_;
PCSI.concentrate_T3 = pcsiT3.DifficultyConcentrating;
PCSI.remember_T3 = pcsiT3.DifficultyRemembering;
PCSI.visualprob_T3 = pcsiT3.VisualProblems_doubleVision_Blurring_;
PCSI.confused_T3 = pcsiT3.GetConfusedWithDirectionsOrTasks;
PCSI.clumsy_T3 = pcsiT3.MoveInAClumsyManner;
PCSI.ansslow_T3 = pcsiT3.AnswerQuestionsMoreSlowlyThanUsual;
PCSI.total_T3 = pcsiT3.PCSICurrent_Teen_TotalSymptomScore;

% Calculate differences between PCSI scores
PCSI.headache_diff1 = diff([PCSI.headache_preinj PCSI.headache_T1],1,2);
PCSI.nausea_diff1 = diff([PCSI.nausea_preinj PCSI.nausea_T1],1,2);
PCSI.balance_diff1 = diff([PCSI.balance_preinj PCSI.balance_T1],1,2);
PCSI.dizziness_diff1 = diff([PCSI.dizziness_preinj PCSI.dizziness_T1],1,2);
PCSI.fatigue_diff1 = diff([PCSI.fatigue_preinj PCSI.fatigue_T1],1,2);
PCSI.sleepmore_diff1 = diff([PCSI.sleepmore_preinj PCSI.sleepmore_T1],1,2);
PCSI.drowsiness_diff1 = diff([PCSI.drowsiness_preinj PCSI.drowsiness_T1],1,2);
PCSI.lightsens_diff1 = diff([PCSI.lightsens_preinj PCSI.lightsens_T1],1,2);
PCSI.soundsens_diff1 = diff([PCSI.soundsens_preinj PCSI.soundsens_T1],1,2);
PCSI.irrit_diff1 = diff([PCSI.irrit_preinj PCSI.irrit_T1],1,2);
PCSI.sadness_diff1 = diff([PCSI.sadness_preinj PCSI.sadness_T1],1,2);
PCSI.nervous_diff1 = diff([PCSI.nervous_preinj PCSI.nervous_T1],1,2);
PCSI.emotional_diff1 = diff([PCSI.emotional_preinj PCSI.emotional_T1],1,2);
PCSI.slowed_diff1 = diff([PCSI.slowed_preinj PCSI.slowed_T1],1,2);
PCSI.foggy_diff1 = diff([PCSI.foggy_preinj PCSI.foggy_T1],1,2);
PCSI.concentrate_diff1 = diff([PCSI.concentrate_preinj PCSI.concentrate_T1],1,2);
PCSI.remember_diff1 = diff([PCSI.remember_preinj PCSI.remember_T1],1,2);
PCSI.visualprob_diff1 = diff([PCSI.visualprob_preinj PCSI.visualprob_T1],1,2);
PCSI.confused_diff1 = diff([PCSI.confused_preinj PCSI.confused_T1],1,2);
PCSI.clumsy_diff1 = diff([PCSI.clumsy_preinj PCSI.clumsy_T1],1,2);
PCSI.ansslow_diff1 = diff([PCSI.ansslow_preinj PCSI.ansslow_T1],1,2);
PCSI.total_diff1 = diff([PCSI.total_preinj PCSI.total_T1],1,2);

PCSI.headache_diff2 = diff([PCSI.headache_preinj PCSI.headache_T2],1,2);
PCSI.nausea_diff2 = diff([PCSI.nausea_preinj PCSI.nausea_T2],1,2);
PCSI.balance_diff2 = diff([PCSI.balance_preinj PCSI.balance_T2],1,2);
PCSI.dizziness_diff2 = diff([PCSI.dizziness_preinj PCSI.dizziness_T2],1,2);
PCSI.fatigue_diff2 = diff([PCSI.fatigue_preinj PCSI.fatigue_T2],1,2);
PCSI.sleepmore_diff2 = diff([PCSI.sleepmore_preinj PCSI.sleepmore_T2],1,2);
PCSI.drowsiness_diff2 = diff([PCSI.drowsiness_preinj PCSI.drowsiness_T2],1,2);
PCSI.lightsens_diff2 = diff([PCSI.lightsens_preinj PCSI.lightsens_T2],1,2);
PCSI.soundsens_diff2 = diff([PCSI.soundsens_preinj PCSI.soundsens_T2],1,2);
PCSI.irrit_diff2 = diff([PCSI.irrit_preinj PCSI.irrit_T2],1,2);
PCSI.sadness_diff2 = diff([PCSI.sadness_preinj PCSI.sadness_T2],1,2);
PCSI.nervous_diff2 = diff([PCSI.nervous_preinj PCSI.nervous_T2],1,2);
PCSI.emotional_diff2 = diff([PCSI.emotional_preinj PCSI.emotional_T2],1,2);
PCSI.slowed_diff2 = diff([PCSI.slowed_preinj PCSI.slowed_T2],1,2);
PCSI.foggy_diff2 = diff([PCSI.foggy_preinj PCSI.foggy_T2],1,2);
PCSI.concentrate_diff2 = diff([PCSI.concentrate_preinj PCSI.concentrate_T2],1,2);
PCSI.remember_diff2 = diff([PCSI.remember_preinj PCSI.remember_T2],1,2);
PCSI.visualprob_diff2 = diff([PCSI.visualprob_preinj PCSI.visualprob_T2],1,2);
PCSI.confused_diff2 = diff([PCSI.confused_preinj PCSI.confused_T2],1,2);
PCSI.clumsy_diff2 = diff([PCSI.clumsy_preinj PCSI.clumsy_T2],1,2);
PCSI.ansslow_diff2 = diff([PCSI.ansslow_preinj PCSI.ansslow_T2],1,2);
PCSI.total_diff2 = diff([PCSI.total_preinj PCSI.total_T2],1,2);

PCSI.headache_diff3 = diff([PCSI.headache_preinj PCSI.headache_T3],1,2);
PCSI.nausea_diff3 = diff([PCSI.nausea_preinj PCSI.nausea_T3],1,2);
PCSI.balance_diff3 = diff([PCSI.balance_preinj PCSI.balance_T3],1,2);
PCSI.dizziness_diff3 = diff([PCSI.dizziness_preinj PCSI.dizziness_T3],1,2);
PCSI.fatigue_diff3 = diff([PCSI.fatigue_preinj PCSI.fatigue_T3],1,2);
PCSI.sleepmore_diff3 = diff([PCSI.sleepmore_preinj PCSI.sleepmore_T3],1,2);
PCSI.drowsiness_diff3 = diff([PCSI.drowsiness_preinj PCSI.drowsiness_T3],1,2);
PCSI.lightsens_diff3 = diff([PCSI.lightsens_preinj PCSI.lightsens_T3],1,2);
PCSI.soundsens_diff3 = diff([PCSI.soundsens_preinj PCSI.soundsens_T3],1,2);
PCSI.irrit_diff3 = diff([PCSI.irrit_preinj PCSI.irrit_T3],1,2);
PCSI.sadness_diff3 = diff([PCSI.sadness_preinj PCSI.sadness_T3],1,2);
PCSI.nervous_diff3 = diff([PCSI.nervous_preinj PCSI.nervous_T3],1,2);
PCSI.emotional_diff3 = diff([PCSI.emotional_preinj PCSI.emotional_T3],1,2);
PCSI.slowed_diff3 = diff([PCSI.slowed_preinj PCSI.slowed_T3],1,2);
PCSI.foggy_diff3 = diff([PCSI.foggy_preinj PCSI.foggy_T3],1,2);
PCSI.concentrate_diff3 = diff([PCSI.concentrate_preinj PCSI.concentrate_T3],1,2);
PCSI.remember_diff3 = diff([PCSI.remember_preinj PCSI.remember_T3],1,2);
PCSI.visualprob_diff3 = diff([PCSI.visualprob_preinj PCSI.visualprob_T3],1,2);
PCSI.confused_diff3 = diff([PCSI.confused_preinj PCSI.confused_T3],1,2);
PCSI.clumsy_diff3 = diff([PCSI.clumsy_preinj PCSI.clumsy_T3],1,2);
PCSI.ansslow_diff3 = diff([PCSI.ansslow_preinj PCSI.ansslow_T3],1,2);
PCSI.total_diff3 = diff([PCSI.total_preinj PCSI.total_T3],1,2);

end % function