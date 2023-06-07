# AETOS: Software for the optimization of algebraic expression trees

AETOS (Algebraic Expression Tree Optimizing Software) is a script for the Wolfram Mathematica<sup>:registered:</sup> application that reduces a long algebraic expression to a smaller one. It achieves this using common expression elimination, constant folding, and global value numbering and is based on the internal Wolfram Mathematica<sup>:registered:</sup> compiler. A tenfold or more reduction in expression size is typical. The software provides very compact expressions that are easy to reason about, prepare for publication and potentially transform into other desired forms like computer programs in lower-level languages.

Mathematica is a registered trademark of Wolfram Research Inc.

## Installation and testing

1. Open the `install_and_test.nb` notebook.
2. Inspect the `InstallCompactor[]` function options, and if you wish, modify them based on your preferences. The defaults are appropriate for first-time installation.
3. Evaluate the `install_and_test` notebook (Evaluation->Evaluate Notebook)

## Usage
A. You can now use the `Compactor` function from any Mathematica notebook. Example:

```Mathematica
<< Compactor` (*Loads the package*)
Compact[a (y + 2) (x + 1) + b (x + 1)^2 +  Cos[(y + 2)] (c (x + 1)^3)/Sin[-1 + x]]
```

B. To display a help message, evaluate the following:
```Mathematica
?Compact
```

## Example
The file `example.nb` provides an example of use for a non-trivial expression based on a Biot-Savart kernel [1]  typically used in N-body simulations. The example script first derives the Jacobian matrix of the kernel and simplifies it. By default a long expression is generated:

<div align="center">
<p align="center">
  <img src="/images/jacobian.png">
</p>
</div>

Subsequently AETOS' `Compact` function is used to generate a much shorter expression with replacement rules:

<div align="center">
<p align="center">
  <img src="/images/jacobianCompact1.png" width="258" />
</p>
</div>

<div align="center">
<p align="center">
  <img src="/images/jacobianCompact2.png" width="461" />
</p>
</div>

## License intent
AETOS is the work of U.S. Government employees, and the relevant source code is in the public domain. Please read the [license](license.txt) to ensure you can satisfy the authorization to use and distribute requirements.

## References
[1] Steven N. Rodriguez, Athanasios P. Iliopoulos, Kevin T. Carlberg, Steven L. Brunton, John C. Steuben, John G. Michopoulos,
Projection-tree reduced-order modeling for fast N-body computations, Journal of Computational Physics, Volume 459, 2022, 111141, ISSN 0021-9991,
https://doi.org/10.1016/j.jcp.2022.111141.

DISTRIBUTION STATEMENT A. Approved for public release; distribution is unlimited.
