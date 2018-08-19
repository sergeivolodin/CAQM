% this script creates a visualization of the set of nonconvexities C_-

clear all;

% changing cwd to directory of .m file
cd(fileparts(which(mfilename)));

% getting a map
load('../../maps/article_example06_R4_R4.mat');

% fixing the random seed
rng(42);

% basis: c_+A=I, c_+b=0
[A_, b_] = change_basis(A, b, c_plus);

% array for starting points
c_start = [];

% array for gradient descent points
% format:
% c_array(i, j, k) -- i'th starting point, j'th element of c, k'th vector
c_array = [];

% number of descent points for starting point
item_size = [];

% number of starting points obtained
i = 1;

% wanted number of starting points
N = 40;

% total number of iterations
j = 1;

% attempts for get_c_minus
max_c_attempts = 20;

% dispersion for generating x
x_search_size = 1.5;

% step size for minimize_z_c
% 4*32 number of pieces a circle is divided into
step_size = (2 * pi / (4 * 32));

% loop filling c_array
while i <= N
    % a point inside F
    x0_ = randn(n, 1) * x_search_size;
    y0_ = quadratic_map(A_, b_, x0_);
    
    % array of all vectors c
    all_c = reshape(permute(c_array, [2 1 3]), m, []);
    all_c(:, find(sum(abs(all_c)) == 0)) = [];
    
    % c, s.t. Theorem 3.4 holds
    display('=== Looking for c_minus ===');
    try
        [c, c_attempts] = get_c_minus(A_, b_, y0_, max_c_attempts, 1);
    catch
        fprintf('i = %d j = %d C not found\n', i, j);
        j = j + 1;
        continue
    end
    
    % projecting to (c_plus)^bot
    c = remove_component(c, c_plus);
    
    % renormalizing
    c = c / norm(c);
    
    % adding starting point to c_start
    c_start(:, end + 1) = c;
    
    % minimizing z(c)
    display('=== Minimizing z(c) ===');

    try
        [~, c_item_array, ~] = minimize_z_c(A_, b_, c, c_plus, 0.08, step_size, 1);
    catch
        display('Minimization failed');
        return;
    end

    % number of gradient descent points
    s = size(c_item_array, 2);
    
    % filling item_size with number of points
    item_size(i) = s;

    % adding obtained gd points to array
    c_array(i, :, 1 : s) = c_item_array;

    
    % number of obtained starting points
    i = i + 1;
    
    % total number of iterations
    j = j + 1;
end

% obtain z(c) for given c
[z_value, c_ans, z_min, z_max, i_min, j_min] = get_z_array(A_, b_, c_array, item_size);

% saving data
save('example06_c_minus.mat', 'N', 'item_size', 'c_array', 'z_value', 'c_ans', 'c_plus', 'z_min', 'z_max');;

%% plot the results
% draw c_minus (gradient)
hold on;
load('example06_c_minus.mat');
draw_cminus_fig(N, item_size, c_array, z_value, c_ans, c_plus, z_min, z_max)

% draw c_dot
load('example06_c_dot.mat');
N = size(item_size, 2) / 2;
for i = 1:(2 * N)
    % obtaining size and array of cs
    s = item_size(i);
    c_item_array = [];

    c_item_array(:, :) = c_array(i, :, 1:s);

    % projecting in 3D
    v = R * c_item_array;

    % renormalizing c
    for j = 1:size(v, 2)
        v(:, j) = v(:, j) / norm(v(:, j));
    end

    % plotting path
    plot_path = scatter3(v(1, :), v(2, :), v(3, :), 5, 'green');
end

[LEGH, OBJH, OUTH, OUTM] = legend; % reading handles
LEGH = legend([OUTH; plot_path], OUTM{:}, 'Whole branch', 'Location','northeast'); % append new plot

% fix view for the article
view(-37, 0);
