function [T, Tshort, notesText] = preProcess_microbiome(spreadSheetName)
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

%% Clean the table


% Change question text variables to categorical



T.DateOfInjury = datetime(T.DateOfInjury);
T = convertvars(T, ["RecordID_", "EventName","Sex","AreYourEyesSensitiveToLight_","DoYouGetHeadaches_",...
    "HaveYouEverHadAHeadache_","HaveYouEverHadAHeadacheThatWasNOTCausedByAHeadInjuryOrIllnessLi","DoYouGetHeadachesThatAreNOTCausedByAHeadInjuryOrIllnessLikeTheC","DoYouGetHeadachesThatAreNOTCausedByAHeadInjuryOrIllnessLikeTheC",...
    "DoYourHeadachesEverLastMoreThanTwoHours_","HaveYouEverHadEpisodesOfDiscomfort_Pressure_OrPainAroundYourEye","HowWouldYouDescribeThisPainOrDiscomfort_",...
    "HowIntenseWouldYouRateThisPainOrDiscomfort_","DuringTheseEpisodes_DoYouEverExperienceTheFollowingSymptoms__ch","DuringTheseEpisodes_DoYouEverExperienceTheFollowingSymptoms___1",...
    "DuringTheseEpisodes_DoYouEverExperienceTheFollowingSymptoms___2","DuringTheseEpisodes_DoYouEverExperienceTheFollowingSymptoms___3","HaveYouEverTakenMedicationToMakeThePainOrDiscomfortFeelBetter_",...
    "HowManyTimesInYourLifeHasThisPainOrDiscomfortHappened_","WhenIsTheLastTimeYouFeltThisPainOrDiscomfort_","DoYouUsuallyGetHeadachesAroundYourMenstrualPeriods_","ForYouWORSTTypeOfHeadache_DoAnyOfTheFollowingStatementsDescribe",...
    "ForYouWORSTTypeOfHeadache_DoAnyOfTheFollowingStatementsDescribe","ForYouWORSTTypeOfHeadache_DoAnyOfTheFollowingStatementsDescri_1","ForYouWORSTTypeOfHeadache_DoAnyOfTheFollowingStatementsDescri_2",...
    "ForYouWORSTTypeOfHeadache_DoAnyOfTheFollowingStatementsDescri_3","ForYouWORSTTypeOfHeadache_DoAnyOfTheFollowingStatementsDescri_4",...
    "DuringYourWORSTTypeOfHeadaches_DoYouEverExperienceTheFollowingS","DuringYourWORSTTypeOfHeadaches_DoYouEverExperienceTheFollowin_1",...
    "DuringYourWORSTTypeOfHeadaches_DoYouEverExperienceTheFollowin_2","DuringYourWORSTTypeOfHeadaches_DoYouEverExperienceTheFollowin_3",...
    "DoHeadachesThatLastMoreThanTwoHoursHaveAnyOfTheFollowing_Please","DoHeadachesThatLastMoreThanTwoHoursHaveAnyOfTheFollowing_Plea_1",...
    "DoHeadachesThatLastMoreThanTwoHoursHaveAnyOfTheFollowing_Plea_2","DoHeadachesThatLastMoreThanTwoHoursHaveAnyOfTheFollowing_Plea_3",...
    "DoHeadachesThatLastMoreThanTwoHoursHaveAnyOfTheFollowing_Plea_4","DoHeadachesThatLastMoreThanTwoHoursHaveAnyOfTheFollowing_Plea_5",...
    "DoHeadachesThatLastMoreThanTwoHoursHaveAnyOfTheFollowing_Plea_6","DoHeadachesThatLastMoreThanTwoHoursHaveAnyOfTheFollowing_Plea_7",...
    "DoHeadachesThatLastMoreThanTwoHoursHaveAnyOfTheFollowing_Plea_8","HaveYouHadThisHeadache5OrMoreTimesInYourLife_","WhenIsTheLastTimeYouHadOneOfTheseHeadaches_",...
    "AroundTheTimeOfYourHeadaches_HaveYouEverSeenAnyOfTheFollowing_P","AroundTheTimeOfYourHeadaches_HaveYouEverSeenAnyOfTheFollowing_1",...
    "AroundTheTimeOfYourHeadaches_HaveYouEverSeenAnyOfTheFollowing_2","AroundTheTimeOfYourHeadaches_HaveYouEverSeenAnyOfTheFollowing_3",...
    "AroundTheTimeOfYourHeadaches_HaveYouEverSeenAnyOfTheFollowing_4","AroundTheTimeOfYourHeadaches_HaveYouEverSeenAnyOfTheFollowing_5",...
    "AroundTheTimeOfYourHeadaches_HaveYouEverSeenAnyOfTheFollowing_6","AroundTheTimeOfYourHeadaches_HaveYouEverSeenAnyOfTheFollowing_7",...
    "HaveYouEverHadAnyOfTheFollowingHappenAroundTheTimeOfYourHeadach","HaveYouEverHadAnyOfTheFollowingHappenAroundTheTimeOfYourHeada_1","HaveYouEverHadAnyOfTheFollowingHappenAroundTheTimeOfYourHeada_2",...
    "HaveYouEverHadAnyOfTheFollowingHappenAroundTheTimeOfYourHeadDis","HaveYouEverHadAnyOfTheFollowingHappenAroundTheTimeOfYourHeadD_1","HaveYouEverHadAnyOfTheFollowingHappenAroundTheTimeOfYourHeadD_2",...
    "HaveYouEverHadAnyOfTheFollowingHappenAroundTheTimeOfYourHeadD_3","HaveYouEverHadAnyOfTheFollowingHappenAroundTheTimeOfYourHeadD_4","HaveYouEverHadAnyOfTheFollowingHappenAroundTheTimeOfYourHeadD_5",...
    "HaveYouEverHadAnyOfTheFollowingHappenAroundTheTimeOfYourHeadD_6","HaveYouEverHadAnyOfTheFollowingHappenAroundTheTimeOfYourHeada_3","HaveYouEverHadAnyOfTheFollowingHappenAroundTheTimeOfYourHeada_4",...
    "HaveYouEverHadAnyOfTheFollowingHappenAroundTheTimeOfYourHeada_5","HaveYouEverHadAnyOfTheFollowingHappenAroundTheTimeOfYourHeada_6","DoChangesInVision_Numbness_tingling_And_orDifficultySpeakingHap",...
    "HaveYouHadDifficultySpeakingWithYourHeadachesTwoOrMoreTimesInYo","HaveYouHadDifficultySpeakingWithYourHeadDiscomfortTwoOrMoreTime",...
    "WhenDoYouHaveDifficultySpeaking_PleaseMarkAllThatApply__choice_","WhenDoYouHaveDifficultySpeaking_PleaseMarkAllThatApply__choic_1",...
    "WhenDoYouHaveDifficultySpeaking_PleaseMarkAllThatApply__choic_2","WhenDoYouHaveDifficultySpeaking_PleaseMarkAllThatApply__choic_3",...
    "WhenDoYouHaveDifficultySpeaking_PleaseMarkAllThatApply__choic_4","WhenDoYouHaveDifficultySpeaking_PleaseMarkAllThatApply__choic_5",...
    "WhenWasTheLastTimeYouHadDifficultySpeaking_","HowLongDoesTheDifficultySpeakingUsuallyLast_","DoesThisDifficultySpeakingEverLast5_60Minutes_",...
    "HaveYouHadTheseVisionChangesWithYourHeadachesTwoOrMoreTimesInYo","HaveYouHadTheseVisionChangesWithYourHeadDiscomfortTwoOrMoreTime","WhenDoYouHaveTheseVisionChanges_PleaseMarkAllThatApply__choice_",...
    "WhenDoYouHaveTheseVisionChanges_PleaseMarkAllThatApply__choic_1","WhenDoYouHaveTheseVisionChanges_PleaseMarkAllThatApply__choic_2","WhenDoYouHaveTheseVisionChanges_PleaseMarkAllThatApply__choic_3",...
    "WhenDoYouHaveTheseVisionChanges_PleaseMarkAllThatApply__choic_4","WhenDoYouHaveTheseVisionChanges_PleaseMarkAllThatApply__choic_5","WhenWasTheLastTimeYouHadTheseVisionChanges_",...
    "HowLongDoTheseVisionChangesUsuallyLast_","DoTheseVisionChangesEverLast5_60Minutes_","AreTheVisionChangesOnlyOneOneSide_",...
    "DoTheVisionChangesSpreadOrMoveAcrossYourVision_","HaveYouHadThisNumbnessAnd_orTinglingWithYourHeadachesTwoOrMoreT","HaveYouHadThisNumbnessAnd_orTinglingWithYourHeadDiscomfortTwoOr",...
    "WhenDoYouHaveThisNumbnessAnd_orTingling_PleaseMarkAllThatApply_","WhenDoYouHaveThisNumbnessAnd_orTingling_PleaseMarkAllThatAppl_1","WhenDoYouHaveThisNumbnessAnd_orTingling_PleaseMarkAllThatAppl_2",...
    "WhenDoYouHaveThisNumbnessAnd_orTingling_PleaseMarkAllThatAppl_3","WhenDoYouHaveThisNumbnessAnd_orTingling_PleaseMarkAllThatAppl_4","WhenDoYouHaveThisNumbnessAnd_orTingling_PleaseMarkAllThatAppl_5",...
    "WhenWasTheLastTimeYouHadThisNumbnessAnd_orTingling_","HowLongDoesTheNumbnessAnd_orTinglingUsuallyLast_","DoesTheNumbnessAnd_orTinglingEverLast5_60Minutes_","IsTheNumbnessAnd_orTinglingOnlyOnOneSideOfYourBody_",...
    "DoesTheNumbnessAnd_orTinglingStartInOneSpot_AndThenSpreadOrMove","DoYouGetMotionSick_e_g_CarSick_NowOrWhenYouWereYounger_","DoYourParents_Brothers_OrSistersGetMigraines_",...
    "DuringYourHeadache_DoYouFeelAGreaterSenseOfGlareOrDazzleInYourE","DuringYourHeadDiscomfort_DoYouFeelAGreaterSenseOfGlareOrDazzleI","DoYouEverFeelAGreaterSenseOfGlareOrDazzleInYourEyesThanUsualByB",...
    "DuringYourHeadDiscomfort_DoFlickeringLights_Glare_SpecificColor","DuringYourHeadache_DoFlickeringLights_Glare_SpecificColors_OrHi","DoFlickeringLights_Glare_SpecificColors_OrHighContrastStripedPa",...
    "DuringYourHeadache_DoYouTurnOffTheLightsOrDrawACurtainToAvoidBr","DuringYourHeadDiscomfort_DoYouTurnOffTheLightsOrDrawACurtainToA","DoYouEverTurnOffTheLightsOrDrawACurtainToAvoidBrightConditions_",...
    "DuringYourHeadache_DoYouHaveToWearSunglassesEvenInNormalDayligh","DuringYourHeadDiscomfort_DoYouHaveToWearSunglassesEvenInNormalD","DoYouEverHaveToWearSunglassesEvenInNormalDaylight_",...
    "DuringYourHeadache_DoBrightLightsHurtYourEyes_","DuringYourHeadDiscomfort_DoBrightLightsHurtYourEyes_","DoBrightLightsEverHurtYourEyes_","IsYourHeadacheWorsenedByBrightLights_","IsYourHeadDiscomfortWorsenedByBrightLights_",...
    "DoYouHaveAnyOfTheAboveSymptomsEvenDuringYourHeadache_freeInterv","DoYouHaveAnyOfTheAboveSymptomsEvenWhenYouDoNotHaveHeadDiscomfor","WasItThePatient_sFinalVisitToClinic_"], @categorical);


