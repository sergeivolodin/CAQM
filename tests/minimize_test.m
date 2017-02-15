clear all;

%% generating a map
n = 4;
m = 4;

[A, b] = get_random_f(4, 4);

%% obtaining c_plus
c_plus = get_c_plus(A);

%% basis: c_+A=I, c_+b=0
[A_, b_] = change_basis(A, b, c_plus);

%% generating a point inside F
x0_ = rand(n, 1);
y0_ = quadratic_map(A_, b_, x0_);

%% c, s.t. Theorem 3.4 holds
[~, c] = get_c_minus(A_, b_, y0_, 1000);

%% minimizing z(c)
[z, c_array, ~, success] = minimize_z_c(A_, b_, c, c_plus, 0.08, 1);

if success == 0
    display('Minimization failed');
    return
end

display(z);