Code development
================

The present project is aimed to develop a computer program for solving 1-D unsteady 'Couette Flow' problem. Hereafter, the program developed in this project is called 'CouetteFlow'.

CouetteFlow Code summary
------------------------

The source code contains two directories, 'io', and 'main', for input/output related sources and main solver routines, respectively. 'CMakeLists.txt' file is also included for cmake compiling.

::

   $ cd CouetteFlow/CODEdev/src/
   $ ls
   $ CMakeLists.txt  io  main

The **io** folder has **io.F90** file which contains **ReadInput()**, **WriteRMSlog()**, **WriteDataOut()** subroutines. it also includes **input** directory which contains a default **input.dat** file.

The **main** folder is only used for calculating essential subroutines required to solve the 'Couette Flow' equation by using implicit-explicit finite difference approximation. The main routine is run by **main.F90** which calls important subroutines from **main** folder itself and **io** folder when needed. All the fortran source files main folder contains are listed below::

   > main.F90
   > Parameters.F90
   > SimulationSetup.F90
   > SimulationVars.F90

Details of CouetteFlow development
----------------------------------

The schematic below shows the flow chart of how the CouetteFlow code runs.

.. image:: ./images/chart.png
   :width: 80%

