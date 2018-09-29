function r = is_nonconvex(A, b, c, check_f1_f2)
%% r = is_nonconvex(A, b, c, check_f1_f2)
% check if c is a normal vector for a hyperplane
% touching image F at nonconvex set
% see Proposition 5.1
% if check_f1_f2 == 1,
% then check if u not parallel to v (see Article)

%% initialization
    
    if nargin == 3
        check_f1_f2 = 0;
    end

    % tolerance for lambda_min = 0
    n = size(A, 1);
    m = size(A, 3);

    is_real = isreal(A) && isreal(b);
    if is_real
        assert(n >= 3);
        assert(m >= 3);
    else
        assert(n >= 2);
        assert(m >= 3);
    end
    
    % result
    r = 0;
    
    % c * b
    bc = b * c;
    
    % c * A
    Ac = get_Ac(A, c);
    
    % eigens of c * A
    [q1, q2] = eig(Ac);
    [~, q3] = sort(diag(q2));
    q1 = q1(:, q3);

    % require: c * A >= 0
    if sum(diag(q2) < 0) > 0
        return
    end
    
    % indexes: lambda < eps0
    inde = find(abs(eig(Ac)) < get_config().c_minus_lambda_min);

    % homogeneous case: just checking Rg == n - 2
    % Dropping non-collinearity test
    if norm(b) == 0
        r = rank(Ac, eps0) == 2;
        return;
    end

    % non-homogeneous case: Rg = n - 1 AND other conditions
    % simple zero eigenvalue check
    if size(inde, 1) == 1
        % zero eigenvector
        e = q1(:, inde);
        
        % check if b_c \bot e
        if abs(e' * bc + bc' * e) < get_config().c_minus_ortho
            
            if check_f1_f2 && is_real
                % e_0 from the article
                e0 = -pinv(Ac) * bc;

                % fill f_1 (u in Article) and f_2 (v in Article)
                f1 = zeros(m, 1);
                f2 = zeros(m, 1);
                for j = 1:m
                    f1(j) = e0' * A(:, :, j) * e + b(:, j)' * e;
                    f2(j) = real(e' * A(:, :, j) * e);
                end

                if is_real
                    % check in real case: Rg == 2
                    r = rank([f1'; f2'], get_config().c_minus_f1f2rank) == 2;
                else
                    % check in complex case: Rg >= 2
                    r = rank([real(f1)'; imag(f1)'; f2'], get_config().c_minus_f1f2rank) >= 2;
                end
            else
                r = 1;
            end
        end
    end
end
