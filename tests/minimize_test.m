clear all;

%% generating a map
n = 4;
m = 4;

% obtain print output
DEBUG = 1;

% use complex map?
is_complex = 1;

[A, b] = get_random_f(n, m, is_complex);

%% obtaining c_plus
c_plus = get_c_plus(A, DEBUG);

%% basis: c_+A=I, c_+b=0
[A_, b_] = change_basis(A, b, c_plus);


%% looking for c_-

while 1
    % generating a point inside F
    if is_complex
        x0_ = (randn(n, 1) + 1i * randn(n, 1));
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

try
    [z, c_array] = minimize_z_c(A_, b_, c, c_plus, 0.01, 2, DEBUG);
    disp(z);
catch ME
    disp('Minimization failed');
end