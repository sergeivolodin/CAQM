clear all

% getting an image

load('example01.mat');

% basis: c_+A=I, c_+b=0
[A_, b_] = change_basis(A, b, c_plus);

DEBUG = 1;

c_start = [];
c_array = [];
z_value = [];

item_size = [];

i = 1;
j = 1;
N = 1;

max_c_attempts = 20;
x_search_size = 1;
item_size = [];
c_array = [];

min_sin = 0.04;

while i <= 2 * N
    % a point inside F
    x0_ = rand(n, 1) * x_search_size;
    y0_ = quadratic_map(A_, b_, x0_);
    
    all_c = reshape(permute(c_array, [2 1 3]), m, []);
    all_c(:, find(sum(abs(all_c)) == 0)) = [];
    
    [c, c_attempts] = get_c_minus(A_, b_, y0_, max_c_attempts, DEBUG);
    if size(c, 1) == 0 || (size(all_c, 2) > 0 && cminus_distance(all_c, c_plus, c) < min_sin)
        fprintf('i = %d j = %d C not found\n', i, j);
        j = j + 1;
        continue
    end
    c = remove_component(c, c_plus);
    c = c / norm(c);

    display(c);
    c_start(:, end + 1) = c;
    
    fprintf('i = %d j = %d Found c\n', i, j);
    
    for coeff = [1, -1] 
        c_item_array = c_dot_travel_single(A_, b_, c, c_plus, coeff, min_sin);
        s = size(c_item_array, 2);
        c_array(i, :, 1 : s) = c_item_array;
        item_size(i) = s;
        i = i + 1;
    end
    j = j + 1;
end

%% plot all c
% obtain z(c) for given c
[z_value, c_ans, z_min, z_max, i_min, j_min] = get_z_array(A_, b_, c_array, item_size);

% drawing C_bad
% projecting 4D to 3D

% three vectors ortohonal to c_plus
R = null(c_plus')';

hold on;
grid on;

axis equal;

for i = 1:(2 * N)
    s = item_size(i);
    c_item_array = [];
    
    if s == 1
        c_item_array(:, 1) = c_array(i, :, 1)';
        c_item_array(:, 2) = c_array(i, :, 1)';
    else
        c_item_array(:, :) = c_array(i, :, 1:s);
    end
    
    c_item_color = [];
    z_item_value = ((z_value(i, 1:s) - z_min) / (z_max - z_min)).^(1/10);
    c_item_color(:, 1 : s) = repmat([0.5 0.5 1]', 1, s) * diag(z_item_value)...
        + repmat([1 0.5 0.5]', 1, s) * diag(1 - z_item_value);
    if rem(i, 2) == 0
        c_item_color(:, end) = [0 1 0]';
    else
        c_item_color(:, end) = [1 0 0]';
    end
    c_item_color(:, 1) = [0 0 1]';
    
    v = R * c_item_array;

    for j = 1:size(v, 2)
        v(:, j) = v(:, j) / norm(v(:, j));
    end
    
    plot_path = line(v(1, :), v(2, :), v(3, :), 'Color', [0.7 0.7 1]');
    
    if rem(i, 2) == 0
        plot_type = 's';
    else
        plot_type = 'd';
    end
    
    plot_cdot = scatter3(v(1, 2:end-1), v(2, 2:end-1), v(3, 2:end-1), 36, ...
        c_item_color(:, 2:end-1)', plot_type);
    
    plot_end = scatter3(v(1, end), v(2, end), v(3, end), 1500, c_item_color(:, end)', '.');
    
    if(rem(i, 2) == 0)
        plot_cdot_inv = plot_cdot;
        plot_end_inv = plot_end;
    else
        plot_cdot_forw = plot_cdot;
        plot_end_forw = plot_end;
    end
    
    plot_begin = scatter3(v(1, 1), v(2, 1), v(3, 1), 800, c_item_color(:, 1)', '.');
end

v = R * c_ans;
v = v / norm(v);
plot_dest = scatter3(v(1), v(2), v(3), 1000, [1 0 0], 'p');

[Sx, Sy, Sz] = sphere(32);
s=surf(Sx,Sy,Sz);
set(s, 'FaceColor', [0 0 0], 'FaceAlpha', 0.1);
set(s, 'EdgeColor', [0 0 0], 'EdgeAlpha', 0.3)

legend([plot_path, plot_cdot_inv, plot_cdot_forw, plot_end_inv, plot_end_forw, plot_begin, plot_dest], {'Path', 'Backwards', 'Forwards', 'End backwards', 'End forwards', 'Start point (certificate)', 'Global minimum'});

%% z(c(t))
z_multiplier = 3;

for i = 1:(2 * N)
    s = item_size(i);
    c_item_array = [];
    
    if s == 1
        c_item_array(:, 1) = c_array(i, :, 1)';
        c_item_array(:, 2) = c_array(i, :, 1)';
    else
        c_item_array(:, :) = c_array(i, :, 1:s);
    end
    
    z_item_value_orig = z_value(i, 1:s);
    c_diff = c_item_array-[c_item_array(:,1) c_item_array(:,1:(s - 1))];
    c_len_pos = cumsum(sqrt(diag(c_diff' * c_diff)));
    z_threshold = median(z_item_value_orig) * z_multiplier;
    [~,s_curve] = max(z_item_value_orig > z_threshold);
    
    figure
    plot(c_len_pos(1:s_curve), z_item_value_orig(1:s_curve));
    title('z(c(t)) curve ' + string(i))
    xlabel('t')
    ylabel('z(c(t))')
end