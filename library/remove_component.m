function v1 = remove_component(v, n)
%% v1 = remove_component(v, n)
% removes normal components from vectors v

%%
    X = null(n');
    v1 = X * X' * v;
end