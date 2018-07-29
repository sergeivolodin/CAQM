function [z_value, c_ans, z_min, z_max, i_min, j_min] = get_z_array(A_, b_, c_array, item_size)
    % array for z values
    z_value = [];

    % min and max values of z(c)
    z_min = +inf;
    z_max = -inf;
    i_min = 0;
    j_min = 0;

    c = [];
    N = size(item_size, 2);
    for i = 1:N
        s = item_size(i);
        c_item_array = [];
        if s == 1
            c_item_array(:, 1) = c_array(i, :, 1)';
        else
            c_item_array(:, :) = c_array(i, :, 1:s);
        end
        for j = 1:s
            c = c_item_array(:, j);
            [~, ~, k, ~, ~, z, ~, ~, ~, ~] = get_dz_dc(A_, b_, c);
            z_value(i, j) = z;
            if z > z_max
                z_max = z;
            end
            if z < z_min
                z_min = z;
                c_ans = c;
                i_min = i;
                j_min = j;
            end
        end
    end
end