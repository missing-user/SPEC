#!/usr/bin/env python3

import os # environ
import sys
import json
import argparse
import setuptools

from os.path import basename, splitext
from glob import glob
import numpy

print("system.platform is {}".format(sys.platform))
if (sys.platform == "darwin"):
    from distutils import sysconfig
    vars = sysconfig.get_config_vars()
    vars['LDSHARED'] = vars['LDSHARED'].replace('-bundle', '-dynamiclib')

from setuptools import find_packages
from skbuild import setup

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

# Unset conflicting environment variables temporarily. They are restored on exit.
conflicting_env_vars = ["HDF5", "HDF5_ROOT", "HDF5_HOME", "FFTW", "FFTW_DIR"]
for env_var in conflicting_env_vars:
   if os.environ.pop(env_var, None):
    print("Detected potentially conflicting envirnoment variable", env_var, "temporarily unset for the installation.")

# Symlink f2py to f2py3, if needed (if there isn't a conda installed version)
import subprocess
f2py_path = subprocess.check_output(["which", "f2py3"], text=True)
conda_env_path = os.environ["CONDA_PREFIX"]
if not conda_env_path in f2py_path:
   f2py_path = os.path.join(conda_env_path,"bin/f2py")
   if not os.path.exists(f2py_path):
      raise ImportError("Couldn't find f2py, which is required for the build. ") 
   f2py3_path = os.path.join(conda_env_path,"bin/f2py3")
   print("Couldn't find f2py3, attempting to symlink ", f2py_path, "to", f2py3_path)
   os.symlink(f2py_path, f2py3_path)


setup(
    name="spec",
    version="0.0.3",
    #license="MIT",
    packages=['spec'],
    package_dir={'': 'Utilities/python_wrapper'},
    #py_modules=[splitext(basename(path))[0] for path in glob('src/vmec/*.py')],
    install_requires=['f90wrap', 'scikit-build'],
    classifiers=[
        "Development Status :: 1 - Alpha",
        "Intended Audience :: Nuclear Fusion Community",
        "License :: OSI Approved :: MIT License",
        "Programming Language :: Python",
        "Programming Language :: Python :: 3",
        "Topic :: MHD Equilibrium Solver"],
    cmake_args=d['cmake_args'],
)
