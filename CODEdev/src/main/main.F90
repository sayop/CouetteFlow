!> \file: main.F90
!> \author: Sayop Kim

PROGRAM main
   USE Parameters_m, ONLY: wp
   USE io_m, ONLY: ReadInput
   USE SimulationSetup_m, ONLY: InitializeCommunication, SetupBCIC

   IMPLICIT NONE

   CALL InitializeCommunication()
   CALL ReadInput()
   CALL SetupBCIC()


END PROGRAM main

