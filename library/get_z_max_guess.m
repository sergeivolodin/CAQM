function z_max_guess = get_z_max_guess(A, c_plus)
    % TODO: readme
    z_max_guess = 10 * trace(get_Ac(A, c_plus));
end
