%% =============0. Initialization and Create output folder==========
wordir = 'F:\FBSP_Matlab\Advanced_OPTIONAL_Exercise\';
subj_code_addr = 'F:\FBSP_Matlab\Advanced_OPTIONAL_Exercise\logs\subj_codes.csv';
logfile_addr = 'F:\FBSP_Matlab\Advanced_OPTIONAL_Exercise\logs';
cd(wordir);
mkdir('subject_event');
mkdir('subject_info');
mkdir('result_fig');
mkdir('subject_data');

cur_program_log_info = 'Step 0 is finished.';
cur_program_time = datestr(now);
fp=fopen(strcat(wordir,'logfile.txt'),'w');
fprintf(fp,'%s\t%s\n',cur_program_log_info,cur_program_time);
fclose(fp);

%% ===================1. Deal with subj_codes.csv===================
%subj_code_addr = 'F:\FBSP_Matlab\Advanced_OPTIONAL_Exercise\logs\subj_codes.csv';
subj_fid = fopen(subj_code_addr);
subj_info = textscan(subj_fid, '%s');
fclose(subj_fid);
for ii = 1:size(subj_info{1})
    sub_split{ii}= split(subj_info{1}{ii},';');
    subjectID(ii) = sub_split{ii}(1);
    groupID(ii) = sub_split{ii}(2);
end

for ii = 1:size(subj_info{1})
    Subject_Infomation(ii).ID = string(subjectID(ii));
    Subject_Infomation(ii).groupID = string(groupID(ii));
end

cur_program_log_info = 'Step 1 is finished.';
cur_program_time = datestr(now);
fp=fopen(strcat(wordir,'logfile.txt'),'a+');
fprintf(fp,'%s\t%s\n',cur_program_log_info,cur_program_time);
fclose(fp);

