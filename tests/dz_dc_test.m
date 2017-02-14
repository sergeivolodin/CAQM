clear all;

% generating image
n = 20;
m = 20;

A = zeros(n, n, m);
b = zeros(n, m);

for i = 1:m
    A(:, :, i) = rand(n, n);
    A(:, :, i) = A(:, :, i) + A(:, :, i)';
    b(:, i) = rand(n, 1);
end

A(:, :, 1) = A(:, :, 1) + 10 * eye(n, n);

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

c_0 = get_nonconvex_c(A_, b_, y0_, 1000);

% minimizing z(c)
display('=== Minimizing z(c) ===');

for mode = 1:2
    c_1 = c_0;
    [~, ~, x_0, ~, ~, z_1, dz_dc, normal] = get_gradient_test(A_, b_, c_1, mode);

    step = dz_dc / norm(dz_dc) * 0.0001;

    %c_2 = c_1 + step;
    [c_2, ~] = project(A_, b_, c_1, x_0, step, normal);
    [~, ~, ~, ~, ~, z_2, ~, ~] = get_gradient_test(A_, b_, c_2, mode);

    delta_z_1 = z_2 - z_1;
    delta_z_2 = dot(dz_dc, c_2 - c_1);
    fprintf('mode=%f dz1=%f dz2=%f\n', mode, delta_z_1, delta_z_2);
end