!> \file SimulationSetup.F90
!> \author Sayop Kim

MODULE SimulationSetup_m
   USE Parameters_m, ONLY: wp
   IMPLICIT NONE

   PUBLIC :: Initialize, SetupBCIC, SetTimeStep, UpdateNonDimVars, &
             UpdateDimVars, UpdateVelocity, CalSteadyExactSol, &
             CalUnSteadyExactSol, CalRMSerrSteady, CalRMSerrUnsteady

CONTAINS

!-----------------------------------------------------------------------------!
   SUBROUTINE Initialize()
!-----------------------------------------------------------------------------!
      USE Parameters_m, ONLY: CODE_VER_STRING
      USE SimulationVars_m, ONLY: t, tp, yp, up, y, u, jmax, uExac, uExacSS, &
                                  upExac, upExacSS
      IMPLICIT NONE

      ALLOCATE(yp(jmax))
      ALLOCATE(up(jmax))
      ALLOCATE(y(jmax))
      ALLOCATE(u(jmax))
      ALLOCATE(uExac(jmax))
      ALLOCATE(uExacSS(jmax))
      ALLOCATE(upExac(jmax))
      ALLOCATE(upExacSS(jmax))

      WRITE(*,'(a)') ""
      WRITE(*,'(3a)') "### CFD code Version: ", CODE_VER_STRING, "###"

      t = 0.0_wp
      tp = 0.0_wp
      y = 0.0_wp
      yp = 0.0_wp
      u = 0.0_wp
      up = 0.0_wp
      uExac = 0.0_wp
      uExacSS = 0.0_wp
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
      WRITE(*,'(a)') "### Setup Initial Condition and Boundary Condition"

      ! Set y coordinate and initial condition
      dy = distL / (jmax - 1)    
      DO j = 1, jmax
         y(j) = dy * (j - 1)
         !        
         ! u(y) = u_top * ( y' + sin(pi x y') )
         !
         u(j) = uTop * ( y(j)/distL + sin(PI * y(j)/distL) )
      END DO

      CALL UpdateNonDimVars()   

   END SUBROUTINE SetupBCIC

!-----------------------------------------------------------------------------!
   SUBROUTINE SetTimeStep(iKill)
!-----------------------------------------------------------------------------!
!   Setup computational time step based on Von-Neumann stability analysis
!-----------------------------------------------------------------------------!
      USE SimulationVars_m, ONLY: dt, dtp, dyp, theta

      IMPLICIT NONE
      INTEGER :: iKill

      IF(theta .GE. 0.5_wp) THEN
         WRITE(*,'(a)') ""
         WRITE(*,'(a)') "### Unconditionally stable!!"
         WRITE(*,'(a)') "### Input any value of 'dt' in input.dat and rerun!!"
         iKill = 1
      ELSE
         dtp = dyp**2 / 4.0_wp / (0.5_wp - theta)  ! Non-Dimensionalized form
         CALL UpdateDimVars()
         WRITE(*,'(a)') ""
         WRITE(*,'(a)') "### Setup Time Step for stable running"
         WRITE(*,'(a,g15.6)') "### This scheme is stable if dt is equal to or less than", dt
         WRITE(*,'(a,g15.6)') "### dt is selected as ", dt
         WRITE(*,'(a,g15.6)') "### Non-Dimensionalized time step 'dtp' is selected as ", dtp
         iKill = 0
      END IF
   END SUBROUTINE SetTimeStep

!-----------------------------------------------------------------------------!
   SUBROUTINE UpdateNonDimVars()
!-----------------------------------------------------------------------------!
!  Update Non-dimensionalized variables from dimensional variables
!-----------------------------------------------------------------------------!
      USE SimulationVars_m, ONLY: t, dt, y, u, dy, &
                                  tp, dtp, yp, up, dyp, nu, distL, uTop, &
                                  upExac, upExacSS, uExac, uExacSS

      IMPLICIT NONE
      REAL(KIND=wp) :: tau

      tau = distL / nu

      tp = t / tau
      yp = y / distL
      up = u / uTop
      dtp = dt / tau
      dyp = dy / distL
      upExac = uExac / uTop
      upExacSS = uExacSS / uTop

   END SUBROUTINE UpdateNonDimVars

!-----------------------------------------------------------------------------!
   SUBROUTINE UpdateDimVars()
!-----------------------------------------------------------------------------!
!  Update dimensionalized variables from Non-dimensional variables
!-----------------------------------------------------------------------------!
      USE SimulationVars_m, ONLY: t, dt, y, u, dy, &
                                  tp, dtp, yp, up, dyp, nu, distL, uTop, &
                                  upExac, upExacSS, uExac, uExacSS

      IMPLICIT NONE
      REAL(KIND=wp) :: tau

      tau = distL / nu

      t = tp * tau
      y = yp * distL
      u = up * uTop
      dt = dtp * tau
      dy = dyp * distL
      uExac = upExac * uTop
      uExacSS = upExacSS * uTop

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
      USE SimulationVars_m, ONLY: upExacSS, yp, jmax

      IMPLICIT NONE

      upExacSS = yp
      CALL UpdateDimVars
   END SUBROUTINE CalSteadyExactSol

!-----------------------------------------------------------------------------!
   SUBROUTINE CalRMSerrSteady()
!-----------------------------------------------------------------------------!
!  Calculate RMS error relative to the Steady-State exact solution
!-----------------------------------------------------------------------------!
      USE SimulationVars_m, ONLY: up, upExacSS, RMSerrSS, jmax

      IMPLICIT NONE
      INTEGER :: j
      REAL(KIND=wp) :: rr
     
      rr = 0.0_wp
      DO j = 2, jmax - 1
         rr = rr + (upExacSS(j) - up(j))**2
      END DO
      RMSerrSS = (rr / (jmax-2)) ** 0.5_wp
      
   END SUBROUTINE CalRMSerrSteady

!-----------------------------------------------------------------------------!
   SUBROUTINE CalUnSteadyExactSol()
!-----------------------------------------------------------------------------!
!  Calculate Steady State Solution: updated every time step
!-----------------------------------------------------------------------------!
      USE Parameters_m, ONLY: PI
      USE SimulationVars_m, ONLY: up, upExac, tp, yp, jmax

      IMPLICIT NONE

      upExac = yp + sin(PI * yp) * exp(-PI**2 * tp)
      CALL UpdateDimVars
   END SUBROUTINE CalUnSteadyExactSol

!-----------------------------------------------------------------------------!
   SUBROUTINE CalRMSerrUnSteady()
!-----------------------------------------------------------------------------!
!  Calculate RMS error relative to the Steady-State exact solution
!-----------------------------------------------------------------------------!
      USE SimulationVars_m, ONLY: up, upExac, RMSerrUS, jmax

      IMPLICIT NONE
      INTEGER :: j
      REAL(KIND=wp) :: rr

      rr = 0.0_wp
      DO j = 2, jmax - 1
         rr = rr + (upExac(j) - up(j))**2
      END DO
      RMSerrUS = (rr / (jmax-2)) ** 0.5_wp

   END SUBROUTINE CalRMSerrUnSteady
END MODULE SimulationSetup_m
