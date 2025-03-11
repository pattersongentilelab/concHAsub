function [diagnosisTable] = poemAnalysis_classify_redcap2(T)
%
% This function takes the table variable "T" and performs a decision tree
% analysis to classify each subject into headache categories.

numSubjects = size(T,1);

% Make diagnostic table for headache type, all questions set to false
variables = {'ID','HeadacheEver','HeadacheSpont','ICHD_MigA','ICHD_MigB','ICHD_MigCloc',...
    'ICHD_MigCpuls','ICHD_MigCsev','ICHD_MigCact','ICHD_MigC','ICHD_MigDphotophono',...
    'ICHD_MigDnaus','probMig','Migraine','VisualSx','probVisualAura','defVisualAura','activeVisualAura','SensorySx',...
    'probSensoryAura','defSensoryAura','activeSensoryAura','SpeechSx','probSpeechAura','defSpeechAura',...
    'activeSpeechAura','FamHx','MotionSick','Choi_score','VD_score','lightSens_noHA'};
varTypes = {'categorical','logical','logical','logical','logical','logical','logical','logical','logical','double',...
    'logical','logical','logical','logical','logical','logical','logical','logical','logical','logical','logical','logical',...
    'logical','logical','logical','logical','logical','logical','double','double','logical'}';
Dx = table('Size',[numSubjects length(variables)],'VariableNames',variables,'VariableTypes',varTypes);

% assign IDs
Dx.ID = categorical(T.RecordID_);
 
% Determine if they ever get headaches
Dx.HeadacheEver(T.DoYouGetHeadaches_=='Yes') = 1;
Dx.HeadacheEver(T.HaveYouEverHadAHeadache_=='Yes') = 1;
Dx.HeadacheEver(T.HaveYouEverHadEpisodesOfDiscomfort_Pressure_OrPainAroundYourEye=='Yes') = 1;

% Determine if they get headaches outside of illness or head injury
Dx.HeadacheSpont(T.HaveYouEverHadAHeadacheThatWasNOTCausedByAHeadInjuryOrIllnessLi=='Yes') = 1;
Dx.HeadacheSpont(T.DoYouGetHeadachesThatAreNOTCausedByAHeadInjuryOrIllnessLikeTheC=='Yes') = 1;

%Family history of migraine
Dx.FamHx(T.DoYourParents_Brothers_OrSistersGetMigraines_=='Yes') = 1;

% History of motion sickness
Dx.MotionSick(T.DoYouGetMotionSick_e_g_CarSick_NowOrWhenYouWereYounger_=='Yes') = 1;

%% Migraine diagnosis

% ICHD Migraine criteria A, at least 5 migraine attacks
Dx.ICHD_MigA(T.HaveYouHadThisHeadache5OrMoreTimesInYourLife_=='Yes') = 1;

% ICHD Migraine criteria B, >2 hours (peds)
Dx.ICHD_MigB(T.DoYourHeadachesEverLastMoreThanTwoHours_=='Yes') = 1;

% ICHD Migraine criteria C
Dx.ICHD_MigCloc(T.DoHeadachesThatLastMoreThanTwoHoursHaveAnyOfTheFollowing_Please=='Checked') = 1;
Dx.ICHD_MigCpuls(T.DoHeadachesThatLastMoreThanTwoHoursHaveAnyOfTheFollowing_Plea_1=='Checked') = 1;
Dx.ICHD_MigCsev(T.DoHeadachesThatLastMoreThanTwoHoursHaveAnyOfTheFollowing_Plea_2=='Checked') = 1;
Dx.ICHD_MigCact(T.DoHeadachesThatLastMoreThanTwoHoursHaveAnyOfTheFollowing_Plea_3=='Checked') = 1;

% ICHD Migraine criteria D
Dx.ICHD_MigDphotophono(T.DoHeadachesThatLastMoreThanTwoHoursHaveAnyOfTheFollowing_Plea_6=='Checked' & T.DoHeadachesThatLastMoreThanTwoHoursHaveAnyOfTheFollowing_Plea_7=='Checked') = 1;
Dx.ICHD_MigDnaus(T.DoHeadachesThatLastMoreThanTwoHoursHaveAnyOfTheFollowing_Plea_5=='Checked') = 1;

