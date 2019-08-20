function config = get_config()
%% config = get_config()
% Returns the configuration parameters for the library

    % Creating empty list
    config = [];

    % get_dz_dc(): tolerance for pinv() function for Q matrix
    config.Q_inv_eps = 1e-5;

    % is_c_plus(): minimal eigenvalue which is still considered > 0
    config.c_plus_min_lambda = 1e-4;

    % is_nonconvex(): maximal eigenvalue which is still considered to be 0
    config.c_minus_lambda_min = 1e-7;

    % is_nonconvex(): tolerance for rank() function in homogeneous case
    config.c_minus_h_rank = 1e-7;

    % is_nonconvex(): maximal value of scalar product of |x0 * (c * b)| s.t. they
    % are still considered orthogonal
    config.c_minus_ortho = 1e-7;

    % is_nonconvex(): tolerance for rank() function for f1 || f2 check
    config.c_minus_f1f2rank = 1e-7;

    % minimize_z_c(): (stopping criteria) minimal norm of a vector (gradient, norm)
    config.descent_min_norm = 1e-3;

    % minimize_z_c(): (stopping criteria) maximal value of z
    config.descent_max_z = 1e9;

    % minimize_z_c(): (stopping criteria) tolerance for rank(Q) check
    config.descent_rank_Q = 1e-5;

    % minimize_z_c(): (stopping criteria) minimal step in direction of the gradient
    config.descent_min_beta = 1e-15;

    % minimize_z_c(): multiplicative factor to reduce beta if projection failed, < 1
    config.descent_theta = 0.5;

    % minimize_z_c(): maximal cos between grad and n s.t. they are still
    % considered to be not parallel
    config.descent_max_cos = 1 - 1e-4;

    % project_descent(): (stopping criteria) maximal tolerable distance to C_- as value of constraint
    config.project_descent_max_dist = 1e-10;

    % project_descent(): (stopping criteria) minimal step in the direction of the gradient
    config.project_descent_min_alpha = 1e-20;

    % project_descent(): multiplicative factor to reduce alpha
    config.project_descent_theta = 0.4;

    % project(): (stopping criteria) minimal value of |r - l|
    config.project_bisection_min_rl = 1e-8;

    % project(): (stopping criteria) minimal value of distance to C_- s.t. considered inside this set
    config.project_bisection_min_value = 1e-9;

    % project(): maximal value of the initial distance to C_- s.t. projection is not attempted
    config.project_bisection_max_value = 1e-3;
end
