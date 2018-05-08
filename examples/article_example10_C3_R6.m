% dimensions
n = 3;
m = 6;

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
c_plus

%% infeasibility for random pt
r = [];
for j = 1 : 10
    r(end + 1) = infeasibility_oracle(A, b, randn(m, 1));
end

disp('Random points inside ' + string(round(mean(r * 100), 1)) + '%')

%% infeasibility for point in F
rng(10);
for j = 1 : 10
    res = infeasibility_oracle(A, b, quadratic_map(A, b, randn(n, 1)));
    if res == 1
        error('Infeasibility oracle error');
    else
        fprintf('.');
    end
end
disp('Infeasibility test OK');

%% boundary oracle
d = -[1,2,3,4,5,6]';
y = [0 0 0 0 0,0]';
boundary_oracle(A, b, y, d)
% 1.9927

%% c from d
get_c_from_d(A, b, y, d)
% some out

%% c minus
rng(10);
get_c_minus(A, b)
% some c

%% certificate
rng(10);
nonconvexity_certificate(A, b)

%% zmax
z_max_guess = 0.1;
z_max = get_z_max(A, b, c_plus, z_max_guess, 100, 1);
z_max