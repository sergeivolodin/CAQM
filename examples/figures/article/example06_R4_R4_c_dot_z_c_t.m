clear all;

% changing cwd to directory of .m file
cd(fileparts(which(mfilename)));

% getting the map parameters and c_plus
load('../../maps/article_example06_R4_R4.mat');

% fixing the random seed
rng(42);

% basis: c_+A = I, c_+b = 0
[A_, b_] = change_basis(A, b, c_plus);

% set to 1 to enable output
DEBUG = 1;

% certificate values
c_start = [];

% array of all cs
c_array = [];

% array of all zs
z_value = [];

% number of values in each array
item_size = [];

% number of found c values in the certificate
i = 1;

% number of attempts to find c values using the certificate
j = 1;

% number of unique curve parts (=points want to obtain from the
% nonconvexity certificate)
N = 2;

% maximal number of attempts for the certificate
max_c_attempts = 15;

% the size of the neighbourhood of 0 in which to search for values of x
% randn is used for x generation
x_search_size = 5;

% minimal distance between c vectors s.t. they are still considered the same
% distance in terms of cminus_distance. The same constant determines if
% the trajectory made a loop (went back to where have already been to)
min_sin = 0.04;

% loop over attempts
% 2 * N because adding two directinos, forward and backward,
% and incrementing i at each direction
while i <= 2 * N
    % generating a point in R^n in the vicinity of 0
    x0_ = randn(n, 1) * x_search_size;
    
    % mapping it to R^m using the map, thus have a point inside F
    y0_ = quadratic_map(A_, b_, x0_);
    
    % obtaining array of all c values
    all_c = reshape(permute(c_array, [2 1 3]), m, []);
    
    % removing found c vectors which are zero
    all_c(:, find(sum(abs(all_c)) == 0)) = [];
    
    % running the nonconvexity certificate
    try
        [c, c_attempts] = get_c_minus(A_, b_, y0_, max_c_attempts, DEBUG);
    catch
        c = [];
    end
    
    % if not found OR found but it was already added before, discard this c
    if size(c, 1) == 0 || (size(all_c, 2) > 0 && cminus_distance(all_c, c_plus, c) < min_sin)
        fprintf('i = %d j = %d C not found\n', i, j);
        j = j + 1;
        continue
    end
    
    % projecting c to c_plus^\bot
    c = remove_component(c, c_plus);
    
    % renormalizing c
    c = c / norm(c);

    % showing c
    display(c);
    fprintf('i = %d j = %d Found c\n', i, j);
    
    % adding c as one of c_start
    c_start(:, end + 1) = c;
    
    % for two search directions (forward +1 and backward -1)
    % perform travel along c(t) curve
    for coeff = [1, -1] 
        % obtaining array of c values by travelling in a direction `coeff`
        c_item_array = c_dot_travel_single(A_, b_, c, c_plus, coeff, min_sin);
        
        % obtaining number of cs
        s = size(c_item_array, 2);
        
        % saving cs and the number of thems
        c_array(i, :, 1 : s) = c_item_array;
        item_size(i) = s;
        
        % incrementing i counter (2 times per c because have two values of
        % `coeff`
        i = i + 1;
    end
    
    % incrementing number of attempts
    j = j + 1;
end

%% Plotting c_minus

% obtain z(c) for given c
[z_value, c_ans, z_min, z_max, i_min, j_min] = get_z_array(A_, b_, c_array, item_size);

% three vectors ortohonal to c_plus used for projection 4D->3D
R = null(c_plus')';

% plotting c
hold on;
grid on;
axis equal;

% loop over data
for i = 1:(2 * N)
    % obtaining size and array of cs
    s = item_size(i);
    c_item_array = [];
    
    if s == 1
        c_item_array(:, 1) = c_array(i, :, 1)';
        c_item_array(:, 2) = c_array(i, :, 1)';
    else
        c_item_array(:, :) = c_array(i, :, 1:s);
    end
    
    % filling color based on z value
    c_item_color = [];
    %z_item_value = ((z_value(i, 1:s) - z_min) / (z_max - z_min)) .^ (0.04);
    %c_item_color(:, 1 : s) = repmat([0 0 1]', 1, s) * diag(z_item_value)...
    %    + repmat([1 0 0]', 1, s) * diag(1 - z_item_value);
    
    if rem(i, 2) == 0
        c_item_color(:, 1 : s) = repmat([.5 1 .5]', 1, s);
    else
        c_item_color(:, 1 : s) = repmat([1 0.5 0.5]', 1, s);
    end
    
    % end point: green or red (dep. on direction)
    if rem(i, 2) == 0
        c_item_color(:, end) = [0 1 0]';
    else
        c_item_color(:, end) = [1 0 0]';
    end
    c_item_color(:, 1) = [0 0 1]';
    
    % projecting in 3D
    v = R * c_item_array;

    % renormalizing c
    for j = 1:size(v, 2)
        v(:, j) = v(:, j) / norm(v(:, j));
    end
    
    % plotting path
    plot_path = line(v(1, :), v(2, :), v(3, :), 'Color', [0.7 0.7 1]');
    
    % type depends on direction
    if rem(i, 2) == 0
        plot_type = '.';
    else
        plot_type = '.';
    end
    
    % plotting c
    plot_cdot = scatter3(v(1, 2:end-1), v(2, 2:end-1), v(3, 2:end-1), 400, ...
        c_item_color(:, 2:end-1)', plot_type);
    
    % plotting end
    plot_end = scatter3(v(1, end), v(2, end), v(3, end), 1500, c_item_color(:, end)', '.');
    
    % saving plot to a variable
    if(rem(i, 2) == 0)
        plot_cdot_inv = plot_cdot;
        plot_end_inv = plot_end;
    else
        plot_cdot_forw = plot_cdot;
        plot_end_forw = plot_end;
    end
    
    % plotting initial c
    plot_begin = scatter3(v(1, 1), v(2, 1), v(3, 1), 800, c_item_color(:, 1)', '.');
end

% plotting the minimal z as a pentagram
v = R * c_ans;
v = v / norm(v);
plot_dest = scatter3(v(1), v(2), v(3), 1000, [1 0 0], 'p');

% plotting the sphere
[Sx, Sy, Sz] = sphere(32);
s=surf(Sx,Sy,Sz);
set(s, 'FaceColor', [0 0 0], 'FaceAlpha', 0.05);
set(s, 'EdgeColor', [0 0 0], 'EdgeAlpha', 0.1)

% displaying the legend
[~, objh] = legend([plot_cdot_inv, plot_cdot_forw, plot_end_inv, plot_end_forw, plot_begin, plot_dest], ...
    {'Backwards', 'Forwards', 'End backwards', 'End forwards', 'Start point (certificate)', 'Global minimum'}, ...
    'Location', 'southeast');

for i = 1:length(objh)
    if size(objh(i).Children) == 0
        continue
    end
    child = objh(i).Children(1);
    if isprop(child, 'MarkerSize')
        objh(i).Children(1).MarkerSize = 8;
    end
end

% adjusting view (az, el)
view(-37, 0);

%% plotting z(c(t))

% coefficient for removing too large z (see code below)
z_multiplier = 10;

% array for all t
all_t = [];

% array for all z
all_z = [];

% loop over data
for i = 1:(2 * N)
    % obtaining number of cs and array of cs
    s = item_size(i);
    c_item_array = [];
    
    if s == 1
        c_item_array(:, 1) = c_array(i, :, 1)';
        c_item_array(:, 2) = c_array(i, :, 1)';
    else
        c_item_array(:, :) = c_array(i, :, 1:s);
    end
    
    % z_value for this data
    z_item_value_orig = z_value(i, 1:s);
    
    % difference in c from the first point
    c_diff = c_item_array - [c_item_array(:,1) c_item_array(:,1:(s - 1))];
    
    % sum of dc1, dc2, dc3, ...
    % equal to t1, t2, t3, ...
    c_len_pos = cumsum(sqrt(diag(c_diff' * c_diff)));
    
    % removing too large values z
    % criteria: z < median(z) * multiplier
    z_threshold = median(z_item_value_orig) * z_multiplier;
    
    % need to stop plotting at s_curve to remove too large z
    [~, s_curve] = max(z_item_value_orig > z_threshold);
    if s_curve == 1
        s_curve = s;
    end
    
    fprintf('%d %d %d\n', i, s, s_curve);
    
    % current t and z(c(t)) values
    t_values = c_len_pos(1:s_curve);
    z_values = z_item_value_orig(1:s_curve);

    if(rem(i, 2) == 0)
        % 2 items done, direction -1
        direction = -1;
    else
        all_t = [];
        all_z = [];
        % 1 item done, direction +1
        direction = +1;
    end
    
    all_t(end + 1 : end + s_curve) = t_values * direction;
    all_z(end + 1 : end + s_curve) = z_values;
    
    if(rem(i, 2) == 0)
        % 2 items done, direction -1
        % sorting all
        [all_t, idx] = sort(all_t);
        all_z = all_z(idx);
        
        figure;
        plot(all_t, all_z);
        title('$z(c(t))$ curve','Interpreter','latex');
        xlabel('t','Interpreter','latex');
        ylabel('$z(c(t))$','Interpreter','latex');
        legend;
    end
end

%save('example06_c_dot.mat', 'A_', 'b_', 'c_plus', 'c_array', 'item_size', 'A', 'b', 'c_start', 'z_value', 'R', 'v');
