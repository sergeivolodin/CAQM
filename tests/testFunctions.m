% test public functions of the library
clear all;

% changing cwd to directory of .m file
cd(fileparts(which(mfilename)));

% preconditions

%% is_infeasible test 1
load('../examples/maps/article_example01_R3_R3.mat');
x = [1 2 3]';
y = quadratic_map(A, b, x);
assert(infeasibility_oracle(A, b, y) == 0);


%% is_infeasible test 2
load('../examples/maps/article_example01_R3_R3.mat');
y = [100 -100 500]';
assert(infeasibility_oracle(A, b, y) == 1);

%% boundary oracle test
load('../examples/maps/article_example07_R4_R4.mat');
x = [1 2 3 4]';
y = quadratic_map(A, b, x);
d = [4 3 2 1]';
[t, is_in_F] = boundary_oracle(A, b, y, d);
assert(abs(t - 193.3203) < 1e-3);
assert(is_in_F == 1);

%% get_c_from_d test
load('../examples/maps/article_example07_R4_R4.mat');
x = [1 2 3 4]';
y = quadratic_map(A, b, x);
d = [4 3 2 1]';
c = get_c_from_d(A, b, y, d);
assert(abs(norm(c) - 1.3622) < 1e-3);