%% Headache Features
T.noChange = categorical(T.HowHaveHeadachesChanged_selectAllThatApply___choice_noChange_);
T.moreFreq = categorical(T.HowHaveHeadachesChanged_selectAllThatApply___choice_moreFrequen);
T.moreSevere = categorical(T.HowHaveHeadachesChanged_selectAllThatApply___choice_moreSevere_);
T.worseFx = categorical(T.HowHaveHeadachesChanged_selectAllThatApply___choice_lessAbleToD);
T.othChange = categorical(T.HowHaveHeadachesChanged_selectAllThatApply___choice_other_);

T.pattern = categorical(T.WhatIsTheCurrentPatternOfYourHeadaches_);
T.pattern(T.EventName=="Time point 2") = categorical(T.WhatIsTheCurrentPatternOfYourHeadaches__1(T.EventName=="Time point 2"));
T.pattern(T.EventName=="Time point 3") = categorical(T.WhatIsTheCurrentPatternOfYourHeadaches__1(T.EventName=="Time point 3"));
T.pattern(isundefined(T.pattern)) = 'no headache';

T.HA_Freq = categorical(T.HowOftenAreTheHeadaches_);
T.HA_Freq(T.EventName=="Time point 2") = categorical(T.HowOftenAreTheHeadaches__1(T.EventName=="Time point 2"));
T.HA_Freq(T.EventName=="Time point 3") = categorical(T.HowOftenAreTheHeadaches__1(T.EventName=="Time point 3"));
T.HA_Freq(T.pattern=="Some headache is there all the time, and it doesn't change much.") = "Always";
T.HA_Freq(T.pattern=="Some headache is there all the time.  The pain is better sometimes, and worse sometimes.") = "Always";
T.HA_Freq(T.pattern=="no headache") = 'Never';
T.HA_Freq = reordercats(T.HA_Freq,{'Never','Less than 1 per week','1 per week','2 to 3 per week','More than 3 per week','Daily','Multiple times a day','Always'});

