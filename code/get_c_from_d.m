function c = get_c_from_d(H_, y0, d)
    m = size(H_, 3);
    n = size(H_, 1) - 1;
    
    cvx_clear;
    cvx_quiet true;
    
    cvx_begin
        variable gam
        variable c(m)
        minimize(gam + dot(c, y0))
        H = zeros(size(H_(:, :, 1)));
            for i = 1:m
                H = H + c(i, 1) * H_(:, :, i);
            end
        H(end, end) = H(end, end) + gam;
        c' * d == -1;
        H == semidefinite(n + 1);
    cvx_end
    
    if cvx_optval == Inf
        c = [];
    end
end