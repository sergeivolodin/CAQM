function Ac = get_Ac(A, c)
    n = size(A, 1);
    m = size(A, 3);
    Ac = zeros(n, n);
    for i = 1:m
        Ac = Ac + c(i) * A(:, :, i);
    end
end