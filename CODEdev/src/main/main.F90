!> \file: main.F90
!> \author: Sayop Kim

PROGRAM main
   USE Parameters_m, ONLY: wp
   USE io_m, ONLY: ReadInput, WriteRMSlog, WriteDataOut, nIterOut
   USE SimulationVars_m, ONLY: t, tp, dt, iterMax, RMSerrSS, RMSerrUS, &
                               RMSlimit
   USE SimulationSetup_m, ONLY: Initialize, SetupBCIC, SetTimeStep, &
                                UpdateNonDimVars, UpdateDimVars, &
                                UpdateVelocity, CalSteadyExactSol, &
                                CalUnSteadyExactSol, CalRMSerrUnsteady, &
                                CalRMSerrSteady

   IMPLICIT NONE
   INTEGER :: iKill, nIter, iCONVERGE
   REAL(KIND=wp) :: MaxRMSerrUS
   MaxRMSerrUS = 0.0_wp

   CALL ReadInput()
   CALL Initialize()
   CALL SetupBCIC()
   IF(dt .EQ. 0.0_wp) THEN
      iKill = 0
      CALL SetTimeStep(iKill)
      IF(iKill .EQ. 1) STOP
   END IF

   CALL CalSteadyExactSol()
   CALL CalUnSteadyExactSol()
   CALL WriteDataOut(0,t)
   TimeLoop: DO nIter = 1, iterMax
      t = t + dt
      CALL UpdateNonDimVars()
      CALL UpdateVelocity()
      CALL CalUnSteadyExactSol()
      CALL CalRMSerrUnsteady
      CALL CalRMSerrSteady
      MaxRMSerrUS = MAX(MaxRMSerrUS,RMSerrUS)
      CALL WriteRMSlog(nIter)
      IF(MOD(nIter, nIterOut) .EQ. 0) THEN
         CALL WriteDataOut(nIter,t)
      ENDIF
      IF(RMSerrSS .LT. RMSlimit) THEN
         iCONVERGE = 1
         WRITE(*,'(A)') "### CONVERGENCE IS SUCCESSFULLY ACHIEVED!!!"
         CALL WriteDataOut(nIter,t)
         EXIT
      ENDIF
   END DO TimeLoop
   IF(iCONVERGE .NE. 1) THEN
      WRITE(*,'(A,I6.6,A)') "### CONVERGENCE IS NOT ACHIEVED WITHIN ",iterMax," ITERATIONS!!!"
   ENDIF
   WRITE(*,'(A,g15.6)') "### Maximum RMS error based on Unsteady-State: ", MaxRMSerrUS

END PROGRAM main

