%% Benchmark POLAR H6
% Polar H6: 1-lead ECG chest strap placed on sternum, recorded with HRV Logger app (Android, LG40 smartphone)
% gold standard: 3-lead ECG Brainproducts ExG BrainAmp
% electrode placement: between right clavicle and sternum, on the left side between the two lower rips, and on the right lower abdomen
% two recordings at rest on July 21, 2015
% subject: healthy young male; age: 34; BMI ~21 kg/m^2
%
% gaebler@cbs.mpg.de
% date: Jan 23, 2017

clear all
close all

datadir = 'D:\Code\Github_ECG_Polar_Test';

ecg.file = dir(fullfile(datadir,'*.eeg')); % ECG
polar.file = dir(fullfile(datadir,'*_RR.csv')); % Polar RR

for ifile = 1:2
    
    cnt = readGenericEEG_raw2(ecg.file(ifile).name(1:end-4),1,'raw'); % external function to read in Brainproducts *.eeg (ECG)
    
    ecg.data = -cnt.x;
    
    %     dlmwrite([ecg.file(ifile).name(1:end-4), '_cropped.txt'], ecg.data)
    
    [ecg.peaks,ecg.locs] = findpeaks(ecg.data,'minpeakdistance',.55*500);%.3)%1); % tweak peak detection
    
    ecg.rr = diff(ecg.locs)*2;
    ecg.rmssd = sqrt(mean(diff(ecg.rr).^2));
    
    ecg.t = 0:1/500:length(ecg.data)...
        /500-1/500;
    ecg.t_ms = ecg.t*1000;
    
    [ n1 n2 n3 polar.rr] = textread(fullfile(datadir, polar.file(ifile).name), '%s%s%s%n', 'delimiter', ',', 'headerlines', 1);
    polar.rmssd = sqrt(mean(diff(polar.rr).^2));
    
    len = min(length(polar.rr), length(ecg.rr));
    [R P] = corrcoef(polar.rr(1:len), ecg.rr(1:len));
    
    %figure, plot(polar.rr(1:len)), hold on, plot(ecg.rr(1:len), 'r')
    
    %[r, lag] = xcorr(rr,ecg.ibisea);
    
    %% calculate CROSS-CORRELATION to account for lag (as there were no markers)
    
    
    if length(polar.rr) > length(ecg.rr)
        for i = 1:10%length(rr)-length(ecg.ibisea)
            a = corrcoef(ecg.rr(1:100),...
                polar.rr(i:i+100-1));
            corrrr(i) = a(1,2);
        end
        
    else
        for i = 1:10%length(ecg.ibisea)-length(rr)
            a = corrcoef(polar.rr(1:100),...
                ecg.rr(i:i+100-1));
            corrrr(i) = a(1,2);
        end
    end
    
    %figure, plot(corrrr)
    [~,ind] = max(corrrr); % ind2 als Ort des Übereinanderlegens
    %     display(['RMSSD - ECG: ', num2str(ecg.rmssd), '; Polar: ', num2str(polar.rmssd)])
    
    if length(polar.rr) > length(ecg.rr)
        
        fig = figure;
        plot(polar.rr(ind:len), 'Linewidth', 2), hold on, plot(ecg.rr(1:len), 'r', 'Linewidth', 2), ...
            title(['Tachogram Teil ' num2str(ifile) ' - correlation Polar and ECG: r = ', num2str(max(corrrr))])
        legend('Polar H6', 'BrainAmp ECG')
        saveas(fig, ['Teil', num2str(ifile), '_correlation_Polar_ECG'])
        saveas(fig, ['Teil', num2str(ifile), '_correlation_Polar_ECG.png'])
        
    else
        
        fig = figure;
        plot(polar.rr(1:len), 'Linewidth', 2), hold on, plot(ecg.rr(ind:len), 'r', 'Linewidth', 2), ...
            title(['Tachogram Teil ' num2str(ifile) ' - correlation Polar and ECG: r = ', num2str(max(corrrr))])
        legend('Polar H6', 'BrainAmp ECG')
        
        saveas(fig, ['Teil', num2str(ifile), '_correlation_Polar_ECG'])
        saveas(fig, ['Teil', num2str(ifile), '_correlation_Polar_ECG.png'])
        
    end
    
    tmp1 = polar.rr';
    tmp2 = ecg.rr';
    
    save(fullfile(datadir, ['Polar_Teil', num2str(ifile), '_RR.txt']),  'tmp1', '-ascii')
    save(fullfile(datadir, ['ECG_Teil', num2str(ifile), '_RR.txt']),  'tmp2', '-ascii')
    
end