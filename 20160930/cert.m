clear all;

n = 3;

A(:, :, 1) = [1 0 0; 0 1 0; 0 0 1];
A(:, :, 2) = [1 0 0; 0 0 0; 0 0 0];
A(:, :, 3) = eye(n);

c = [0 1 0];

Ac = zeros(n, n);
for i = 1:n
    Ac = Ac + c(i) * A(:,:,i);
end

r = rank(Ac);

found = 0;

if r == n - 2
    disp('Rank n - 2');
    [V,D] = eig(Ac);
    % disp(D);
    % eigenvectors e^1, e^2:
    
    e1 = V(:, 1);
    e2 = V(:, 2);
    assert(D(1,1) == 0 && D(2,2) == 0)
    
    % how to compute f(e1)??
end;
