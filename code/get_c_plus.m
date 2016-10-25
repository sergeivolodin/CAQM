function c = get_c_plus(A)
    c = [];
    found = 0;
    m = size(A, 3);
    n = size(A, 1);
    
    cvx_clear;
    cvx_quiet true;
    
    while ~found
        display('iteration');
        p = randn(m, 1);  % random variable for diversity

        cvx_clear;
        cvx_begin
            variable c(m)
            minimize(1)
            Ac = get_Ac(A, c);
            Ac = Ac - 0.01 * eye(n);
            Ac  == semidefinite(n);
            %c' * p == 1;
         cvx_end
         
         if cvx_optval < Inf
             found = 1;
         end
    end
end