MigC = sum(double([Dx.ICHD_MigCloc Dx.ICHD_MigCpuls Dx.ICHD_MigCsev Dx.ICHD_MigCact]),2);

Dx.Migraine(Dx.ICHD_MigA==1 & Dx.ICHD_MigB==1 & MigC>=2 & (Dx.ICHD_MigDphotophono==1 | Dx.ICHD_MigDnaus==1)) = 1;

Dx.probMig(Dx.ICHD_MigA==1 & Dx.ICHD_MigB==1 & MigC>=2 & Dx.ICHD_MigDnaus~=1 & (T.DoHeadachesThatLastMoreThanTwoHoursHaveAnyOfTheFollowing_Plea_6=='Checked' | T.DoHeadachesThatLastMoreThanTwoHoursHaveAnyOfTheFollowing_Plea_7=='Checked')) = 1;
Dx.probMig(Dx.ICHD_MigA==0 & Dx.ICHD_MigB==1 & MigC>=2 & (Dx.ICHD_MigDphotophono==1 | Dx.ICHD_MigDnaus==1)) = 1;
Dx.probMig(Dx.ICHD_MigA==1 & Dx.ICHD_MigB==0 & MigC>=2 & (Dx.ICHD_MigDphotophono==1 | Dx.ICHD_MigDnaus==1)) = 1;
Dx.probMig(Dx.ICHD_MigA==1 & Dx.ICHD_MigB==1 & MigC<2 & (Dx.ICHD_MigDphotophono==1 | Dx.ICHD_MigDnaus==1)) = 1;

Dx.probMig(Dx.Migraine==1) = 0;

%% Aura diagnosis

% ICHD visual aura
Dx.VisualSx(T.AroundTheTimeOfYourHeadaches_HaveYouEverSeenAnyOfTheFollowing_P=='Checked' | T.AroundTheTimeOfYourHeadaches_HaveYouEverSeenAnyOfTheFollowing_1=='Checked' |...
    T.AroundTheTimeOfYourHeadaches_HaveYouEverSeenAnyOfTheFollowing_2=='Checked' | T.AroundTheTimeOfYourHeadaches_HaveYouEverSeenAnyOfTheFollowing_3=='Checked' |...
    T.AroundTheTimeOfYourHeadaches_HaveYouEverSeenAnyOfTheFollowing_4=='Checked' | T.AroundTheTimeOfYourHeadaches_HaveYouEverSeenAnyOfTheFollowing_5=='Checked' |...
    T.AroundTheTimeOfYourHeadaches_HaveYouEverSeenAnyOfTheFollowing_6=='Checked') = 1;
Dx.probVisualAura(T.HaveYouHadTheseVisionChangesWithYourHeadDiscomfortTwoOrMoreTime=='Yes' & Dx.VisualSx==1 & T.HowLongDoTheseVisionChangesUsuallyLast_=='5 minutes to 1 hour' & ...
    (T.AreTheVisionChangesOnlyOneOneSide_=='No' | T.DoTheVisionChangesSpreadOrMoveAcrossYourVision_=='No')) = 1;
Dx.defVisualAura(T.HaveYouHadTheseVisionChangesWithYourHeadDiscomfortTwoOrMoreTime=='Yes' & Dx.VisualSx==1 & T.HowLongDoTheseVisionChangesUsuallyLast_=='5 minutes to 1 hour' & ...
    T.AreTheVisionChangesOnlyOneOneSide_=='Yes' & T.DoTheVisionChangesSpreadOrMoveAcrossYourVision_=='Yes') = 1;

Dx.activeVisualAura(T.WhenWasTheLastTimeYouHadTheseVisionChanges_=='Within the past week' | T.WhenWasTheLastTimeYouHadTheseVisionChanges_=='Within the past month' |...
    T.WhenWasTheLastTimeYouHadTheseVisionChanges_=='Within the past year') = 1;

