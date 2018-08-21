clear all;

%% This file finds a c_plus and z_max_guess for example04 such that y = y0 + c_plus * z_max_guess is close to the nonconvexity

% loading map
load('../maps/article_example04_C2_R4.mat');

%% The nonconvexity: can be obtained by boundary_point(A, b, [0 1 0 0]');, vector c_minus = [0 1 0 0]' from Mathematica (article_example04.nb)
y = quadratic_map(A, b, [0 0]');

%% using random c_+ search
rng(2);

% minimal distance to y, 
min_dist = 100;
c_plus_best = [];

% random search for c_plus
for i = 1:10000
    % getting c_plus
    c_plus = get_c_plus(A);
    c_plus = c_plus / norm(c_plus);

    % dF_c for that c=c_plus
    y0 = quadratic_map(A, b, boundary_point(A, b, c_plus));

    % distance to y
    dist = norm(y - y0);

    % cos between c_plus and y-y0
    cos_alpha = (c_plus' * (y - y0)) / dist;

    % min distance between y and line from y0 in direction c_plus
    h = dist * sqrt(1 - cos_alpha ^ 2);

    % how much to go down the line until that minimal point h
    z = dist * cos_alpha;

    % printing h, z
    fprintf('min=%f h=%f z=%f\n', min_dist, h, z);

    % updating min
    if h < min_dist
        min_dist = h;
        c_plus_best = c_plus;
    end
end

%% saving c_plus, z, h
c_plus = c_plus_best;
y0 = quadratic_map(A, b, boundary_point(A, b, c_plus));
dist = norm(y - y0);
cos_alpha = (c_plus' * (y - y0)) / dist;
h = dist * sqrt(1 - cos_alpha ^ 2);
z = dist * cos_alpha;
save('cplex4.mat', 'c_plus', 'z', 'h');
