!> \defgroup grp_force_driver Force-driver
!>
!> \file
!> \brief Employs Newton method to find \f${\bf F}({\bf x})=0\f$, where \f${\bf x}\equiv\{\mathrm{geometry}\}\f$ and \f${\bf F}\f$ is defined in dforce() .

!> \brief timing of Newton iterations
module newtontime

  INTEGER :: nFcalls !< number of calls to get function   values (?)
  REAL    :: lastcpu !< last CPU that called this (?)

end module newtontime

!> \brief Employs Newton method to find \f${\bf F}({\bf x})=0\f$, where \f${\bf x}\equiv\{\mathrm{geometry}\}\f$ and \f${\bf F}\f$ is defined in dforce() .
!> \ingroup grp_force_driver
!>
!> Solves \f${\bf F}({\bf \xi})=0\f$, where \f${\bf F} \equiv \{ [[p+B^2/2]]_{i,l}, I_{i,l} \}\f$ and \f${\bf \xi} \equiv \{ R_{i,l},Z_{i,l} \}\f$.
!>
!> **iterative, reverse communication loop**
!>
!> <ul>
!> <li> The iterative, Newton search to find \f${\bf x} \equiv \{ \mathrm{geometry} \} \equiv \{ R_{i,l}, Z_{i,l} \}\f$ such that \f${\bf F}({\bf x})=0\f$,
!>       where \f${\bf F}\f$ and its derivatives, \f$\nabla_{{\bf x}} {\bf F}\f$, are calculated by dforce() , is provided by either</li>
!> <ul>
!> <li> \c C05NDF if \c Lfindzero=1 ,
!>      which only uses function values; or </li>
!> <li> \c C05PDF if \c Lfindzero=2,
!>      which uses user-provided derivatives. </li>
!> </ul>
!> <li> The iterative search will terminate when the solution is within \c c05xtol of the true solution (see NAG documentation). </li>
!> <li> The input variable \c c05factor is provided to determine the initial step bound (see NAG documentation). </li>
!> </ul>
!>
!> **logic, writing/reading from file**
!>
!> <ul>
!> <li> Before proceeding with iterative search, dforce() is called to determine the magnitude of the initial force imbalance,
!>       and if this is less than \c forcetol then the iterative search will not be performed. </li>
!> <li> As the iterations proceed, wrtend() will be called to save itermediate information (also see xspech() ). </li>
!> <li> If the derivative matrix, \f$\nabla_{{\bf x}} {\bf F}\f$, is required, i.e. if \c Lfindzero=2 , and if \c LreadGF=T
!>       then the derivative matrix will initially be read from \c .ext.sp.DF , if it exists, or from \c .sp.DF . </li>
!> <li> As the iterations proceed, the derivative matrix will be written to \c .ext.sp.DF . </li>
!> </ul>
!>
!> @param[in]    NGdof
!> @param[inout] bndDofs
!> @param[out]   ihybrd
subroutine newton( NGdof_bnd, bndDofs, ihybrd )

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  use constants, only : zero, one, two, ten

  use numerical, only : sqrtmachprec

  use fileunits, only : ounit

  use inputlist, only : Wmacros, Wnewton, &
                        Igeometry, & ! only for screen output;
                        Nvol,                    &
                        Lfindzero, forcetol, c05xmax, c05xtol, c05factor, LreadGF, &
                        Lcheck, Lboundary, Lforcereal

  use cputiming, only : Tnewton

  use allglobal, only : myid, ncpu, cpus, MPI_COMM_SPEC, ext, &
                        NOTstellsym, &
                        ForceErr, Energy, &
                        mn_field, im_field, in_field, iRbc, iZbs, iRbs, iZbc, Mvol, &
                        mn_force, im_force, in_force, &
                        mn_rho, im_rho, in_rho, &
                        BBe, IIo, BBo, IIe, &
                        LGdof_force, LGdof_field, NGdof_force, NGdof_field, &
                        dFFdRZ, dBBdmp, dmupfdx, hessian, dessian, Lhessianallocated, &
			                  Lhessian2Dallocated, Lhessian3Dallocated, &
                        nfreeboundaryiterations, &
                        LocalConstraint, nDcalls, NGdof_force

  use bndRep, only    : pack_henneberg_to_hudson, pack_hudson_to_henneberg

  use newtontime

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  LOCALS

  INTEGER, intent(in)    :: NGdof_bnd
  REAL   , intent(inout) :: bndDofs(0:NGdof_bnd)
  INTEGER, intent(out)   :: ihybrd

  LOGICAL                :: LComputeDerivatives
  INTEGER                :: wflag, iflag, idof, jdof, ijdof, ireadhessian, igdof, lvol, ii, imn, ierr2
  REAL                   :: rflag
  CHARACTER              :: pack

  INTEGER                :: irevcm, mode, Ldfjac, LR
  REAL                   :: xtol, epsfcn, factor
  REAL                   :: diag(1:NGdof_force), QTF(1:NGdof_force), workspace(1:NGdof_force,1:4)

  REAL                   :: force(0:NGdof_force)
  REAL                   :: position(0:NGdof_field)
  REAL, allocatable      :: fjac(:,:), RR(:), work(:,:)

  INTEGER                :: ML, MU ! required for only Lc05ndf;

  LOGICAL                :: Lexit = .true. ! perhaps this could be made user input;
  LOGICAL                :: LComputeAxis

  INTEGER                :: nprint = 1, nfev, njev

  INTEGER, parameter     :: maxfev = 5000 ! maximum calls per iteration;

  external               :: fcn1, fcn2

  BEGIN(newton)

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  FATAL( newton, NGdof_bnd.NE.NGdof_force, Invalid number of dofs )



  if( Wnewton .and. myid.eq.0 ) then ! screen output;
   cput = GETTIME
   write(ounit,'("newton : ", 10x ," : ")')
   write(ounit,'("newton : ",f10.2," : Lfindzero="i2" ; forcetol="es13.5" ; c05xtol="es13.5" ; c05factor="es13.5" ; LreadGF="L2" ; NGdof_bnd="i6" ;")')&
                           cput-cpus,  Lfindzero,       forcetol,           c05xtol,           c05factor,           LreadGF,       NGdof_bnd
   write(ounit,'("newton : ", 10x ," : ")')
  endif

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  if( c05xtol.gt.zero ) then ; xtol =          c05xtol                                          ! tolerance in bndDofs;
  else                       ; xtol = max( abs(c05xtol), c05xmax/two**nfreeboundaryiterations ) ! tolerance in bndDofs;
  endif

  Ldfjac = NGdof_force ; LR = NGdof_force * (NGdof_force+1) / 2 ! supplied to NAG;

  mode = 0 ; diag(1:NGdof_force) = one ! if mode=2, multiplicative scale factors need to be provided in diag; if mode=0, factors computed internally;

  factor = c05factor ! used to determine initial step bound; supplied to NAG;

  select case( Lfindzero )
  case( 1 )    ; ML = NGdof_force-1 ; MU = NGdof_force-1 ; epsfcn = sqrtmachprec ! only required for C05NDF; supplied to NAG;
  case( 2 )    ;
  end select

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  nFcalls = 0 ;! counters;

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  lastcpu = GETTIME

  if( Lexit ) then ! will call initial force, and if ForceErr.lt.forcetol will immediately exit;

    !write(ounit,'("newton: salut!")')

    if( Lboundary.eq.0 ) then
