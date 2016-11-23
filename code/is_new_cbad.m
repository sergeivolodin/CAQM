function r = is_new_cbad(c_array, c_plus, c, min_sin)
    n = size(c_plus, 1);
    r = 0;
    c_array = remove_component(c_array, c_plus);
    c = remove_component(c, c_plus);
    c = c / norm(c);
    N = diag(sqrt(c_array' * c_array))';
    N = repmat(N, n, 1);
    c_array = c_array ./ N;
    cos = c_array' * c;
    sin = sqrt(1 - cos.^2);
    m = min(sin);
    if m > min_sin
        r = 1;
    end    
end

