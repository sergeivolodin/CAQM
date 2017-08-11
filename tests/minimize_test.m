clear all;

%% This file
% 1) generates a map or loads a map
% 2) generates a vector c_+
% 3) changes basis s.t. c_+A=I, c_+b=0
% 4) looks for c_minus
% 5) cuts convex subpart via z(c) minimization

%% generating a map
% disp('Generating map');
%n = 4;
%m = 4;
% use complex map?
%is_complex = 1;
%[A, b] = get_random_f(n, m, is_complex);

%% using saved map
disp('Loading map');

% Real case R4->R4
%load('examples/maps/real_R4_R4.mat')

% Complex case C2->R4, pre-defined c_plus
load('examples/maps/complex_C2_R4_poster.mat')

%% obtain print output
DEBUG = 1;

%% obtaining c_plus
if ~exist('c_plus')
    disp('Generating c_plus');
    % random c_plus
    %c_plus = get_c_plus(A, 10, DEBUG);

    % best c_plus
    c_plus = get_best_c_plus(A);
end

%% basis: c_+A=I, c_+b=0
disp('Changing basis');
[A_, b_] = change_basis(A, b, c_plus);

%% looking for c_-
disp('Looking for c_-');

while 1
    % generating a point inside F
    disp('Generating point inside F');
    
    if is_complex
        x0_ = ((randn(n, 1) + 1i * randn(n, 1)));
    else
        x0_ = randn(n, 1);
    end
    y0_ = quadratic_map(A_, b_, x0_);

    try
        % c, s.t. Theorem 3.4 holds
        c = get_c_minus(A_, b_, y0_, 6, DEBUG);
        break
    catch
        continue
    end
        
end

%% minimizing z(c)
disp('Minimizing z(c)');

try
    [z, c_array] = minimize_z_c(A_, b_, c, c_plus, 0.01, 2, DEBUG);
    disp(z);
catch ME
    disp('Minimization failed');
end