#ifdef DEBUG
      FATAL( newton, NGdof_field.ne.NGdof_bnd, Incorrect number of dofs in boundary )
#endif
      position(0:NGdof_bnd) = bndDofs(0:NGdof_bnd)
    else
      pack = 'R'
      WCALL( newton, pack_henneberg_to_hudson, (position(0:NGdof_field), bndDofs(0:NGdof_bnd) ) )
    endif !Lboundary

    LComputeDerivatives= .false.
    LComputeAxis = .true.
    WCALL( newton, dforce, ( NGdof_field, position(0:NGdof_field), force(0:NGdof_force), LComputeDerivatives, LComputeAxis) ) ! calculate the force-imbalance;
    
    
   if( myid.eq.0 ) then ! screen output;
    cput = GETTIME
    ; write(ounit,1000) cput-cpus, nFcalls, nDcalls, ForceErr,  cput-lastcpu, "|BB|e", alog10(BBe(1:min(Mvol-1,28)))
    if( Igeometry.ge.3 .and. Lboundary.eq.0 ) then ! include spectral constraints;
     ;write(ounit,1001)                                                                       "|II|o", alog10(IIo(1:min(Mvol-1,28)))
    endif
    if( NOTstellsym ) then
     ;write(ounit,1001)                                                                       "|BB|o", alog10(BBo(1:min(Mvol-1,28)))
     if( Igeometry.ge.3 .and. Lboundary.eq.0 ) then ! include spectral constraints;
      write(ounit,1001)                                                                       "|II|e", alog10(IIe(1:min(Mvol-1,28)))
     endif
    endif
   endif

   if( ForceErr.lt.forcetol ) then ; ihybrd = 0 ; goto 9999 ! force-balance is satisfied;
   endif

  endif ! end of if( Lexit ) ;

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

