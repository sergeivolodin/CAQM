clear all

% generating image
n = 4;
m = 4;

A(:,:,1) = eye(n);
b(:,1) = zeros(n,1);   
y(:,:,1) = [A(:,:,1), b(:,1); b(:,1)', 0];

y(:,:,2) = [1  0  1  0 1;...
            0  2 -1  4 0;...
            1 -1  0  0 0;...
            0  4  0  0 0;...
            1  0  0  0 0];
        
y(:,:,3) = [ 0  0  0  -1 1;...
             0  3 -1   0 1;...
             0 -1 -1   0 0;...
            -1  0  0  -1 0;...
             1  1  0   0 0];
        
y(:,:,4) = [4  0  1   2 0;...
             0  0  0   4 0;...
             1  0  0   0 0;...
             2  4  0  -2 1;...
             0  0  0   1 0];
for i = 1:m
    A(:, :, i) = y(1:end-1, 1:end-1, i);
    b(:, i) = y(1:end-1, end, i);
end

% c, s.t. c * A > 0
display('=== Looking for c+ ===');

%c_plus = get_c_plus(A);

c_plus = [1 0 0 0]';

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
N = 10;
while i <= N
    % a point inside F
    x0_ = rand(n, 1);
    y0_ = quadratic_map(A_, b_, x0_);
    
    c = get_nonconvex_c(A_, b_, y0_, 1000);
    
    if ~is_new_cbad(c_start, c_plus, c)
        fprintf('i = %d j = %d Processed already\n', i, j);
        j = j + 1;
        continue;
    end
    
    c_start(:, end + 1) = c;
    
    % minimizing z(c)
    display('=== Minimizing z(c) ===');

    [~, c_item_array, ~] = minimize_z_c(A_, b_, c);

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
for i = 1:N
    s = item_size(i);
    c_item_array = [];
    c_item_array(:, :) = c_array(i, :, 1:s);
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
    c_item_array(:, :) = c_array(i, :, 1:s);
    
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
    plot_gd = scatter3(v(1, 2:end-1), v(2, 2:end-1), v(3, 2:end-1), 36, c_item_color(:, 2:end-1)', 'd', 'DisplayName', 'Gradient Descent');
    plot_end = scatter3(v(1, end), v(2, end), v(3, end), 1500, c_item_color(:, end)', '.');
    plot_begin = scatter3(v(1, 1), v(2, 1), v(3, 1), 800, c_item_color(:, 1)', '.');
end

v = R * c_ans;
v = v / norm(v);
plot_dest = scatter3(v(1), v(2), v(3), 1000, [1 0 0], 'p');
legend([plot_path, plot_gd, plot_end, plot_begin, plot_dest], {'Path', 'Gradient Descent point', 'End point', 'Start point (certificate)', 'Global minimum'});