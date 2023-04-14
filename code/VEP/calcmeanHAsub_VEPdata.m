% Organize VEP subject data and combine with VEP matlab files

%% Load VEP data
data_path = getpref('concHAsub','concHAsubDataPath');
filepath = [data_path '/VEP'];

load([filepath '/vep_files.mat'],'vep','x_data')

%% calculate mean VEP response

vep.vepM = cell(height(vep),1);
vep.vep5 = cell(height(vep),1);
vep.vep95 = cell(height(vep),1);

for x = 1:height(vep)
    temp = vep.response{x};
    if ~isnan(temp)
        bootstat = sort(bootstrp(1000,@mean,temp),1);
        vep.vepM{x} = bootstat(500,:);
        vep.vep5{x} = bootstat(25,:);
        vep.vep95{x} = bootstat(975,:);
    else
        vep.vepM{x} = NaN;
        vep.vep5{x} = NaN;
        vep.vep95{x} = NaN;
    end
end

figure

for x = 1:height(vep)
    if ~isnan(vep.vepM{x})
        x_ERR = cat(2,x_data,fliplr(x_data));
        y_ERR = cat(2,vep.vep5{x},fliplr(vep.vep95{x}));
        hold on
        fill(x_ERR,y_ERR,[0.5 0.5 0.5],'EdgeColor','none');
        plot(x_data,vep.vepM{x},'-k')
        ax = gca; ax.Box = 'off'; ax.TickDir = 'out';
        title([cellstr(vep.StudyID(x)) ', TimePoint ' num2str(vep.TimePoint(x))])
        pause
        clf
    end
end
