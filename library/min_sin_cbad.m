function r = min_sin_cbad(c_array, c_plus, c)
    r = 1;
    if size(c_array, 2) == 0
        return;
    end
    n = size(c_plus, 1);
    c_array = remove_component(c_array, c_plus);
    c = remove_component(c, c_plus);
    c = c / norm(c);
    N = diag(sqrt(c_array' * c_array))';
    N = repmat(N, n, 1);
    c_array = c_array ./ N;
    cos = c_array' * c;
    sin = sqrt(1 - cos.^2);
    r = min(sin);
end