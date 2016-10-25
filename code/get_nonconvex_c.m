function c = get_nonconvex_c(A, b, y0, MAXITER)
    c = [];
    n = size(A, 1);
    m = size(A, 3);

    H = get_H(A, b);

    found = 0;
    i = 0;
    
    while (~found) && (i < MAXITER)
        %fprintf('%d\n', i);
        d = rand(n, 1);
        %d = d / norm(d);
        c = get_c_from_d(H, y0, d);
        if size(c, 1) == m
            if is_nonconvex(A, b, c)
                found = 1;
            end
        end
        i = i + 1;
    end
    c = c / norm(c);
end