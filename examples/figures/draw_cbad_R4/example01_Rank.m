clear all;

load('example03.mat');

% basis: c_+A=I, c_+b=0
[A_, b_] = change_basis(A, b, c_plus);

% complete basis
R = null(c_plus');

Phi = [];
Theta = [];
M = [];

Sx = 500;
Sy = 500;

theta_r = [0:Sx-1] * pi / Sx;
phi_r = [0:Sy-1] / Sy * 2 * pi;

for theta = theta_r
    for phi = phi_r
        c0 = [sin(theta) * cos(phi); sin(theta) * sin(phi); cos(theta)];
        c = R * c0;
        Ac = get_Ac(A_, c);
        r = eig(Ac);
        a = repmat(r, 1, 4);
        m = min(min(abs(a - a') + diag(repmat([nan], 1, 4))));
        M(end + 1) = m;
       % fprintf('m = %f\n', m);
    end
end

Z = reshape(M, Sy, Sx);

surf(theta_r, phi_r, Z);