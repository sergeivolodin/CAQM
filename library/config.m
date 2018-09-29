function config = get_config()
%% config = get_config()
% Returns the configuration parameters for the library
    config = [];
    config.Q_inv_eps = 1e-5;
    config.c_plus_min_lambda = 1e-4;
    config.c_minus_lambda_min = 1e-7;
    config.c_minus_ortho = 1e-7;
    config.c_minus_f1f2rank = 1e-7;
    config.descent_min_norm = 1e-3;
    config.descent_max_z = 1e9;
    config.descent_rank_Q = 1e-5;
    config.descent_min_beta = 1e-15;
    config.descent_theta = 0.5;
    config.descent_max_cos = 1 - 1e-4;
    config.project_descent_max_dist = 1e-10;
    config.project_descent_min_alpha = 1e-20;
    config.project_descent_theta = 0.4;
    config.project_bisection_min_rl = 1e-8;
    config.project_bisection_min_value = 1e-9;
    config.project_bisection_max_value = 1e-3;
end