T.HA_Freq_disable = categorical(T.HowOftenDoTheHeadachesGetInTheWayOfWhatYouWantToDo_);
T.HA_Freq_disable(T.EventName=="Time point 2") = categorical(T.HowOftenDoTheHeadachesGetInTheWayOfWhatYouWantToDo__1(T.EventName=="Time point 2"));
T.HA_Freq_disable(T.EventName=="Time point 3") = categorical(T.HowOftenDoTheHeadachesGetInTheWayOfWhatYouWantToDo__1(T.EventName=="Time point 3"));
T.HA_Freq_disable(T.pattern=="no headache") = 'Never';
T.HA_Freq_disable = reordercats(T.HA_Freq_disable,{'Never','Less than 1 per week','1 per week','2 to 3 per week','More than 3 per week','Daily','Multiple times a day'});
T.pedmidas = T.TotalPedMIDASScore;
T.pedmidas(isnan(T.pedmidas) & T.EventName=="Time point 3") = 0;

T.quality_throbbing = NaN*ones(height(T),1);
T.quality_throbbing(categorical(T.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__ch)=='Checked'|...
    categorical(T.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__1)=='Checked'|categorical(T.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__10)=='Checked') = 1;
T.quality_throbbing(categorical(T.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__ch)=='Unchecked' &...
    categorical(T.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__1)=='Unchecked' & categorical(T.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__10)=='Unchecked') = 0;
T.quality_throbbing = categorical(T.quality_throbbing,[0 1],{'Unchecked','Checked'});

T.quality_neuralgia = NaN*ones(height(T),1);
T.quality_neuralgia(categorical(T.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__2)=='Checked'|...
    categorical(T.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__6)=='Checked'|categorical(T.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__7)=='Checked' | ...
    categorical(T.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__9)=='Checked') = 1;
T.quality_neuralgia(categorical(T.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__2)=='Unchecked'& ...
    categorical(T.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__6)=='Unchecked' & categorical(T.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__7)=='Unchecked' & ...
    categorical(T.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__9)=='Unchecked') = 0;
T.quality_neuralgia = categorical(T.quality_neuralgia,[0 1],{'Unchecked','Checked'});

T.quality_pressure = NaN*ones(height(T),1);
T.quality_pressure(categorical(T.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__3)=='Checked'|...
    categorical(T.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__4)=='Checked'|categorical(T.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__5)=='Checked' | ...
    categorical(T.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__8)=='Checked') = 1;
T.quality_pressure(categorical(T.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__3)=='Unchecked'& ...
    categorical(T.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__4)=='Unchecked' & categorical(T.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__5)=='Unchecked' & ...
    categorical(T.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__8)=='Unchecked') = 0;
T.quality_pressure = categorical(T.quality_pressure,[0 1],{'Unchecked','Checked'});

T.quality_oth = NaN*ones(height(T),1);
T.quality_oth(categorical(T.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__11)=='Checked'|...
    categorical(T.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__12)=='Checked') = 1;
T.quality_oth(categorical(T.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__11)=='Unchecked'&...
    categorical(T.WhichOfTheFollowingBestDescribesYourHeadacheWhenItIsVeryBad__12)=='Unchecked') = 0;
T.quality_oth = categorical(T.quality_oth,[0 1],{'Unchecked','Checked'});

T.painLoc_front = categorical(T.WhereOnYourHeadDoYouFeelPain__choice_Front_Forehead_);
T.painLoc_top = categorical(T.WhereOnYourHeadDoYouFeelPain__choice_Top_);
T.painLoc_sides = categorical(T.WhereOnYourHeadDoYouFeelPain__choice_Temples_sides_);
T.painLoc_occiput = categorical(T.WhereOnYourHeadDoYouFeelPain__choice_BackOfHead_);
T.painLoc_neck = categorical(T.WhereOnYourHeadDoYouFeelPain__choice_Neck_);
T.painLoc_peri_orbit = categorical(T.WhereOnYourHeadDoYouFeelPain__choice_AroundEyes_);
T.painLoc_retro_orbit = categorical(T.WhereOnYourHeadDoYouFeelPain__choice_BehindTheEyes_);
T.painLoc_holocephalic = categorical(T.WhereOnYourHeadDoYouFeelPain__choice_AllOver_);
T.painLoc_other = categorical(T.WhereOnYourHeadDoYouFeelPain__choice_Other_);
T.painLoc_cantdesc = categorical(T.WhereOnYourHeadDoYouFeelPain__choice_UnableToDescribe_);

T.severity = categorical(T.Overall_HowBadAreTheHeadaches_);
T.severity(T.EventName=="Time point 2") = categorical(T.Overall_HowBadAreTheHeadaches__1(T.EventName=="Time point 2"));
T.severity(T.EventName=="Time point 3") = categorical(T.Overall_HowBadAreTheHeadaches__1(T.EventName=="Time point 3"));

%% Headache triggers
T.trig_none = categorical(T.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Non);
T.trig_menses = categorical(T.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Men);
T.trig_sleepmore = categorical(T.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Too);
T.trig_sleepless = categorical(T.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_T_1);
T.trig_fatigue = categorical(T.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Fat);
T.trig_exercise = categorical(T.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Exe);
T.trig_overheat = categorical(T.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Bec);
T.trig_dehydrate = categorical(T.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Deh);
T.trig_skipmeal = categorical(T.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Ski);
T.trig_foods = categorical(T.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Spe);
T.trig_meds = categorical(T.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Med);
T.trig_chew = categorical(T.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Che);
T.trig_stress = categorical(T.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Str);
T.trig_letdown = categorical(T.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_S_1);
T.trig_screen = categorical(T.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Scr);
T.trig_reading = categorical(T.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Rea);
T.trig_light = categorical(T.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Lig);
T.trig_noise = categorical(T.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Noi);
T.trig_smoking = categorical(T.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Smo);
T.trig_weather = categorical(T.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Wea);
T.trig_hiAlt = categorical(T.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Hig);
T.trig_other = categorical(T.AreThereTriggersThatBringOnHeadachesOrMakeThemWorse__choice_Oth);

