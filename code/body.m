clear all

% example set
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

display('=== Looking for c+ ===');

% c, s.t. c * A > 0
c_plus = get_c_plus(A);

% A_+ = c_+ * A
[A_, b_] = change_basis(A, b, c_plus);

% a point inside F
x0_ = rand(n, 1);
y0_ = quadratic_map(A_, b_, x0_);

display('=== Looking for c_bad ===');

% c, s.t. Theorem 3.4 holds
c = get_nonconvex_c(A_, b_, y0_, 1000);

display('=== Minimizing z(c) ===');

% minimizing z(c)
z = minimize_z_c(A_, b_, c);

display(z);