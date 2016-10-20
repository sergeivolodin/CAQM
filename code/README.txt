Outline: cutting a convex part from image f(R^n)
Input: A_i, b_i, y_0, c_+, N
Output: z_min

get_z_min(A_i, b_i, y_0, c_+, N):
    z_min = +infty
    if is_infeasible(A_i, b_i, y_0)):
        return(0)
    for i in range(1,N):
        d = get_random_d()
        c = get_c_from_d(A_i, b_i)
        is_nonconvex = nonconvexity_certificate(A_i, b_i, c)
        if not is_nonconvex:
            continue
        # c in C_-
        z = get_z(A_i, b_i, y_0, c, c_+)
        if z < z_min:
            z_min = z
    return z_min

# assuming discrete C_-
get_z(A_i, b_i, c, c_+):
    z <-- inf((c_+, f(\alpha e+e_0)))

# assuming continuous C_-
get_z(A_i', b_i', c', c_+'):
    #go to basis where C_+A=I, C_+v=0
    (A_i, b_i, c, c_+) = _(A_i', b_i', c', c_+')
    while not (stop_condition):
        c_dot = _(A_i, b_i, c, c_+)
