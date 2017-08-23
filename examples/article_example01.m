clear all;

n = 3;
m = 3;

A(:, :, 1) = [1 1 1; 1 2 0; 1 0 2];
A(:, :, 2) = [3 -1 0; -1 0 -1; 0 -1 1];
A(:, :, 3) = eye(n);

b(:, 1) = [1 1 1]';
b(:, 2) = [1 0 -1]';
b(:, 3) = [0 0 0]';

disp('1. The map R4->R4');
for i = 1:n
    fprintf('A_%d = %s\n', i, mat2str(A(:, :, i)));
end

for i = 1:n
    fprintf('b_%d = %s\n', i, mat2str(b(:, i)));
end

%%
c_plus = [0 0 1]';

fprintf('2. c_+ = %s\n', mat2str(c_plus));

%%
rand_seed = 42;
rng(rand_seed);
fprintf('3. Random seed set to %d\n', rand_seed);

%%
fprintf('4. Finding convex cut\n');
z_max = get_z_max(A, b, c_plus, 0.2, 200, 1);

fprintf('Result: convex cut of size %f\n', z_max);