%% =================2. Deal with log file==========================
fileFolder=fullfile(logfile_addr);
dirOutput=dir(fullfile(fileFolder,'*.log'));
fileNames={dirOutput.name};
for jj = 1:40
    cur_dir = ['F:\FBSP_Matlab\Advanced_OPTIONAL_Exercise\logs\' fileNames{jj}];
    cur_fid = fopen(cur_dir);
    cur_line = fgetl(cur_fid);
    time_position = 1;
    while cur_line(1) == '#'
        cur_line = fgetl(cur_fid);
    end
    while cur_line(1) ~= '#' & cur_line ~= -1
        cur_line_split = strsplit(cur_line,'\t');
        Subject_Infomation(jj).Time(time_position) = str2num(cur_line_split{1});
        Subject_Infomation(jj).HHGG(time_position) = str2num(cur_line_split{2});
        Subject_Infomation(jj).Event(time_position) = string(cur_line_split{3});
        time_position = time_position + 1;
        cur_line = fgetl(cur_fid);
    end 
    fclose(cur_fid);
end

cur_program_log_info = 'Step 2 is finished.';
cur_program_time = datestr(now);
fp=fopen(strcat(wordir,'logfile.txt'),'a+');
fprintf(fp,'%s\t%s\n',cur_program_log_info,cur_program_time);
fclose(fp);

%% ==============3. Calculate the data needed======================
for ii = 1:40
    Subject_Infomation(ii).correct = 0;
    Subject_Infomation(ii).wrong = 0;
    Subject_Infomation(ii).freq = 0;
    Subject_Infomation(ii).rare = 0;
    Subject_Infomation(ii).freq_correct = 0;
    Subject_Infomation(ii).freq_wrong = 0;
    Subject_Infomation(ii).rare_correct = 0;
    Subject_Infomation(ii).rare_wrong = 0;
    k_freq = 1;
    k_rare = 1;
    for jj = 1: length(Subject_Infomation(ii).Time)/2
        Subject_Infomation(ii).stimu_time(jj) = Subject_Infomation(ii).Time(2*jj-1);
        Subject_Infomation(ii).action_time(jj) = Subject_Infomation(ii).Time(2*jj);
        Subject_Infomation(ii).RT(jj) = Subject_Infomation(ii).Time(2*jj)-Subject_Infomation(ii).Time(2*jj-1);
        cur_stimu_sig =  char(Subject_Infomation(ii).Event(2*jj-1));
        cur_action = char(Subject_Infomation(ii).Event(2*jj));
        Subject_Infomation(ii).stimu_sig(jj) = cur_stimu_sig(length(cur_stimu_sig));
        Subject_Infomation(ii).action(jj) = cur_action(length(cur_action));
        
        if Subject_Infomation(ii).stimu_sig(jj) >= 'a' && Subject_Infomation(ii).stimu_sig(jj) <= 'z'
            Subject_Infomation(ii).stimu_type(jj) = '1';
            Subject_Infomation(ii).freq =  Subject_Infomation(ii).freq + 1;
            Subject_Infomation(ii).freq_RT(k_freq) = Subject_Infomation(ii).RT(jj);
            k_freq = k_freq + 1;
            if Subject_Infomation(ii).stimu_type(jj) == Subject_Infomation(ii).action(jj)
                Subject_Infomation(ii).correct = Subject_Infomation(ii).correct + 1;
                Subject_Infomation(ii).freq_correct = Subject_Infomation(ii).freq_correct + 1;
                Subject_Infomation(ii).is_correct(jj) = 1;
            else
                Subject_Infomation(ii).wrong = Subject_Infomation(ii).wrong + 1;
                Subject_Infomation(ii).freq_wrong = Subject_Infomation(ii).freq_wrong + 1;
                Subject_Infomation(ii).is_correct(jj) = 0;
            end     
        end
        if Subject_Infomation(ii).stimu_sig(jj) >= '0' && Subject_Infomation(ii).stimu_sig(jj) <= '9'
            Subject_Infomation(ii).stimu_type(jj) = '2';
            Subject_Infomation(ii).rare =  Subject_Infomation(ii).rare + 1;
            Subject_Infomation(ii).rare_RT(k_rare) = Subject_Infomation(ii).RT(jj);
            k_rare = k_rare + 1;
            if Subject_Infomation(ii).stimu_type(jj) == Subject_Infomation(ii).action(jj)
                Subject_Infomation(ii).correct = Subject_Infomation(ii).correct + 1;
                Subject_Infomation(ii).rare_correct = Subject_Infomation(ii).rare_correct + 1;
                Subject_Infomation(ii).is_correct(jj) = 1;
            else
                Subject_Infomation(ii).wrong = Subject_Infomation(ii).wrong + 1;
                Subject_Infomation(ii).rare_wrong = Subject_Infomation(ii).rare_wrong + 1;
                Subject_Infomation(ii).is_correct(jj) = 0;
            end
        end   
    end
    Subject_Infomation(ii).freq_accuracy = Subject_Infomation(ii).freq_correct / Subject_Infomation(ii).freq;
    Subject_Infomation(ii).rare_accuracy = Subject_Infomation(ii).rare_correct / Subject_Infomation(ii).rare;
    Subject_Infomation(ii).accuracy = Subject_Infomation(ii).correct / (Subject_Infomation(ii).correct + Subject_Infomation(ii).wrong); 
    Subject_Infomation(ii).aveRT = double(mean(Subject_Infomation(ii).RT));
    Subject_Infomation(ii).medRT = double(median(Subject_Infomation(ii).RT));
    Subject_Infomation(ii).ave_freqRT = double(mean(Subject_Infomation(ii).freq_RT));
    Subject_Infomation(ii).ave_rareRT = double(mean(Subject_Infomation(ii).rare_RT));
end

cur_program_log_info = 'Step 3 is finished.';
cur_program_time = datestr(now);
fp=fopen(strcat(wordir,'logfile.txt'),'a+');
fprintf(fp,'%s\t%s\n',cur_program_log_info,cur_program_time);
fclose(fp);

%% ========================4. Data export=========================

%% ================4.1 Subject_Info to excle====================== 
export_data = [{Subject_Infomation.ID}' ...
               {Subject_Infomation.groupID}' ...
               {Subject_Infomation.correct}' ...
               {Subject_Infomation.wrong}' ...
               {Subject_Infomation.freq}' ...
               {Subject_Infomation.freq_correct}' ...
               {Subject_Infomation.freq_wrong}' ...
               {Subject_Infomation.freq_accuracy}' ...
               {Subject_Infomation.ave_freqRT}' ...
               {Subject_Infomation.rare}' ...
               {Subject_Infomation.rare_correct}' ...
               {Subject_Infomation.rare_wrong}' ...
               {Subject_Infomation.rare_accuracy}' ...
               {Subject_Infomation.ave_rareRT}'];
header = [{'SubjectID'} {'GroupID'} {'TotalCorrect'} {'TotalWrong'} {'TotalFreq'} {'TotalFreqCorrect'} ...
    {'TotalFreqWrong'} {'FreqAccuracy'} {'AveFreqRT'} {'TotalRare'} {'TotalRareCorrect'} {'TotalRareWrong'} ...
    {'RareAccuracy'} {'AveRareqRT'}];
xlsdata = [header; export_data];
xlswrite(strcat(wordir,'subject_data\','subject_data'),xlsdata);

cur_program_log_info = 'Step 4.1 is finished.';
cur_program_time = datestr(now);
fp=fopen(strcat(wordir,'logfile.txt'),'a+');
fprintf(fp,'%s\t%s\n',cur_program_log_info,cur_program_time);
fclose(fp);

%% =================4.2 each subject info to excle=================
for ii = 1:40
    cur_log_name = Subject_Infomation(ii).ID; 
    
    cur_time_posi = Subject_Infomation(ii).Time;
    cur_hhgg = Subject_Infomation(ii).HHGG;
    cur_event = Subject_Infomation(ii).Event;
    
    subinfo_header = [{'Time'} {'HHGG'} {'Event'}];
    subinfo_data = [cur_time_posi' cur_hhgg' cur_event'];
    xls_subinfo = [subinfo_header; subinfo_data];
    xlswrite(strcat(wordir,'subject_info\',cur_log_name,'_info'),xls_subinfo);
end

cur_program_log_info = 'Step 4.2 is finished.';
cur_program_time = datestr(now);
fp=fopen(strcat(wordir,'logfile.txt'),'a+');
fprintf(fp,'%s\t%s\n',cur_program_log_info,cur_program_time);
fclose(fp);

%% ===============4.3 each subject event to excel==================
for ii = 1:40
    cur_log_name = Subject_Infomation(ii).ID; 
    cur_stimu_time = string(Subject_Infomation(ii).stimu_time');
    cur_action_time = string(Subject_Infomation(ii).action_time');
    cur_RT = string(Subject_Infomation(ii).RT');
    cur_sig_arr = string(Subject_Infomation(ii).stimu_sig');
    cur_sig_type = string(Subject_Infomation(ii).stimu_type');
    cur_action_arr = string(Subject_Infomation(ii).action');
    cur_iscorrt = string(Subject_Infomation(ii).is_correct');
   
    subevent_header = [{'StimuTime'} {'ActionTime'} {'RT'} {'StimuSig'} {'StimuType'} ...
        {'Action'} {'IsCorrect'}];
    subevent_data = [cur_stimu_time cur_action_time cur_RT cur_sig_arr cur_sig_type cur_action_arr cur_iscorrt];
    xls_subevent = [subevent_header; subevent_data];
    xlswrite(strcat(wordir,'subject_event\',cur_log_name,'_event'),xls_subevent);
end

cur_program_log_info = 'Step 4.3 is finished.';
cur_program_time = datestr(now);
fp=fopen(strcat(wordir,'logfile.txt'),'a+');
fprintf(fp,'%s\t%s\n',cur_program_log_info,cur_program_time);
fclose(fp);

%% ==================5. Data visualization========================

%% ==================5.1 RT between control and patient============
total_control = 0;
total_patient = 0;
total_RT_control = 0;
total_RT_patient = 0;
freq_RT_control = 0;
rare_RT_control = 0;
freq_RT_patient = 0;
rare_RT_patient = 0;
for ii = 1:40  
    if Subject_Infomation(ii).groupID == 'Control'
        total_RT_control = Subject_Infomation(ii).aveRT + total_RT_control;
        total_control = total_control +1;
        freq_RT_control = Subject_Infomation(ii).ave_freqRT + freq_RT_control;
        rare_RT_control = Subject_Infomation(ii).ave_rareRT + rare_RT_control;
    end
    if Subject_Infomation(ii).groupID == 'Patient'
        total_RT_patient = Subject_Infomation(ii).aveRT + total_RT_patient;
        total_patient = total_patient +1;
        freq_RT_patient = Subject_Infomation(ii).ave_freqRT + freq_RT_patient;
        rare_RT_patient = Subject_Infomation(ii).ave_rareRT + rare_RT_patient;
    end
end
ave_control_RT = total_RT_control / total_control;
ave_patient_RT = total_RT_patient / total_patient;
ave_freq_control_RT = freq_RT_control / total_control;
ave_freq_patient_RT = freq_RT_patient / total_patient;
ave_rare_control_RT = rare_RT_control / total_control;
ave_rare_patient_RT = rare_RT_patient / total_patient;

RT_grid = [ave_control_RT ave_patient_RT;ave_freq_control_RT ave_freq_patient_RT;...
    ave_rare_control_RT ave_rare_patient_RT];
RT_bar = bar(RT_grid);
legend('Control','Patient');
set(gca,'XTickLabel',{'Average','Freq','Rare'});
xlabel('Condition');
ylabel('Time(10e-4s)');
set(gca,'YLim',[0 7350]);
title('RT between Control and Patient');
for ii = 1:size(RT_grid,1)
    for jj = 1:size(RT_grid,2)
        if jj == 1
            text(ii-0.135,RT_grid(ii,jj),num2str(RT_grid(ii,jj),'%g'),...
            'HorizontalAlignment','center',...
            'VerticalAlignment','bottom');
        end
        if jj == 2
            text(ii+0.135,RT_grid(ii,jj),num2str(RT_grid(ii,jj),'%g'),...
            'HorizontalAlignment','center',...
            'VerticalAlignment','bottom');
        end
    end
end
set(gcf,'unit','centimeters','position',[10 5 20 15]);
grid on;
saveas(gcf,strcat(wordir,'result_fig\RT.jpg'));

cur_program_log_info = 'Step 5.1 is finished.';
cur_program_time = datestr(now);
fp=fopen(strcat(wordir,'logfile.txt'),'a+');
fprintf(fp,'%s\t%s\n',cur_program_log_info,cur_program_time);
fclose(fp);

%% =============5.2 Accuracy between control and patient===========
total_control = 0;
total_patient = 0;
total_RT_control = 0;
total_RT_patient = 0;
freq_RT_control = 0;
rare_RT_control = 0;
freq_RT_patient = 0;
rare_RT_patient = 0;
for ii = 1:40  
    if Subject_Infomation(ii).groupID == 'Control'
        total_RT_control = Subject_Infomation(ii).accuracy + total_RT_control;
        total_control = total_control +1;
        freq_RT_control = Subject_Infomation(ii).freq_accuracy + freq_RT_control;
        rare_RT_control = Subject_Infomation(ii).rare_accuracy + rare_RT_control;
    end
    if Subject_Infomation(ii).groupID == 'Patient'
        total_RT_patient = Subject_Infomation(ii).accuracy + total_RT_patient;
        total_patient = total_patient +1;
        freq_RT_patient = Subject_Infomation(ii).freq_accuracy + freq_RT_patient;
        rare_RT_patient = Subject_Infomation(ii).rare_accuracy + rare_RT_patient;
    end
end

ave_control_RT = total_RT_control / total_control;
ave_patient_RT = total_RT_patient / total_patient;
ave_freq_control_RT = freq_RT_control / total_control;
ave_freq_patient_RT = freq_RT_patient / total_patient;
ave_rare_control_RT = rare_RT_control / total_control;
ave_rare_patient_RT = rare_RT_patient / total_patient;

Accuracy_grid = [ave_control_RT ave_patient_RT;ave_freq_control_RT ave_freq_patient_RT;...
    ave_rare_control_RT ave_rare_patient_RT];
Accuracy_bar = bar(Accuracy_grid);
legend('Control','Patient');
set(gca,'XTickLabel',{'Average','Freq','Rare'});
xlabel('Condition');
ylabel('Accuracy');
set(gca,'YLim',[0 1.1]);
title('Accuracy between Control and Patient');
for ii = 1:size(Accuracy_grid,1)
    for jj = 1:size(Accuracy_grid,2)
        if jj == 1
            numstr = num2str(Accuracy_grid(ii,jj));
            text(ii-0.135,Accuracy_grid(ii,jj),numstr(1:5),...
            'HorizontalAlignment','center',...
            'VerticalAlignment','bottom');
        end
        if jj == 2
            numstr = num2str(Accuracy_grid(ii,jj));
            text(ii+0.135,Accuracy_grid(ii,jj),numstr(1:5),...
            'HorizontalAlignment','center',...
            'VerticalAlignment','bottom');
        end
    end
end
set(gcf,'unit','centimeters','position',[10 5 20 15]);
grid on;
saveas(gcf,strcat(wordir,'result_fig\Accuracy.jpg'));

cur_program_log_info = 'Step 5.2 is finished.';
cur_program_time = datestr(now);
fp=fopen(strcat(wordir,'logfile.txt'),'a+');
fprintf(fp,'%s\t%s\n',cur_program_log_info,cur_program_time);
fclose(fp);

%% ==============6. Spectrum of Accuracy among Stimulus============

%% =====6.1 Accuracy between Control and Patient among stimulus====
Control_FreqTotalType = zeros(1,26);
Patient_FreqTotalType = zeros(1,26);
Control_RareTotalType = zeros(1,10);
Patient_RareTotalType = zeros(1,10);
RareTotalType = zeros(1,10);
FreqTotalType = zeros(1,26);
Control_FreqCorrectType = zeros(1,26);
Control_RareCorrectType = zeros(1,10);
Patient_FreqCorrectType = zeros(1,26);
Patient_RareCorrectType = zeros(1,10);
for ii = 1:40
    Subject_Infomation(ii).freq_total_type = zeros(1,26);
    Subject_Infomation(ii).rare_total_type = zeros(1,10);
    Subject_Infomation(ii).freq_correct_type = zeros(1,26);
    Subject_Infomation(ii).rare_correct_type = zeros(1,10);
    for jj = 1: length(Subject_Infomation(ii).stimu_time)
        if Subject_Infomation(ii).stimu_type(jj) == '1'
            type = Subject_Infomation(ii).stimu_sig(jj) - 'a'+1;
            Subject_Infomation(ii).freq_total_type(type) = Subject_Infomation(ii).freq_total_type(type) +1;
            if Subject_Infomation(ii).is_correct(jj) == 1
                Subject_Infomation(ii).freq_correct_type(type) = Subject_Infomation(ii).freq_correct_type(type) + 1;
                if Subject_Infomation(ii).groupID == 'Control'
                    Control_FreqCorrectType(type) = Control_FreqCorrectType(type) + 1;
                end
                if Subject_Infomation(ii).groupID == 'Patient'
                    Patient_FreqCorrectType(type) = Patient_FreqCorrectType(type) + 1;
                end
            end
        end
        if Subject_Infomation(ii).stimu_type(jj) == '2'
            type = Subject_Infomation(ii).stimu_sig(jj) - '0'+1;
            Subject_Infomation(ii).rare_total_type(type) = Subject_Infomation(ii).rare_total_type(type) +1;
            if Subject_Infomation(ii).is_correct(jj) == 1
                Subject_Infomation(ii).rare_correct_type(type) = Subject_Infomation(ii).rare_correct_type(type) + 1;
                if Subject_Infomation(ii).groupID == 'Control'
                    Control_RareCorrectType(type) = Control_RareCorrectType(type) + 1;
                end
                if Subject_Infomation(ii).groupID == 'Patient'
                    Patient_RareCorrectType(type) = Patient_RareCorrectType(type) + 1;
                end
            end
        end
    end
    for kk = 1:26
        Subject_Infomation(ii).freq_total_probability(kk) = Subject_Infomation(ii).freq_total_type(kk)/Subject_Infomation(ii).freq;
        FreqTotalType(kk) =  Subject_Infomation(ii).freq_total_type(kk) +  FreqTotalType(kk);
        if Subject_Infomation(ii).groupID == 'Control'
            Control_FreqTotalType(kk) = Control_FreqTotalType(kk) + Subject_Infomation(ii).freq_total_type(kk);
        end
        if Subject_Infomation(ii).groupID == 'Patient'
            Patient_FreqTotalType(kk) = Patient_FreqTotalType(kk) + Subject_Infomation(ii).freq_total_type(kk);
        end
    end
    for kk = 1:10
        Subject_Infomation(ii).rare_total_probability(kk) = Subject_Infomation(ii).rare_total_type(kk)/Subject_Infomation(ii).rare;
        RareTotalType(kk) =  Subject_Infomation(ii).rare_total_type(kk) +  RareTotalType(kk);
        if Subject_Infomation(ii).groupID == 'Control'
           Control_RareTotalType(kk) = Control_RareTotalType(kk) + Subject_Infomation(ii).rare_total_type(kk);
        end
        if Subject_Infomation(ii).groupID == 'Patient'
           Patient_RareTotalType(kk) = Patient_RareTotalType(kk) + Subject_Infomation(ii).rare_total_type(kk);
        end
    end
end

cur_program_log_info = 'Step 6.1 is finished.';
cur_program_time = datestr(now);
fp=fopen(strcat(wordir,'logfile.txt'),'a+');
fprintf(fp,'%s\t%s\n',cur_program_log_info,cur_program_time);
fclose(fp);

%% =============6.2 Draw the spectrum as histogram=================
Accuracy_grid_freq_type = [ ];
for ii = 1:26
    Control_FreqTotalType_Accuracy(ii) = Control_FreqCorrectType(ii)/Control_FreqTotalType(ii);
    Patient_FreqTotalType_Accuracy(ii) = Patient_FreqCorrectType(ii)/Patient_FreqTotalType(ii);
    Accuracy_grid_freq_type = [Control_FreqTotalType_Accuracy(ii) Patient_FreqTotalType_Accuracy(ii);Accuracy_grid_freq_type];
end
Accuracy_grid_freq_type_bar = bar(Accuracy_grid_freq_type);
set(gca,'XTickLabel',{'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'});
set(gca,'XTick',1:26);
legend('Control','Patient');
xlabel('Stimulus Type');
ylabel('Accuracy');
set(gca,'YLim',[0 1.1]);
title('Accuracy between Control and Patient among Stimulus');
set(gcf,'unit','centimeters','position',[10 5 20 15]);
grid on;
saveas(gcf,strcat(wordir,'result_fig\Accuracy_freq_stimulus.jpg'));

Accuracy_grid_rare_type = [ ];
for ii = 1:10
    Control_RareTotalType_Accuracy(ii) = Control_RareCorrectType(ii)/Control_RareTotalType(ii);
    Patient_RareTotalType_Accuracy(ii) = Patient_RareCorrectType(ii)/Patient_RareTotalType(ii);
    Accuracy_grid_rare_type = [Control_RareTotalType_Accuracy(ii) Patient_RareTotalType_Accuracy(ii);Accuracy_grid_rare_type];
end
Accuracy_grid_rare_type_bar = bar(Accuracy_grid_rare_type);
set(gca,'XTickLabel',{'0','1','2','3','4','5','6','7','8','9'});
set(gca,'XTick',1:10);
legend('Control','Patient');
xlabel('Stimulus Type');
ylabel('Accuracy');
set(gca,'YLim',[0 1.1]);
title('Accuracy between Control and Patient among Stimulus');
set(gcf,'unit','centimeters','position',[10 5 20 15]);
grid on;
saveas(gcf,strcat(wordir,'result_fig\Accuracy_rare_stimulus.jpg'));

cur_program_log_info = 'Step 6.2 is finished.';
cur_program_time = datestr(now);
fp=fopen(strcat(wordir,'logfile.txt'),'a+');
fprintf(fp,'%s\t%s\n',cur_program_log_info,cur_program_time);
fclose(fp);

%% ===============7. Spectrum of RT among Stimulus=================

%% ========7.1 RT between Control and Patient among stimulus=======
Control_FreqTotalType_RT = zeros(1,26);
Patient_FreqTotalType_RT = zeros(1,26);
Control_RareTotalType_RT = zeros(1,10);
Patient_RareTotalType_RT = zeros(1,10);

Control_FreqTotalType_RT_Num = zeros(1,26); 
Patient_FreqTotalType_RT_Num = zeros(1,26); 
Control_RareTotalType_RT_Num = zeros(1,10);
Patient_RareTotalType_RT_Num = zeros(1,10);

Ave_Control_FreqTotalType_RT = zeros(1,26);
Ave_Patient_FreqTotalType_RT = zeros(1,26);
Ave_Control_RareTotalType_RT = zeros(1,10);
Ave_Patient_RareTotalType_RT = zeros(1,10);

for ii = 1:40
    for jj = 1: length(Subject_Infomation(ii).stimu_time)
        if Subject_Infomation(ii).stimu_type(jj) == '1'
            type = Subject_Infomation(ii).stimu_sig(jj) - 'a'+1;
            if Subject_Infomation(ii).groupID == 'Control'
                Control_FreqTotalType_RT(type) = Control_FreqTotalType_RT(type) + Subject_Infomation(ii).RT(jj);
                Control_FreqTotalType_RT_Num(type) = Control_FreqTotalType_RT_Num(type) +1;
            end
            if Subject_Infomation(ii).groupID == 'Patient'
                Patient_FreqTotalType_RT(type) = Patient_FreqTotalType_RT(type) + Subject_Infomation(ii).RT(jj);
                Patient_FreqTotalType_RT_Num(type) = Patient_FreqTotalType_RT_Num(type) +1;
            end
        end
        if Subject_Infomation(ii).stimu_type(jj) == '2'
            type = Subject_Infomation(ii).stimu_sig(jj) - '0'+1;
            if Subject_Infomation(ii).groupID == 'Control'
                Control_RareTotalType_RT(type) = Control_RareTotalType_RT(type) + Subject_Infomation(ii).RT(jj);
                Control_RareTotalType_RT_Num(type) = Control_RareTotalType_RT_Num(type) +1;
            end
            if Subject_Infomation(ii).groupID == 'Patient'
                Patient_RareTotalType_RT(type) = Patient_RareTotalType_RT(type) + Subject_Infomation(ii).RT(jj);
                Patient_RareTotalType_RT_Num(type) = Patient_RareTotalType_RT_Num(type) +1;
            end
        end
    end
    for kk = 1:26
        Ave_Control_FreqTotalType_RT(kk) = Control_FreqTotalType_RT(kk)/Control_FreqTotalType_RT_Num(kk);
        Ave_Patient_FreqTotalType_RT(kk) = Patient_FreqTotalType_RT(kk)/Patient_FreqTotalType_RT_Num(kk);
    end
    for kk = 1:10
        Ave_Control_RareTotalType_RT(kk) = Control_RareTotalType_RT(kk)/Control_RareTotalType_RT_Num(kk);
        Ave_Patient_RareTotalType_RT(kk) = Patient_RareTotalType_RT(kk)/Patient_RareTotalType_RT_Num(kk);
    end
end

cur_program_log_info = 'Step 7.1 is finished.';
cur_program_time = datestr(now);
fp=fopen(strcat(wordir,'logfile.txt'),'a+');
fprintf(fp,'%s\t%s\n',cur_program_log_info,cur_program_time);
fclose(fp);

%% =============7.2 Draw the spectrum as histogram=================
RT_grid_freq_type = [ ];
for ii = 1:26
    RT_grid_freq_type = [Ave_Control_FreqTotalType_RT(ii) Ave_Patient_FreqTotalType_RT(ii);RT_grid_freq_type];
end
RT_grid_freq_type_bar = bar(RT_grid_freq_type);
set(gca,'XTickLabel',{'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'});
set(gca,'XTick',1:26);
legend('Control','Patient');
xlabel('Stimulus Type');
ylabel('Time(10e-4s)');
set(gca,'YLim',[0 6300]);
title('RT between Control and Patient among Stimulus');
set(gcf,'unit','centimeters','position',[10 5 20 15]);
grid on;
saveas(gcf,strcat(wordir,'result_fig\RT_freq_stimulus.jpg'));

RT_grid_rare_type = [ ];
for ii = 1:10
    RT_grid_rare_type = [Ave_Control_RareTotalType_RT(ii) Ave_Patient_RareTotalType_RT(ii);RT_grid_rare_type];
end
RT_grid_rare_type_bar = bar(RT_grid_rare_type);
set(gca,'XTickLabel',{'0','1','2','3','4','5','6','7','8','9'});
set(gca,'XTick',1:10);
legend('Control','Patient');
xlabel('Stimulus Type');
ylabel('Time(10e-4s)');
set(gca,'YLim',[0 7200]);
title('RT between Control and Patient among Stimulus');
set(gcf,'unit','centimeters','position',[10 3 20 15]);
grid on;
saveas(gcf,strcat(wordir,'result_fig\RT_rare_stimulus.jpg'));
 
cur_program_log_info = 'Step 7.2 is finished.';
cur_program_time = datestr(now);
fp=fopen(strcat(wordir,'logfile.txt'),'a+');
fprintf(fp,'%s\t%s\n',cur_program_log_info,cur_program_time);
fclose(fp);

%% ========8. A Further exploration: Stimulation frequency=========

%% ======= 8.1 RT and Accuracy with Stimulation frequency =========
for ii = 1:40
    freq_time_posi = 1;
    rare_time_posi = 1;
    for jj = 1:length(Subject_Infomation(ii).is_correct)
        if Subject_Infomation(ii).stimu_type(jj) == '1'
            Subject_Infomation(ii).freq_iscorrect(freq_time_posi) = Subject_Infomation(ii).is_correct(jj);
            freq_time_posi = freq_time_posi + 1;
        end
        if Subject_Infomation(ii).stimu_type(jj) =='2'
            Subject_Infomation(ii).rare_iscorrect(rare_time_posi) = Subject_Infomation(ii).is_correct(jj);
            rare_time_posi = rare_time_posi + 1;
        end
    end
end

Freq_Control_Cornum = zeros(1,1024);
Freq_Patient_Cornum = zeros(1,1024);
Rare_Control_Cornum = zeros(1,256);
Rare_Patient_Cornum = zeros(1,256);

Freq_Control_CorAcc = zeros(1,1024);
Freq_Patient_CorAcc = zeros(1,1024);
Rare_Control_CorAcc = zeros(1,256);
Rare_Patient_CorAcc = zeros(1,256);

Freq_Control_RT = zeros(1,1024);
Freq_Patient_RT = zeros(1,1024);
Rare_Control_RT = zeros(1,256);
Rare_Patient_RT = zeros(1,256);

Ave_Freq_Control_RT = zeros(1,1024);
Ave_Freq_Patient_RT = zeros(1,1024);
Ave_Rare_Control_RT = zeros(1,256);
Ave_Rare_Patient_RT = zeros(1,256);

for ii = 1:1024
    for jj = 1:40
        if Subject_Infomation(jj).groupID == 'Control'
            Freq_Control_Cornum(ii) = Freq_Control_Cornum(ii) + sum(Subject_Infomation(jj).freq_iscorrect(1:ii));
            Freq_Control_RT(ii) = Subject_Infomation(jj).freq_RT(ii) + Freq_Control_RT(ii);
        end
        if Subject_Infomation(jj).groupID == 'Patient'
            Freq_Patient_Cornum(ii) = Freq_Patient_Cornum(ii) + sum(Subject_Infomation(jj).freq_iscorrect(1:ii));
            Freq_Patient_RT(ii) = Subject_Infomation(jj).freq_RT(ii) + Freq_Patient_RT(ii);
        end
    end 
    Freq_Control_CorAcc(ii) = Freq_Control_Cornum(ii)/(ii*20);
    Freq_Patient_CorAcc(ii) = Freq_Patient_Cornum(ii)/(ii*20);
    Ave_Freq_Control_RT(ii) = Freq_Control_RT(ii)/20;
    Ave_Freq_Patient_RT(ii) = Freq_Patient_RT(ii)/20;
end

for ii = 1:256
    for jj = 1:40
        if Subject_Infomation(jj).groupID == 'Control'
            Rare_Control_Cornum(ii) = Rare_Control_Cornum(ii) + sum(Subject_Infomation(jj).rare_iscorrect(1:ii));
            Rare_Control_RT(ii) = Subject_Infomation(jj).rare_RT(ii) + Rare_Control_RT(ii);
        end
        if Subject_Infomation(jj).groupID == 'Patient'
            Rare_Patient_Cornum(ii) = Rare_Patient_Cornum(ii) + sum(Subject_Infomation(jj).rare_iscorrect(1:ii));
            Rare_Patient_RT(ii) = Subject_Infomation(jj).rare_RT(ii) + Rare_Patient_RT(ii);
        end
    end 
    Rare_Control_CorAcc(ii) = Rare_Control_Cornum(ii)/(ii*20);
    Rare_Patient_CorAcc(ii) = Rare_Patient_Cornum(ii)/(ii*20);
    Ave_Rare_Control_RT(ii) = Rare_Control_RT(ii)/20;
    Ave_Rare_Patient_RT(ii) = Rare_Patient_RT(ii)/20;
end

cur_program_log_info = 'Step 8.1 is finished.';
cur_program_time = datestr(now);
fp=fopen(strcat(wordir,'logfile.txt'),'a+');
fprintf(fp,'%s\t%s\n',cur_program_log_info,cur_program_time);
fclose(fp);

%% ================== 8.2 Draw to a line ==========================
for ii = 1:64
    ave_freq_control_ac(ii) = mean(Freq_Control_CorAcc(ii:16*ii));
    ave_freq_patient_ac(ii) = mean(Freq_Patient_CorAcc(ii:16*ii));
    ave_rare_control_ac(ii) = mean(Rare_Control_CorAcc(ii:4*ii));
    ave_rare_patient_ac(ii) = mean(Rare_Patient_CorAcc(ii:4*ii));
end
figure;
ac_freq_x = [1:64];
plot(ac_freq_x,ave_freq_control_ac,'r-');
hold on;
plot(ac_freq_x,ave_freq_patient_ac,'b-');
hold on;
ac_rare_x = [1:64];
plot(ac_rare_x,ave_rare_control_ac,'r--');
hold on;
plot(ac_rare_x,ave_rare_patient_ac,'b--');
hold on;
xlabel({'Stimulus Times';'Ave per 16 times for Freq & Ave per 4 times for Rare';' '})
ylabel('Accuracy'); 
legend('FreqControlCorAcc','FreqPatientCorAcc','RareControlCorAcc','RarePatientCorAcc','Location','East');
title('Accuracy between Control and Patient among Stimulus Times');
saveas(gcf,strcat(wordir,'result_fig\Accuracy_stimulus_times.jpg'));

for ii = 1:64
    ave_freq_control_rt(ii) = mean(Ave_Freq_Control_RT(ii:16*ii));
    ave_freq_patient_rt(ii) = mean(Ave_Freq_Patient_RT(ii:16*ii));
    ave_rare_control_rt(ii) = mean(Ave_Rare_Control_RT(ii:4*ii));
    ave_rare_patient_rt(ii) = mean(Ave_Rare_Patient_RT(ii:4*ii));
end
figure(2);
rt_freq_x = [1:64];
plot(rt_freq_x,ave_freq_control_rt,'r-');
hold on;
plot(rt_freq_x,ave_freq_patient_rt,'b-');
hold on;
rt_rare_x = [1:64];
plot(rt_rare_x,ave_rare_control_rt,'r--');
hold on;
plot(rt_rare_x,ave_rare_patient_rt,'b--');
hold on;
xlabel({'Stimulus Times';'Ave per 16 times for Freq & Ave per 4 times for Rare';' '})
ylabel('Time(10e-4s)'); 
legend('AveFreqControlRT','AveFreqPatientRT','AveRareControlRT','AveRarePatientRT');
title('RT between Control and Patient among Stimulus Times');
saveas(gcf,strcat(wordir,'result_fig\RT_stimulus_times.jpg'));

cur_program_log_info = 'Step 8.2 is finished.';
cur_program_time = datestr(now);
fp=fopen(strcat(wordir,'logfile.txt'),'a+');
fprintf(fp,'%s\t%s\n',cur_program_log_info,cur_program_time);
fclose(fp);