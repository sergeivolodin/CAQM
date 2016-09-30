function cert = certificate_default(y, y0, total)

m = size(y,3);
n = size(y,1) - 1;

flag = 0;
ind = 0;


while ~flag
    ind = ind + 1;
    h = randn(m,1); h = h/norm(h);

cvx_quiet true
cvx_begin
    variable gam
    variable c(m)
    minimize(gam + dot(c,y0))
    H = zeros(size(y(:,:,1)));
        for jj = 1:m
            H = H + c(jj,1)*y(:,:,jj);
        end
    H(end,end) = H(end,end) + gam;
    c'*h == -1;
    H  == semidefinite(n+1);
cvx_end

if cvx_optval < Inf   
    e = []; d = [];
    Ac = H(1:(end-1), 1:(end-1));
     Ac = full(Ac);
    [q1,q2] = eig(Ac);
    inde = find(abs(eig(Ac))<1e-7);
    if size(inde,1)>0
        e = q1(:, inde);
        if abs(H(1:(end-1), end)'*e)<1e-6
            flag = 1;
            c_bad = c/norm(c);
            mess = 'Image is nonconvex.';
            detect = 1;
        end
    end
end

if ind == total
    flag = 1;
    mess = sprintf('Runout of %g random directions. Convexity is expected.', total);
    c_bad = NaN;
    detect = 0;
end

end

cert = struct('result', mess, 'c_bad', c_bad, 'detect', detect); 
