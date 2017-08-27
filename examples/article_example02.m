clear all;

n = 3;
m = 3;

A(:, :, 1) = [1 -0.25 0.5;-0.25 0 0;0.5 0 0];
A(:, :, 2) = [0 -0.25 0;-0.25 1 -0.5;0 -0.5 0];
A(:, :, 3) = [0 0 -eps;0 0 -eps;-eps -eps 1];

b(:, 1) = [-0.75 0 0]';
b(:, 2) = [0 0.25 0]';
b(:, 3) = [0 0 -0.5];

disp('1. The map R3->R3');
for i = 1:n
    fprintf('A_%d = %s\n', i, mat2str(A(:, :, i)));
end

for i = 1:n
    fprintf('b_%d = %s\n', i, mat2str(b(:, i)));
end

%%
c_plus = [0.5 0.5 0.25]';
c_plus = c_plus / norm(c_plus);

fprintf('2. c_+ = %s\n', mat2str(c_plus));

%%
rand_seed = 44;
rng(rand_seed);
fprintf('3. Random seed set to %d\n', rand_seed);

%%
fprintf('4. Finding convex cut\n');
z_max = get_z_max(A, b, c_plus, 0.5, 200, 1);

fprintf('Result: convex cut of size %f\n', z_max);