%% Headache associated symptoms

T.vis_none = categorical(T.ChangesInVision__choice_None_);
T.vis_spots = categorical(T.ChangesInVision__choice_Spots_);
T.vis_stars = categorical(T.ChangesInVision__choice_Stars_);
T.vis_zigzag = categorical(T.ChangesInVision__choice_ZigzagLines_);
T.vis_blurred = categorical(T.ChangesInVision__choice_BlurredVision_);
T.vis_double = categorical(T.ChangesInVision__choice_DoubleVision_);
T.vis_heatwave = categorical(T.ChangesInVision__choice_HeatWaves_);
T.vis_loss = categorical(T.ChangesInVision__choice_LossOfVision_);
T.vis_cantdesc = categorical(T.ChangesInVision__choice_UnableToDescribe_);

T.uni_none = categorical(T.DoYouExperienceAnyOfTheseSymptomsOnONESIDEOfYourBody__choice_No);
T.uni_weak = categorical(T.DoYouExperienceAnyOfTheseSymptomsOnONESIDEOfYourBody__choice_We);
T.uni_numb = categorical(T.DoYouExperienceAnyOfTheseSymptomsOnONESIDEOfYourBody__choice_Nu);
T.uni_tingle = categorical(T.DoYouExperienceAnyOfTheseSymptomsOnONESIDEOfYourBody__choice_Ti);
T.uni_noserun = categorical(T.DoYouExperienceAnyOfTheseSymptomsOnONESIDEOfYourBody__choice_Ru);
T.uni_eyetear = categorical(T.DoYouExperienceAnyOfTheseSymptomsOnONESIDEOfYourBody__choice_Ey);
T.uni_ptosis = categorical(T.DoYouExperienceAnyOfTheseSymptomsOnONESIDEOfYourBody__choice_Dr);
T.uni_eyered = categorical(T.DoYouExperienceAnyOfTheseSymptomsOnONESIDEOfYourBody__choice_Re);
T.uni_eyepuff = categorical(T.DoYouExperienceAnyOfTheseSymptomsOnONESIDEOfYourBody__choice_Pu);
T.uni_anisocoria = categorical(T.DoYouExperienceAnyOfTheseSymptomsOnONESIDEOfYourBody__choice_On);
T.uni_none = categorical(T.DoYouExperienceAnyOfTheseSymptomsOnONESIDEOfYourBody__choice_No);
T.uni_flush = categorical(T.DoYouExperienceAnyOfTheseSymptomsOnONESIDEOfYourBody__choice_Fo);

T.allodynia = NaN*ones(height(T),1);
T.allodynia(categorical(T.DoAnyOfTheFollowingHurt__choice_None_)=='Checked' | categorical(T.DoAnyOfTheFollowingHurt__choice_None__1)=='Checked') = 0;
T.allodynia(categorical(T.DoAnyOfTheFollowingHurt__choice_WearingYourHairInAPonytail_)=='Checked' | categorical(T.DoAnyOfTheFollowingHurt__choice_WearingYourHairInAPonytail__1)=='Checked') = 1;
T.allodynia(categorical(T.DoAnyOfTheFollowingHurt__choice_CombingOrBrushingYourHair_)=='Checked' | categorical(T.DoAnyOfTheFollowingHurt__choice_CombingOrBrushingYourHair__1)=='Checked') = 1;
T.allodynia(categorical(T.DoAnyOfTheFollowingHurt__choice_WearingAHat_)=='Checked' | categorical(T.DoAnyOfTheFollowingHurt__choice_WearingAHat__1)=='Checked') = 1;
T.allodynia(categorical(T.DoAnyOfTheFollowingHurt__choice_WearingHeadphones_)=='Checked' | categorical(T.DoAnyOfTheFollowingHurt__choice_WearingHeadphones__1)=='Checked') = 1;
T.allodynia = categorical(T.allodynia,[0 1],{'Unchecked','Checked'});

T.othSx_none = categorical(T.OtherSymptoms__choice_None_);
T.othSx_none(T.EventName=="Time point 2") = categorical(T.OtherSymptoms__choice_None__1(T.EventName=="Time point 2"));
T.othSx_none(T.EventName=="Time point 3") = categorical(T.OtherSymptoms__choice_None__1(T.EventName=="Time point 3"));

T.othSx_nausea = categorical(T.OtherSymptoms__choice_Nausea_);
T.othSx_nausea(T.EventName=="Time point 2") = categorical(T.OtherSymptoms__choice_Nausea__1(T.EventName=="Time point 2"));
T.othSx_nausea(T.EventName=="Time point 3") = categorical(T.OtherSymptoms__choice_Nausea__1(T.EventName=="Time point 3"));

T.othSx_vomiting = categorical(T.OtherSymptoms__choice_Vomiting_);
T.othSx_vomiting(T.EventName=="Time point 2") = categorical(T.OtherSymptoms__choice_Vomiting__1(T.EventName=="Time point 2"));
T.othSx_vomiting(T.EventName=="Time point 3") = categorical(T.OtherSymptoms__choice_Vomiting__1(T.EventName=="Time point 3"));

T.othSx_lightsens = categorical(T.OtherSymptoms__choice_SensitivityToLight_);
T.othSx_lightsens(T.EventName=="Time point 2") = categorical(T.OtherSymptoms__choice_SensitivityToLight__1(T.EventName=="Time point 2"));
T.othSx_lightsens(T.EventName=="Time point 3") = categorical(T.OtherSymptoms__choice_SensitivityToLight__1(T.EventName=="Time point 3"));

T.othSx_smellsens = categorical(T.OtherSymptoms__choice_SensitivityToSmells_);
T.othSx_smellsens(T.EventName=="Time point 2") = categorical(T.OtherSymptoms__choice_SensitivityToSmells__1(T.EventName=="Time point 2"));
T.othSx_smellsens(T.EventName=="Time point 3") = categorical(T.OtherSymptoms__choice_SensitivityToSmells__1(T.EventName=="Time point 3"));

