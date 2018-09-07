function z_max_guess = get_z_max_guess(A, c_plus)
%% z_max_guess = get_z_max_guess(A, c_plus)
% Get some heuristical initial value as a z_max guess

%%
    z_max_guess = 10 * trace(get_Ac(A, c_plus));
end
