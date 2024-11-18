#!/usr/bin/env python3

import os # environ
import sys
import json
import warnings

import numpy
import subprocess
from skbuild import setup

print("system.platform is {}".format(sys.platform))
if (sys.platform == "darwin"):
    from distutils import sysconfig
    vars = sysconfig.get_config_vars()
    vars['LDSHARED'] = vars['LDSHARED'].replace('-bundle', '-dynamiclib')


# Load machine-specific options from cmake_config.json.
# It should contain a dict with an array called cmake_args.
with open('cmake_config.json') as fp:
    d = json.load(fp)

# Include additional parameters from CMAKE_ARGS environment variable.
# This is the way Anaconda tells CMake its specific needs.
if 'CMAKE_ARGS' in os.environ:

  print("CMAKE_ARGS = '%s'"%(os.environ['CMAKE_ARGS']))
  for cmake_arg in os.environ['CMAKE_ARGS'].split(" "):
    d['cmake_args'].append(cmake_arg)

# Tell CMake about where to find numpy libraries
# see also: https://stackoverflow.com/a/14657667
d['cmake_args'].append("-DCMAKE_C_FLAGS=-I"+numpy.get_include())

d['cmake_args'].append('-DSKBUILD=ON')

# Unset conflicting environment variables temporarily. They are restored on exit.
conflicting_env_vars = ["HDF5", "HDF5_ROOT", "HDF5_HOME", "FFTW", "FFTW_DIR"]
for env_var in conflicting_env_vars:
   if os.environ.pop(env_var, None):
    print("Detected potentially conflicting envirnoment variable", env_var, "temporarily unset for the installation.")

# Symlink f2py to f2py3, if needed (if there isn't a conda installed version)
f2py_path = subprocess.getoutput("which f2py3")
conda_env_path = os.environ.get("CONDA_PREFIX", None)
if conda_env_path is None:
    warnings.warn("No conda environment active. It is heavily recommended to install spec python tools using a conda environment.")
else:
    if not conda_env_path in f2py_path:
        f2py_path = os.path.join(conda_env_path,"bin/f2py")
        if not os.path.exists(f2py_path):
            raise ImportError("Couldn't find f2py, which is required for the build. ") 
        f2py3_path = os.path.join(conda_env_path,"bin/f2py3")
        os.symlink(f2py_path, f2py3_path)
        print("Couldn't find f2py3, created a symlink ", f2py_path, "to", f2py3_path)

import setuptools

setuptools.setup(
    name="spec",
    packages=['spec'],
    package_dir={'': 'Utilities/python_wrapper'},
    cmake_args=d['cmake_args'],
    cmake_install_dir=os.path.join(".", "install")

)
