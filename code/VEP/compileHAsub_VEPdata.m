% Organize VEP subject data and combine with VEP matlab files

data_path = getpref('concHAsubDataPath','MindsMatter_DataPath');

load([data_path '/VEPsubject_masterList111220.mat'])

 %% organize and extract VEP files
filepath=['/Volumes/CIRP_Epidemiology/TM_Pediatric Concussion Prospective Cohort/Data/Equipment Data/VEP/Data exports/Shipley/SHIPLEY 4.22.20 RAW/rdata/'];

% Match VEP data to subject
temp=table2array(VEPsubject_data(:,[1 133 118]));

for x=1:length(temp)
    if temp(x,3) <100
        filename(x,:)=['f00000' num2str(temp(x,2)) '_000000' num2str(temp(x,3)) '.m'];
    else if temp(x,3) >=100 && temp(x,3)<1000
        filename(x,:)=['f00000' num2str(temp(x,2)) '_00000' num2str(temp(x,3)) '.m'];
        else if temp(x,3)>=1000
                filename(x,:)=['f00000' num2str(temp(x,2)) '_0000' num2str(temp(x,3)) '.m'];
            end
        end
    end
end

VEPsubject_data.filename=filename;

clear temp x filename

% Find and select patient IDs and sessions with existing matlab file
vep_files_loc=[];
no_vep_files_loc=[];
for x=1:size(VEPsubject_data,1)
    temp_file=[filepath table2array(VEPsubject_data(x,216))];
    vep_files_loc=cat(1,vep_files_loc,x);

end

clear temp x

vep_files=VEPsubject_data(vep_files_loc,:);
vep_loc=vep_loc(vep_files_loc,:);
no_vep_filenames=VEPsubject_data(no_vep_files_loc,216);


% Extract VEP files
for x=1:size(vep_files,1)
    if vep_loc(x,:)==['Ship']
        run([filepath_ship table2array(vep_files(x,216))]);
    else if vep_loc(x,:)==['Clin']
            run([filepath_clinic table2array(vep_files(x,216))]);
        end
    end
        if exist('RawDataFrame_20')==1
            all_VEP=cat(1,RawDataFrame_1,RawDataFrame_2,RawDataFrame_3,RawDataFrame_4,RawDataFrame_5,RawDataFrame_6,...
                RawDataFrame_7,RawDataFrame_8,RawDataFrame_9,RawDataFrame_10,RawDataFrame_11,RawDataFrame_12,RawDataFrame_13,...
                RawDataFrame_14,RawDataFrame_15,RawDataFrame_16,RawDataFrame_17,RawDataFrame_18,RawDataFrame_19,RawDataFrame_20);
        else if exist('RawDataFrame_20')==0
                all_VEP=cat(1,RawDataFrame_1,RawDataFrame_2,RawDataFrame_3,RawDataFrame_4,RawDataFrame_5,RawDataFrame_6,...
                    RawDataFrame_7,RawDataFrame_8,RawDataFrame_9,RawDataFrame_10,RawDataFrame_11,RawDataFrame_12,RawDataFrame_13,...
                    RawDataFrame_14,RawDataFrame_15);
            end
        end
        clear A Raw*
        
        raw_vep{x,1}=vep_files(x,:).uniqueID;
        raw_vep{x,2}=vep_files(x,:).age_vep;
        raw_vep{x,3}=all_VEP;
end

% save VEP_and_subject_data VEPsubject_data vep_files raw_vep

clear