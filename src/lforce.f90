!> \defgroup grp_local_force "local" force
!>
!> \file
!> \brief Computes \f$B^2\f$, and the spectral condensation constraints if required, on the interfaces, \f${\cal I}_i\f$.

!> \brief Computes \f$B^2\f$, and the spectral condensation constraints if required, on the interfaces, \f${\cal I}_i\f$.
!> \ingroup grp_local_force
!>
!> **field strength**
!>
!> <ul>
!> <li> The field strength is given by \f$B^2 = B^s B_s + B^\theta B_\theta + B^\zeta B_\zeta\f$, and on the interfaces \f$B^s=0\f$ by construction. </li>
!> <li> The magnetic field is
!>       \f$\sqrt g \; {\bf B} = (\partial_\theta A_\zeta - \partial_\zeta A_\theta ) {\bf e}_s - \partial_s A_\zeta {\bf e}_\theta + \partial_s A_\theta {\bf e}_\zeta\f$. </li>
!> <li> The covariant components of the field are computed via \f$B_\theta = B^\theta g_{\theta\theta} + B^\zeta g_{\theta\zeta}\f$ and \f$B_\zeta = B^\theta g_{\theta\zeta} + B^\zeta g_{\zeta\zeta}\f$. </li>
!> <li> The expression for \f$B^2\f$ is
!>       \f{eqnarray}{
!>       (\sqrt g)^2 B^2 = A_\zeta^\prime \; A_\zeta^\prime \; g_{\theta\theta} - 2 \; A_\zeta^\prime \; A_\theta^\prime \; g_{\theta\zeta} + A_\theta^\prime \; A_\theta^\prime \; g_{\zeta\zeta},
!>       \f}
!>       where the \f$"\prime"\f$ denotes derivative with respect to \f$s\f$. </li>
!> <li> The quantity returned is
!>       \f{eqnarray}{ F \equiv \texttt{pscale} \times \frac{P}{V^\gamma} + \frac{B^2}{2},
!>       \f}
!>       where \f$P\equiv\f$ \c adiabatic  and \f$V\equiv\f$ volume. </li>
!> </ul>
!>
!> **spectral constraints**
!>
!> <ul>
!> <li> In addition to the physical-force-balance constraints, namely that \f$[[p+B^2/2]]=0\f$ across the interfaces,
!>       additional angle constraints are required to obtain a unique Fourier representation of the interface geometry. </li>
!> <li> Introducing the angle functional: a weighted combination of the "polar" constraint;
!>       the normalized, poloidal, spectral width (Hirshman & Meier (1985) \cite y1985_hirshman, Hirshman & Breslau (1998) \cite y1998_hirshman)
!>       the poloidal-angle origin constraint; and the "length" of the angle curves
!>       \f{eqnarray}{ F \!\equiv\! \sum_{i=1}^{N-1} \alpha_i \underbrace{\oint\!\!\!\oint \!d\theta d\zeta \,\,\, \!\! \frac{1}{\Theta_{i,\theta}}}_{polar-angle}
!>                            +     \sum_{i=1}^{N-1} \beta_i \, \underbrace{\;\; M_i \;\;}_{spectral-width}
!>                            +     \sum_{i=1}^{N-1} \gamma_i \int_{0}^{2\pi} \! \frac{1}{2}\left[Z_i(0,\zeta)-Z_{i,0}\right]^2 d\zeta
!>                            +     {\color{red}{\oint\!\!\!\oint \!d\theta d\zeta \,\,\, \!\! \sum_{i=1}^{N} \delta_i \, \underbrace{\;\;\;\; L_i \;\;\;\;}_{poloidal-length}}}
!>       \f}
!>       where \f$i\f$ labels the interfaces, and
!>       \f{eqnarray}{ \Theta_{i,\theta} & \equiv & \frac{x \, y_\theta - x_\theta \, y}{x^2+y^2}, \\
!>       M_i          & \equiv & \frac{\sum_j m_j^p ( R_{j,i}^2 + Z_{j,i}^2 )}{\sum_j       ( R_{j,i}^2 + Z_{j,i}^2 )} ,\\
!>       {\color{red}{L_i}}          & \equiv & {\color{red}{\sqrt{      [R_{i}(\theta,\zeta)-R_{i-1}(\theta,\zeta)]^2+[Z_{i}(\theta,\zeta)-Z_{i-1}(\theta,\zeta)]^2}}},
!>       \f}
!>       and where \f$j\f$ labels the Fourier harmonics.
!>       The \f$\alpha_i\f$, \f$\beta_i\f$, \f$\gamma_i\f$ and \f$\delta_i \equiv \f$ \c sweight are user-supplied weight factors. </li>
!> <li> The polar constraint is derived from defining \f$\tan \Theta \equiv y/x\f$, where
!>       \f{eqnarray}{ x(\theta,\zeta) &  \equiv &  R_{i}(\theta,\zeta)-R_{i,0}(\zeta), \\
!>           y(\theta,\zeta) &  \equiv &  Z_{i}(\theta,\zeta)-Z_{i,0}(\zeta),
!>       \f}
!>       and where the geometric center of each interface is given by the arc-length weighted integrals, see rzaxis(),
!>       \f{eqnarray}{
!>           R_{i,0} & \equiv & \int_0^{2\pi} \!\!\!\! d\theta \; R_i(\theta,\zeta) \sqrt{R_{i,\theta}(\theta,\zeta)^2+Z_{i,\theta}(\theta,\zeta)^2}, \\
!>           Z_{i,0} & \equiv & \int_0^{2\pi} \!\!\!\! d\theta \; Z_i(\theta,\zeta) \sqrt{R_{i,\theta}(\theta,\zeta)^2+Z_{i,\theta}(\theta,\zeta)^2},
!>       \f}
!>       and \f$\cos \Theta = x / \sqrt{x^2+y^2}\f$ has been used to simplify the expressions and to avoid divide-by-zero. </li>
!> <li> Only "poloidal tangential" variations will be allowed to find the extremum of \f$F\f$, which are described by
!>       \f{eqnarray}{
!>           \delta R_i(\theta,\zeta) & \equiv & R_{i,\theta}(\theta,\zeta) \, \delta u_i(\theta,\zeta),\\
!>           \delta Z_i(\theta,\zeta) & \equiv & Z_{i,\theta}(\theta,\zeta) \, \delta u_i(\theta,\zeta),
!>       \f}
!>       from which it follows that the variation in each Fourier harmonic is
!>       \f{eqnarray}{
!>           \delta R_{j,i} = \displaystyle \oint\!\!\!\oint \!d\theta d\zeta \,\,\, R_{i,\theta}(\theta,\zeta) \, \delta u_i(\theta,\zeta) \, \cos(m_j\theta-n_j\zeta), \\
!>           \delta Z_{j,i} = \displaystyle \oint\!\!\!\oint \!d\theta d\zeta \,\,\, Z_{i,\theta}(\theta,\zeta) \, \delta u_i(\theta,\zeta) \, \sin(m_j\theta-n_j\zeta),
!>       \f}
!>       and
!>       \f{eqnarray}{
!>           \delta R_{i,\theta}(\theta,\zeta) & \equiv & R_{i,\theta\theta}(\theta,\zeta) \, \delta u_i(\theta,\zeta) + R_{i,\theta}(\theta,\zeta) \, \delta u_{i,\theta} (\theta,\zeta) \\
!>           \delta Z_{i,\theta}(\theta,\zeta) & \equiv & Z_{i,\theta\theta}(\theta,\zeta) \, \delta u_i(\theta,\zeta) + Z_{i,\theta}(\theta,\zeta) \, \delta u_{i,\theta} (\theta,\zeta)
!>       \f} </li>
!> <li> The variation in \f$F\f$ is
!>       \f{eqnarray}{ \delta F
!>       & = & \sum_{i=1}^{N-1} \alpha_i \;\;\;\oint\!\!\!\oint \!d\theta d\zeta \,\,\, \!\! \left( \frac{-2\Theta_{i,\theta\theta}}{\Theta_{i,\theta}^2} \right) \delta u_i \nonumber \\
!>       & + & \sum_{i=1}^{N-1} \beta_i  \;\;\;\oint\!\!\!\oint \!d\theta d\zeta \,\,\, \!\! \left( R_{i,\theta} X_i + Z_{i,\theta} Y_i \right) \delta u_i \nonumber \\
!>       & + & \sum_{i=1}^{N-1} \gamma_i  \;\;\; \int \! d\zeta \;   \left( Z_{i}(0,\zeta)-Z_{i,0} \right) Z_{i,\theta} \; \delta u_i \nonumber \\
!>       & + & {\color{red}{\sum_{i=1}^{N-1} \delta_i \;\;\;\oint\!\!\!\oint \!d\theta d\zeta \,\,\, \!\! \left( \frac{\Delta R_{i  } R_{i,\theta} + \Delta Z_{i  } Z_{i,\theta}}{L_{i  }} \right)
!>             \delta u_i}}
!>       \nonumber \\
!>       & - & {\color{red}{\sum_{i=1}^{N-1} \delta_{i+1}   \oint\!\!\!\oint \!d\theta d\zeta \,\,\, \!\! \left( \frac{\Delta R_{i+1} R_{i,\theta} + \Delta Z_{i+1} Z_{i,\theta}}{L_{i+1}} \right)
!>             \delta u_i}}
!>       \label{eq:firstvariation_lforce}
!>       \f}
!>       where, for the stellarator symmetric case,
!>       \f{eqnarray}{
!>           X_i & \equiv & \displaystyle \sum\nolimits_j ( m_j^p - M_i ) \, R_{j,i} \cos(m_j\theta-n_j\zeta), \\
!>           Y_i & \equiv & \displaystyle \sum\nolimits_j ( m_j^p - M_i ) \, Z_{j,i} \sin(m_j\theta-n_j\zeta),
!>       \f}
!>       and
!>       \f{eqnarray}{ {\color{red}{\Delta R_{i}}} & \equiv & {\color{red}{R_{i}(\theta,\zeta)-R_{i-1}(\theta,\zeta)}},\\
!>           {\color{red}{\Delta Z_{i}}} & \equiv & {\color{red}{Z_{i}(\theta,\zeta)-Z_{i-1}(\theta,\zeta)}},
!>       \f} </li>
!> <li> The spectral constraints derived from Eqn.\f$(\ref{eq:firstvariation_lforce})\f$ are
!>       \f{eqnarray}{ I_i(\theta,\zeta) & \equiv & - 2 \alpha_i \frac{\Theta_{i,\theta\theta}}{\Theta_{i,\theta}^{2}}
!>               + \beta_i \left( R_{i,\theta} X_i + Z_{i,\theta} Y_i \right)
!>               + \gamma_i \left( Z_{i}(0,\zeta) - Z_{i,0} \right) Z_{i,\theta}(0,\zeta) \nonumber \\
!>             & + & {\color{red}{\delta_{i  } \frac{\Delta R_{i  } R_{i,\theta} + \Delta Z_{i  } Z_{i,\theta}}{L_i}}}
!>               -   {\color{red}{\delta_{i+1} \frac{\Delta R_{i+1} R_{i,\theta} + \Delta Z_{i+1} Z_{i,\theta}}{L_{i+1} } } }
!>       \label{eq:spectralconstraints_lforce}
!>       \f} </li>
!> <li> Note that choosing \f$p=2\f$ gives \f$X=-R_{\theta\theta}\f$ and \f$Y=-Z_{\theta\theta}\f$, and the spectrally condensed angle constraint, \f$R_\theta X + Z_\theta Y=0\f$,
!>       becomes \f$\partial_\theta (R_\theta^2+Z_\theta^2)=0\f$,
!>       which defines the equal arc length angle. </li>
!> <li> The poloidal-angle origin term, namely \f$\gamma_i \left( Z_{i}(0,\zeta) - Z_{i,0} \right) Z_{i,\theta}(0,\zeta)\f$
!>       is only used to constrain the \f$m_j=0\f$ harmonics. </li>
!> <li> The construction of the angle functional was influenced by the following considerations: </li>
!>       <ul>
!>       <li>The minimal spectral width constraint is very desirable as it reduces the required Fourier resolution,
!>             but it does not constrain the \f$m=0\f$ harmonics
!>             and the minimizing spectral-width poloidal-angle may not be consistent with the poloidal angle used on adjacent interfaces. </li>
!>       <li>  The regularization of the vector potential and the coordinate interpolation near the coordinate origin (see elsewhere)
!>             assumes that the poloidal angle is the polar angle. </li>
!>       <li> The user will provide the Fourier harmonics of the boundary, and thus the user will implicitly define the poloidal angle used on the boundary. </li>
!>       <li>  Minimizing the length term will ensure that the poloidal angle used on each interface
!>             is smoothly connected to the poloidal angle used on adjacent interfaces. </li>
!>       </ul> </li>
!> <li> A suitable choice of the weight factors, \f$\alpha_i\f$, \f$\beta_i\f$, \f$\gamma_i\f$ and \f$\delta_i\f$, will ensure
!>       that the polar constraint dominates for the innermost surfaces and that this constraint rapidly becomes insignificant away from the origin;
!>       that the minimal spectral constraint dominates in the "middle";
!>       and that the minimizing length constraint will be significant near the origin and dominant near the edge,
!>       so that the minimizing spectral width angle will be continuously connected to the polar angle on the innermost surfaces
!>       and the user-implied angle at the plasma boundary.
!>       The length constraint should not be insignificant where the spectral constraint is dominant (so that the \f$m=0\f$ harmonics are constrained). </li>
!> <li> The polar constraint does not need normalization.
!>       The spectral width constraint has already been normalized.
!>       The length constraint is not yet normalized, but perhaps it should be. </li>
!> <li> The spectral constraints given in Eqn.\f$(\ref{eq:spectralconstraints_lforce})\f$ need to be differentiated
!>       with respect to the interface Fourier harmonics, \f$R_{j,i}\f$ and \f$Z_{j,i}\f$.
!>       The first and second terms lead to a block diagonal hessian, and the length term leads to a block tri-diagonal hessian. </li>
!> <li> Including the poloidal-angle origin constraint means that the polar angle constraint can probably be ignored, i.e. \f$\alpha_i=0\f$. </li>
!> </ul>
!>
!> @param[in] lvol
!> @param[in] iocons
!> @param[in] ideriv
!> @param[in] Ntz
!> @param dBB
!> @param XX
!> @param YY
!> @param length
!> @param DDl
!> @param MMl
!> @param[in] iflag
subroutine lforce( lvol, iocons, ideriv, Ntz, dBB, XX, YY, length, DDl, MMl, iflag )

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  use constants, only : zero, half, one, two

  use fileunits, only : ounit

  use inputlist, only : Wlforce, Igeometry, Nvol, Lrad, gamma, pscale, adiabatic, Lcheck

  use cputiming, only : Tlforce

  use allglobal, only : ncpu, myid, cpus, MPI_COMM_SPEC, &
                        Lcoordinatesingularity, Mvol, &
                        iRbc, iZbs, iRbs, iZbc, &
                        YESstellsym, NOTstellsym, &
                        mn, im, in, regumm, &
                        ijreal, ijimag, jireal, jiimag, &
                        efmn, ofmn, cfmn, sfmn, evmn, odmn, comn, simn, &
                        Nt, Nz, &
                        Ate, Aze, Ato, Azo, &
                        TT, RTT, &
                        sg, guvij, iRij, iZij, dRij, dZij, tRij, tZij, &
                        mmpp, &
                        Bemn, Bomn, Iomn, Iemn, Somn, Semn, &
                        Pomn, Pemn, &
                        vvolume, &
                        build_vector_potential

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  LOCALS

  INTEGER, intent(in)  :: lvol, iocons, ideriv, Ntz, iflag
  REAL                 :: dAt(1:Ntz, -1:2), dAz(1:Ntz, -1:2), XX(1:Ntz), YY(1:Ntz), dRR(1:Ntz,-1:1), dZZ(1:Ntz,-1:1), DDl, MMl

  REAL                 :: IIl(1:Ntz), length(1:Ntz), dLL(1:Ntz)
  INTEGER              :: Lcurvature, ii, jj, kk, ll, ifail, ivol, lnn, mi, id!, oicons
  REAL                 :: dBB(1:Ntz, -1:2), lss, mfactor

  REAL                 :: dAs(1:Ntz)!, dRdt(-1:1,0:1), dZdt(-1:1,0:1)
  REAL                 :: lgvuij(1:Ntz,1:3,1:3) ! local workspace; 13 Sep 13;

  BEGIN(lforce)

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

