# CAQM: Convexity Analysis of Quadratic Maps

Code for various tasks for quadratic maps.

See the paper <i>Geometry of quadratic maps via convex relaxation, Anatoly Dymarsky, Elena Gryazina, Sergei Volodin, Boris Polyak, 2018</i>, <a href="https://arxiv.org/abs/1810.00896">arXiv:1810.00896</a>

## Prerequisites
* MATLAB (tested with 9.6-2019a) with Parallel Computing toolbox
* <a href="http://cvxr.com/cvx/download/">CVX</a>. Tested with `Version 2.1, Build 1127 (95903bf)`
* Tested on Linux (Debian 10.1) amd64 kernel `4.19.0-6-amd64`, Java version `1.8.0_181`
* Mathematica 12 for semi-analytical tests and figures 4, 7

## Installing
See [doc/readme.pdf](doc/readme.pdf) file

## Testing
To test separate functions run in MATLAB from root directory:
```
>> cd tests
>> runtests('testFunctions')
```

Result should be like the following:
```
Totals:
   15 Passed, 0 Failed, 0 Incomplete.
   45.7854 seconds testing time.
```

Moreover, see [tests/testCAQM.m](tests/testCAQM.m) as an example of library usage.

```
>> cd tests
>> testCAQM
```

Should give output ending with `TEST PASSED`.
A [Youtube video](https://youtu.be/Ikh_GDHnu-4 "Certificate cutting: z_max test") demonstrates how the test normally performs.

For more information see [doc/readme.pdf](doc/readme.pdf)

## License
See [LICENSE.txt](LICENSE.txt)

## Files and folders
* / -- main functions (see [doc/readme.pdf](doc/readme.pdf))
* [library/](library/) -- supplementary functions (see [doc/library.pdf](doc/library.pdf))
* [doc/](doc/) -- documentation
* [examples/](examples/) contains the code which reproduces the results from the Section 7. Examples from the article, both using our library (MATLAB) and using semi-analytical methods (Mathematica)
* [examples/figures/](examples/figures/) -- MATLAB code for drawing figures from the article:
  - `example05_c_minus.m` reproduces Fig. 5a
  - `example05_c_dot_z_c_t_plot.m` reproduces Fig. 5b
  - `example06_c_minus.m` reproduces Fig. 6a
  - `example06_c_dot_z_c_t_plot.m` reproduces Fig. 6b
  - `homogeneous_procedure_H.m` reproduces Fig. 8
* [examples/](examples/) also contains Mathematica notebooks for reproducing Figures 4 and 7: `article_example01_fig4.nb` and `article_example10_fig7.nb`
* [examples/maps](examples/maps/) -- sample quadratic maps
* [tests/](tests/) -- code for testing the setup

## Parameters
The library contains several numerical constants the purpose of which is described on the second page of the supplementary functions document [doc/library.pdf](doc/library.pdf).

## Further reading
Refer to the documentation in [doc/readme.pdf](doc/readme.pdf) and the article

Copyright (c) 2015-2019 Anatoly Dymarsky, Elena Gryazina, Sergei Volodin, Boris Polyak
