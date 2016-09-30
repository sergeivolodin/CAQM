function c = c_search(y)

n = size(y,1) - 1;
nn = randn(3,1);  % random variable for diversity
nn = [1; zeros(n-1, 1)]; % alternative nn

cvx_begin
    variable c(n)
    minimize(1)
    Ac = zeros([n, n, 1]);
        for jj = 1:n
            Ac = Ac + c(jj,1)*y(1:n, 1:n, jj);
        end
    Ac = Ac - eye(n);
    Ac  == semidefinite(n);
    c'*nn == 1;
 cvx_end
 
 c = c/norm(c);
 
 %eig(Ac)