#ifdef DEBUG
  FATAL( lforce, lvol.lt.1 .or. lvol.gt.Mvol, illegal lvol )
  FATAL( lforce, lvol.eq.1 .and. iocons.eq.0, illegal combination )
  FATAL( lforce, lvol.eq.Mvol .and. iocons.eq.1, illegal combination )
  FATAL( lforce, iflag.lt.0 .or. iflag.gt.1, illegal iflag )
#endif

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  dAt(1:Ntz, -1:2) = zero ! initialize intent out; 01 Jul 14;
  dAz(1:Ntz, -1:2) = zero ! initialize intent out; 01 Jul 14;

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  lss = two * iocons - one ! recall that iocons is effective local radial coordinate; 24 Apr 13;

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  Lcurvature = 1

  WCALL( lforce, coords, ( lvol, lss, Lcurvature, Ntz, mn ) ) ! get coordinates and derivatives wrt Rj, Zj, at specific radial location;

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

! if( lvol.eq.Mvol .and. ideriv.eq.0 ) then
!  ii = 1
!  write(ounit,'("lforce : ", 10x ," : sum(Ate(",i3,",",i2,",",i2,")%s) =",99es23.15)') lvol, ideriv, ii, sum(Ate(lvol,ideriv,ii)%s(0:Lrad(lvol)))
! endif

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

