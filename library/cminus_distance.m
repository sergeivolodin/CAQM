function r = cminus_distance(c_array, c_plus, c)
%% r = cminus_distance(c_array, c_plus, c)
% calculate distance
% min(c, c_array(i))
% removes c_plus component
% normalizes vectors
% distance is ||c - c_array(i)||

%%
    if size(c_array, 2) == 0
        error('size(c_array, 2) == 0')
    end
    n = size(c_plus, 1);
    c_array = remove_component(c_array, c_plus);
    c = remove_component(c, c_plus);
    c = c / norm(c);
    N = diag(sqrt(c_array' * c_array))';
    N = repmat(N, n, 1);
    c_array = c_array ./ N - c;
    dist = sqrt(diag(c_array' * c_array));
    r = min(dist);
end