% ICHD sensory aura
Dx.SensorySx(T.HaveYouEverHadAnyOfTheFollowingHappenAroundTheTimeOfYourHeadach=='Checked' | T.HaveYouEverHadAnyOfTheFollowingHappenAroundTheTimeOfYourHeada_1 == 'Checked') = 1;
Dx.probSensoryAura(T.IsTheNumbnessAnd_orTinglingOnlyOnOneSideOfYourBody_=='Yes' & T.HowLongDoesTheNumbnessAnd_orTinglingUsuallyLast_=='5 minutes to 1 hour' & T.HaveYouHadThisNumbnessAnd_orTinglingWithYourHeadachesTwoOrMoreT=='Yes' &...
    T.DoesTheNumbnessAnd_orTinglingStartInOneSpot_AndThenSpreadOrMove~='Yes' & (T.WhenDoYouHaveThisNumbnessAnd_orTingling_PleaseMarkAllThatApply_=='Checked' | T.WhenDoYouHaveThisNumbnessAnd_orTingling_PleaseMarkAllThatAppl_1 =='Checked')) = 1;
Dx.defSensoryAura(T.IsTheNumbnessAnd_orTinglingOnlyOnOneSideOfYourBody_=='Yes' & T.HowLongDoesTheNumbnessAnd_orTinglingUsuallyLast_=='5 minutes to 1 hour' &...
    T.DoesTheNumbnessAnd_orTinglingStartInOneSpot_AndThenSpreadOrMove=='Yes' & (T.WhenDoYouHaveThisNumbnessAnd_orTingling_PleaseMarkAllThatApply_=='Checked' | T.WhenDoYouHaveThisNumbnessAnd_orTingling_PleaseMarkAllThatAppl_1 =='Checked') & ...
    T.HaveYouHadThisNumbnessAnd_orTinglingWithYourHeadachesTwoOrMoreT=='Yes') = 1;

Dx.activeSensoryAura(T.WhenWasTheLastTimeYouHadThisNumbnessAnd_orTingling_=='Within the past week' | T.WhenWasTheLastTimeYouHadThisNumbnessAnd_orTingling_=='Within the past month' |...
    T.WhenWasTheLastTimeYouHadThisNumbnessAnd_orTingling_=='Within the past year' & (Dx.probSensoryAura==1 | Dx.defSensoryAura==1)) = 1;

% ICHD speech aura
Dx.SpeechSx(T.HaveYouEverHadAnyOfTheFollowingHappenAroundTheTimeOfYourHeada_4=='Checked' | T.HaveYouEverHadAnyOfTheFollowingHappenAroundTheTimeOfYourHeada_5=='Checked'|...
    T.HaveYouEverHadAnyOfTheFollowingHappenAroundTheTimeOfYourHeada_6=='Checked') = 1;
Dx.probSpeechAura((T.HaveYouEverHadAnyOfTheFollowingHappenAroundTheTimeOfYourHeada_4=='Checked' | T.HaveYouEverHadAnyOfTheFollowingHappenAroundTheTimeOfYourHeada_6=='Checked') &...
    T.HaveYouHadDifficultySpeakingWithYourHeadachesTwoOrMoreTimesInYo=='Yes' & T.HowLongDoesTheDifficultySpeakingUsuallyLast_=='5 minutes to 1 hour' & ...
    (T.WhenDoYouHaveDifficultySpeaking_PleaseMarkAllThatApply__choice_=='Checked' | T.WhenDoYouHaveDifficultySpeaking_PleaseMarkAllThatApply__choic_1=='Checked')) = 1;
Dx.defSpeechAura((T.HaveYouEverHadAnyOfTheFollowingHappenAroundTheTimeOfYourHeada_4=='Checked' | T.HaveYouEverHadAnyOfTheFollowingHappenAroundTheTimeOfYourHeada_6=='Checked') &...
     T.HaveYouEverHadAnyOfTheFollowingHappenAroundTheTimeOfYourHeada_6=='Unchecked' & T.HaveYouHadDifficultySpeakingWithYourHeadachesTwoOrMoreTimesInYo=='Yes' & ...
     T.HowLongDoesTheDifficultySpeakingUsuallyLast_=='5 minutes to 1 hour' & (T.WhenDoYouHaveDifficultySpeaking_PleaseMarkAllThatApply__choice_=='Checked' | ...
     T.WhenDoYouHaveDifficultySpeaking_PleaseMarkAllThatApply__choic_1=='Checked')) = 1;

