function r = is_new_cminus(c_array, c_plus, c, min_sin)
    r = 0;
    m = min_sin_cminus(c_array, c_plus, c);
    if m > min_sin
        r = 1;
    end    
end

