/*
 @licstart  The following is the entire license notice for the JavaScript code in this file.

 The MIT License (MIT)

 Copyright (C) 1997-2020 by Dimitri van Heesch

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software
 and associated documentation files (the "Software"), to deal in the Software without restriction,
 including without limitation the rights to use, copy, modify, merge, publish, distribute,
 sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or
 substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
 BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

 @licend  The above is the entire license notice for the JavaScript code in this file
*/
var NAVTREE =
[
  [ "SPEC", "index.html", [
    [ "The Stepped Pressure Equilibrium Code", "index.html", null ],
    [ "Compilation hints for SPEC", "md_Compile.html", [
      [ "Mac", "md_Compile.html#autotoc_md1", null ]
    ] ],
    [ "Manual / Documentation", "grp_documentation.html", [
      [ "Poloidal flux and rotational transform", "grp_documentation.html#grp_polFluxRotTransform", null ],
      [ "Outline", "grp_documentation.html#grp_outline", null ],
      [ "Numerical Improvements", "grp_documentation.html#sec_NumericalImprovements", [
        [ "Compile code with GCC for error checking", "grp_documentation.html#sec_gcc", null ],
        [ "Profile code with gprof to find inefficient lines of code", "grp_documentation.html#sec_gprof", null ],
        [ "Run code with Valgrind to identify memory leaks", "grp_documentation.html#sec_valgrind", null ],
        [ "De-NAG-ification", "grp_documentation.html#sec_denag", null ],
        [ "Revision of spectral-constraints", "grp_documentation.html#sec_spectralConstraints", null ],
        [ "Extension to arbitrary toroidal angle", "grp_documentation.html#sec_torAngle", null ],
        [ "Exploit symmetry of the metric", "grp_documentation.html#sec_metricSymmetry", null ],
        [ "symmetry of \"local\" Beltrami matrices", "grp_documentation.html#sec_beltrami", null ],
        [ "Exploit block tri-diagonal structure of \"global\" linearized force balance matrix", "grp_documentation.html#sec_tridiagnonal", null ],
        [ "Enforce Helicity constraint", "grp_documentation.html#sec_heliciy_constraint", null ],
        [ "Establish test-cases", "grp_documentation.html#sec_tests", null ],
        [ "Verify free-boundary", "grp_documentation.html#sec_freeb", null ],
        [ "Enforcement of toroidal current profile", "grp_documentation.html#sec_toroidal_current", null ],
        [ "Interpret eigenvectors and eigenvalues of Hessian", "grp_documentation.html#sec_hessian", null ]
      ] ],
      [ "Physics Applications", "grp_documentation.html#sec_PhysicsApplications", [
        [ "Calculate high-resolution equilibria, e.g. W7-X", "grp_documentation.html#sec_hires", null ],
        [ "Calculate equilibria by conserving helicity and fluxes", "grp_documentation.html#sec_calc_consvHelicity", null ],
        [ "Calculate free-boundary stellarator equilibria", "grp_documentation.html#sec_calc_freeb", null ],
        [ "Evaluate stability of MRxMHD equilibria", "grp_documentation.html#sec_eval_stability", null ]
      ] ],
      [ "Revision of coordinate singularity: axisymmetric; polar coordinates", "grp_documentation.html#grp_coord_singularity", [
        [ "somewhat generally, ...", "grp_documentation.html#sec_generally", null ],
        [ "non-stellarator symmetric terms", "grp_documentation.html#sec_nonstellsym", null ]
      ] ]
    ] ],
    [ "Todo List", "todo.html", null ],
    [ "Bibliography", "citelist.html", null ],
    [ "Modules", "modules.html", "modules" ],
    [ "Module Members", "namespacemembers.html", [
      [ "All", "namespacemembers.html", "namespacemembers_dup" ],
      [ "Functions/Subroutines", "namespacemembers_func.html", null ],
      [ "Variables", "namespacemembers_vars.html", "namespacemembers_vars" ]
    ] ],
    [ "Data Types List", "annotated.html", [
      [ "Data Types List", "annotated.html", "annotated_dup" ],
      [ "Data Fields", "functions.html", [
        [ "All", "functions.html", null ],
        [ "Variables", "functions_vars.html", null ]
      ] ]
    ] ],
    [ "Files", "files.html", [
      [ "File List", "files.html", "files_dup" ],
      [ "File Members", "globals.html", [
        [ "All", "globals.html", null ],
        [ "Functions/Subroutines", "globals_func.html", null ]
      ] ]
    ] ]
  ] ]
];

var NAVTREEINDEX =
[
"annotated.html",
"global_8f90.html#ga6afae1f88ed1efd5cfc6ede989bc4599",
"group__grp__chebychev__metric.html#ga1a9b8841f0e4af771acaf38d613b24f1",
"group__grp__global__diagnostics.html#ga56b8079bfa338e976ae73476fabb28bf",
"group__grp__trig.html#gab120e8ef003e765cdde4b784e4a03db0",
"spsint_8f90.html#a01df49c498752e8a4201cc6eb5e283af"
];

var SYNCONMSG = 'click to disable panel synchronisation';
var SYNCOFFMSG = 'click to enable panel synchronisation';