1000 format("newton : ",f10.2," : "i9,i3," ; ":"|f|="es12.5" ; ":"time=",f10.2,"s ;":" log"a5"="28f6.2" ...")
1001 format("newton : ", 10x ," : "9x,3x" ; ":"    "  12x "   ":"     ", 10x ,"  ;":" log"a5"="28f6.2" ...")

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  irevcm = 0 ; ihybrd = 1 ! required for initial entry; herefater unchanged by user;

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  SALLOCATE( fjac, (1:NGdof_force, 1:NGdof_force), zero)
  SALLOCATE( RR  , (1:NGdof_bnd*(NGdof_bnd+1)/2) , zero)

  if( Lfindzero.eq.2 ) then
    SALLOCATE( dFFdRZ, (1:LGdof_force,0:1,1:LGdof_field,0:1,1:Mvol), zero )
    SALLOCATE( dBBdmp, (1:LGdof_force,1:Mvol,0:1,1:2), zero )
   if( LocalConstraint ) then
   	SALLOCATE( dmupfdx, (1:Mvol,    1:1,1:2,1:LGdof_field,0:1), zero )
   else
    ! TODO change the format to put vvol in last index bndDofs...
   	SALLOCATE( dmupfdx, (1:Mvol, 1:Mvol-1,1:2,1:LGdof_field,1), zero ) 
   endif

    FATAL( newton, NGdof_bnd.ne.NGdof_force, illdefined Newton problem )

    SALLOCATE( hessian, (1:NGdof_force,1:NGdof_bnd), zero )
    SALLOCATE( dessian, (1:NGdof_force,1:NGdof_bnd), zero )
		    Lhessianallocated = .true.
  else
    Lhessianallocated = .false.
  endif
  Lhessian2Dallocated = .false.
  Lhessian3Dallocated = .false.


!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  select case( Lfindzero )

  case( 1 ) ! use function values                               to find x st f(x)=0, where x is the geometry of the interfaces, and f is the force;

    if( Lforcereal.eq.0 ) then ! find zero of spectral force
      WCALL( newton, hybrd, ( fcn1, NGdof_bnd, bndDofs(1:NGdof_bnd), force(1:NGdof_force), &
              xtol, maxfev, ML, MU, epsfcn, diag(1:NGdof_force), mode, factor, nprint, ihybrd, nfev, &
              fjac(1:Ldfjac,1:NGdof_force), Ldfjac, &
              RR(1:LR), LR, QTF(1:NGdof_force), workspace(1:NGdof_force,1), &
              workspace(1:NGdof_force,2), workspace(1:NGdof_force,3), workspace(1:NGdof_force,4) ) )
    elseif( Lforcereal.eq.1 ) then
      ! TO COMPLETE
    endif

  case( 2 ) ! use function values and user-supplied derivatives to find x st f(x)=0, where x is the geometry of the interfaces, and f is the force;

    if( Lforcereal.eq.0 ) then ! find zero of spectral force
      WCALL( newton, hybrj, ( fcn2, NGdof_bnd, bndDofs(1:NGdof_bnd), force(1:NGdof_force), &
              fjac(1:Ldfjac,1:NGdof_force), Ldfjac, &
              xtol, maxfev, diag(1:NGdof_force), mode, factor, nprint, ihybrd, nfev, njev, &
              RR(1:LR), LR, QTF(1:NGdof_force), workspace(1:NGdof_force,1), &
              workspace(1:NGdof_force,2), workspace(1:NGdof_force,3), workspace(1:NGdof_force,4) ) )
    elseif( Lforcereal.eq.1 ) then
      ! TO COMPLETE
    endif
  case default

   FATAL( newton, .true., value of Lfindzero not supported )

  end select

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  if( myid.eq.0 ) then
   cput = GETTIME
   ;              write(ounit,'("newton : ", 10x ," :")')
   select case( ihybrd )
   case( 1   )  ; write(ounit,'("newton : ",f10.2," : finished ; success        ; ic05p*f="i2" ; its="i7" ,"i4" ;")') cput-cpus, ihybrd, nFcalls, nDcalls
   case( 0   )  ; write(ounit,'("newton : ",f10.2," : finished ; input error    ; ic05p*f="i2" ; its="i7" ,"i4" ;")') cput-cpus, ihybrd, nFcalls, nDcalls
   case( 2   )  ; write(ounit,'("newton : ",f10.2," : finished ; max. iter      ; ic05p*f="i2" ; its="i7" ,"i4" ;")') cput-cpus, ihybrd, nFcalls, nDcalls
   case( 3   )  ; write(ounit,'("newton : ",f10.2," : finished ; xtol too small ; ic05p*f="i2" ; its="i7" ,"i4" ;")') cput-cpus, ihybrd, nFcalls, nDcalls
   case( 4:5 )  ; write(ounit,'("newton : ",f10.2," : finished ; bad progress   ; ic05p*f="i2" ; its="i7" ,"i4" ;")') cput-cpus, ihybrd, nFcalls, nDcalls
   case default ; write(ounit,'("newton : ",f10.2," : finished ; illegal ifail  ; ic05p*f="i2" ; its="i7" ,"i4" ;")') cput-cpus, ihybrd, nFcalls, nDcalls
   end select
  endif ! end of if( myid.eq.0 ) then;

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  if( Lfindzero.eq.2 .and. myid.eq.0 .and. irevcm.eq.0 ) then ! will save derivative matrix for future use;

   if( Wnewton ) write(ounit,'("newton : ", 10x ," : saving derivative matrix to file ;")')

