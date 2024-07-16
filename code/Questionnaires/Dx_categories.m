function [dxCat] = Dx_categories(T,U)
%
% This function takes the table variable "T" and performs a decision tree
% analysis to classify each subject into migraine-like headache,
% non-migraine like headache, recovered, and not recovered no headache
% based on timepoint T3

Dx = T(:,1); % link to ID

%% headache present at 1 month

Dx.HeadacheT1 = mergecats(T.pattern,{'Sometimes I have a headache, and sometimes I have no headache.',...
    'Some headache is there all the time.  The pain is better sometimes, and worse sometimes.',...
    'Some headache is there all the time, and it doesn''t change much.'});
Dx.HeadacheT1 = renamecats(Dx.HeadacheT1,{'Sometimes I have a headache, and sometimes I have no headache.'},{'headache'});

Dx.HeadacheT2 = mergecats(T.patternT2,{'Sometimes I have a headache, and sometimes I have no headache.',...
    'Some headache is there all the time.  The pain is better sometimes, and worse sometimes.',...
    'Some headache is there all the time, and it doesn''t change much.'});
Dx.HeadacheT2 = renamecats(Dx.HeadacheT2,{'Sometimes I have a headache, and sometimes I have no headache.'},{'headache'});

Dx.HeadacheT3 = mergecats(T.patternT3,{'Sometimes I have a headache, and sometimes I have no headache.',...
    'Some headache is there all the time.  The pain is better sometimes, and worse sometimes.',...
    'Some headache is there all the time, and it doesn''t change much.'});
Dx.HeadacheT3 = renamecats(Dx.HeadacheT3,{'Sometimes I have a headache, and sometimes I have no headache.'},{'headache'});

Dx.HA_change = zeros(height(Dx),1);
Dx.HA_change(T.noChange=='Unchecked') = 1;

Dx.prolongedPTH = zeros(height(Dx),1);
Dx.prolongedPTH(Dx.HA_change==1 & Dx.HeadacheT3=='headache') = 1;
%% ICHD criteria C
Dx.ichdC1 = zeros(height(Dx),1);
Dx.ichdC2 = zeros(height(Dx),1);
Dx.ichdC3 = zeros(height(Dx),1);
Dx.ichdC4 = zeros(height(Dx),1);
Dx.ichdC1(T.painLoc_front=='Checked'|T.painLoc_top=='Checked'|T.painLoc_peri_orbit=='Checked'|...
    T.painLoc_retro_orbit=='Checked'|T.painLoc_occiput=='Checked'|T.painLoc_sides=='Checked') = 1; % 1) anything but holocephalic
Dx.ichdC2(T.quality_throbbing=='Checked') = 1; % 2) throbbing quality
Dx.ichdC3(T.severityT3=='Checked' | T.Freq_disableT3=='2 to 3 per week' |T.Freq_disableT3=='More than 3 per week'...
    | T.Freq_disableT3=='Daily' | T.Freq_disableT3=='1 per week' | T.Freq_disableT3=='Less than 1 per week') = 1; % 3) moderate-to-severe/disabling
Dx.ichdC4(T.trig_exercise=='Checked') = 1; % 4) triggered/worsened by exercise

Dx.ichdC = sum([Dx.ichdC1 Dx.ichdC2 Dx.ichdC3 Dx.ichdC4],2);
%% ICHD criteria D nausea, vomiting, and/or light AND sound sensitivity
Dx.ichdD = zeros(height(Dx),1);
Dx.ichdD(T.othSx_vomitingT3=='Checked'|T.othSx_nauseaT3=='Checked') = 1;
Dx.ichdD(T.othSx_lightsensT3=='Checked'& T.othSx_soundsensT3=='Checked') = 1;

%% determine if migraine-like

Dx.migLike = zeros(height(Dx),1);
Dx.migLike(Dx.ichdC>=2 & Dx.ichdD==1) = 1;
Dx.migLike = categorical(Dx.migLike,[1 0],{'Yes','No'});

%% Determine if symptomatic

% based on PCSI <7
Dx.symptS1 = zeros(height(Dx),1);
Dx.symptS1(U.total_T1>=7) = 1;

Dx.symptS2 = zeros(height(Dx),1);
Dx.symptS2(U.total_T2>=7) = 1;

Dx.symptS3 = zeros(height(Dx),1);
Dx.symptS3(U.total_T3>=7) = 1;

% based on difference in PCSI of 2+ items with 1+ severity to identify
% symptomatic children (Hearps et al,2017)

Dx.symptV1 = NaN*ones(height(Dx),1);
for x = 1:height(Dx)
    temp = table2array(U(x,90:110));
    if length(temp(temp<1))>=20
        Dx.symptV1(x) = 0;
    end
    if length(temp(temp>=1))>=2
        Dx.symptV1(x) = 1;
    end
end

Dx.symptV2 =  NaN*ones(height(Dx),1);
for x = 1:height(Dx)
    temp = table2array(U(x,112:132));
    if length(temp(temp<1))>=20
        Dx.symptV2(x) = 0;
    end
    if length(temp(temp>=1))>=2
        Dx.symptV2(x) = 1;
    end
end

Dx.symptV3 =  NaN*ones(height(Dx),1);
for x = 1:height(Dx)
    temp = table2array(U(x,134:154));
    if length(temp(temp<1))>=20
        Dx.symptV3(x) = 0;
    end
    if length(temp(temp>=1))>=2
        Dx.symptV3(x) = 1;
    end
end

Dx.sympt1 = Dx.symptV1;
Dx.sympt1(isnan(Dx.sympt1)) = Dx.symptS1(isnan(Dx.sympt1));

Dx.sympt2 = Dx.symptV2;
Dx.sympt2(isnan(Dx.sympt2)) = Dx.symptS2(isnan(Dx.sympt2));

Dx.sympt3 = Dx.symptV3;
Dx.sympt3(isnan(Dx.sympt3)) = Dx.symptS3(isnan(Dx.sympt3));

%% categorize for analysis

Dx.category = NaN*ones(height(Dx),1);
Dx.category(Dx.sympt3==0 & U.headache_T3==0) = 0;
Dx.category(Dx.sympt3==1 & U.headache_T3==0) = 1;
Dx.category(Dx.sympt3==1 & U.headache_T3>=1 & Dx.HA_change==1 & Dx.migLike=='No') = 2;
Dx.category(Dx.sympt3==1 & U.headache_T3>=1 & Dx.HA_change==1 & Dx.migLike=='Yes') = 3;
Dx.category = categorical(Dx.category,[0 1 2 3],{'asymptomatic','symptomatic no HA','symptomatic non-migraine HA','symptomatic migraine HA'});

Dx.catPTH = mergecats(Dx.category,{'symptomatic non-migraine HA','symptomatic migraine HA'});
Dx.catPTH = renamecats(Dx.catPTH,{'symptomatic non-migraine HA'},{'pth'});
Dx.catPTH = mergecats(Dx.catPTH,{'asymptomatic','symptomatic no HA'});
Dx.catPTH = renamecats(Dx.catPTH,{'asymptomatic'},{'no pth'});

dxCat = Dx;
end % function