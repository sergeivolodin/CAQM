function is_nonconvex = nonconvexity_certificate(A, b, y, k)
    is_nonconvex = 0;

    [c, i] = get_c_minus(A, b, y, k);
    
    if size(c, 1) > 0
        is_nonconvex = 1;
    end
end
