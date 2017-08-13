clear all;
load('output/example01_c_dot.mat');
id = 1;
N = item_size(id);
m = size(c_array, 2);
c_item_array = reshape(c_array(id, :, 1:N), [m, N]);
z_item_value = z_value(id, 1:N);

c_dot_array = c_item_array;
c_dot_prev = zeros(m, 1);

for i=1:N
    c = c_item_array(:, i);
    [Q, Q_inv, x_0, v, lambda, z, dz_dc, normal, normal_im, drho_dc] = get_dz_dc(A_, b_, c);
    cminus_distance_c = x_0' * (b_ * c);
    cos_theta = dot(normal, dz_dc) / norm(dz_dc) / norm(normal);

    c_dot = null([normal c_plus c]');
    c_dot = c_dot / norm(c_dot);
    if dot(c_dot, c_dot_prev) < 0
        c_dot = -c_dot;
    end
    c_dot_prev = c_dot;
    c_dot_array(:, i) = c_dot;
   
    display(c_dot');

    fprintf('C_bad step cos=%f Q_norm=%f Rank_Q=%d z(c)=%f c=[%f %f %f] lambda=%f distance=%f\n', cos_theta, ...
        norm(Q_inv), rank(Q, 1e-5), z, c(1), c(2), c(3), lambda, cminus_distance_c);
end

start_id = N - 3;
dist_to_end = norm(c_item_array(:, N)-c_item_array(:, start_id));
c = c_item_array(:, start_id);
max_step = dist_to_end / 3;

K = 20;
for i=0:K
    step_size = i * max_step / K;
    delta_c = c_dot_array(:, start_id) * step_size;
    [c_new, lambda] = project_descent(A_, b_, c + delta_c, normal, normal, 1);
    c_item_array(:, end + 1) = c_new;
    c_new_dist_to_end = norm(c_new-c_item_array(:,N));
    fprintf('iteration %d step_size %f dist %f\n', i, step_size, c_new_dist_to_end);
end

N_new = size(c_item_array, 2);

c_item_array_p = R * c_item_array;
c_dot_array_p = (R * c_dot_array);

hold on;
grid on;
axis equal;

%[Sx, Sy, Sz] = sphere(32);
%s=surf(Sx,Sy,Sz);
%set(s, 'FaceColor', [0 0 0], 'FaceAlpha', 0.1);
%set(s, 'EdgeColor', [0 0 0], 'EdgeAlpha', 0.3)

plot_c = plot3(c_item_array_p(1, :), c_item_array_p(2, :), c_item_array_p(3, :));
scatter3(c_item_array_p(1, :), c_item_array_p(2, :), c_item_array_p(3, :));
plot_end = scatter3(c_item_array_p(1, N + 1 : N_new), c_item_array_p(2, N + 1 : N_new), c_item_array_p(3, N + 1 : N_new), 100, [1 0 0], 'Marker', 'hexagram');
plot_c_dot = quiver3(c_item_array_p(1, 1:N), c_item_array_p(2, 1:N), c_item_array_p(3, 1:N), c_dot_array_p(1, 1:N), c_dot_array_p(2, 1:N), c_dot_array_p(3, 1:N), 1.5);
%plot_end = scatter3(c_item_array_p(1, N + 1), c_item_array_p(2, N), c_item_array_p(3, N + 1), 100, [1 0 0], 'Marker', 'hexagram');
plot_start = scatter3(c_item_array_p(1, start_id), c_item_array_p(2, start_id), c_item_array_p(3, start_id), 100, [1 0 0], 'Marker', 'diamond');

leg = legend([plot_c, plot_c_dot, plot_start, plot_end], {'$c$', '$\dot{c}$', '$c_k$', '$\hat{c}_{k+1}$'});
set(leg,'Interpreter','latex')