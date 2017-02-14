clear all;

% generating a map
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

% basis: c_+A=I, c_+b=0
[A_, b_] = change_basis(A, b, c_plus);

% a point inside F
x0_ = rand(n, 1);
y0_ = quadratic_map(A_, b_, x0_);

% c, s.t. Theorem 3.4 holds
display('=== Looking for c_bad ===');

[~, c] = get_nonconvex_c(A_, b_, y0_, 1000);

% minimizing z(c)
display('=== Minimizing z(c) ===');

[z, c_array, ~, success] = minimize_z_c(A_, b_, c, c_plus, 0.08, 1);

if success == 0
    display('Minimization failed');
    return
end

display(z);