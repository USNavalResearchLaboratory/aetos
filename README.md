# AETOS (Algebraic Expression Tree Optimizing Software): Software for the optimization of algebraic expression trees.

## Installation and testing:
1. Open the "install_and_test.nb" notebook.
2. Inspect the InstallCompactor[] function options and if you wish, modify based on your preferences. The defaults are appropriate for first time installation.
3. Evaluate the "install_and_test" notebook (Evaluation->Evaluate Notebook)

## Usage:
A. You can now use the Compactor from any mathematica Notebook. Example:

<< Compactor` (*Loads the package*)
Compact[a (y + 2) (x + 1) + b (x + 1)^2 +  Cos[(y + 2)] (c (x + 1)^3)/Sin[-1 + x]]

B. To display the help messeage, evaluate:
?Compact

## Example
The file example.nb provides an example of use for a non-trivial expression.

## License intent
AETOS is the work of U.S. Government employees and the relevant source code is in the public domain. Please read the [license](license.txt) to ensure you can satisfy the authorization to use and distribute requirements.

DISTRIBUTION STATEMENT A. Approved for public release; distribution is unlimited.



