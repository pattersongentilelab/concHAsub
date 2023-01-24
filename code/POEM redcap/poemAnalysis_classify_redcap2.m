function [diagnosisTable] = poemAnalysis_classify_redcap2( T )
%
% This function takes the table variable "T" and performs a decision tree
% analysis to classify each subject into headache categories.

numSubjects = size(T,1);

QuestionText = T.Properties.VariableNames;

% Make diagnostic table for headache type, all questions set to false
variables = {'HeadacheEver','HeadacheSpont','ICHD_MigA','ICHD_MigB','ICHD_MigCloc','ICHD_MigCpuls','ICHD_MigCsev','ICHD_MigCact','ICHD_MigC','ICHD_MigDphotophono','ICHD_MigDnaus','VisualSx','probVisualAura','defVisualAura','activeVaura','SensorySx','probSensoryAura','defSensoryAura','activeSaura','SpeechSx','probSpeechAura','defSpeechAura','activeSpAura'};
varTypes = {'logical','logical','logical','logical','logical','logical','logical','logical','double','logical','logical','logical','logical','logical','logical','logical','logical'}';
Dx = table('Size',[numSubjects length(variables)],'VariableNames',variables,'VariableTypes',varTypes);

 
% Determine if they ever get headaches
Dx.HeadacheEver(T.DoYouGetHeadaches_=='Yes') = 1;
Dx.HeadacheEver(T.HaveYouEverHadAHeadache_=='Yes') = 1;
Dx.HeadacheEver(T.HaveYouEverHadEpisodesOfDiscomfort_Pressure_OrPainAroundYourEye=='Yes') = 1;

% Determine if they get headaches outside of illness or head injury
Dx.HeadacheSpont(T.HaveYouEverHadAHeadacheThatWasNOTCausedByAHeadInjuryOrIllnessLi=='Yes') = 1;
Dx.HeadacheSpont(T.DoYouGetHeadachesThatAreNOTCausedByAHeadInjuryOrIllnessLikeTheC=='Yes') = 1;

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

% ICHD visual aura
Dx.VisualSx(T.AroundTheTimeOfYourHeadaches_HaveYouEverSeenAnyOfTheFollowing_P=='Checked' | T.AroundTheTimeOfYourHeadaches_HaveYouEverSeenAnyOfTheFollowing_1=='Checked' |...
    T.AroundTheTimeOfYourHeadaches_HaveYouEverSeenAnyOfTheFollowing_2=='Checked' | T.AroundTheTimeOfYourHeadaches_HaveYouEverSeenAnyOfTheFollowing_3=='Checked' |...
    T.AroundTheTimeOfYourHeadaches_HaveYouEverSeenAnyOfTheFollowing_4=='Checked' | T.AroundTheTimeOfYourHeadaches_HaveYouEverSeenAnyOfTheFollowing_5=='Checked' |...
    T.AroundTheTimeOfYourHeadaches_HaveYouEverSeenAnyOfTheFollowing_6=='Checked') = 1;
Dx.probVisualAura(T.HaveYouHadTheseVisionChangesWithYourHeadDiscomfortTwoOrMoreTime=='Yes' & Dx.VisualSx==1 & T.HowLongDoTheseVisionChangesUsuallyLast_=='5 minutes to 1 hour' & ...
    (T.AreTheseVisionChangesOnlyOnOneSide_=='No' | T.DoTheVisionChangesSpreadOrMoveAcrossYourVision_=='No')) = 1;
Dx.defVisualAura(T.HaveYouHadTheseVisionChangesWithYourHeadDiscomfortTwoOrMoreTime=='Yes' & Dx.VisualSx==1 & T.HowLongDoTheseVisionChangesUsuallyLast_=='5 minutes to 1 hour' & ...
    T.AreTheseVisionChangesOnlyOnOneSide_=='Yes' & T.DoTheVisionChangesSpreadOrMoveAcrossYourVision_=='Yes') = 1;

% ICHD sensory aura
Dx.SensorySx(T.HaveYouEverHadAnyOfTheFollowingHappenAroundTheTimeOfYourHeadach=='Checked' | HaveYouEverHadAnyOfTheFollowingHappenAroundTheTimeOfYourHeada_1 == 'Checked') = 1;

end % function