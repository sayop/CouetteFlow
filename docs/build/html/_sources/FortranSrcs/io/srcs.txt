io directory
============

CMakeLists.txt
--------------

::

  set(IO_SRC_FILES
      ${CMAKE_CURRENT_SOURCE_DIR}/io.F90 CACHE INTERNAL "" FORCE)


io.F90
------

::

  !> \file: io.F90
  !> \author: Sayop Kim
  !> \brief: Provides routines to read input and write output

  MODULE io_m
     USE Parameters_m, ONLY: wp
  
     IMPLICIT NONE

     PUBLIC :: ReadInput, WriteRMSlog, WriteDataOut
  
     INTEGER :: nIterOut
     INTEGER, PARAMETER :: IOunit = 10, filenameLength = 64
     CHARACTER(LEN=50) :: prjTitle

  CONTAINS

  !-----------------------------------------------------------------------------!
     SUBROUTINE ReadInput()
  !-----------------------------------------------------------------------------!
  !  Read input files
  !-----------------------------------------------------------------------------!
        USE SimulationVars_m, ONLY: uTop, jmax, distL, nu, theta, dt, iterMax, &
                                 RMSlimit
        IMPLICIT NONE
        INTEGER :: ios
        CHARACTER(LEN=8) :: inputVar
  
        OPEN(IOunit, FILE = 'input.dat', FORM = 'FORMATTED', ACTION = 'READ', &
              STATUS = 'OLD', IOSTAT = ios)
        IF(ios /= 0) THEN
           WRITE(*,'(a)') ""
           WRITE(*,'(a)') "### Fatal error: Could not open the input data file."
           RETURN
        ELSE
           WRITE(*,'(a)') ""
           WRITE(*,'(a)') "### Reading input file for Couette Flow problem"
        ENDIF

        READ(IOunit,*)
        READ(IOunit,'(a)') prjTitle
        WRITE(*,'(4a)') '### Project Title:', '"',TRIM(prjTitle),'"'
        READ(IOunit,*) inputVar, uTop
        WRITE(*,'(a,f6.3)') inputVar, uTop
        READ(IOunit,*) inputVar, distL
        WRITE(*,'(a,f6.3)') inputVar, distL
        READ(IOunit,*) inputVar, nu
        WRITE(*,'(a,f6.3)') inputVar, nu
        READ(IOunit,*) inputVar, jmax
        WRITE(*,'(a,i6)') inputVar, jmax
        READ(IOunit,*) inputVar, theta
        WRITE(*,'(a,f6.3)') inputVar, theta
        READ(IOunit,*) inputVar, dt
        WRITE(*,'(a,f6.3)') inputVar, dt
        READ(IOunit,*) inputVar, iterMax
        WRITE(*,'(a,i6)') inputVar, iterMax
        READ(IOunit,*) inputVar, nIterOut
        WRITE(*,'(a,i6)') inputVar, nIterOut
        READ(IOunit,*) inputVar, RMSlimit
        WRITE(*,'(a,g15.6)') inputVar,RMSlimit
     END SUBROUTINE ReadInput

  !-----------------------------------------------------------------------------!
     SUBROUTINE WriteRMSlog(iter)
  !-----------------------------------------------------------------------------!
  !  Write RMS error log relative to unsteady and steady solutions
  !-----------------------------------------------------------------------------!
        USE SimulationVars_m, ONLY: RMSerrUS, RMSerrSS
  
        IMPLICIT NONE
        INTEGER :: iter
        CHARACTER(LEN=filenameLength) :: fileName = 'RMSlog.dat'
  
        IF(iter .EQ. 1) THEN
           OPEN(IOunit, File = fileName, FORM = 'FORMATTED', ACTION = 'WRITE')
           WRITE(IOunit,'(A,3A10)') '#', 'Iteration', 'RMSerrUS', 'RMSerrSS'
        ELSE
           OPEN(IOunit, File = fileName, FORM = 'FORMATTED', ACTION = 'WRITE', &
                POSITION = 'APPEND')
        ENDIF
  
        WRITE(IOunit,'(i6,2g15.6)') iter, RMSerrUS, RMSerrSS
        CLOSE(IOunit)

     END SUBROUTINE WriteRMSlog

  !-----------------------------------------------------------------------------!
     SUBROUTINE WriteDataOut(iter,time)
  !-----------------------------------------------------------------------------!
  !  Write RMS error log relative to unsteady and steady solutions
  !-----------------------------------------------------------------------------!
        USE SimulationVars_m, ONLY: y, yp, u, up, uExac, upExac, jmax
  
        IMPLICIT NONE
        INTEGER :: iter, j
        REAL(KIND=wp) :: time
        CHARACTER(LEN=filenameLength) :: fileName
  
        WRITE(fileName,'(A,i6.6,A)') "Data_", iter, ".dat"
        WRITE(*,'(2A)') "PRINTING FILE:", fileName
        OPEN(IOunit, File = fileName, FORM = 'FORMATTED', ACTION = 'WRITE')
        WRITE(IOunit,'(A,g15.6)') "#Time=", time
        WRITE(IOunit,'(A,6A15)') "#", "y", "u", "u_exac", "y'", "u'", "u'_exac"
        DO j = 1, jmax
           WRITE(IOunit,'(6g15.6)') y(j), u(j), uExac(j), yp(j), up(j), upExac(j)
        END DO
        CLOSE(IOunit)
  
     END SUBROUTINE WriteDataOut
  END MODULE io_m
                                                     
