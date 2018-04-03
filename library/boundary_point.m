function x = get_x(A, b, c)
%% Helper functions which returns
%% pre-image of a point in dF_c

%% Implementation
    % dimensions
    n = size(A, 1);
    m = size(A, 3);
    
    % result
    x = zeros(n, 1);
    
    % Ac, bc
    Ac = get_Ac(A, c);
    bc = b * c;

    % checking if Ac >= 0
    [~,p] = chol(Ac);
    if p == 1
        % if not, dF_c is empty
        error('f(x) is NOT a boundary point\n');
    end

    % checking degeneracy
    if det(Ac) == 0
        % det = 0 means that dF_c might be not a singleton
        fprintf('x and f(x) may NOT be unique!\n');
    end

    % calculating result (in any case)
    x = -pinv(Ac) * bc;
end