! compute B^2 on interface;
  ! Compute covariant vector potential. Stored in efmn, ofmn, cfmn, sfmn.
  !                                         ideriv, tderiv
  call build_vector_potential(lvol, iocons,      0)

  ! Map to real space
  call invfft( mn, im, in, efmn(1:mn), ofmn(1:mn), cfmn(1:mn), sfmn(1:mn), Nt, Nz, dAt(1:Ntz, 0), dAz(1:Ntz, 0) )

  id = ideriv
  if( id.eq.0 ) then

    dBB(1:Ntz,id) = half * (        dAz(1:Ntz, id)*dAz(1:Ntz, id)*guvij(1:Ntz,2,2,id) &
                            - two * dAz(1:Ntz, id)*dAt(1:Ntz, id)*guvij(1:Ntz,2,3,id) &
                            +       dAt(1:Ntz, id)*dAt(1:Ntz, id)*guvij(1:Ntz,3,3,id)  ) / sg(1:Ntz,0)**2

  else
    ! Compute covariant vector potential. Stored in efmn, ofmn, cfmn, sfmn.
    call build_vector_potential(lvol, iocons, id)
    ! Map to real space
    call invfft( mn, im, in, efmn(1:mn), ofmn(1:mn), cfmn(1:mn), sfmn(1:mn), Nt, Nz, dAt(1:Ntz, id), dAz(1:Ntz, id) )

    dBB(1:Ntz,id) = half * (        dAz(1:Ntz,id)*dAz(1:Ntz, 0)*guvij(1:Ntz,2,2,0) &
                            - two * dAz(1:Ntz,id)*dAt(1:Ntz, 0)*guvij(1:Ntz,2,3,0) &
                            +       dAt(1:Ntz,id)*dAt(1:Ntz, 0)*guvij(1:Ntz,3,3,0) &
                            +       dAz(1:Ntz, 0)*dAz(1:Ntz,id)*guvij(1:Ntz,2,2,0) &
                            - two * dAz(1:Ntz, 0)*dAt(1:Ntz,id)*guvij(1:Ntz,2,3,0) &
                            +       dAt(1:Ntz, 0)*dAt(1:Ntz,id)*guvij(1:Ntz,3,3,0)  ) / sg(1:Ntz,0)**2
  endif ! end of if( ideriv.gt.0 ) ;

  ! If derivatives w.r.t geometry, take into account metric derivatives
  if( ideriv.eq.-1 ) then
    ! Get coordinate metrics and their derivatives wrt Rj, Zj on interface;
    lss = two * iocons - one ; Lcurvature = 4
    WCALL( lforce, coords, ( lvol, lss, Lcurvature, Ntz, mn ) )

    dBB(1:Ntz,id) = dBB(1:Ntz, id) + &
                    half * (        dAz(1:Ntz, 0)*dAz(1:Ntz, 0)*guvij(1:Ntz,2,2,1) &
                            - two * dAz(1:Ntz, 0)*dAt(1:Ntz, 0)*guvij(1:Ntz,2,3,1) &
                            +       dAt(1:Ntz, 0)*dAt(1:Ntz, 0)*guvij(1:Ntz,3,3,1)  ) / sg(1:Ntz,0)**2 &
                    - dBB(1:Ntz,0) * two * sg(1:Ntz,1) / sg(1:Ntz,0)
  endif

  ijreal(1:Ntz) = adiabatic(lvol) * pscale / vvolume(lvol)**gamma + dBB(1:Ntz, 0) ! p + B^2/2; 13 Sep 13;

