function [offset_1, offset_2] = find_offsets(path1, path2)

data_1 = csvread(path1,2);
data_2 = csvread(path2,2);

data_1_mag = sqrt(data_1(:, 3).^2 + data_1(:, 4).^2 +data_1(:, 5).^2);
data_2_mag = sqrt(data_2(:, 3).^2 + data_2(:, 4).^2 +data_2(:, 5).^2);

data_1_mag_filt = lowpass(data_1_mag, 3, 50);
data_2_mag_filt = lowpass(data_2_mag, 3, 50);

[pks1, loc1] = findpeaks(data_1_mag_filt, 'MinPeakHeight', 11);
[pks2, loc2] = findpeaks(data_2_mag_filt, 'MinPeakHeight', 11);

offset_1 = loc1(1);
offset_2 = loc2(1);

% x1 = 1:length(data_1_mag_filt);
% x2 = 1:length(data_2_mag_filt);
% 
% figure
% plot(x1, data_1_mag_filt, x1(loc1), data_1_mag_filt(loc1),'r*');hold on;
% plot(x2, data_2_mag_filt, x2(loc2), data_2_mag_filt(loc2),'r*');
% 
% figure
% plot(data_1_mag_filt(loc1(1):end, :));hold on;plot(data_2_mag_filt(loc2(1):end,:));




