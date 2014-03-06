!> \file: SimulationVars.F90
!> \author: Sayop Kim

MODULE SimulationVars_m
   USE parameters_m, ONLY : wp
   IMPLICIT NONE

   INTEGER :: jmax
   REAL(KIND=wp), ALLOCATABLE, DIMENSION(:) :: yp, up
   REAL(KIND=wp) :: distL, theta, time

END MODULE SimulationVars_m