T.othSx_soundsens = categorical(T.OtherSymptoms__choice_SensitivityToSounds_);
T.othSx_soundsens(T.EventName=="Time point 2") = categorical(T.OtherSymptoms__choice_SensitivityToSounds__1(T.EventName=="Time point 2"));
T.othSx_soundsens(T.EventName=="Time point 3") = categorical(T.OtherSymptoms__choice_SensitivityToSounds__1(T.EventName=="Time point 3"));

T.othSx_lighthead = categorical(T.OtherSymptoms__choice_Lightheadness_);
T.othSx_lighthead(T.EventName=="Time point 2") = categorical(T.OtherSymptoms__choice_Lightheadness__1(T.EventName=="Time point 2"));
T.othSx_lighthead(T.EventName=="Time point 3") = categorical(T.OtherSymptoms__choice_Lightheadness__1(T.EventName=="Time point 3"));

T.othSx_spinning = categorical(T.OtherSymptoms__choice_SpinningSensation_);
T.othSx_spinning(T.EventName=="Time point 2") = categorical(T.OtherSymptoms__choice_SpinningSensation__1(T.EventName=="Time point 2"));
T.othSx_spinning(T.EventName=="Time point 3") = categorical(T.OtherSymptoms__choice_SpinningSensation__1(T.EventName=="Time point 3"));

T.othSx_balance = categorical(T.OtherSymptoms__choice_BalanceProblems_);
T.othSx_balance(T.EventName=="Time point 2") = categorical(T.OtherSymptoms__choice_BalanceProblems__1(T.EventName=="Time point 2"));
T.othSx_balance(T.EventName=="Time point 3") = categorical(T.OtherSymptoms__choice_BalanceProblems__1(T.EventName=="Time point 3"));

T.othSx_hearing = categorical(T.OtherSymptoms__choice_TroubleHearing_);
T.othSx_hearing(T.EventName=="Time point 2") = categorical(T.OtherSymptoms__choice_TroubleHearing__1(T.EventName=="Time point 2"));
T.othSx_hearing(T.EventName=="Time point 3") = categorical(T.OtherSymptoms__choice_TroubleHearing__1(T.EventName=="Time point 3"));

T.othSx_ringing = categorical(T.OtherSymptoms__choice_RingingInEar_);
T.othSx_ringing(T.EventName=="Time point 2") = categorical(T.OtherSymptoms__choice_RingingInEar__1(T.EventName=="Time point 2"));
T.othSx_ringing(T.EventName=="Time point 3") = categorical(T.OtherSymptoms__choice_RingingInEar__1(T.EventName=="Time point 3"));

T.othSx_unresponsive = categorical(T.OtherSymptoms__choice_Unresponsive_);
T.othSx_unresponsive(T.EventName=="Time point 2") = categorical(T.OtherSymptoms__choice_Unresponsive__1(T.EventName=="Time point 2"));
T.othSx_unresponsive(T.EventName=="Time point 3") = categorical(T.OtherSymptoms__choice_Unresponsive__1(T.EventName=="Time point 3"));

T.othSx_neckpain = categorical(T.OtherSymptoms__choice_NeckPainOrStiffness_);
T.othSx_neckpain(T.EventName=="Time point 2") = categorical(T.OtherSymptoms__choice_NeckPainOrStiffness__1(T.EventName=="Time point 2"));
T.othSx_neckpain(T.EventName=="Time point 3") = categorical(T.OtherSymptoms__choice_NeckPainOrStiffness__1(T.EventName=="Time point 3"));

T.othSx_thinking = categorical(T.OtherSymptoms__choice_TroubleThinking_);
T.othSx_thinking(T.EventName=="Time point 2") = categorical(T.OtherSymptoms__choice_TroubleThinking__1(T.EventName=="Time point 2"));
T.othSx_thinking(T.EventName=="Time point 3") = categorical(T.OtherSymptoms__choice_TroubleThinking__1(T.EventName=="Time point 3"));

T.othSx_talking = categorical(T.OtherSymptoms__choice_TroubleTalking_);
T.othSx_talking(T.EventName=="Time point 2") = categorical(T.OtherSymptoms__choice_TroubleTalking__1(T.EventName=="Time point 2"));
T.othSx_talking(T.EventName=="Time point 3") = categorical(T.OtherSymptoms__choice_TroubleTalking__1(T.EventName=="Time point 3"));

T.DaysPostInjury = T.TimeFromInjuryToVisit;

