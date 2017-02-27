function H_c = get_H_c(A, b, c, y)
%% H_c = get_H_c(A, b, c, y)
% get H matrix [A_c, b_c; b_c', -(c, y)] from A, b, c, y
% see Theorem 3.2

%%
    A_c = get_Ac(A, c);
    b_c = b * c;
    
    H_c = [A_c, b_c; b_c', -(c' * y)];
end