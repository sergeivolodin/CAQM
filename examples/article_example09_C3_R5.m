% dimensions
clear all;
n = 3;
m = 5;

rng(47, 'twister');

a_max = 1;
A = zeros(n, n, m);

for j = 1 : m
    A(:, :, j) = randi([-a_max a_max], n, n) + randi([-a_max a_max], n, n) * i;
    A(:, :, j) = (A(:, :, j) + A(:, :, j)');
end

% adding a bit of E to ensure existence of c_plus
A(:, :, m) = A(:, :, m) + 5 * a_max * eye(n);

b = randi([-a_max, a_max], n, m);

%% calculating c_plus
c_plus = get_c_plus(A);
disp('=== c_plus:');
disp(c_plus');

%% infeasibility for random pt
r = [];
for j = 1 : 10
    r(end + 1) = infeasibility_oracle(A, b, randn(m, 1));
end

disp('Random points inside ' + string(round(mean(r * 100), 1)) + '%')

%% infeasibility for point in F
rng(10);
fprintf('Infeasibility test: ');
for i = 1 : 10
    res = infeasibility_oracle(A, b, quadratic_map(A, b, randn(n, 1)));
    if res == 1
        error('Infeasibility oracle error');
    else
        fprintf('.');
    end
end
disp('OK');

%% boundary oracle
d = -[1,2,3,4,5]';
y = [0 0 0 0 0]';
disp('=== Boundary oracle');
t = boundary_oracle(A, b, y, d);
fprintf('t = %.5f\n\n', t);

%% c from d
disp('=== Get c from d');
c_d = get_c_from_d(A, b, y, d);
disp('c_d = ');
disp(c_d');

%% c minus
rng(10);
disp('=== c_minus');
c_minus = get_c_minus(A, b);
disp(c_minus');

%% certificate
rng(10);
disp('=== Non-convexity certificate');
result = nonconvexity_certificate(A, b);
if result == 1
    disp('Search finished. The image is non-convex.');
else
    disp('Search finished. Cannot certify non-convexity.');
end

%% zmax
disp('=== z_max');
z_max_guess = 0.1;
z_max = get_z_max(A, b, c_plus, z_max_guess, 100, 1);
fprintf('Search finished. z_max=%.15f\n', z_max);