%% Headache medications
T = convertvars(T,["MedicationsToSTOPHeadaches_choice_None_","MedicationsToSTOPHeadaches_choice_Acetaminophen_Tylenol__","MedicationsToSTOPHeadaches_choice_Ibuprofen_Motrin_Advil__",...
    "MedicationsToSTOPHeadaches_choice_Naproxen_Aleve_Naprosyn__","MedicationsToSTOPHeadaches_choice_Aspirin_","MedicationsToSTOPHeadaches_choice_Ketorolac_Toradol_Sprix__",...
    "MedicationsToSTOPHeadaches_choice_Ketoprofen_Relafen__","MedicationsToSTOPHeadaches_choice_Diclofenac_Voltaren__","MedicationsToSTOPHeadaches_choice_Celecoxib_Celebrex__",...
    "MedicationsToSTOPHeadaches_choice_Excedrin_ExcedrinMigraine_Exc","MedicationsToSTOPHeadaches_choice_Butalbital_Fioricet_Fiorinal_","MedicationsToSTOPHeadaches_choice_Midrin_",...
    "MedicationsToSTOPHeadaches_choice_Methylprednisolone_MedrolPack","MedicationsToSTOPHeadaches_choice_Prednisone_Prednisolone_","MedicationsToSTOPHeadaches_choice_Sumatriptan_Imitrex_Treximet_",...
    "MedicationsToSTOPHeadaches_choice_Rizatriptan_Maxalt__","MedicationsToSTOPHeadaches_choice_Naratriptan_Amerge__","MedicationsToSTOPHeadaches_choice_Almotriptan_Axert__",...
    "MedicationsToSTOPHeadaches_choice_Frovatriptan_Frova__","MedicationsToSTOPHeadaches_choice_Eletriptan_Relpax__","MedicationsToSTOPHeadaches_choice_Zolmitriptan_Zomig__",...
    "MedicationsToSTOPHeadaches_choice_Metoclopramide_Reglan__","MedicationsToSTOPHeadaches_choice_Prochlorperazine_Compazine__","MedicationsToSTOPHeadaches_choice_Promethazine_Phenergan__",...
    "MedicationsToSTOPHeadaches_choice_Ondansetron_Zofran__","MedicationsToSTOPHeadaches_choice_Diphenhydramine_Benadryl__","MedicationsToSTOPHeadaches_choice_DHE_Migranal__",...
    "MedicationsToSTOPHeadaches_choice_Tramadol_Ultram_Ultracet__","MedicationsToSTOPHeadaches_choice_Tylenol_3_TylenolWithCodeine_","MedicationsToSTOPHeadaches_choice_Morphine_",...
    "MedicationsToSTOPHeadaches_choice_Hydromorphone_Dilaudid__","MedicationsToSTOPHeadaches_choice_NerveBlockOrTriggerPointInjec","MedicationsToSTOPHeadaches_choice_Other_",...
    "MedicationsToSTOPHeadaches_choice_None__1","MedicationsToSTOPHeadaches_choice_Acetaminophen_Tylenol___1","MedicationsToSTOPHeadaches_choice_Ibuprofen_Motrin_Advil___1",...
    "MedicationsToSTOPHeadaches_choice_Naproxen_Aleve_Naprosyn___1","MedicationsToSTOPHeadaches_choice_Aspirin__1","MedicationsToSTOPHeadaches_choice_Ketorolac_Toradol_Sprix___1",...
    "MedicationsToSTOPHeadaches_choice_Ketoprofen_Relafen___1","MedicationsToSTOPHeadaches_choice_Diclofenac_Voltaren___1","MedicationsToSTOPHeadaches_choice_Celecoxib_Celebrex___1",...
    "MedicationsToSTOPHeadaches_choice_Excedrin_ExcedrinMigraine_E_1","MedicationsToSTOPHeadaches_choice_Butalbital_Fioricet_Fiorina_1","MedicationsToSTOPHeadaches_choice_Midrin__1",...
    "MedicationsToSTOPHeadaches_choice_Methylprednisolone_MedrolPa_1","MedicationsToSTOPHeadaches_choice_Prednisone_Prednisolone__1","MedicationsToSTOPHeadaches_choice_Sumatriptan_Imitrex_Trexime_1",...
    "MedicationsToSTOPHeadaches_choice_Rizatriptan_Maxalt___1","MedicationsToSTOPHeadaches_choice_Naratriptan_Amerge___1","MedicationsToSTOPHeadaches_choice_Almotriptan_Axert___1",...
    "MedicationsToSTOPHeadaches_choice_Frovatriptan_Frova___1","MedicationsToSTOPHeadaches_choice_Eletriptan_Relpax___1","MedicationsToSTOPHeadaches_choice_Zolmitriptan_Zomig___1",...
    "MedicationsToSTOPHeadaches_choice_Metoclopramide_Reglan___1","MedicationsToSTOPHeadaches_choice_Prochlorperazine_Compazine__1","MedicationsToSTOPHeadaches_choice_Promethazine_Phenergan___1",...
    "MedicationsToSTOPHeadaches_choice_Ondansetron_Zofran___1","MedicationsToSTOPHeadaches_choice_Diphenhydramine_Benadryl___1","MedicationsToSTOPHeadaches_choice_DHE_Migranal___1","MedicationsToSTOPHeadaches_choice_Tramadol_Ultram_Ultracet___1",...
    "MedicationsToSTOPHeadaches_choice_Tylenol_3_TylenolWithCodein_1","MedicationsToSTOPHeadaches_choice_Morphine__1","MedicationsToSTOPHeadaches_choice_Hydromorphone_Dilaudid___1",...
    "MedicationsToSTOPHeadaches_choice_NerveBlockOrTriggerPointInj_1","MedicationsToSTOPHeadaches_choice_Other__1"],@categorical);


T.acute_simpAn = zeros(height(T),1);
T.acute_simpAn(T.MedicationsToSTOPHeadaches_choice_Acetaminophen_Tylenol__=='Checked'|T.MedicationsToSTOPHeadaches_choice_Ibuprofen_Motrin_Advil__=='Checked'|T.MedicationsToSTOPHeadaches_choice_Naproxen_Aleve_Naprosyn__=='Checked'|...
    T.MedicationsToSTOPHeadaches_choice_Aspirin_=='Checked'|T.MedicationsToSTOPHeadaches_choice_Ketorolac_Toradol_Sprix__=='Checked'|...
    T.MedicationsToSTOPHeadaches_choice_Ketoprofen_Relafen__=='Checked'|T.MedicationsToSTOPHeadaches_choice_Diclofenac_Voltaren__=='Checked'|T.MedicationsToSTOPHeadaches_choice_Celecoxib_Celebrex__=='Checked'|...
    T.MedicationsToSTOPHeadaches_choice_Excedrin_ExcedrinMigraine_Exc=='Checked'|T.MedicationsToSTOPHeadaches_choice_Acetaminophen_Tylenol___1=='Checked'|T.MedicationsToSTOPHeadaches_choice_Ibuprofen_Motrin_Advil___1=='Checked'|...
    T.MedicationsToSTOPHeadaches_choice_Naproxen_Aleve_Naprosyn___1=='Checked'|T.MedicationsToSTOPHeadaches_choice_Aspirin__1=='Checked'|T.MedicationsToSTOPHeadaches_choice_Ketorolac_Toradol_Sprix___1=='Checked'|...
    T.MedicationsToSTOPHeadaches_choice_Ketoprofen_Relafen___1=='Checked'|T.MedicationsToSTOPHeadaches_choice_Diclofenac_Voltaren___1=='Checked'|T.MedicationsToSTOPHeadaches_choice_Celecoxib_Celebrex___1=='Checked'|...
    T.MedicationsToSTOPHeadaches_choice_Excedrin_ExcedrinMigraine_E_1=='Checked') = 1;
T.acute_simpAn = categorical(T.acute_simpAn,[0 1],{'Unchecked','Checked'});

