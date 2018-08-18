clear all;

% changing cwd to directory of .m file
cd(fileparts(which(mfilename)));

% loading map
load('./maps/article_example10_homog_R4_R4.mat');

% some fixed random seed
rng(42);

%% showing c_plus
disp('=== c_plus:');
disp(c_plus');

%% boundary oracle
d = -[1,2,3,4]';
y = quadratic_map(A, b, [1,2,3,4]');
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
c_minus = get_c_minus(A, b, [0, 0, 0, 1]', 10);
disp(c_minus');

%% certificate
rng(10);
disp('=== Non-convexity certificate');
result = nonconvexity_certificate(A, b, [0, 0, 0, 1]', 10);
if result == 1
    disp('Search finished. The image is non-convex.');
else
    disp('Search finished. Cannot certify non-convexity.');
end

%% zmax
disp('=== z_max');
% Warning: get_z_max doesn't work for homogeneous cases yet.
disp('z_max search for continuous homogeneous cases is not implemented yet');
%z_max_guess = 0.1;
%z_max = get_z_max(A, b, c_plus, z_max_guess, 100, 1);
%fprintf('Search finished. z_max=%.15f\n', z_max);