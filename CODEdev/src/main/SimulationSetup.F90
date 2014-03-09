!> \file SimulationSetup.F90
!> \author Sayop Kim

MODULE SimulationSetup_m
   USE Parameters_m, ONLY: wp
   IMPLICIT NONE

   PUBLIC :: Initialize, SetupBCIC, SetTimeStep, UpdateNonDimVars, &
             UpdateDimVars, UpdateVelocity, CalSteadyExactSol, &
             CalUnSteadyExactSol

CONTAINS

!-----------------------------------------------------------------------------!
   SUBROUTINE Initialize()
!-----------------------------------------------------------------------------!
      USE Parameters_m, ONLY: CODE_VER_STRING
      USE SimulationVars_m, ONLY: tp, yp, up, y, u, uExac, uExacSS, jmax
      IMPLICIT NONE

      ALLOCATE(yp(jmax))
      ALLOCATE(up(jmax))
      ALLOCATE(y(jmax))
      ALLOCATE(u(jmax))
      ALLOCATE(uExac(jmax))
      ALLOCATE(uExacSS(jmax))

      WRITE(*,'(a)') ""
      WRITE(*,'(a)') "CFD code Version: ", CODE_VER_STRING

      tp = 0.0_wp
   END SUBROUTINE Initialize


!-----------------------------------------------------------------------------!
   SUBROUTINE SetupBCIC()
!-----------------------------------------------------------------------------!
!   Setup Boundary Conditions and Initial Conditions
!-----------------------------------------------------------------------------!
      USE Parameters_m, ONLY: PI
      USE SimulationVars_m, ONLY: y, u, dy, &
                                  jmax, yp, up, distL, dyp, uTop
    
      IMPLICIT NONE
      INTEGER :: j

      WRITE(*,'(a)') ""
      WRITE(*,'(a)') "Setup Initial Condition and Boundary Condition"

      ! Set y coordinate
      dy = distL / (jmax - 1)    
      DO j = 1, jmax
         y(j) = dy * real(j - 1)
      END DO

      ! Set initial condition:
      !        
      ! u(y) = u_top * ( y' + sin(pi x y') )
      !       
      DO j = 1, jmax
         u(j) = uTop * ( y(j)/distL + sin(PI * yp(j)/distL) )
      END DO

      CALL UpdateNonDimVars()   

   END SUBROUTINE SetupBCIC

!-----------------------------------------------------------------------------!
   SUBROUTINE SetTimeStep(iKill)
!-----------------------------------------------------------------------------!
!   Setup computational time step based on Von-Neumann stability analysis
!-----------------------------------------------------------------------------!
      USE SimulationVars_m, ONLY: dt, dtp, distL, dyp, theta, nu

      IMPLICIT NONE
      INTEGER :: iKill
      REAL(KIND=wp) :: tau

      IF(theta .GE. 0.5_wp) THEN
         WRITE(*,'(a)') ""
         WRITE(*,'(a)') "Unconditionally stable!!"
         WRITE(*,'(a)') "Input any value of 'dt' in input.dat and rerun!!"
         iKill = 1
      ELSE
         CALL UpdateNonDimVars()
         dtp = dyp**2 / 4.0_wp / (0.5_wp - theta)  ! Non-Dimensionalized form
         CALL UpdateDimVars()
         WRITE(*,'(a)') ""
         WRITE(*,'(a)') "Setup Time Step for stable running"
         WRITE(*,'(a,g15.6)') "This scheme is stable if dt is equal to or less than", dt
         WRITE(*,'(a,g15.6)') 'dt is selected as ', dt
         iKill = 0
      END IF
   END SUBROUTINE SetTimeStep

!-----------------------------------------------------------------------------!
   SUBROUTINE UpdateNonDimVars()
!-----------------------------------------------------------------------------!
!  Update Non-dimensionalized variables from dimensional variables
!-----------------------------------------------------------------------------!
      USE SimulationVars_m, ONLY: t, dt, y, u, dy, &
                                  tp, dtp, yp, up, dyp, nu, distL, uTop

      IMPLICIT NONE
      REAL(KIND=wp) :: tau

      tau = distL / nu

      tp = t / tau
      yp = y / distL
      up = u / uTop
      dtp = dt / tau
      dyp = dy / distL

   END SUBROUTINE UpdateNonDimVars