#ifdef DEBUG
	if( Wlforce ) then
		write(ounit, 8375) lvol, iocons, ideriv, dAz(1:Ntz, id), dAt(1:Ntz, id)
		write(ounit, 8376) lvol, iocons, ideriv, guvij(1:Ntz,2,2,0), guvij(1:Ntz,2,3,0), guvij(1:Ntz,3,3,0), sg(1:Ntz,0)

8375 format("lforce : lvol=",i7,", iocons=", i7, ", ideriv=", i7 ,"; dAz=",f10.6,", dAt=", f10.6)
8376 format("lforce : lvol=",i7,", iocons=", i7, ", ideriv=", i7 ,"; g22=",f10.6,", g23=", f10.6,", g33=", f10.6,", sg=", f10.6)
	endif
#endif


!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  if( iflag .eq. 1 ) goto 9999 ! iflag = 1 indicates the derivatives of the force are to be calculated; derivatives of magnetic field calculated above;

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

! compute spectral constraints;

  select case( Igeometry )

  case( 1:2 ) ; dLL(1:Ntz) = zero ! placeholder; 08 Feb 16;
   ;          ; IIl(1:Ntz) = zero ! placeholder; 11 Aug 14;
  case(   3 )

   do ivol = 0, 1

    call invfft( mn, im(1:mn), in(1:mn),            iRbc(1:mn ,lvol-1+ivol),              iRbs(1:mn ,lvol-1+ivol), &
                                                    iZbc(1:mn ,lvol-1+ivol),              iZbs(1:mn ,lvol-1+ivol), &
                                         Nt, Nz,    iRij(1:Ntz,lvol-1+ivol),              iZij(1:Ntz,lvol-1+ivol)   )

    call invfft( mn, im(1:mn), in(1:mn), im(1:mn) * iRbs(1:mn ,lvol-1+ivol), - im(1:mn) * iRbc(1:mn ,lvol-1+ivol), &
                                         im(1:mn) * iZbs(1:mn ,lvol-1+ivol), - im(1:mn) * iZbc(1:mn ,lvol-1+ivol), &
                                         Nt, Nz,    tRij(1:Ntz,lvol-1+ivol),              tZij(1:Ntz,lvol-1+ivol) )
   enddo ! end of do ivol = 0, 1 ; 18 Jul 14;

   dRij(1:Ntz,lvol) = iRij(1:Ntz,lvol) - iRij(1:Ntz,lvol-1)
   dZij(1:Ntz,lvol) = iZij(1:Ntz,lvol) - iZij(1:Ntz,lvol-1)

   length(1:Ntz) = sqrt( dRij(1:Ntz,lvol)**2 + dZij(1:Ntz,lvol)**2 )

   dLL(1:Ntz) = ( dRij(1:Ntz,lvol) * tRij(1:Ntz,lvol-1+iocons) + dZij(1:Ntz,lvol) * tZij(1:Ntz,lvol-1+iocons) ) / length(1:Ntz)

   if( iocons.eq.1 ) then ! include spectral condensation constraints; local to interface, i.e. no tri-diagonal structure;
    ;                      ; efmn(1:mn) = ( mmpp(1:mn)            ) * iRbc(1:mn,lvol)
    ;                      ; sfmn(1:mn) = ( mmpp(1:mn)            ) * iZbs(1:mn,lvol)
    if( NOTstellsym ) then ; ofmn(1:mn) = ( mmpp(1:mn)            ) * iRbs(1:mn,lvol)
     ;                     ; cfmn(1:mn) = ( mmpp(1:mn)            ) * iZbc(1:mn,lvol)
    else                   ; ofmn(1:mn) = zero
     ;                     ; cfmn(1:mn) = zero
    endif ! end of if( NOTstellsym ) ; 20 Feb 13;

    call invfft( mn, im(1:mn), in(1:mn), efmn(1:mn), ofmn(1:mn), cfmn(1:mn), sfmn(1:mn), &
                 Nt, Nz, XX(1:Ntz), YY(1:Ntz) )

    if( YESstellsym ) then ; DDl = sum(              ( iRbc(1:mn,lvol)**2 + iZbs(1:mn,lvol)**2                                           ) )
     ;                     ; MMl = sum( mmpp(1:mn) * ( iRbc(1:mn,lvol)**2 + iZbs(1:mn,lvol)**2                                           ) ) / DDl
    else                   ; DDl = sum(              ( iRbc(1:mn,lvol)**2 + iZbs(1:mn,lvol)**2 + iRbs(1:mn,lvol)**2 + iZbc(1:mn,lvol)**2 ) )
     ;                     ; MMl = sum( mmpp(1:mn) * ( iRbc(1:mn,lvol)**2 + iZbs(1:mn,lvol)**2 + iRbs(1:mn,lvol)**2 + iZbc(1:mn,lvol)**2 ) ) / DDl
    endif

    IIl(1:Ntz) = tRij(1:Ntz,lvol) * ( XX(1:Ntz) - MMl * iRij(1:Ntz,lvol) ) &
               + tZij(1:Ntz,lvol) * ( YY(1:Ntz) - MMl * iZij(1:Ntz,lvol) )

   else ! matches if( iocons.eq.1 ) ; 11 Aug 14;

    IIl(1:Ntz) = zero ! placeholder; 11 Aug 14;

   endif ! end of if( iocons.eq.1 ) ; 20 Feb 13;

  end select ! end of select case( Igeometry ) ; 08 Feb 16;

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

