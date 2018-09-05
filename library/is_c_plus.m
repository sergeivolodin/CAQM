function res = is_c_plus(A, c)
% USAGE
% res = is_c_plus(A, c)
% Test if c * A > 0
%%

%% test if c * A > 0
    assert(norm(c) > 0, 'c must be a non-zero vector');

    % renormalizing c
    c = c / norm(c);

    % get eigenvalues
    eigens = eig(get_Ac(A, c));

    % tolerance for being > 0
    eps = 1e-5;

    % calculating result
    res = (min(eigens > 0.0001) > 0);
end