Dx.activeSpeechAura(T.WhenWasTheLastTimeYouHadDifficultySpeaking_=='Within the past week' | T.WhenWasTheLastTimeYouHadDifficultySpeaking_=='Within the past month' |...
    T.WhenWasTheLastTimeYouHadDifficultySpeaking_=='Within the past year' & (Dx.probSpeechAura==1 | Dx.defSpeechAura==1)) = 1;

%% Headache Diagnosis
Dx.HAdx = zeros(height(Dx),1);
Dx.HAdx(Dx.HeadacheSpont==1) = 1;
Dx.HAdx(Dx.probMig==1 & Dx.defVisualAura==0 & Dx.defSensoryAura==0 & Dx.defSpeechAura==0) = 2;
Dx.HAdx(Dx.probMig==1 & (Dx.defVisualAura==1|Dx.defSensoryAura==1|Dx.defSpeechAura==1)) = 3;
Dx.HAdx(Dx.Migraine==1 & Dx.defVisualAura==0 & Dx.defSensoryAura==0 & Dx.defSpeechAura==0) = 4;
Dx.HAdx(Dx.defVisualAura==1|Dx.defSensoryAura==1|Dx.defSpeechAura==1) = 5;
Dx.HAdx = categorical(Dx.HAdx,[0 1 2 3 4 5],{'no headache','non-migraine headache','probable migraine without aura','probable migraine with aura','migraine without aura','migraine with aura'});
Dx.HAdxSimp = mergecats(Dx.HAdx,{'migraine without aura','migraine with aura','probable migraine without aura','probable migraine with aura'});
Dx.HAdxSimp = renamecats(Dx.HAdxSimp,{'migraine without aura'},{'migraine/probable migraine'});

%% Calculate Choi visual discomfort score
Choi = [T.DuringYourHeadache_DoYouFeelAGreaterSenseOfGlareOrDazzleInYourE T.DuringYourHeadache_DoFlickeringLights_Glare_SpecificColors_OrHi...
    T.DuringYourHeadache_DoYouTurnOffTheLightsOrDrawACurtainToAvoidBr T.DuringYourHeadache_DoYouHaveToWearSunglassesEvenInNormalDayligh ...
    T.DuringYourHeadache_DoBrightLightsHurtYourEyes_ T.IsYourHeadacheWorsenedByBrightLights_ T.IsYourHeadacheTriggeredByBrightLights_ ...
    T.DoYouHaveAnyOfTheAboveSymptomsEvenDuringYourHeadache_freeInterv];

Choi2 = zeros(size(Choi));
Choi2(Choi=='Yes') = 1;
Choi2(Dx.HeadacheSpont==0) = -99;
Dx.Choi_score = sum(Choi2,2);

Dx.lightSens_noHA(T.DoYouHaveAnyOfTheAboveSymptomsEvenDuringYourHeadache_freeInterv=='Yes') = 1;

% Calculate visual discomfort score for non headache participants

VD = [T.DoYouEverFeelAGreaterSenseOfGlareOrDazzleInYourEyesThanUsualByB T.DoFlickeringLights_Glare_SpecificColors_OrHighContrastStripedPa ...
    T.DoYouEverTurnOffTheLightsOrDrawACurtainToAvoidBrightConditions_ T.DoYouEverHaveToWearSunglassesEvenInNormalDaylight_ ...
    T.DoBrightLightsEverHurtYourEyes_];

VD2 = zeros(size(VD));
VD2(VD=='Yes') = 1;
VD2(Dx.HeadacheSpont==1) = -99;
Dx.VD_score = sum(VD2,2);

Dx.VD_all = Dx.Choi_score;
Dx.VD_all(Dx.VD_all==-99) = Dx.VD_score(Dx.VD_all==-99);

Dx.interVD = NaN*ones(height(Dx),1);
Dx.interVD(T.DoYouHaveAnyOfTheAboveSymptomsEvenWhenYouDoNotHaveHeadDiscomfor=='No') = 0;
Dx.interVD(T.DoYouHaveAnyOfTheAboveSymptomsEvenWhenYouDoNotHaveHeadDiscomfor=='Yes') = 1;

diagnosisTable = Dx;

end % function