T.acute_triptan = zeros(height(T),1);
T.acute_triptan(T.MedicationsToSTOPHeadaches_choice_Sumatriptan_Imitrex_Treximet_=='Checked'|T.MedicationsToSTOPHeadaches_choice_Rizatriptan_Maxalt__=='Checked'|T.MedicationsToSTOPHeadaches_choice_Naratriptan_Amerge__=='Checked'|...
    T.MedicationsToSTOPHeadaches_choice_Almotriptan_Axert__=='Checked'|T.MedicationsToSTOPHeadaches_choice_Frovatriptan_Frova__=='Checked'|T.MedicationsToSTOPHeadaches_choice_Eletriptan_Relpax__=='Checked'| ...
    T.MedicationsToSTOPHeadaches_choice_Zolmitriptan_Zomig__=='Checked'|T.MedicationsToSTOPHeadaches_choice_Sumatriptan_Imitrex_Trexime_1=='Checked'|T.MedicationsToSTOPHeadaches_choice_Rizatriptan_Maxalt___1=='Checked'|...
    T.MedicationsToSTOPHeadaches_choice_Naratriptan_Amerge___1=='Checked'|T.MedicationsToSTOPHeadaches_choice_Almotriptan_Axert___1=='Checked'|T.MedicationsToSTOPHeadaches_choice_Frovatriptan_Frova___1=='Checked'| ...
    T.MedicationsToSTOPHeadaches_choice_Eletriptan_Relpax___1=='Checked'|T.MedicationsToSTOPHeadaches_choice_Zolmitriptan_Zomig___1=='Checked') = 1;
T.acute_triptan = categorical(T.acute_triptan,[0 1],{'Unchecked','Checked'});

T.acute_steroid = zeros(height(T),1);
T.acute_steroid(T.MedicationsToSTOPHeadaches_choice_Methylprednisolone_MedrolPack=='Checked'|T.MedicationsToSTOPHeadaches_choice_Prednisone_Prednisolone_=='Checked'|...
    T.MedicationsToSTOPHeadaches_choice_Methylprednisolone_MedrolPa_1=='Checked'|T.MedicationsToSTOPHeadaches_choice_Prednisone_Prednisolone__1=='Checked') = 1;
T.acute_steroid = categorical(T.acute_steroid,[0 1],{'Unchecked','Checked'});

T.acute_antiemetic = zeros(height(T),1);
T.acute_antiemetic(T.MedicationsToSTOPHeadaches_choice_Metoclopramide_Reglan__=='Checked'|T.MedicationsToSTOPHeadaches_choice_Prochlorperazine_Compazine__=='Checked'|T.MedicationsToSTOPHeadaches_choice_Ondansetron_Zofran__=='Checked'|...
    T.MedicationsToSTOPHeadaches_choice_Promethazine_Phenergan__=='Checked'|T.MedicationsToSTOPHeadaches_choice_Metoclopramide_Reglan___1=='Checked'|T.MedicationsToSTOPHeadaches_choice_Prochlorperazine_Compazine__1=='Checked'|...
    T.MedicationsToSTOPHeadaches_choice_Promethazine_Phenergan___1=='Checked'|T.MedicationsToSTOPHeadaches_choice_Ondansetron_Zofran___1=='Checked') = 1;
T.acute_antiemetic = categorical(T.acute_antiemetic,[0 1],{'Unchecked','Checked'});

T.acute_freq = categorical(T.HowOftenDoYouTakeAMedicationToStopAHeadache_);
T.acute_freq(T.EventName=="Time point 2") = categorical(T.HowOftenDoYouTakeAMedicationToStopAHeadache__1(T.EventName=="Time point 2"));
T.acute_freq(T.EventName=="Time point 3") = categorical(T.HowOftenDoYouTakeAMedicationToStopAHeadache__1(T.EventName=="Time point 3"));

T.acute_HiFreqDur = categorical(T.ForHowLongHaveYouBeenTakingAnAcuteMedicineMoreThan3DaysPerWeek_);
T.acute_HiFreqDur(T.EventName=="Time point 2") = categorical(T.HowOftenDoYouTakeAMedicationToStopAHeadache__1(T.EventName=="Time point 2"));
T.acute_HiFreqDur(T.EventName=="Time point 3") = categorical(T.HowOftenDoYouTakeAMedicationToStopAHeadache__1(T.EventName=="Time point 3"));

T = convertvars(T,["CGRPBlockingAgents_choice_None_","Beta_blockers_choice_None_","PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSever",...
    "VitaminsAndSupplements_choice_None_"],@categorical);


T.preventive = zeros(height(T),1);
T.preventive(T.CGRPBlockingAgents_choice_None_=='Unchecked'|T.Beta_blockers_choice_None_=='Unchecked'|T.PrescribedTreatmentsToPREVENTHeadachesOrMakeTheFrequencyOrSever=='Unchecked') = 1;
T.preventive = categorical(T.preventive,[0 1],{'Unchecked','Checked'});

T.supplement = zeros(height(T),1);
T.supplement(T.VitaminsAndSupplements_choice_None_=='Unchecked') = 1;
T.supplement = categorical(T.supplement,[0 1],{'Unchecked','Checked'});

%% Concussion measures
T.noChange = categorical(T.HowHaveHeadachesChanged_selectAllThatApply___choice_noChange_);

