clear all;

% changing cwd to directory of .m file
cd(fileparts(which(mfilename)));

% loading the saved data
load('example05_c_dot.mat');

% fixing the random seed
rng(42);

% c subarray to use (forw 1/back 2)
id = 1;

% loading number of cs
N = item_size(id);

% m dimension
m = size(c_array, 2);

% loading c array
c_item_array = reshape(c_array(id, :, 1:N), [m, N]);

% loading z array
z_item_value = z_value(id, 1:N);

% c_dot copy
c_dot_array = c_item_array;

% previous c_dot buffer
c_dot_prev = zeros(m, 1);

% filling c_dot array
for i=1:N
    % loading c
    c = c_item_array(:, i);

    % loading gradient
    [Q, Q_inv, x_0, v, lambda, z, dz_dc, normal, normal_im, drho_dc] = get_dz_dc(A_, b_, c);

    % distance to c__
    cminus_distance_c = x_0' * (b_ * c);

    % cos(n, grad)
    cos_theta = dot(normal, dz_dc) / norm(dz_dc) / norm(normal);

    % c_dot in Ker(n, c_+, c)
    c_dot = null([normal c_plus c]');
    c_dot = c_dot / norm(c_dot);
    if dot(c_dot, c_dot_prev) < 0
        c_dot = -c_dot;
    end

    % filling c_dot & c_dot_prev
    c_dot_prev = c_dot;
    c_dot_array(:, i) = c_dot;
   
    % showing c_dot
    display(c_dot');

    fprintf('C_bad step cos=%f Q_norm=%f Rank_Q=%d z(c)=%f c=[%f %f %f] lambda=%f distance=%f\n', cos_theta, ...
        norm(Q_inv), rank(Q, 1e-5), z, c(1), c(2), c(3), lambda, cminus_distance_c);
end

% point in the curve (N = last)
start_id = N - 5;

% distance from point to end
dist_to_end = norm(c_item_array(:, N)-c_item_array(:, start_id));

% c at this point
c = c_item_array(:, start_id);

% maximal projection distance to try
max_step = dist_to_end * 2;

% precision of forward step size
% trying to go following c_dot a bit more
K = 20;

% loop over additional forward step size
for i = 0:K
    % calculating step size
    step_size = i * max_step / K;

    % delta_c = c_dot * size
    delta_c = c_dot_array(:, start_id) * step_size;

    % projecting c + delta_c
    [c_new, lambda] = project_descent(A_, b_, c + delta_c, normal, normal, 1);

    % saving new c
    c_item_array(:, end + 1) = c_new;

    % and new distance to end
    c_new_dist_to_end = norm(c_new - c_item_array(:,N));

    % printing results
    fprintf('iteration %d step_size %f dist %f\n', i, step_size, c_new_dist_to_end);
end

% new number of items in c array
N_new = size(c_item_array, 2);

% removing c_+ component from c and c_dot
c_item_array_p = R * c_item_array;
c_dot_array_p = (R * c_dot_array);

% plotting 3d picture
hold on;
grid on;
axis equal;

% no sphere
%[Sx, Sy, Sz] = sphere(32);
%s=surf(Sx,Sy,Sz);
%set(s, 'FaceColor', [0 0 0], 'FaceAlpha', 0.1);
%set(s, 'EdgeColor', [0 0 0], 'EdgeAlpha', 0.3)

% plotting c
plot_c = plot3(c_item_array_p(1, :), c_item_array_p(2, :), c_item_array_p(3, :));
plot_c_circle = scatter3(c_item_array_p(1, :), c_item_array_p(2, :), c_item_array_p(3, :));

% plotting end
plot_end = scatter3(c_item_array_p(1, N + 1 : N_new), c_item_array_p(2, N + 1 : N_new), c_item_array_p(3, N + 1 : N_new), 100, [1 0 0], 'Marker', 'hexagram');

% plotting c_dot
plot_c_dot = quiver3(c_item_array_p(1, 1:N), c_item_array_p(2, 1:N), c_item_array_p(3, 1:N), c_dot_array_p(1, 1:N), c_dot_array_p(2, 1:N), c_dot_array_p(3, 1:N), 1.5);

% last point
%plot_end = scatter3(c_item_array_p(1, N + 1), c_item_array_p(2, N), c_item_array_p(3, N + 1), 100, [1 0 0], 'Marker', 'hexagram');

% starting point
plot_start = scatter3(c_item_array_p(1, start_id), c_item_array_p(2, start_id), c_item_array_p(3, start_id), 100, [1 0 0], 'Marker', 'diamond');

% plotting legend
[legend_h, objh, plot_h, text_strings] = legend([plot_c, plot_c_circle, plot_c_dot, plot_start, plot_end], ...
    {'$c(t)$', '$c$', '$\dot{c}$', '$c_k$', '$\hat{c}_{k+1}$'}, 'interpreter', 'latex');

% increasing marker size for legend
for i = 1:length(objh)
    % setting interpreter and font size, if available
    if isprop(objh(i), 'Interpreter')
        objh(i).Interpreter = 'Latex';
        objh(i).FontSize = 11;
    end

    % setting marker size for the first child, if available
    if size(objh(i).Children) == 0
        continue
    end
    child = objh(i).Children(1);
    if isprop(child, 'MarkerSize')
        objh(i).Children(1).MarkerSize = 8;
    end
end

% setting the view
view(-84, 6);
