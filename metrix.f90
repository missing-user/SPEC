!> \defgroup grp_metrics Metric quantities
!>
!> \file metrix.f90
!> \brief Calculates the metric quantities, \f$\sqrt g \, g^{\mu\nu}\f$, which are required for the energy and helicity integrals.

!> \brief Calculates the metric quantities, \f$\sqrt g \, g^{\mu\nu}\f$, which are required for the energy and helicity integrals.
!> \ingroup grp_metrics
!> 
!> **metrics**
!>
!> <ul>
!> <li> The Jacobian, \f$\sqrt g\f$, and the "lower" metric elements, \f$g_{\mu\nu}\f$, are calculated by coords(),
!>      and are provided on a regular grid in "real-space", i.e. \f$(\theta,\zeta)\f$, at a given radial location, i.e. where \f$s\f$ is input. </li>
!> </ul>
!>
!> **plasma region**
!>
!> <ul>
!> <li>  In the plasma region, the required terms are \f$\bar g_{\mu\nu} \equiv g_{\mu\nu}/\sqrt g\f$.
!>
!>       \f{eqnarray}{ \begin{array}{ccccccccccccccccccccccccc}
!>       \sqrt g \; g^{s     s     } & = & \left( g_{\theta\theta} g_{\zeta \zeta } - g_{\theta\zeta } g_{\theta\zeta } \right) / \sqrt g \\
!>       \sqrt g \; g^{s     \theta} & = & \left( g_{\theta\zeta } g_{s     \zeta } - g_{s     \theta} g_{\zeta \zeta } \right) / \sqrt g \\
!>       \sqrt g \; g^{s     \zeta } & = & \left( g_{s     \theta} g_{\theta\zeta } - g_{\theta\theta} g_{s     \zeta } \right) / \sqrt g \\
!>       \sqrt g \; g^{\theta\theta} & = & \left( g_{\zeta \zeta } g_{s     s     } - g_{s     \zeta } g_{s     \zeta } \right) / \sqrt g \\
!>       \sqrt g \; g^{\theta\zeta } & = & \left( g_{s     \zeta } g_{s     \theta} - g_{\theta\zeta } g_{s     s     } \right) / \sqrt g \\
!>       \sqrt g \; g^{\zeta \zeta } & = & \left( g_{s     s     } g_{\theta\theta} - g_{s     \theta} g_{s     \theta} \right) / \sqrt g
!>       \end{array}
!>       \f} </li>
!> </ul>
!>
!> **FFTs**
!>
!> <ul>
!> <li> After constructing the required quantities in real space, FFTs provided the required Fourier harmonics, which are returned through global.f90 .
!>      (The "extended" Fourier resolution is used.) </li>
!> </ul>
subroutine metrix( lvol, lss ) 
  
!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!
  
  use constants, only : zero, one
  
  use numerical, only : small
  
  use fileunits, only : ounit
  
  use inputlist, only : Wmetrix
  
  use cputiming, only : Tmetrix
  
  use allglobal, only : myid, ncpu, cpus, &
                        dBdX, &
                        mn, im, in, mne, ime, ine, &
                        Nt, Nz, Ntz, efmn, ofmn, cfmn, sfmn, &   ! 10 Dec 15;
                        ijreal, &                                ! workspace;
                        sg, guvij, &                             ! calculated in coords;
                        gvuij, &                                 ! this is workspace: nowhere used outside of this routine;
                        goomne, goomno, &
                        gssmne, gssmno, &
                        gstmne, gstmno, &
                        gszmne, gszmno, &
                        gttmne, gttmno, &
                        gtzmne, gtzmno, &
                        gzzmne, gzzmno
  
!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!
  
  LOCALS
  
  INTEGER, intent(in) :: lvol
  REAL   , intent(in) :: lss
  
  INTEGER             :: Lcurvature, ifail, ideriv
  
  BEGIN( metrix )
  
!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!
  
#ifdef DEBUG
  FATAL( metrix, abs(lss).gt.one, invalid local radial coordinate )
#endif
  
!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!
  
  if( dBdX%L ) then ; Lcurvature = 3 ; ideriv = 1
  else              ; Lcurvature = 1 ; ideriv = 0
  endif
  
  WCALL( metrix, coords, ( lvol, lss, Lcurvature, Ntz, mn ) ) ! this returns guvij \equiv g_{\mu\nu}; 17 Apr 13;
  
!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!
  
  gvuij(1:Ntz,0,0) =   guvij(1:Ntz,0,0,ideriv) ! required for helicity calculation; 17 Dec 15;
  
  gvuij(1:Ntz,1,1) =   guvij(1:Ntz,1,1,ideriv) / sg(1:Ntz,0) ! 10 Dec 15;
  gvuij(1:Ntz,1,2) =   guvij(1:Ntz,1,2,ideriv) / sg(1:Ntz,0)
  gvuij(1:Ntz,1,3) =   guvij(1:Ntz,1,3,ideriv) / sg(1:Ntz,0)
  gvuij(1:Ntz,2,2) =   guvij(1:Ntz,2,2,ideriv) / sg(1:Ntz,0)
  gvuij(1:Ntz,2,3) =   guvij(1:Ntz,2,3,ideriv) / sg(1:Ntz,0)
  gvuij(1:Ntz,3,3) =   guvij(1:Ntz,3,3,ideriv) / sg(1:Ntz,0)
  
!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!
  
  ijreal(1:Ntz) = zero

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  ifail = 0
  call tfft( Nt, Nz, gvuij(1:Ntz,0,0), ijreal(1:Ntz) , &
             mne, ime(1:mne), ine(1:mne), goomne(1:mne), goomno(1:mne), cfmn(1:mne)    , sfmn(1:mne)    , ifail )
  goomne(0) = zero ; goomno(0) = zero

  ifail = 0
  call tfft( Nt, Nz, gvuij(1:Ntz,1,1), gvuij(1:Ntz,1,2), &
             mne, ime(1:mne), ine(1:mne), gssmne(1:mne), gssmno(1:mne), gstmne(1:mne), gstmno(1:mne), ifail )
  gssmne(0) = zero ; gssmno(0) = zero
  gstmne(0) = zero ; gstmno(0) = zero

  ifail = 0
  call tfft( Nt, Nz, gvuij(1:Ntz,1,3), gvuij(1:Ntz,2,2), &
             mne, ime(1:mne), ine(1:mne), gszmne(1:mne), gszmno(1:mne), gttmne(1:mne), gttmno(1:mne), ifail )
  gszmne(0) = zero ; gszmno(0) = zero
  gttmne(0) = zero ; gttmno(0) = zero

  ifail = 0
  call tfft( Nt, Nz, gvuij(1:Ntz,2,3), gvuij(1:Ntz,3,3), &
             mne, ime(1:mne), ine(1:mne), gtzmne(1:mne), gtzmno(1:mne), gzzmne(1:mne), gzzmno(1:mne), ifail )
  gtzmne(0) = zero ; gtzmno(0) = zero
  gzzmne(0) = zero ; gzzmno(0) = zero
   
!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!
  
  RETURN( metrix )
  
!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!
  
end subroutine metrix

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!