clear all;

% loading map
load('./maps/article_example04_C2_R4.mat');

y0 = quadratic_map(A, b, [0 0]');

%% using random c_+ search

rng(2);

min_dist = 100;
c_plus_best = [];

for i=1:10000
    c_plus = get_c_plus(A);
    c_plus = c_plus / norm(c_plus);
    y = quadratic_map(A, b, boundary_point(A, b, c_plus));
    dist = norm(y - y0);
    cos_alpha = (c_plus' * (y0 - y)) / dist;
    h = dist * sqrt(1 - cos_alpha ^ 2);
    z = dist * cos_alpha;
    fprintf('min=%f h=%f z=%f\n', min_dist, h, z);
    if h < min_dist
        min_dist = h;
        c_plus_best = c_plus;
    end
end

%%
c_plus = c_plus_best;
y = quadratic_map(A, b, boundary_point(A, b, c_plus));
dist = norm(y - y0);
cos_alpha = (c_plus' * (y0 - y)) / dist;
h = dist * sqrt(1 - cos_alpha ^ 2);
z = dist * cos_alpha;
save('cplex4.mat', 'c_plus', 'z', 'h');

return;
%% using boundary oracle
y0 = quadratic_map(A, b, [0.01 1]');
d = [0 0 1 1]';
for i=1:100
    % (c,d) < 0!
    disp(boundary_oracle(A, b, y0, d));
    c_d = get_c_from_d(A, b, y0, d);
    disp(d' * c_d);
    d = d + c_d / 100;
    d = d / norm(d);
end