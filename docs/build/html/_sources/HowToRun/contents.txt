How to run the code
===================


Machine platform for development
--------------------------------

This CouetteFlow code has been developed on personal computer operating on linux system (Ubuntu Linux 3.2.0-38-generic x86_64). Machine specification is summarized as shown below:

vendor_id       : GenuineIntel

cpu family      : 6

model name      : Intel(R) Core(TM) i7-2600 CPU @ 3.40GHz

cpu cores       : 4

Memory          : 16418112 kB



Code setup
----------

The CouetteFlow source code has been developed with version management tool, GIT. The git repository was built on 'github.com'. Thus, the source code as well as related document files can be cloned into user's local machine by following command::

   $ git clone http://github.com/sayop/CouetteFlow.git

If you open the git-cloned folder **CouetteFlow**, you will see two different folders and README file. The **CODEdev** folder contains again **bin** folder, **Python** folder, and **src** folder. In order to run the code, use should run **setup.sh** script in the **bin** folder. **Python** folder contains python scripts that are used to postprocess data. It may contain **build** folder, which might have been created in the different platform. Thus it is recommended that user should remove **build** folder before setting up the code. Note that the **setup.sh** script will run **cmake** command. Thus, make sure to have cmake installed on your system::

  $ rm -rf build
  $ ./setup.sh
  -- The C compiler identification is GNU 4.6.3
  -- The CXX compiler identification is GNU 4.6.3
  -- Check for working C compiler: /usr/bin/gcc
  -- Check for working C compiler: /usr/bin/gcc -- works
  -- Detecting C compiler ABI info
  -- Detecting C compiler ABI info - done
  -- Check for working CXX compiler: /usr/bin/c++
  -- Check for working CXX compiler: /usr/bin/c++ -- works
  -- Detecting CXX compiler ABI info
  -- Detecting CXX compiler ABI info - done
  -- The Fortran compiler identification is Intel
  -- Check for working Fortran compiler: /opt/intel/composer_xe_2011_sp1.11.339/bin/intel64/ifort
  -- Check for working Fortran compiler: /opt/intel/composer_xe_2011_sp1.11.339/bin/intel64/ifort  -- works
  -- Detecting Fortran compiler ABI info
  -- Detecting Fortran compiler ABI info - done
  -- Checking whether /opt/intel/composer_xe_2011_sp1.11.339/bin/intel64/ifort supports Fortran 90
  -- Checking whether /opt/intel/composer_xe_2011_sp1.11.339/bin/intel64/ifort supports Fortran 90 -- yes
  -- Configuring done
  -- Generating done
  -- Build files have been written to: /data/ksayop/GitHub.Clone/CouetteFlow/CODEdev/bin/build
  Scanning dependencies of target cfd.x
  [ 20%] Building Fortran object CMakeFiles/cfd.x.dir/main/Parameters.F90.o
  [ 40%] Building Fortran object CMakeFiles/cfd.x.dir/main/SimulationVars.F90.o
  [ 60%] Building Fortran object CMakeFiles/cfd.x.dir/io/io.F90.o
  [ 80%] Building Fortran object CMakeFiles/cfd.x.dir/main/SimulationSetup.F90.o
  [100%] Building Fortran object CMakeFiles/cfd.x.dir/main/main.F90.o
  Linking Fortran executable cfd.x
  [100%] Built target cfd.x

If you run this, you will get executable named **cfd.x** and **input.dat** files. The input file is made by default. You can quickly change the required input options.


Input file setup
----------------

The CouetteFlow code allows user to set multiple options to solve the unsteady Couette flow problem by reading **input.dat** file at the beginning of the computation. Followings are default setup values you can find in the input file when you run **setup.sh** script::

  # Input file for tecplot print
  Couette Flow
  uTop            1.0
  distL           1.0
  nu              1.0
  jmax            51
  theta           0.0
  dt              0.0
  iterMax         999999
  nIterOut        500
  RMSlimit        1.0e-7


* **First line** ('Couette Flow' by default): Project Name

* **uTop**: velocity at which top plate is moving

* **distL**: distance between top plate and bottom plate

* **nu**: viscosity coefficient

* **jmax**: spatial resolution in height (y-direction)

* **theta**: :math:`\Theta`, a weighting parameter for implicit scheme running

* **dt**: temporal step size

* **iterMax**: Maximum number of iteration to be converged. If the code run beyond this number, it will be forced to be terminated.

* **nIterOut**: Interval of time step between writing out the data files.

* **RMSlimit**: RMS error limit to determine convergence

