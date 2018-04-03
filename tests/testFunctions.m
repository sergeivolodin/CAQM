% test public functions of the library
clear all;
cd(fileparts(which(mfilename)));

% preconditions

%% is_infeasible test 1
load('../examples/maps/article_example01_R3_R3.mat');
x = [1 2 3]';
y = quadratic_map(A, b, x);
rng(10);
assert(infeasibility_oracle(A, b, y) == 0);

%% is_infeasible test 2
load('../examples/maps/article_example01_R3_R3.mat');
y = [100 -100 500]';
rng(10);
assert(infeasibility_oracle(A, b, y) == 1);

%% boundary oracle test
load('../examples/maps/article_example07_R4_R4.mat');
x = [1 2 3 4]';
y = quadratic_map(A, b, x);
d = [4 3 2 1]';
rng(10);
[t, is_in_F] = boundary_oracle(A, b, y, d);
assert(abs(t - 193.3203) < 1e-3);
assert(is_in_F == 1);

%% get_c_from_d test
load('../examples/maps/article_example07_R4_R4.mat');
x = [1 2 3 4]';
y = quadratic_map(A, b, x);
d = [4 3 2 1]';
rng(10);
c = get_c_from_d(A, b, y, d);
assert(abs(norm(c - [0.4535, -0.8288, 0.1215, -0.3045]')) < 1e-3);

%% get_c_minus test 1 (all arguments)
load('../examples/maps/article_example07_R4_R4.mat');
x = [1 1 0 0]';
y = quadratic_map(A, b, x);
rng(10);
c = get_c_minus(A, b, y, 10);
assert(norm(c - [0.3803, 0.9227, -0.0558, 0.0292]') < 1e-3);

%% get_c_minus test 2 (all arguments but iterations)
load('../examples/maps/article_example07_R4_R4.mat');
x = [1 1 0 0]';
y = quadratic_map(A, b, x);
rng(10);
c = get_c_minus(A, b, y);
assert(norm(c - [0.3803, 0.9227, -0.0558, 0.0292]') < 1e-3);

%% get_c_minus test 3 (only A, b)
load('../examples/maps/article_example07_R4_R4.mat');
x = [0 0 0 0]';
y = quadratic_map(A, b, x);
rng(10);
c1 = get_c_minus(A, b, y, 10);
rng(10);
c2 = get_c_minus(A, b);
assert(norm(c1 - c2) < 1e-3);

%% nonconvexity_certificate test 1 (all parameters)
load('../examples/maps/article_example07_R4_R4.mat');
x = [0 0 0 0]';
y = quadratic_map(A, b, x);
rng(10);
is_nonconvex = nonconvexity_certificate(A, b, y, 10);
assert(is_nonconvex == 1)

%% nonconvexity_certificate test 2 (all arguments but iterations)
load('../examples/maps/article_example07_R4_R4.mat');
x = [0 0 0 0]';
y = quadratic_map(A, b, x);
rng(10);
is_nonconvex = nonconvexity_certificate(A, b, y);
assert(is_nonconvex == 1)

%% get_c_minus test 3 (only A, b)
load('../examples/maps/article_example07_R4_R4.mat');
rng(10);
is_nonconvex = nonconvexity_certificate(A, b);
assert(is_nonconvex == 1)

%% get_c_plus test (all arguments)
load('../examples/maps/article_example07_R4_R4.mat');
rng(10);
c = get_c_plus(A, 10);
assert(min(eig(get_Ac(A, c))) > 0)
assert(norm(c - [0.6624; -0.5430; 0.3050; 0.4164]) < 1e-3)

%% get_c_plus test (only A)
load('../examples/maps/article_example07_R4_R4.mat');
rng(10);
c = get_c_plus(A);
assert(min(eig(get_Ac(A, c))) > 0)
assert(norm(c - [0.6624; -0.5430; 0.3050; 0.4164]) < 1e-3)

%% minimize_z_c (all arguments)
load('../examples/maps/article_example07_R4_R4.mat');
rng(10);
c_plus = get_max_c_plus(A);
rng(10);
z_max = get_z_max(A, b, c_plus, 10, 4);
assert(abs(z_max - 0.2046) < 1e-3);

%% minimize_z_c (w/o iterations)
load('../examples/maps/article_example07_R4_R4.mat');
rng(10);
c_plus = get_max_c_plus(A);
rng(10);
z_max = get_z_max(A, b, c_plus, 10);
assert(abs(z_max - 0.2046) < 1e-3);

%% minimize_z_c (A, b, c_plus)
load('../examples/maps/article_example07_R4_R4.mat');
rng(10);
c_plus = get_max_c_plus(A);
rng(10);
z_max = get_z_max(A, b, c_plus);
assert(abs(z_max - 0.2046) < 1e-3);