#ifdef DEBUG
   FATAL( newton, .not.Lhessianallocated, error )
#endif

   !hessian(1:NGdof_force,1:NGdof_bnd) = zero
   SALLOCATE(work, (1:NGdof_bnd,1:NGdof_bnd), zero)! BLAS version; 19 Jul 2019
   ijdof = 0
   do idof = 1, NGdof_force
    !do jdof = idof, NGdof_bnd ; ijdof = ijdof + 1 ; hessian(idof,jdof) = RR(ijdof) ! un-pack R matrix; old version
    do jdof = idof, NGdof_bnd ; ijdof = ijdof + 1 ; work(idof,jdof) = RR(ijdof) ! un-pack R matrix; BLAS version; 19 Jul 2019
    enddo
   enddo

!  derivative matrix = Q R;
   !hessian(1:NGdof_force,1:NGdof_bnd) = matmul( fjac(1:NGdof_force,1:NGdof_bnd), hessian(1:NGdof_force,1:NGdof_bnd) )
   call DGEMM('N','N',NGdof_bnd,NGdof_bnd,NGdof_bnd,one,fjac,NGdof_bnd,work,NGdof_bnd,zero,hessian,NGdof_bnd)     ! BLAS version; 19 Jul 2019

   DALLOCATE(work)! BLAS version; 19 Jul 2019

   call writereadgf( 'W', NGdof_bnd, ireadhessian ) ! write derivative matrix to file;

   if( Wnewton ) write(ounit,'("newton : ", 10x ," : saved  derivative matrix to file ;")')

  endif ! end of if( myid.eq.0 ) then;

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!
	call MPI_BARRIER( MPI_COMM_SPEC, ierr2)

  if( Lfindzero.eq.2 ) then
   DALLOCATE( dFFdRZ )
   DALLOCATE( dBBdmp )
   DALLOCATE( dmupfdx )
   DALLOCATE( hessian )
   DALLOCATE( dessian )
   Lhessianallocated = .false.
  endif

  DALLOCATE( fjac )
  DALLOCATE( RR )

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!
  RETURN(newton)

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

end subroutine newton

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!