!-----------------------------------------------------------------------------!
   SUBROUTINE UpdateDimVars()
!-----------------------------------------------------------------------------!
!  Update dimensionalized variables from Non-dimensional variables
!-----------------------------------------------------------------------------!
      USE SimulationVars_m, ONLY: t, dt, y, u, dy, &
                                  tp, dtp, yp, up, dyp, nu, distL, uTop

      IMPLICIT NONE
      REAL(KIND=wp) :: tau

      tau = distL / nu

      t = tp * tau
      y = yp * distL
      u = up * uTop
      dt = dtp * tau
      dy = dyp * distL

   END SUBROUTINE UpdateDimVars

!-----------------------------------------------------------------------------!
   SUBROUTINE UpdateVelocity()
!-----------------------------------------------------------------------------!
!   Setup Tri-Diagonal matrix for solving Thomas Loop
!-----------------------------------------------------------------------------!
      USE SimulationVars_m, ONLY: jmax, dtp, dyp, theta, up

      IMPLICIT NONE
      INTEGER :: j
 
      REAL(KIND=wp) :: rr
      REAL(KIND=wp), DIMENSION(jmax) :: A, B, C, D
   
      rr = dtp / dyp**2
      DO j = 1, jmax
         IF( j == 1 .or. j == jmax ) THEN
            A(j) = 0.0_wp
            B(j) = 1.0_wp
            C(j) = 0.0_wp
            D(j) = up(j)
         ELSE
            A(j) = -rr * theta
            B(j) = 1.0_wp + 2.0_wp * rr * theta
            C(j) = -rr * theta
            D(j) = up(j) + rr * (1.0_wp - theta) * (up(j-1) - 2.0_wp*up(j) +up(j+1))
         END IF 
      END DO

      ! Call Thomas method solver
      CALL SY(1, jmax, A, B, C, D)

      DO j = 1, jmax
         up(j) = D(j)
      END DO
   END SUBROUTINE UpdateVelocity
   
!-----------------------------------------------------------------------------!
   SUBROUTINE SY(IL,IU,BB,DD,AA,CC)
!-----------------------------------------------------------------------------!
      IMPLICIT NONE
      INTEGER, INTENT(IN) :: IL, IU
      REAL(KIND=wp), DIMENSION(IL:IU), INTENT(IN) :: AA, BB
      REAL(KIND=wp), DIMENSION(IL:IU), INTENT(INOUT) :: CC, DD

      INTEGER :: LP, I, J
      REAL(KIND=wp) :: R

      LP = IL + 1

      DO I = LP, IU
         R = BB(I) / DD(I-1)
         DD(I) = DD(I) - R*AA(I-1)
         CC(I) = CC(I) - R*CC(I-1)
      ENDDO
  
      CC(IU) = CC(IU)/DD(IU)
      DO I = LP, IU
         J = IU - I + IL
         CC(J) = (CC(J) - AA(J)*CC(J+1))/DD(J)
      ENDDO
   END SUBROUTINE SY

!-----------------------------------------------------------------------------!
   SUBROUTINE CalSteadyExactSol()
!-----------------------------------------------------------------------------!
!  Calculate Steady State Solution: used at one time
!  USE Non-Dimensionalized variables only!
!-----------------------------------------------------------------------------!
      USE SimulationVars_m, ONLY: uExacSS, yp, jmax

      IMPLICIT NONE
      INTEGER :: j

      DO j = 1, jmax
         !uExacSS(j) = yp(j)
      END DO
   END SUBROUTINE CalSteadyExactSol

!-----------------------------------------------------------------------------!
   SUBROUTINE CalUnSteadyExactSol()
!-----------------------------------------------------------------------------!
!  Calculate Steady State Solution: updated every time step
!-----------------------------------------------------------------------------!


   END SUBROUTINE CalUnSteadyExactSol

END MODULE SimulationSetup_m
