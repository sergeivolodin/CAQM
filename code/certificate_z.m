function cert = certificate_z(y, y0, total, c_plus, zt)

flag = 0;
n = size(y,1) - 1;
m = size(y,3);

Ap = zeros(n,n);
bp = zeros(n,1);
for k = 1:m
    Ap = Ap + c_plus(k, 1)*y(1:n, 1:n, k);
    bp = bp + c_plus(k, 1)*y(1:n, n+1, k);
end

x0 = -inv(Ap)*bp;
z0 = 0;
for k = 1:m
    z0 = z0 + c_plus(k,1)*[x0; 1]'*y(:,:,k)*[x0; 1];
end
    
if zt < z0
    mess = 'Error. z < min(c+, f)';
    flag = 1;
    detect = 2;
    c_bad = NaN;
end

% gen y0
ksi = randn(n,1);
ksi = ksi/norm(ksi);
x0 = x0 + inv(sqrtm(Ap/(zt - z0)))*ksi;

for k = 1:m
    y0(k,1) = [x0; 1]'*y(:,:,k)*[x0; 1];
end

ind = 0;
while ~flag
    ind = ind + 1;
    h = randn(n,1); h = h/norm(h);
    h = h - (h'*c_plus)*c_plus/norm(c_plus)^2; % generate h orthgonal to cp

cvx_quiet true
cvx_begin
    variable gam
    variable c(n)
    minimize(gam + dot(c,y0))
    H = zeros(size(y(:,:,1)));
        for jj = 1:n
            H = H + c(jj,1)*y(:,:,jj);
        end
    H(end,end) = H(end,end) + gam;
    c'*h == -1;
    H  == semidefinite(n+1);
cvx_end

if cvx_optval < Inf  
    e = []; d = [];
    Ac = H(1:(end-1), 1:(end-1));
    [q1,q2] = eig(Ac);
    inde = find(abs(eig(Ac))<1e-7);
    if size(inde,1)>0
        e = q1(:, inde);
        if abs(H(1:(end-1), end)'*e)<1e-6
            flag = 1;
            mess = 'Nonconvexity is detected.';
            c_bad = c/norm(c);
            detect = 1;
        end
    end
end

if ind == total
    flag = 1;
    mess = 'runout';
    c_bad = NaN;
    detect = 0;
end

end


cert = struct('result', mess, 'c_bad', c_bad, 'detect', detect); 


