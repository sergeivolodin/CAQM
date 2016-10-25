clear all

% example set
n = 3;
m = 3;
A(:, :, 1) = [1 1 1; 1 2 0; 1 0 2];
A(:, :, 2) = [3 -1 0; -1 0 -1; 0 -1 1];
A(:, :, 3) = eye(n, n);

b(:, 1) = [1 1 1];
b(:, 2) = [1 0 -1];
b(:, 3) = [0 0 0];

% TODO: check infeasibility of y0

% c, s.t. Theorem 3.4 holds
%c = get_nonconvex_c(A, b, y0, 1000);

% c, s.t. c * A > 0
c_plus = get_c_plus(A);

% A_+ = c_+ * A
[A_, b_] = change_basis(A, b, c_plus);

% a point inside F
x0_ = [1; 2; 3];
y0_ = quadratic_map(A_, b_, x0_);

c = get_nonconvex_c(A_, b_, y0_, 100);

while 1
Ac = get_Ac(A_, c);
[q1, q2] = eig(Ac);
lambda_min = q2(1, 1);
x_0 = q1(:, 1);
Q = Ac - lambda_min;
b_c = b_ * c;
eps0 = 1e-7;
Q_inv = pinv(Q, lambda_min * 2);
v = Q_inv * b_c;

z = norm(v) ^ 3;
fprintf('z=%f\n', z);

dz_dc = zeros(m, 1);
n = zeros(m, 1);

for i = 1:m
    R = A_(:, :, i) - x_0' * A_(:, :, i) * x_0;
    dz_dc(i) = 2 * v' * Q_inv * (b_(:, i) - R * v);
    n(i) = (b_(:, i)' - v' * R) * x_0;
end

if norm(dz_dc) < eps0
    break
end

delta_c = -dz_dc * 0.001;
n = n / norm(n);

c_1 = c + delta_c - n * dot(delta_c, n);

lambda_0 = norm(c_1 - c) * 10;

l = -lambda_0;
r = lambda_0;

while (r - l) > 0
    center = (r + l) / 2;
    sign_c = sign(get_m(A_, b_, c_1, n, x_0, center));
    sign_p = sign(get_m(A_, b_, c_1, n, x_0, r));
    sign_m = sign(get_m(A_, b_, c_1, n, x_0, l));
    
    value = get_m(A_, b_, c_1, n, x_0, center);
    
    if abs(value) < eps0
        break;
    end
    
    if ~(sign_c == sign_p)
        l = center;
    elseif ~(sign_c == sign_m)
        r = center;
    else
        display('Error: all signs equal');
        break;
    end
    
    %fprintf('l = %f r = %f val = %f\n', l, r, value);
end

lambda = (l + r) / 2;
c_new = c_1 + lambda * n;
c_new = c_new / norm(c_new);
c = c_new;
end