% add age at time of injury, sex, and pre-injury scores to Timepoints 2 and 3
for x = 1:height(T)
    if any(T.EventName == "Time point 2" | T.EventName == "Time point 3")
        T.Sex(x) = T.Sex(T.EventName=="Time point 1" & T.RecordID_==T.RecordID_(x));
        T.DateOfInjury(x) = T.DateOfInjury(T.EventName=="Time point 1" & T.RecordID_==T.RecordID_(x));
        T.AgeAtTimeOfInjury(x) = T.AgeAtTimeOfInjury(T.EventName=="Time point 1" & T.RecordID_==T.RecordID_(x));
        
        T.noChange(x) = T.noChange(T.EventName=="Time point 1" & T.RecordID_==T.RecordID_(x)); % Asked only if there was a change in headache after concussion at first visit

        T.Headache_2(x) = T.Headache_2(T.EventName=="Time point 1" & T.RecordID_==T.RecordID_(x));
        T.Nausea_2(x) = T.Nausea_2(T.EventName=="Time point 1" & T.RecordID_==T.RecordID_(x));
        T.BalanceProblems_2(x) = T.BalanceProblems_2(T.EventName=="Time point 1" & T.RecordID_==T.RecordID_(x));
        T.Dizziness_2(x) = T.Dizziness_2(T.EventName=="Time point 1" & T.RecordID_==T.RecordID_(x));
        T.Fatigue_2(x) = T.Fatigue_2(T.EventName=="Time point 1" & T.RecordID_==T.RecordID_(x));
        T.SleepMoreThanUsual_2(x) = T.SleepMoreThanUsual_2(T.EventName=="Time point 1" & T.RecordID_==T.RecordID_(x));
        T.Drowsiness_2(x) = T.Drowsiness_2(T.EventName=="Time point 1" & T.RecordID_==T.RecordID_(x));
        T.SensitivityToLight_2(x) = T.SensitivityToLight_2(T.EventName=="Time point 1" & T.RecordID_==T.RecordID_(x));
        T.SensitivityToNoise_2(x) = T.SensitivityToNoise_2(T.EventName=="Time point 1" & T.RecordID_==T.RecordID_(x));
        T.Irritability_2(x) = T.Irritability_2(T.EventName=="Time point 1" & T.RecordID_==T.RecordID_(x));
        T.Sadness_2(x) = T.Sadness_2(T.EventName=="Time point 1" & T.RecordID_==T.RecordID_(x));
        T.Nervousness_2(x) = T.Nervousness_2(T.EventName=="Time point 1" & T.RecordID_==T.RecordID_(x));
        T.FeelingMoreEmotional_2(x) = T.FeelingMoreEmotional_2(T.EventName=="Time point 1" & T.RecordID_==T.RecordID_(x));
        T.FeelingSlowedDown_2(x) = T.FeelingSlowedDown_2(T.EventName=="Time point 1" & T.RecordID_==T.RecordID_(x));
        T.FeelingMentally_foggy__2(x) = T.FeelingMentally_foggy__2(T.EventName=="Time point 1" & T.RecordID_==T.RecordID_(x));
        T.DifficultyConcentrating_2(x) = T.DifficultyConcentrating_2(T.EventName=="Time point 1" & T.RecordID_==T.RecordID_(x));
        T.DifficultyRemembering_2(x) = T.DifficultyRemembering_2(T.EventName=="Time point 1" & T.RecordID_==T.RecordID_(x));
        T.VisualProblems_doubleVision_Blurring__2(x) = T.VisualProblems_doubleVision_Blurring__2(T.EventName=="Time point 1" & T.RecordID_==T.RecordID_(x));
        T.GetConfusedWithDirectionsOrTasks_2(x) = T.GetConfusedWithDirectionsOrTasks_2(T.EventName=="Time point 1" & T.RecordID_==T.RecordID_(x));
        T.MoveInAClumsyManner_2(x) = T.MoveInAClumsyManner_2(T.EventName=="Time point 1" & T.RecordID_==T.RecordID_(x));
        T.AnswerQuestionsMoreSlowlyThanUsual_2(x) = T.AnswerQuestionsMoreSlowlyThanUsual_2(T.EventName=="Time point 1" & T.RecordID_==T.RecordID_(x));
        T.PCSIPre_InjuryTotalSymptomScore(x) = T.PCSIPre_InjuryTotalSymptomScore(T.EventName=="Time point 1" & T.RecordID_==T.RecordID_(x));
    end
end

% Change in PCSI; Calculate differences between PCSI scores, pre-injury
% scores are denoted with "_2"
T.headache_diff = diff([T.Headache_2 T.Headache],1,2);
T.nausea_diff = diff([T.Nausea_2 T.Nausea],1,2);
T.balance_diff = diff([T.BalanceProblems_2 T.BalanceProblems],1,2);
T.dizziness_diff = diff([T.Dizziness_2 T.Dizziness],1,2);
T.fatigue_diff = diff([T.Fatigue_2 T.Fatigue],1,2);
T.sleepmore_diff = diff([T.SleepMoreThanUsual_2 T.SleepMoreThanUsual],1,2);
T.drowsiness_diff = diff([T.Drowsiness_2 T.Drowsiness],1,2);
T.lightsens_diff = diff([T.SensitivityToLight_2 T.SensitivityToLight],1,2);
T.soundsens_diff = diff([T.SensitivityToNoise_2 T.SensitivityToNoise],1,2);
T.irrit_diff = diff([T.Irritability_2 T.Irritability],1,2);
T.sadness_diff = diff([T.Sadness_2 T.Sadness],1,2);
T.nervous_diff = diff([T.Nervousness_2 T.Nervousness],1,2);
T.emotional_diff = diff([T.FeelingMoreEmotional_2 T.FeelingMoreEmotional],1,2);
T.slowed_diff = diff([T.FeelingSlowedDown_2 T.FeelingSlowedDown],1,2);
T.foggy_diff = diff([T.FeelingMentally_foggy__2 T.FeelingMentally_foggy_],1,2);
T.concentrate_diff = diff([T.DifficultyConcentrating_2 T.DifficultyConcentrating],1,2);
T.remember_diff = diff([T.DifficultyRemembering_2 T.DifficultyRemembering],1,2);
T.visualprob_diff = diff([T.VisualProblems_doubleVision_Blurring__2 T.VisualProblems_doubleVision_Blurring_],1,2);
T.confused_diff = diff([T.GetConfusedWithDirectionsOrTasks_2 T.GetConfusedWithDirectionsOrTasks],1,2);
T.clumsy_diff = diff([T.MoveInAClumsyManner_2 T.MoveInAClumsyManner],1,2);
T.ansslow_diff = diff([T.AnswerQuestionsMoreSlowlyThanUsual_2 T.AnswerQuestionsMoreSlowlyThanUsual],1,2);
T.total_diff = diff([T.PCSIPre_InjuryTotalSymptomScore T.PCSICurrent_Teen_TotalSymptomScore],1,2);

% VVE
T.NPC = T.ConvergenceBreak_double_;
T.repsHorGaze = T.x_OfRepsOfHorizontalGazeStability;
T.repsVertGaze = T.x_OfRepsOfVerticalGazeStability;
T.repsHorSac = T.x_OfRepsOfHorizontalSaccades;
T.repsVertSac = T.x_OfRepsOfVerticalSaccades;
T.ExerciseReturn = T.HasThePatientReturnedToExerciseSinceTheInjury_;

T.FinalConcVt = T.WasItThePatient_sFinalVisitToClinic_;


%% Construct simplified table
Tshort = T(:,["RecordID_","EventName","Sex","DateOfInjury","AgeAtTimeOfInjury","DaysPostInjury","Height","Weight","BMI","pattern","HA_Freq","HA_Freq_disable",...
    "PCSIPre_InjuryTotalSymptomScore","PCSICurrent_Teen_TotalSymptomScore","total_diff","NPC","repsHorGaze","repsVertGaze","repsHorSac","repsVertSac","FinalConcVt",...
    "acute_simpAn","preventive","supplement"]);
% Transpose the notesText for ease of subsequent display
notesText=notesText';

end % function