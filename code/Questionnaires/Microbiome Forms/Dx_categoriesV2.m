function [dxCat] = Dx_categoriesV2(T)
%
% This function takes the table variable "T" and performs a decision tree
% analysis to classify each subject into migraine-like headache,
% non-migraine like headache, recovered, and not recovered no headache
% based on timepoint T3

Dx = T(:,1); % link to ID

%% headache present at 1 month

Dx.Headache = mergecats(T.pattern,{'Sometimes I have a headache, and sometimes I have no headache.',...
    'Some headache is there all the time.  The pain is better sometimes, and worse sometimes.',...
    'Some headache is there all the time, and it doesn''t change much.'});
Dx.Headache = renamecats(Dx.Headache,{'Sometimes I have a headache, and sometimes I have no headache.'},{'headache'});

Dx.HA_change = zeros(height(Dx),1);
Dx.HA_change(T.noChange=='Unchecked') = 1;

Dx.HAcont = zeros(height(Dx),1);
Dx.HAcont(categorical(T.pattern)=='Some headache is there all the time.  The pain is better sometimes, and worse sometimes.'...
    | categorical(T.pattern)=='Some headache is there all the time, and it doesn''t change much.') = 1; 


Dx.prolongedPTH = zeros(height(Dx),1);
Dx.prolongedPTH(Dx.HA_change==1 & Dx.Headache=='headache') = 1;
% Base diagnosis only on headache presence at timepoint 3
for x = 1:height(Dx)
    if any(T.EventName == "Time point 2" | T.EventName == "Time point 1")
        Dx.prolongedPTH(x) = Dx.prolongedPTH(T.EventName=="Time point 3" & T.RecordID_==T.RecordID_(x));
    end
end
%% ICHD criteria C
Dx.ichdC1 = zeros(height(Dx),1);
Dx.ichdC2 = zeros(height(Dx),1);
Dx.ichdC3 = zeros(height(Dx),1);
Dx.ichdC4 = zeros(height(Dx),1);
Dx.ichdC1(T.painLoc_front=='Checked'|T.painLoc_top=='Checked'|T.painLoc_peri_orbit=='Checked'|...
    T.painLoc_retro_orbit=='Checked'|T.painLoc_occiput=='Checked'|T.painLoc_sides=='Checked') = 1; % 1) anything but holocephalic
Dx.ichdC2(T.quality_throbbing=='Checked') = 1; % 2) throbbing quality
Dx.ichdC3(T.severity=='Checked' | T.HA_Freq_disable=='2 to 3 per week' |T.HA_Freq_disable=='More than 3 per week'...
    | T.HA_Freq_disable=='Daily' | T.HA_Freq_disable=='1 per week' | T.HA_Freq_disable=='Less than 1 per week') = 1; % 3) moderate-to-severe/disabling
Dx.ichdC4(T.trig_exercise=='Checked') = 1; % 4) triggered/worsened by exercise

for x = 1:height(Dx)
    if any(T.EventName == "Time point 2" | T.EventName == "Time point 3")
        Dx.ichdC1(x) = Dx.ichdC1(T.EventName=="Time point 1" & T.RecordID_==T.RecordID_(x));
        Dx.ichdC2(x) = Dx.ichdC2(T.EventName=="Time point 1" & T.RecordID_==T.RecordID_(x));
        Dx.ichdC4(x) = Dx.ichdC4(T.EventName=="Time point 1" & T.RecordID_==T.RecordID_(x));
    end
end

Dx.ichdC = sum([Dx.ichdC1 Dx.ichdC2 Dx.ichdC3 Dx.ichdC4],2);
%% ICHD criteria D nausea, vomiting, and/or light AND sound sensitivity
Dx.ichdD = zeros(height(Dx),1);
Dx.ichdD(T.othSx_vomiting=='Checked'|T.othSx_nausea=='Checked') = 1;
Dx.ichdD(T.othSx_lightsens=='Checked'& T.othSx_soundsens=='Checked') = 1;

%% determine if migraine-like

Dx.migLike = zeros(height(Dx),1);
Dx.migLike(Dx.ichdC>=2 & Dx.ichdD==1) = 1;
Dx.migLike = categorical(Dx.migLike,[1 0],{'Yes','No'});

%% determine if probable migraine-like

Dx.prmigLike = zeros(height(Dx),1);
Dx.prmigLike(Dx.ichdC3>=2 | Dx.ichdD==1) = 1;
Dx.prmigLike = categorical(Dx.prmigLike,[1 0],{'Yes','No'});

%% Determine if symptomatic

% based on PCSI <7
Dx.sympt = zeros(height(Dx),1);
Dx.sympt(T.PCSICurrent_Teen_TotalSymptomScore>=7) = 1;

% based on difference in PCSI of 2+ items with 1+ severity to identify
% symptomatic children (Hearps et al,2017)

U = [T.headache_diff T.nausea_diff T.balance_diff T.dizziness_diff T.fatigue_diff T.sleepmore_diff T.drowsiness_diff T.lightsens_diff...
    T.soundsens_diff T.irrit_diff T.sadness_diff T.nervous_diff T.emotional_diff T.slowed_diff T.foggy_diff T.concentrate_diff T.remember_diff...
    T.visualprob_diff T.confused_diff T.clumsy_diff T.ansslow_diff];
Dx.symptDif = zeros(height(Dx),1);

for x = 1:height(Dx)
    temp = U(x,:);
    if length(temp(temp<1))>=20
        Dx.symptDif(x) = 0;
    end
    if length(temp(temp>=1))>=2
        Dx.symptDif(x) = 1;
    end
end

%% categorize for analysis based on migraine ICHD

Dx.category = NaN*ones(height(Dx),1);
Dx.category(Dx.sympt==0 & Dx.Headache=='no headache') = 0;
Dx.category(Dx.sympt==1 & Dx.Headache=='no headache') = 1;
Dx.category(Dx.migLike=='No' & Dx.Headache=='headache') = 2;
Dx.category(Dx.migLike=='Yes' & Dx.Headache=='headache') = 3;
Dx.category = categorical(Dx.category,[0 1 2 3],{'asymptomatic','symptomatic no HA','post-traumatic non-migraine HA','post-traumatic migraine-like'});

%% categorize for analysis based on PCSI
Dx.pcsiMig = NaN*ones(height(Dx),1);
Dx.pcsiMig(T.Headache>2 & (T.Nausea>0|(T.SensitivityToLight>0 & T.SensitivityToNoise>0))) = 1;
Dx.pcsiMig(T.Headache<=2 & (T.Nausea==0 & (T.SensitivityToLight==0 | T.SensitivityToNoise==0))) = 0;

dxCat = Dx;
end % function