function bits = quan_window(window_s, alpha, bits_depth)
value_s = window_s(:, 1);
l = length(value_s);
num_level = 2 ^ bits_depth;
bits_level = (max(value_s) - min(value_s)) / num_level;
bits = [];
% count = 0;
for i = 1 : l
    for j = 0 : num_level - 1
        guard_band_floor = min(value_s) + (j + alpha / 2) * bits_level;
        guard_band_top = min(value_s) + (j + 1 - alpha / 2) * bits_level;
        if value_s(i) >= guard_band_floor && value_s(i) <= guard_band_top
            bit_convert = de2bi(j);
            bit_array = padarray(bit_convert', bits_depth - length(de2bi(j)), 0, 'post');
            bit_array = bit_array';
            bit_array = fliplr(bit_array);
            bits = [bits; bit_array, window_s(i, 2)];
        end
%         count = count +1;
    end
%     fprintf('discarded count is %d\n',count)
end