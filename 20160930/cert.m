clear all;

n = 3;

A(:, :, 1) = [1 0 0; 0 0 0; 0 0 1];
A(:, :, 2) = [1 0 0; 0 0 0; 0 0 0];
A(:, :, 3) = [0 1 0; 0 0 0; 0 0 0];

sz = size(A);
m = sz(3);
n = sz(1);

c = [1 -1 0]';

Ac = GetAc(A, c);
r = rank(Ac);

found = 0;

assert(rank(Ac) == n - 2);
disp('RgAc = n - 2');

[V,D] = eig(Ac);
% disp(D);
% eigenvectors e^1, e^2:
    
e1 = V(:, 1);
e2 = V(:, 2);
disp(e1');
disp(e2');
assert(D(1,1) == 0 && D(2,2) == 0)
    
for i = 3:n
    assert(D(i, i) >= 0);
end
disp('Ac >= 0');

R(:, 1) = fxy(A, e1, e1);
R(:, 2) = fxy(A, e2, e2);
R(:, 3) = fxy(A, e1, e2);

disp(R);

assert(rank(R) >= 2);

disp('Nonconvexity detected');