clear all

% example set
n = 3;
m = 3;
%A(:, :, 1) = [1 1 1; 1 2 0; 1 0 2];
%A(:, :, 2) = [3 -1 0; -1 0 -1; 0 -1 1];
%A(:, :, 3) = eye(n, n);

%b(:, 1) = [1 1 1];
%b(:, 2) = [1 0 -1];
%b(:, 3) = [0 0 0];

A(:, :, 1) = sqrt(2) * [1 0 0 ; 0 0 0; 0 0 0.5];
A(:, :, 2) = sqrt(2) * [0 -1 0; -1 0 0; 0 0 -0.5];
A(:, :, 3) = sqrt(2) * [0 0 0 ; 0 1 0; 0 0 0.5];
b(:, 1) = [0 0 1];
b(:, 2) = [0 0 0];
b(:, 3) = [0 0 -1];

% TODO: check infeasibility of y0

% c, s.t. Theorem 3.4 holds
%c = get_nonconvex_c(A, b, y0, 1000);

% c, s.t. c * A > 0
%c_plus = get_c_plus(A);
%c_plus = [3.5604, 2.2273, 2.4196]';

% A_+ = c_+ * A
c_plus = [1; 0; 1]/sqrt(2);
[A_, b_] = change_basis(A, b, c_plus);

% a point inside F
x0_ = [1; -2; 3];
y0_ = quadratic_map(A_, b_, x0_);

c = get_nonconvex_c(A_, b_, y0_, 1000);

c

while 1
Ac = get_Ac(A_, c);
[q1, q2] = eig(Ac);
[q2, q3] = sort(diag(q2));
q1 = q1(:, q3);
q2 = diag(q2);
lambda_min = q2(1, 1);
x_0 = q1(:, 1);
Q = Ac - lambda_min * eye(n);
b_c = b_ * c;
eps0 = 1e-7;
Q_inv = pinv(Q, 1e-5);
v = Q_inv * b_c;

z = norm(v) ^ 2;
fprintf('norm=%f z=%f c=%f %f %f\n', norm(Q_inv), z, c(1), c(2), c(3));

dz_dc = zeros(m, 1);
normal = zeros(m, 1);

for i = 1:m
    R = A_(:, :, i) - eye(n) * (x_0' * A_(:, :, i) * x_0);
    dz_dc(i) = 2 * v' * Q_inv * (b_(:, i) - R * v);
    normal(i) = (b_(:, i)' - v' * R) * x_0;
end

if norm(dz_dc) < eps0
    break
end

delta_c = -dz_dc * 0.01;
normal = normal / norm(normal);

if abs(dot(delta_c, normal)) / norm(delta_c) >= (1-eps0)
    display('gradient parallel normal')
    break;
end

c_1 = c + delta_c - normal * dot(delta_c, normal);

lambda_0 = norm(c_1 - c) * 10;

l = -lambda_0;
r = lambda_0;

while (r - l) > 0
    center = (r + l) / 2;
    sign_c = sign(get_m(A_, b_, c_1, normal, x_0, center));
    sign_p = sign(get_m(A_, b_, c_1, normal, x_0, r));
    sign_m = sign(get_m(A_, b_, c_1, normal, x_0, l));
    
    value = get_m(A_, b_, c_1, normal, x_0, center);
    
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
c_new = c_1 + lambda * normal;
c_new = c_new / norm(c_new);
c = c_new;

if abs(lambda) < eps0
    break
end

fprintf('lambda=%f\n', lambda);
break;
end