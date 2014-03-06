!> \file SimulationSetup.F90
!> \author Sayop Kim

MODULE SimulationSetup_m
   USE Parameters_m, ONLY: wp
   IMPLICIT NONE

   PUBLIC :: InitializeCommunication

CONTAINS

!-----------------------------------------------------------------------------!
   SUBROUTINE InitializeCommunication()
!-----------------------------------------------------------------------------!
      USE Parameters_m, ONLY: CODE_VER_STRING
      IMPLICIT NONE

      WRITE(*,'(a)') ""
      WRITE(*,'(a)') "CFD code Version: ", CODE_VER_STRING
   END SUBROUTINE InitializeCommunication


!-----------------------------------------------------------------------------!
   SUBROUTINE SetupBCIC()
!-----------------------------------------------------------------------------!
!   Setup Boundary Conditions and Initial Conditions
!-----------------------------------------------------------------------------!
    USE SimulationVars_m, ONLY: jmax, yp
    
    IMPLICIT NONE

    WRITE(*,'(a)') ""
    WRITE(*,'(a)') "Setup Initial Condition and Boundary Condition"
    ALLOCATE(yp(jmax))
    yp = 0.0_wp


 

   END SUBROUTINE SetupBCIC

END MODULE SimulationSetup_m
