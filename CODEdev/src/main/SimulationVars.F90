!> \file: SimulationVars.F90
!> \author: Sayop Kim

MODULE SimulationVars_m
   USE parameters_m, ONLY : wp
   IMPLICIT NONE

   INTEGER :: jmax, iterMax
   REAL(KIND=wp), ALLOCATABLE, DIMENSION(:) :: yp, up, y, u, &
                                               upExac, upExacSS, &
                                               uExac, uExacSS
   REAL(KIND=wp) :: t, dt, dy
   REAL(KIND=wp) :: uTop, distL, nu, theta, tp, dtp, dyp
   REAL(KIND=wp) :: RMSerrSS, RMSerrUS, RMSlimit

END MODULE SimulationVars_m
