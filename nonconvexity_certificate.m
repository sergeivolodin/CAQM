function is_nonconvex = nonconvexity_certificate(A, b, y, k)
% TODO: description
%% is_nonconvex = nonconvexity_certificate(A, b, y, k)
% Certificate nonconvexity of F
% if TRUE, then the image F is nonconvex
% otherwise uncertain
% uses k iterations of get_c_minus
%
% Format for the map f:
% matrices (A_1, ..., A_m) -> tensor A(i, j, k) -- i'th row, j'th column of matrix A_k
% vectors  (b_1, ..., b_m) -> tensor b(i, j)    -- i'th element          of vector b_j
%
%% example
% 1) loading map from file
% 2) checking nonconvexity of the image F
% 3) by running get_c_minus for given y
%
% clear all;
% load('maps/real_R4_R4.mat');
% x = [1 1 0 0]';
% y = quadratic_map(A, b, x);
% nonconvexity_certificate(A, b, y, 10)
% 1

%%
    is_nonconvex = 0;

    try
        [c, ~] = get_c_minus(A, b, y, k);
    
        if size(c, 1) > 0
            is_nonconvex = 1;
        end
    catch
    end
end
