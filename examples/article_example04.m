clear all;

is_complex = 1;
n = 2;
m = 4;

A(:, :, 1) = [3.7, -0.6 + 0.8j;-0.6-0.8j,0];
A(:, :, 2) = [1 0;0 0];
A(:, :, 3) = [0,-0.6-0.8j;-0.6+0.8j,3.6];
A(:, :, 4) = [0,-0.8+0.6j;-0.8-0.6j,4.8];

b(:, 1) = [-1.25+1.25j;0];
b(:, 2) = [0;0];
b(:, 3) = [0;-1.2+1.6j];
b(:, 4) = [0;-1.6-1.2j];

disp('1. The map C2->R4');
for i = 1:n
    fprintf('A_%d = %s\n', i, mat2str(A(:, :, i)));
end

for i = 1:n
    fprintf('b_%d = %s\n', i, mat2str(b(:, i)));
end

%%
c_plus = get_max_c_plus(A);

fprintf('2. c_+ = %s\n', mat2str(c_plus));

%%
rand_seed = 45;
rng(rand_seed);
fprintf('3. Random seed set to %d\n', rand_seed);

%%
fprintf('4. Finding convex cut\n');
z_max = get_z_max(A, b, c_plus, 9, 300, 1);

fprintf('Result: convex cut of size %f\n', z_max);