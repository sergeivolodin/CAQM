clear all

% getting an image

load('example03.mat');

% basis: c_+A=I, c_+b=0
[A_, b_] = change_basis(A, b, c_plus);

% c, s.t. Theorem 3.4 holds
display('=== Looking for c_bad ===');

c_start = [];
c_array = [];
z_value = [];

item_size = [];

i = 1;
j = 1;
N = 40;

max_c_attempts = 20;
x_search_size = 1.5;

while i <= N
    % a point inside F
    x0_ = rand(n, 1) * x_search_size;
    y0_ = quadratic_map(A_, b_, x0_);
    
    all_c = reshape(permute(c_array, [2 1 3]), m, []);
    all_c(:, find(sum(abs(all_c)) == 0)) = [];
    
    [c_attempts, c] = get_nonconvex_c(A_, b_, y0_, max_c_attempts);
    if size(c, 1) == 0
        fprintf('i = %d j = %d C not found\n', i, j);
        j = j + 1;
        continue
    end
    c = remove_component(c, c_plus);
    c = c / norm(c);
    
    c_start(:, end + 1) = c;
    
    % minimizing z(c)
    display('=== Minimizing z(c) ===');

    [~, c_item_array, ~, success] = minimize_z_c(A_, b_, c, 0.08, 1);

    if success == 0
        display('Minimization failed');
        return;
    end

    s = size(c_item_array, 2);
    item_size(i) = s;

    c_array(i, :, 1 : s) = c_item_array;

    
    i = i + 1;
    j = j + 1;
end

z_value = [];
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
        z = get_z(A_, b_, c);
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

% drawing C_bad
% projecting 4D to 3D

% three vectors ortohonal to c_plus
R = complete_basis(c_plus)';

hold on;
grid on;

for i = 1:N
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
    c_item_color(:, end) = [1 0 0]';
    c_item_color(:, 1) = [0 0 1]';
    
    v = R * c_item_array;

    for j = 1:size(v, 2)
        v(:, j) = v(:, j) / norm(v(:, j));
    end
    
    plot_path = line(v(1, :), v(2, :), v(3, :), 'Color', [0.7 0.7 1]');
    
    plot_gd = scatter3(v(1, 2:end-1), v(2, 2:end-1), v(3, 2:end-1), 36, ...
        c_item_color(:, 2:end-1)', 'd');
    plot_end = scatter3(v(1, end), v(2, end), v(3, end), 1500, c_item_color(:, end)', '.');
    plot_begin = scatter3(v(1, 1), v(2, 1), v(3, 1), 800, c_item_color(:, 1)', '.');
end

v = R * c_ans;
v = v / norm(v);
plot_dest = scatter3(v(1), v(2), v(3), 1000, [1 0 0], 'p');

[Sx, Sy, Sz] = sphere(32);
s=surf(Sx,Sy,Sz);
set(s, 'FaceColor', [0 0 0], 'FaceAlpha', 0.05);
set(s, 'EdgeColor', [0 0 0], 'EdgeAlpha', 0.1)

legend([plot_path, plot_gd, plot_end, plot_begin, plot_dest], {'Path', 'Gradient Descent point', 'End (minimize)', 'Start point (certificate)', 'Global minimum'});