function [key1, key2] = tkg_new(input1, input2, alpha, bits_depth, w_size_q)

q_setting = 1;
re_setting = 1;

Fs = 50;
f_cutoff = 10;

w_size_expmovavg = 30;

% %% LPF
% bcutoff = f_cutoff / (Fs / 2);
% [filtB,filtA] = butter(4, bcutoff, 'low');
% input1 = filtfilt(filtB, filtA, input1);
% input2 = filtfilt(filtB, filtA, input2);
% 
% %% Moving average
% input_exp = tsmovavg(input1, 'e', w_size_expmovavg, 1);
% input1 = input_exp(w_size_expmovavg:end);
% input_exp = tsmovavg(input2, 'e', w_size_expmovavg, 1);
% input2 = input_exp(w_size_expmovavg:end);

%% Quantization Methods Selection
l = length(input1);
if l > 1
    switch q_setting
        case 0 % Linear
        case 1 % Pairwise Linear
            input1(1:l-1, :) = input1(1:l-1, :) + input1(2:l, :);
            input1 = input1(1:l-1, :);
            input2(1:l-1, :) = input2(1:l-1, :) + input2(2:l, :);
            input2 = input2(1:l-1, :);
        case 2 % Exponential
            input1 = exp(input1);
            input2 = exp(input2);
        case 3 % Pairwise Exponential
            input1(1:l-1, :) = exp(input1(1:l-1, :)) + exp(input1(2:l, :));
            input1 = input1(1:l-1, :);
            input2(1:l-1, :) = exp(input2(1:l-1, :)) + exp(input2(2:l, :));
            input2 = input2(1:l-1, :);
    end
end


%% Quantization Windows
l = length(input1);
n_i = 1:l;
input1 = [input1, n_i'];
input2 = [input2, n_i'];
% w_size_q = l;
a_bits = [];
b_bits = [];
for i = 1 : w_size_q : l - w_size_q + 1
    window_a = input1(i:i + w_size_q - 1, :);
    window_b = input2(i:i + w_size_q - 1, :);
    a_bits_w = quan_window(window_a, alpha, bits_depth);
    b_bits_w = quan_window(window_b, alpha, bits_depth);
    
%     figure
%     plot(window_a);
    a_bits = [a_bits; a_bits_w];
    b_bits = [b_bits; b_bits_w];
end




%% Quantization Reconcilliation
if ~isempty(a_bits) && ~isempty(b_bits)
    if re_setting == 1
        [~, a_i, b_i] = intersect(a_bits(:, (bits_depth + 1)), b_bits(:, (bits_depth + 1)));
        b_bits = b_bits(b_i, :);
        a_bits = a_bits(a_i, :);
    end
    a_bits = a_bits(:, 1:bits_depth);
    b_bits = b_bits(:, 1:bits_depth);
    a_bits = a_bits(:);
    b_bits = b_bits(:);
end
key1 = a_bits;
key2 = b_bits;