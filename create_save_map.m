% generating image
n = 4;
m = 4;

A = zeros(n, n, m);
b = zeros(n, m);

for i = 1:m
    A(:, :, i) = rand(n, n);
    A(:, :, i) = A(:, :, i) + A(:, :, i)';
    b(:, i) = rand(n, 1);
end

A(:, :, 1) = A(:, :, 1) + 2 * eye(n, n);

% c, s.t. c * A > 0
display('=== Looking for c+ ===');

c_plus = get_c_plus(A);

save('example.mat', 'A', 'b', 'c_plus', 'n','m');