!> \brief read or write force-derivative matrix
!> \ingroup grp_force_driver
!>
!> @param[in]  readorwrite
!> @param[in]  NGdof_bnd
!> @param[out] ireadhessian
subroutine writereadgf( readorwrite, NGdof_bnd , ireadhessian )

  use constants, only : zero

  use numerical, only :

  use fileunits, only : ounit, dunit

  use inputlist, only : Wnewton, Igeometry, Istellsym, Lfreebound, Nvol
  
  use bndRep,    only : Mpol_field, Ntor_field, pack_henneberg_to_hudson, pack_hudson_to_henneberg

  use cputiming, only : Tnewton

  use allglobal, only : myid, cpus, MPI_COMM_SPEC, ext, &
                        mn_field, im_field, in_field, hessian, Lhessianallocated, &
                        NGdof_force

  LOCALS

  CHARACTER, intent(in) :: readorwrite
  LOGICAL               :: exist
  INTEGER, intent(in)   :: NGdof_bnd
  INTEGER, intent(out)  :: ireadhessian

  INTEGER               :: lIgeometry, lIstellsym, lLfreebound, lNvol, lMpol, lNtor, lNGdof

  FATAL( newton, .not.Lhessianallocated, error )

  ireadhessian = 0 ! set default intent out;

  select case( readorwrite )

  case( 'W' ) ! will write derivative matrix to file;

   ! reset I/O state
   ios = 0

   open( dunit, file="."//trim(ext)//".sp.DF", status="replace", form="unformatted", iostat=ios ) ! save derivative matrix to file;
   FATAL( newton, ios.ne.0, error opening derivative matrix file )

   write( dunit, iostat=ios ) Igeometry, Istellsym, Lfreebound, Nvol, Mpol_field, Ntor_field, NGdof_bnd ! enable resolution consistency check;
   FATAL( newton, ios.ne.0, error writing Nvol, Mpol_field, Ntor_field, NGdof_bnd )

   write( dunit, iostat=ios ) hessian(1:NGdof_force,1:NGdof_bnd)
   FATAL( newton, ios.ne.0, error writing hessian to file )

   close( dunit, iostat=ios )
   FATAL( newton, ios.ne.0, error closing derivative matrix file )

  case( 'R' )

   cput = GETTIME

   inquire( file="."//trim(ext)//".sp.DF", exist=exist ) ! the derivative matrix;

   if( exist ) then !                  01234567890123456789012345678901
    write(ounit,2000) cput-cpus, myid, "reading .ext.sp.DF ;           "
    open( dunit, file="."//trim(ext)//".sp.DF", status="old", form="unformatted", iostat=ios )
   else !                              01234567890123456789012345678901
    write(ounit,2000) cput-cpus, myid, ".ext.sp.DF does not exist ;    "
    inquire( file=".sp.DF", exist=exist ) ! the derivative matrix;
    if( exist ) then !                  01234567890123456789012345678901
     write(ounit,2000) cput-cpus, myid, "reading .sp.DF ;               "
     open( dunit, file=".sp.DF", status="old", form="unformatted", iostat=ios )
    else !                              01234567890123456789012345678901
     write(ounit,2000) cput-cpus, myid, ".sp.DF does not exist ;        " ; goto 9999
    endif ! matches if( .sp.DF exist ) ;
   endif ! matches if( .ext.sp.DF exist ) ;
!                                                             01234567890123456789012345678901
   if( ios .ne. 0 ) then ; write(ounit,2000) cput-cpus, myid, "error opening .ext.sp.DF/.sp.DF" ; goto 9999
   endif

   read( dunit, iostat=ios ) lIgeometry, lIstellsym, lLfreebound, lNvol, lMpol, lNtor, lNGdof ! resolution consistency check;
!                                                             01234567890123456789012345678901
   if( ios .ne. 0 ) then ; write(ounit,2000) cput-cpus, myid, "error reading .ext.sp.DF/.sp.DF" ; goto 9998
   endif
!                                                                            01234567890123456789012345678901
   if( lIgeometry .ne.Igeometry  ) then ; write(ounit,2000) cput-cpus, myid, "inconsistent Igeometry        :", lIgeometry, Igeometry   ; goto 9998
   endif
   if( lIstellsym .ne.Istellsym  ) then ; write(ounit,2000) cput-cpus, myid, "inconsistent Istellsym        :", lIstellsym, Istellsym   ; goto 9998
   endif
   if( lLfreebound.ne.Lfreebound ) then ; write(ounit,2000) cput-cpus, myid, "inconsistent Lfreebound       :", lLfreebound, Lfreebound ; goto 9998
   endif
   if( lNvol      .ne.Nvol       ) then ; write(ounit,2000) cput-cpus, myid, "inconsistent Nvol             :", lNvol      , Nvol       ; goto 9998
   endif
   if( lMpol      .ne.Mpol_field ) then ; write(ounit,2000) cput-cpus, myid, "inconsistent Mpol             :", lMpol      , Mpol_field ; goto 9998
   endif
   if( lNtor      .ne.Ntor_field ) then ; write(ounit,2000) cput-cpus, myid, "inconsistent Ntor             :", lNtor      , Ntor_field ; goto 9998
   endif
   if( lNGdof     .ne.NGdof_bnd      ) then ; write(ounit,2000) cput-cpus, myid, "inconsistent NGdof_bnd            :", lNGdof     , NGdof_bnd      ; goto 9998
   endif

   read( dunit, iostat=ios ) hessian(1:NGdof_force,1:NGdof_bnd)
!                                                             01234567890123456789012345678901
   if( ios .ne. 0 ) then ; write(ounit,2000) cput-cpus, myid, "error reading .DF ;            " ; goto 9998
   endif

   ireadhessian = 1
!                                                             01234567890123456789012345678901
   ;                       write(ounit,2000) cput-cpus, myid, "read .DF ;                     "

9998 close( dunit, iostat=ios )

  case default

   FATAL( newton, .true., invalid readorwrite )

  end select

9999 return

2000 format("newton : ",f10.2," : myid=",i3," ; "a31,:" old="i4" ; new="i4" ;")

end subroutine writereadgf

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!


!> \brief Objective to be given to the Newton solver, using only function values.
!> \ingroup grp_force_driver
!>
!> @param[in] NGdof_bnd
!> @param[in] xx
!> @param[out] fvec
!> @param[in] irevcm
subroutine fcn1( NGdof_bnd, xx, fvec, irevcm )

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  use constants, only : zero, one, two, ten

  use numerical, only : sqrtmachprec

  use fileunits, only : ounit

  use inputlist, only : Wmacros, Wnewton, &
                        Igeometry, & ! only for screen output;
                        Nvol,                    &
                        Lboundary, &
                        Lfindzero, forcetol, c05xmax, c05xtol, c05factor, LreadGF, &
                        Lcheck

  use cputiming, only : Tnewton

  use allglobal, only : myid, ncpu, cpus, MPI_COMM_SPEC, ext, &
                        NOTstellsym, &
                        ForceErr, Energy, &
                        mn_field, im_field, in_field, iRbc, iZbs, iRbs, iZbc, Mvol, &
                        NGdof_force, NGdof_field, &
                        BBe, IIo, BBo, IIe, &
                        dFFdRZ, dBBdmp, dmupfdx, hessian, dessian, Lhessianallocated, &
                        nfreeboundaryiterations, nDcalls

  use bndRep,    only : pack_henneberg_to_hudson, pack_hudson_to_henneberg

  use newtontime

  use sphdf5, only : write_convergence_output

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  LOCALS

  INTEGER, intent(in)    :: NGdof_bnd, irevcm
  REAL   , intent(in)    :: xx(1:NGdof_bnd)
  REAL   , intent(out)   :: fvec(1:NGdof_bnd)

  REAL                   :: bndDofs(0:NGdof_bnd), force(0:NGdof_force), position(0:NGdof_field)

  LOGICAL                :: LComputeDerivatives, Lonlysolution, LComputeAxis
  INTEGER                :: idof, jdof, ijdof, ireadhessian, igdof, lvol, ii, imn, tag
  CHARACTER              :: pack
  INTEGER                :: status(MPI_STATUS_SIZE), from, to

  BEGIN(newton)

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  bndDofs = zero ; force = zero ; bndDofs(1:NGdof_bnd) = xx(1:NGdof_bnd)

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

! Generate position arraz from geometrical dofs.
  if( Lboundary.eq.0 ) then
#ifdef DEBUG
    FATAL( newton, NGdof_field.ne.NGdof_bnd, Incorrect number of dofs in boundary )
#endif
    position(0:NGdof_bnd) = bndDofs(0:NGdof_bnd)
  else
    pack = 'R'
    WCALL( newton, pack_henneberg_to_hudson, (position(0:NGdof_field), bndDofs(0:NGdof_bnd) ) )
  endif


  select case ( irevcm )

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

   case( 0 ) ! indicates start of new iteration; no action is required; bndDofs and force available for printing; force must not be changed;

    pack = 'U' ! unpack geometrical degrees of freedom;
    LComputeAxis = .true.
    LComputeDerivatives = .false.
    WCALL( newton, packxi, ( NGdof_field, position(0:NGdof_field), Mvol, mn_field, iRbc(1:mn_field,0:Mvol), iZbs(1:mn_field,0:Mvol), &
                             iRbs(1:mn_field,0:Mvol), iZbc(1:mn_field,0:Mvol), pack, LComputeDerivatives, LComputeAxis ) )

    if( myid.eq.0 ) then

     cput = GETTIME

     ; write(ounit,1000) cput-cpus, nFcalls, nDcalls, ForceErr, cput-lastcpu, "|BB|e", alog10(BBe(1:min(Mvol-1,28)))
     if( Igeometry.ge.3 .and. Lboundary.eq.0  ) then ! include spectral constraints;
      ;write(ounit,1001)                                                                      "|II|o", alog10(IIo(1:min(Mvol-1,28)))
     endif
     if( NOTstellsym ) then
      ;write(ounit,1001)                                                                      "|BB|o", alog10(BBo(1:min(Mvol-1,28)))
      if( Igeometry.ge.3 .and. Lboundary.eq.0 ) then ! include spectral constraints;
       write(ounit,1001)                                                                      "|II|e", alog10(IIe(1:min(Mvol-1,28)))
      endif
     endif
     lastcpu = GETTIME

     WCALL( newton, wrtend ) ! write restart file; save geometry to ext.end;

    endif ! end of if( myid.eq.0 );

    !WCALL( newton, write_convergence_output, ( nDcalls, ForceErr ) ) ! save iRbc, iZbs consistent with bndDofs;

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

   case( 1:2 ) ! before re-entry to C05NDF / C05PDF, force must contain the function values;

    nFcalls = nFcalls + 1

    LComputeDerivatives = .false.
    LComputeAxis = .true.

    !call MPI_Barrier( MPI_COMM_SPEC, ierr )
    !LlBCAST( ImagneticOK(1), 1, 0)
    ! if( myid.eq.0 ) then
    !   to = 1
    !   tag=2001
    !   call MPI_SEND( ImagneticOK(1), 1, MPI_LOGICAL, to, tag, MPI_COMM_SPEC, ierr )
    ! else
    !   from=0
    !   tag=2001
    !   call MPI_RECV( ImagneticOK(1), 1, MPI_LOGICAL, from, tag, MPI_COMM_SPEC, status, ierr ) 
    ! endif
    !call MPI_Barrier( MPI_COMM_SPEC, ierr )
    WCALL( newton, dforce, ( NGdof_field, position(0:NGdof_field), force(0:NGdof_force), LComputeDerivatives, LComputeAxis ) ) ! calculate the force-imbalance;

    fvec(1:NGdof_force) = force(1:NGdof_force)

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

   case default

    FATAL( fcn1 , .true., illegal irevcm : C05P*F error )

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

   end select ! end of select case(irevcm);

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

1000 format("fcn1   : ",f10.2," : "i9,i3," ; ":"|f|="es12.5" ; ":"time=",f10.2,"s ;":" log"a5"="28f6.2" ...")
1001 format("fcn1   : ", 10x ," : "9x,3x" ; ":"    "  12x "   ":"     ", 10x ,"  ;":" log"a5"="28f6.2" ...")

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

   RETURN(newton)

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

 end subroutine fcn1

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!


!> \brief Objective to be given to the Newton solver, using function values and derivatives.
!> \ingroup grp_force_driver
!>
!> @param[in]  NGdof_bnd
!> @param[in]  xx
!> @param[out] fvec
!> @param[out] fjac
!> @param[in]  Ldfjac
!> @param[in]  irevcm indicator for reverse communication; provided by solver to tell this method what to compute
subroutine fcn2( NGdof_bnd, xx, fvec, fjac, Ldfjac, irevcm )

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  use constants, only : zero, one, two, ten

  use numerical, only : sqrtmachprec

  use fileunits, only : ounit

  use inputlist, only : Wmacros, Wnewton, &
                        Igeometry, & ! only for screen output;
                        Nvol,                    &
                        Lfindzero, forcetol, c05xmax, c05xtol, c05factor, LreadGF, &
                        Lcheck, &
                        Lboundary

  use cputiming, only : Tnewton

  use allglobal, only : myid, ncpu, cpus, MPI_COMM_SPEC, ext, &
                        NOTstellsym, &
                        ForceErr, Energy, &
                        mn_field, im_field, in_field, iRbc, iZbs, iRbs, iZbc, Mvol, &
                        NGdof_force, NGdof_field, &
                        BBe, IIo, BBo, IIe, &
                        dFFdRZ, dBBdmp, dmupfdx, hessian, dessian, Lhessianallocated, &
                        nfreeboundaryiterations, nDcalls

  use newtontime

  use sphdf5, only: write_convergence_output

  use bndRep, only    : pack_henneberg_to_hudson

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  LOCALS

  INTEGER, intent(in)    :: NGdof_bnd, Ldfjac, irevcm
  REAL   , intent(in)    :: xx(1:NGdof_bnd)
  REAL   , intent(out)   :: fvec(1:NGdof_force), fjac(1:Ldfjac,1:NGdof_force)

  REAL                   :: bndDofs(0:NGdof_bnd), force(0:NGdof_force), position(0:NGdof_field)

  LOGICAL                :: LComputeDerivatives, Lonlysolution, LComputeAxis
  INTEGER                :: idof, jdof, ijdof, ireadhessian, igdof, lvol, ii, imn
  CHARACTER              :: pack

  BEGIN(newton)

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  bndDofs = zero ; force = zero ; bndDofs(1:NGdof_bnd) = xx(1:NGdof_bnd)  ! assign bndDofs to xx;

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  if( Lboundary.eq.0 ) then
#ifdef DEBUG
    FATAL( newton, NGdof_field.ne.NGdof_bnd, Incorrect number of dofs in boundary )
#endif
    position(0:NGdof_bnd) = bndDofs(0:NGdof_bnd)
  else
    pack = 'R'
    WCALL( newton, pack_henneberg_to_hudson, (position(0:NGdof_field), bndDofs(0:NGdof_bnd) ) )
  endif !Lboundary


  select case ( irevcm )

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

   case( 0 ) ! indicates start of new iteration; no action is required; bndDofs and force available for printing; force must not be changed;
    
    pack = 'U' ! unpack geometrical degrees of freedom;
    LComputeAxis = .true.
    LComputeDerivatives = .false.
    WCALL( newton, packxi, ( NGdof_field, position(0:NGdof_field), Mvol, mn_field, iRbc(1:mn_field,0:Mvol), iZbs(1:mn_field,0:Mvol), &
                             iRbs(1:mn_field,0:Mvol), iZbc(1:mn_field,0:Mvol), pack, LComputeDerivatives, LComputeAxis ) )    

    if( myid.eq.0 ) then

     cput = GETTIME

     ; write(ounit,1000) cput-cpus, nFcalls, nDcalls, ForceErr, cput-lastcpu, "|BB|e", alog10(BBe(1:min(Mvol-1,28)))
     if( Igeometry.ge.3  .and. Lboundary.eq.0 ) then ! include spectral constraints;
      ;write(ounit,1001)                                                                      "|II|o", alog10(IIo(1:min(Mvol-1,28)))
     endif
     if( NOTstellsym ) then
      ;write(ounit,1001)                                                                      "|BB|o", alog10(BBo(1:min(Mvol-1,28)))
      if( Igeometry.ge.3  .and. Lboundary.eq.0 ) then ! include spectral constraints;
       write(ounit,1001)                                                                      "|II|e", alog10(IIe(1:min(Mvol-1,28)))
      endif
     endif
     lastcpu = GETTIME

     WCALL( newton, wrtend ) ! write restart file; save geometry to ext.end;

    endif ! end of if( myid.eq.0 );

    !WCALL( newton, write_convergence_output, ( nDcalls, ForceErr ) ) ! save iRbc, iZbs consistent with bndDofs;

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

   case( 1 ) ! before re-entry to C05NDF / C05PDF, force must contain the function values;

    nFcalls = nFcalls + 1

    LComputeDerivatives = .false.
    LComputeAxis = .true.
    WCALL( newton, dforce, ( NGdof_field, position(0:NGdof_field), force(0:NGdof_force), LComputeDerivatives, LComputeAxis ) ) ! calculate the force-imbalance;

    fvec(1:NGdof_force) = force(1:NGdof_force)

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

   case( 2 ) ! before re-entry to          C05PDF, fjac must contain the derivatives;

#ifdef DEBUG
    FATAL( newton, .not.Lhessianallocated, need to allocate hessian )
#endif


    if( LreadGF .and. nDcalls.eq.1 ) then ! this is the first iteration; will check to see if derivative matrix already exists in file .DF;

     if( myid.eq.0 ) call writereadgf( 'R', NGdof_bnd, ireadhessian ) ! reads derivatives matrix from file;

     IlBCAST( ireadhessian, 1, 0 )

     if( ireadhessian.eq.1 ) then ! derivative matrix has been read from file;
      RlBCAST( hessian(1:NGdof_force,1:NGdof_bnd), NGdof_force*NGdof_bnd, 0 )
     endif

    else ! matches if( LreadGF .and. nDcalls.eq.1 ) then;

     ireadhessian = 0 ! derivative matrix has not been read from file;

    endif ! end of if( LreadGF .and. nDcalls.eq.1 ) then;

    if( ireadhessian.eq.0 ) then

      LComputeDerivatives = .true.
      LComputeAxis = .true.
      WCALL( newton, dforce, ( NGdof_field, position(0:NGdof_field), force(0:NGdof_force), LComputeDerivatives, LComputeAxis ) ) ! calculate the force-imbalance;

#ifdef DEBUG
      FATAL( newton, Lcheck.eq.4, derivatives of Beltrami field have been computed )
#endif

    endif

    fjac(1:NGdof_force,1:NGdof_bnd) = hessian(1:NGdof_force,1:NGdof_bnd) ! derivative matrix is passed through global; CAN SAVE MEMORY;

    if( myid.eq.0 ) call writereadgf( 'W', NGdof_bnd, ireadhessian ) ! will always save derivative matrix;

#ifdef DEBUG

    if( Lcheck.eq.3 ) then
     write(ounit,'("newton : ", 10x ," : myid=",i3," ; volume derivatives have been compared ;")') myid
     stop "newton :            : myid=    ; volume derivatives have been compared ;"
    endif

    FATAL( newton, Lcheck.eq.3, volume derivatives have been compared ) ! the first process will terminate all processes;

    if( (Lcheck.eq.4) .and. (nDcalls.ne.1) ) then
     write(ounit,'("newton : ", 10x ," : myid=",i3," ; field derivatives have been compared ;")') myid
     stop "newton :            : myid=    ; field derivatives have been compared ;"
    endif

    FATAL( newton, (Lcheck.eq.4) .and. (nDcalls.ne.1), field derivatives have been compared ) ! the first process will terminate all processes;

#endif

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

   case default

    FATAL( fcn2 , .true., illegal irevcm : hybrj error )

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

   end select ! end of select case(irevcm);

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

1000 format("fcn2   : ",f10.2," : "i9,i3," ; ":"|f|="es12.5" ; ":"time=",f10.2,"s ;":" log"a5"="28f6.2" ...")
1001 format("fcn2   : ", 10x ," : "9x,3x" ; ":"    "  12x "   ":"     ", 10x ,"  ;":" log"a5"="28f6.2" ...")

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

   RETURN(newton)

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

 end subroutine fcn2

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!