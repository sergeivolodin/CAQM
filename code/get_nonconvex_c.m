function c = get_nonconvex_c(A, b, y0, c_array, c_plus, MAXITER)
    c = [];
    n = size(A, 1);
    m = size(A, 3);

    H = get_H(A, b);

    found = 0;
    i = 0;
    
    while (~found) && (i < MAXITER)
        fprintf('%d\n', i);
        d = rand(m, 1);
        %d = d / norm(d);
        c = get_c_from_d(H, y0, d);
        if size(c, 1) == m
            if is_nonconvex(A, b, c)
                if is_new_cbad(c_array, c_plus, c)
                    found = 1;
                else
                    display('Found but old');
                end
            else
                c = [];
            end
        end
        i = i + 1;
    end
    c = c / norm(c);
end