!  ijreal(1:Ntz) contains the pressure + magnetic energy term;

#ifdef DEBUG
  FATAL( lforce, iocons.lt.0 .or. iocons.gt.2, error )
#endif

  ;ifail = 0
  ;call tfft( Nt, Nz, ijreal(1:Ntz), IIl(1:Ntz  ), & ! compute force-imbalance and spectral constraints;
              mn, im(1:mn), in(1:mn), Bemn(1:mn,lvol,iocons), Bomn(1:mn,lvol,iocons), Iemn(1:mn,lvol       ), Iomn(1:mn,lvol       ), ifail )

  if( Igeometry.ge.3 ) then ! add minimal length constraint; 18 Jul 14;

   ifail = 0 ; ijimag(1:Ntz) = zero

   call tfft( Nt, Nz, dLL(1:Ntz), ijimag(1:Ntz), &
              mn, im(1:mn), in(1:mn), Semn(1:mn,lvol,iocons), Somn(1:mn,lvol,iocons), Pemn(1:mn,lvol,iocons), Pomn(1:mn,lvol,iocons), ifail )

#ifdef DEBUG
   if( Wlforce ) then
    write(ounit,'("lforce : ", 10x ," : lvol=",i3," ; iocons="i2" ; Somn="999es13.5)') lvol, iocons, Somn(1:mn,lvol,iocons)
    write(ounit,'("lforce : ", 10x ," : lvol=",i3," ; iocons="i2" ; Semn="999es13.5)') lvol, iocons, Semn(1:mn,lvol,iocons)
   endif
#endif

  endif ! end of if( Igeometry.eq.3 ) ; 01 Jul 14;

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  RETURN(lforce)

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

 end subroutine lforce

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!
