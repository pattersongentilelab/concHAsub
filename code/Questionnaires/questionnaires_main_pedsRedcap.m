%% Questionnaire organization
% Analysis code for the Penn Online Evaluation of Migraine (POEM) adapted
% for children and adolescents, and run for data collected through CHOP redcap
%
% Description:
%   This routine loads the .csv files generated by Redcap that have the
%   results of the migraine diagnostic pathway.
%
%   Subsequent functions called from this main script are responsible for
%   pre-processing of the data fields and then implementing the headache
%   classification pathway.
%

%% Housekeeping
clear variables
close all

addpath '/Users/pattersonc/Documents/MATLAB/commonFx'

%% Set paths to data and output
dataDir = '/Users/pattersonc/OneDrive - Children''s Hospital of Philadelphia/Research/Minds Matter/Data/HAsubstudy/Forms/';
analysisDir = '/Users/pattersonc/OneDrive - Children''s Hospital of Philadelphia/Research/Minds Matter/analysis/HAsubstudy/Forms/';

% Set the output filenames
outputResultExcelName = fullfile(analysisDir, 'POEMpeds_v2.3_results.xlsx');
rawDataSheets = {'HeadacheSubstudy-PrelimDataAnalysisCP_DATA_LABELS_2025-03-04_1951.csv'};
rawDataSheets2 = {'HeadacheSubstudy-DemographicsAndIntak_DATA_LABELS_2025-03-10_1300.csv'};

% get the full path to thisDataSheet
thisDataSheetFileName = fullfile(dataDir, rawDataSheets{1});
thatDataSheetFileName = fullfile(dataDir, rawDataSheets2{1});


%% Organize and analyze POEM results
[POEM] = poemAnalysis_preProcess_redcap(thisDataSheetFileName);

% classify headache based upon table T
diagnosisTable = poemAnalysis_classify_redcap2(POEM);
writetable(diagnosisTable,outputResultExcelName,'Range','A4','WriteRowNames',true)

%% Organize headache questions
[HA,MEDS,PCSI] = headacheQ_preProcess_redcap(thisDataSheetFileName);

%% Organize headache questions
[DEMO] = demoIntake_preProcess_redcap(thatDataSheetFileName);

%% Determine diagnosis categories
DxCat = Dx_categories(HA,PCSI);

%% Calculate CAMS
analysis_pathCAMS = getpref('assocSxHA','assocSxHaAnalysisPath');
load([analysis_pathCAMS '/CAMS_ChopAll_May2024.mat'],'CAMS')

var_HAaSx = CAMS.var_pres;

haASx = [HA.othSx_nausea HA.othSx_vomiting HA.othSx_lightsens HA.othSx_soundsens...
    HA.othSx_smellsens HA.othSx_lighthead HA.othSx_spinning HA.othSx_balance... 
    HA.othSx_thinking HA.vis_blurred HA.vis_double HA.othSx_ringing HA.othSx_neckpain];

binary_hx = cell(size(haASx));
binary_struct = NaN*ones(size(haASx,2),1);
for x = 1:size(haASx,2)
    temp = haASx(:,x);
    outcome = unique(temp);
        for y = 1:size(haASx,1)
            binary_struct(x,:) = 2;
                switch temp(y)
                    case outcome(1)
                        binary_hx{y,x} = [1 0];
                    case outcome(2)
                        binary_hx{y,x} = [0 1];
                end
        end
end

% concatonate each subjects binary outcomes
binary_Hx = NaN*ones(size(binary_hx,1),size(var_HAaSx,1)*2);
temp = [];
for x = 1:size(binary_hx,1)
    for y = 1:size(binary_hx,2)
        temp = cat(2,temp,cell2mat(binary_hx(x,y)));
    end
    binary_Hx(x,:) = temp;
    temp = [];
end

CAMS_model = CAMS.MCA_model;

% Calculate CAMS scores
MCA_no=3;
MCA_score_HAaSx = NaN*ones(size(binary_Hx,1),MCA_no);
for x = 1:size(binary_Hx,1)
    for y = 1:MCA_no
        temp1 = binary_Hx(x,:);
        temp2 = CAMS_model(:,y);
        r=temp1*temp2;
        MCA_score_HAaSx(x,y) = r;
    end
end

HA.CAMS1_T1 = 1*MCA_score_HAaSx(:,1);
HA.CAMS2_T1 = 1*MCA_score_HAaSx(:,2);
HA.CAMS3_T1 = -1*MCA_score_HAaSx(:,3);

clear MCA* temp* x y r binary* haASx