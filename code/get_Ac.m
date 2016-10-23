function Ac = get_Ac(A, c)
    n = size(A, 1);
    Ac = zeros(n, n);
    for i = 1:n
        Ac = Ac +  c(i) * A(:, :, i);
    end
end