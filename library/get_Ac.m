function Ac = get_Ac(A, c)
%% Ac = get_Ac(A, c)
% calculate Ac = c * A

%%
    % dimensions
    n = size(A, 1);
    m = size(A, 3);
    
    % filling Ac
    Ac = zeros(n, n);
    for i = 1:m
        Ac = Ac + c(i) * A(:, :, i);
    end
end