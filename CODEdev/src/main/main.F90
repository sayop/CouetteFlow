!> \file: main.F90
!> \author: Sayop Kim

PROGRAM main
   USE Parameters_m, ONLY: wp
   USE io_m, ONLY: ReadInput
   USE SimulationVars_m, ONLY: t, dt, iterMax
   USE SimulationSetup_m, ONLY: Initialize, SetupBCIC, SetTimeStep, &
                                UpdateNonDimVars, UpdateDimVars, &
                                UpdateVelocity, CalSteadyExactSol, &
                                CalUnSteadyExactSol

   IMPLICIT NONE
   INTEGER :: iKill, nIter

   CALL Initialize()
   CALL ReadInput()
   CALL SetupBCIC()
   IF(dt .EQ. 0.0_wp) THEN
      iKill = 0
      CALL SetTimeStep(iKill)
      IF(iKill .EQ. 1) STOP
   END IF

   !CALL CalSteadyExactSol()
   TimeLoop: DO nIter = 1, iterMax
      CALL UpdateNonDimVars()
      CALL UpdateVelocity()
      !CALL CalUnSteadyExactSol()
      CALL UpdateDimVars()
      t = t + dt
   END DO TimeLoop

END PROGRAM main

