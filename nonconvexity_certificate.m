function is_nonconvex = nonconvexity_certificate(A, b, y, k)
%% is_nonconvex = nonconvexity_certificate(A, b, y, k)
% Certificate nonconvexity of F
% if TRUE, then the image F is nonconvex
% otherwise uncertain
% uses k iterations of get_c_minus

%%
    is_nonconvex = 0;

    [~, c] = get_c_minus(A, b, y, k);
    
    if size(c, 1) > 0
        is_nonconvex = 1;
    end
end
