!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

!title (coordinate axis) ! Specifies position of coordinate axis; ${\bf x}_a(\zeta) \equiv \int {\bf x}_1(\theta,\zeta) dl \, / \int dl$.

!latex \briefly{The coordinate axis is assigned via a poloidal average over an arbitrary surface.}

!latex \calledby{\link{preset}, \link{packxi}}

!latex \tableofcontents

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

!latex \subsection{coordinate axis}

!latex \begin{enumerate}
!latex \item The coordinate axis is {\em not} an independent degree-of-freedom of the geometry.
!latex       It is constructed by extrapolating the geometry of a given interface, as determined by $i \equiv $ \internal{ivol} which is given on input,
!latex       down to a line.
!latex \item If the coordinate axis depends only on the {\em geometry} of the interface and not the angle parameterization,
!latex       then the block tri-diagonal structure of the the force-derivative matrix is preserved.
!latex \item Define the arc-length-weighted averages,
!latex       \be R_0(\z) \equiv \frac{\ds \int_{0}^{2\pi} R_i(\t,\z) \, dl}{\ds \int_{0}^{2\pi} \!\!\!\! dl}, \qquad
!latex           Z_0(\z) \equiv \frac{\ds \int_{0}^{2\pi} Z_i(\t,\z) \, dl}{\ds \int_{0}^{2\pi} \!\!\!\! dl},
!latex       \ee
!latex       where $dl \equiv \dot l \, d\t = \sqrt{ \partial_\t R_i(\t,\z)^2 + \partial_\t Z_i(\t,\z)^2 } \, d\t$.
!latex \item (Note that if $\dot l$ does not depend on $\t$, i.e. if $\t$ is the equal arc-length angle, then the expressions simplify.
!latex        This constraint is not enforced.)
!latex \item The geometry of the coordinate axis thus constructed only depends on the geometry of the interface, i.e. 
!latex       the angular parameterization of the interface is irrelevant.
!latex \end{enumerate}

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

!latex \subsection{coordinate axis: derivatives}

!latex \begin{enumerate}
!latex \item The derivatives of the coordinate axis with respect to the Fourier harmonics of the given interface are given by
!latex       \be
!latex       \ds \frac{\partial R_0}{\partial R_{i,j}^c} & = & \ds \int \left( \cos\a_j \; \dot l
!latex                                                     -       \Delta R_i R_{i,\t} \, m_j \sin\a_j / \; \dot l \right) d\t / L \\
!latex       \ds \frac{\partial R_0}{\partial R_{i,j}^s} & = & \ds \int \left( \sin\a_j \; \dot l
!latex                                                     +       \Delta R_i R_{i,\t} \, m_j \cos\a_j / \; \dot l \right) d\t / L \\
!latex       \ds \frac{\partial R_0}{\partial Z_{i,j}^c} & = & \ds \int \left( \;\;\;\;\;\;\;\;\;\;\;\;\,
!latex                                                     -       \Delta R_i Z_{i,\t} \, m_j \sin\a_j / \; \dot l \right) d\t / L \\
!latex       \ds \frac{\partial R_0}{\partial Z_{i,j}^s} & = & \ds \int \left( \;\;\;\;\;\;\;\;\;\;\;\;\,                             
!latex                                                     +       \Delta R_i Z_{i,\t} \, m_j \cos\a_j / \; \dot l \right) d\t / L \\ \nonumber \\
!latex       \ds \frac{\partial Z_0}{\partial R_{i,j}^c} & = & \ds \int \left( \;\;\;\;\;\;\;\;\;\;\;\;\,                             
!latex                                                     -       \Delta Z_i R_{i,\t} \, m_j \sin\a_j / \; \dot l \right) d\t / L \\
!latex       \ds \frac{\partial Z_0}{\partial R_{i,j}^s} & = & \ds \int \left( \;\;\;\;\;\;\;\;\;\;\;\;                            
!latex                                                     +       \Delta Z_i R_{i,\t} \, m_j \cos\a_j / \; \dot l \right) d\t / L \\
!latex       \ds \frac{\partial Z_0}{\partial Z_{i,j}^c} & = & \ds \int \left( \cos\a_j \; \dot l
!latex                                                     -       \Delta Z_i Z_{i,\t} \, m_j \sin\a_j / \; \dot l \right) d\t / L \\
!latex       \ds \frac{\partial Z_0}{\partial Z_{i,j}^s} & = & \ds \int \left( \sin\a_j \; \dot l
!latex                                                     +       \Delta Z_i Z_{i,\t} \, m_j \cos\a_j / \; \dot l \right) d\t / L
!latex       \ee
!latex       where $\ds L(\z) \equiv \int_{0}^{2\pi} \!\!\!\! dl$.
!latex \end{enumerate}

!latex \subsection{some numerical comments}

!latex \begin{enumerate}
!latex \item First, the differential poloidal length, $\dot l \equiv \sqrt{ R_\t^2 + Z_\t^2 }$, is computed in real space using 
!latex       an inverse FFT from the Fourier harmonics of $R$ and $Z$.
!latex \item Second, the Fourier harmonics of $dl$ are computed using an FFT.
!latex       The integration over $\t$ to construct $L\equiv \int dl$ is now trivial: just multiply the $m=0$ harmonics of $dl$ by $2\pi$.
!latex       The \internal{ajk(1:mn)} variable is used, and this is assigned in \link{global}.
!latex \item Next, the weighted $R \, dl$ and $Z \, dl$ are computed in real space, and the poloidal integral is similarly taken.
!latex \item Last, the Fourier harmonics are constructed using an FFT after dividing in real space.
!latex \end{enumerate}

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

subroutine rzaxis( Mvol, mn, inRbc, inZbs, inRbs, inZbc, ivol, LcomputeDerivatives )
  
!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!
  
  use constants, only : zero, one, half, two
  
  use numerical, only :
  
  use fileunits, only : ounit
  
  use inputlist, only : Wrzaxis, Igeometry, Ntor, Lcheck, Wmacros
  
  use cputiming, only : Trzaxis
  
  use allglobal, only : ncpu, myid, cpus, im, in, &
                        ajk, Nt, Nz, Ntz, &
                        Rij, Zij, sg, cosi, sini, &
                        ijreal, ijimag, jireal, jiimag, jkreal, jkimag, kjreal, kjimag, &
                        efmn, ofmn, cfmn, sfmn, evmn, odmn, comn, simn, cosi, sini, &
                        YESstellsym, NOTstellsym, Lcoordinatesingularity, &
                        dRodR, dRodZ, dZodR, dZodZ, &
                        dRadR, dRadZ, dZadR, dZadZ, &
                        iRbc, iZbs, iRbs, iZbc, &
                        dBdX
  
!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!
  
  LOCALS
  
  LOGICAL, intent(in)  :: LComputeDerivatives ! indicates whether derivatives are to be calculated;

  INTEGER, intent(in)    :: Mvol, mn, ivol
  REAL                   :: inRbc(1:mn,0:Mvol), inZbs(1:mn,0:Mvol), inRbs(1:mn,0:Mvol), inZbc(1:mn,0:Mvol)
  REAL                   :: jRbc(1:mn,0:Mvol), jZbs(1:mn,0:Mvol), jRbs(1:mn,0:Mvol), jZbc(1:mn,0:Mvol)
  REAL                   :: tmpRbc(1:mn,0:Mvol), tmpZbs(1:mn,0:Mvol), tmpRbs(1:mn,0:Mvol), tmpZbc(1:mn,0:Mvol) ! use as temp matrices to store iRbc etc

  REAL                   :: jacbase(1:Ntz), jacbasec(1:mn), jacbases(1:mn) ! the 2D Jacobian and its Fourier
  REAL                   :: junkc(1:mn), junks(1:mn) ! these are junk matrices used for fft

  INTEGER                :: jvol, ii, ifail, jj, id, issym, irz, imn

  INTEGER                :: Lrzaxis, Ntoraxis, Lcurvature

  INTEGER                :: Njac, idgetrf, idgetrs ! internal variables used in Jacobian method
  REAL, allocatable      :: jacrhs(:), djacrhs(:), jacmat(:,:), djacmat(:,:), solution(:), LU(:,:) ! internal matrices used in Jacobian method
  INTEGER, allocatable   :: ipiv(:)   ! internal matrices used in  Jacobian method

#ifdef DEBUG
  ! Debug variables
  REAL                   :: dx, threshold ! used to check result with finite difference.
  REAL                   :: newRbc(1:mn,0:Mvol), newZbs(1:mn,0:Mvol), newRbs(1:mn,0:Mvol), newZbc(1:mn,0:Mvol)
#endif

  BEGIN(rzaxis)
  
!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

#ifdef DEBUG
  FATAL( rzaxis, ivol.gt.Mvol, perhaps illegal combination Linitialize=2 and Lfreebound=0 )
#endif
  
!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  jvol = 0 ! this identifies the "surface" in which the poloidal averaged harmonics will be placed; 19 Jul 16; 

  Lrzaxis = 1 ! hard coded for testing only
  Ntoraxis = min(Ntor,3)

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  select case( Igeometry ) 
   
  case( 1:2 )
   
   inRbc(1:mn,jvol) = zero
   inRbs(1:mn,jvol) = zero
   
  case(   3 )
   
   if (Lrzaxis .eq. 1) then ! use centroid method

    call invfft( mn, im(1:mn), in(1:mn), im(1:mn) * inRbs(1:mn,ivol), - im(1:mn) * inRbc(1:mn,ivol), &
                                          im(1:mn) * inZbs(1:mn,ivol), - im(1:mn) * inZbc(1:mn,ivol), &
                  Nt, Nz, jkreal(1:Ntz), jkimag(1:Ntz) ) ! R_\t, Z_\t; 03 Nov 16;
  
    ijreal(1:Ntz) = sqrt( jkreal(1:Ntz)**2 + jkimag(1:Ntz)**2 ) ! dl ; 11 Aug 14;
    ijimag(1:Ntz) = zero

    jireal(1:Ntz) = ijreal(1:Ntz) ! dl ; 19 Sep 16;
    
    ifail = 0
    call tfft( Nt, Nz, ijreal(1:Ntz), ijimag(1:Ntz), &
                mn, im(1:mn), in(1:mn), efmn(1:mn), ofmn(1:mn), cfmn(1:mn), sfmn(1:mn), ifail ) ! Fourier harmonics of differential poloidal length; 11 Mar 16;

    efmn(1:mn) = efmn(1:mn) * ajk(1:mn) ! poloidal integration of length; only take m=0 harmonics; 11 Aug 14;
    ofmn(1:mn) = ofmn(1:mn) * ajk(1:mn)
    cfmn(1:mn) = zero
    sfmn(1:mn) = zero
        
    call invfft( mn, im(1:mn), in(1:mn), efmn(1:mn), ofmn(1:mn), cfmn(1:mn), sfmn(1:mn), & ! map length = "integrated dl" back to real space; 19 Sep 16;
                  Nt, Nz, ijreal(1:Ntz), ijimag(1:Ntz) )
      
    jiimag(1:Ntz) = ijreal(1:Ntz) !  L ; 19 Sep 16;


    call invfft( mn, im(1:mn), in(1:mn),            inRbc(1:mn,ivol),              inRbs(1:mn,ivol), &
                                                    inZbc(1:mn,ivol),              inZbs(1:mn,ivol), &
                  Nt, Nz, kjreal(1:Ntz), kjimag(1:Ntz) ) ! R, Z; 03 Nov 16;
    
    ijreal(1:Ntz) = kjreal(1:Ntz) * jireal(1:Ntz) ! R dl;
    ijimag(1:Ntz) = kjimag(1:Ntz) * jireal(1:Ntz) ! Z dl;
    
    ifail = 0
    call tfft( Nt, Nz, ijreal(1:Ntz), ijimag(1:Ntz), &
                mn, im(1:mn), in(1:mn), evmn(1:mn), odmn(1:mn), comn(1:mn), simn(1:mn), ifail ) ! Fourier harmonics of weighted R & Z; 11 Mar 16;

    evmn(1:mn) = evmn(1:mn) * ajk(1:mn) ! poloidal integration of R dl; 19 Sep 16;
    odmn(1:mn) = odmn(1:mn) * ajk(1:mn)
    comn(1:mn) = comn(1:mn) * ajk(1:mn) ! poloidal integration of Z dl; 19 Sep 16;
    simn(1:mn) = simn(1:mn) * ajk(1:mn)
    
    call invfft( mn, im(1:mn), in(1:mn), evmn(1:mn), odmn(1:mn), comn(1:mn), simn(1:mn), &
                  Nt, Nz, ijreal(1:Ntz), ijimag(1:Ntz) )
  
    ijreal(1:Ntz) = ijreal(1:Ntz) / jiimag(1:Ntz) ! Ro; 19 Sep 16;
    ijimag(1:Ntz) = ijimag(1:Ntz) / jiimag(1:Ntz) ! Zo; 19 Sep 16;
    
    kjreal(1:Ntz) = kjreal(1:Ntz) - ijreal(1:Ntz) ! \Delta R = R_1 - R_0 ; 03 Nov 16;
    kjimag(1:Ntz) = kjimag(1:Ntz) - ijimag(1:Ntz) ! \Delta R = Z_1 - Z_0 ; 03 Nov 16;

    ifail = 0
    call tfft( Nt, Nz, ijreal(1:Ntz), ijimag(1:Ntz), &
                mn, im(1:mn), in(1:mn), inRbc(1:mn,jvol), inRbs(1:mn,jvol), inZbc(1:mn,jvol), inZbs(1:mn,jvol), ifail )
    
#ifdef DEBUG
    if( Wrzaxis ) then
      cput = GETTIME
      write(ounit,'("rzaxis : ", 10x ," : ")')
      write(ounit,'("rzaxis : ",f10.2," : myid=",i3," ; inner : Rbc=[",    999(es23.15," ,"))') cput-cpus, myid, inRbc(1:Ntor+1,ivol)
      write(ounit,'("rzaxis : ",f10.2," : myid=",i3," ; axis  : Rbc=[",    999(es23.15," ,"))') cput-cpus, myid, inRbc(1:Ntor+1,jvol)
      if( Ntor.gt.0 ) then
      write(ounit,'("rzaxis : ",f10.2," : myid=",i3," ; inner : Zbs=[",25x,998(es23.15," ,"))') cput-cpus, myid, inZbs(2:Ntor+1,ivol)
      write(ounit,'("rzaxis : ",f10.2," : myid=",i3," ; axis  : Zbs=[",25x,998(es23.15," ,"))') cput-cpus, myid, inZbs(2:Ntor+1,jvol)
      endif
      if( NOTstellsym ) then
      if( Ntor.gt.0 ) then
      write(ounit,'("rzaxis : ",f10.2," : myid=",i3," ; inner : Rbs=[",25x,998(es23.15," ,"))') cput-cpus, myid, inRbs(2:Ntor+1,ivol)
      write(ounit,'("rzaxis : ",f10.2," : myid=",i3," ; axis  : Rbs=[",25x,998(es23.15," ,"))') cput-cpus, myid, inRbs(2:Ntor+1,jvol)
      endif
      write(ounit,'("rzaxis : ",f10.2," : myid=",i3," ; inner : Zbc=[",    999(es23.15," ,"))') cput-cpus, myid, inZbc(1:Ntor+1,ivol)
      write(ounit,'("rzaxis : ",f10.2," : myid=",i3," ; axis  : Zbc=[",    999(es23.15," ,"))') cput-cpus, myid, inZbc(1:Ntor+1,jvol)
      endif
    endif
#endif

  !-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

#ifdef DEBUG
    FATAL( rzaxis, .not.allocated(cosi), fatal )
    FATAL( rzaxis, .not.allocated(sini), fatal )
#endif

  !-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!
    if (LComputeDerivatives) then
    ! compute derivatives of axis; 03 Nov 16;

      do ii = 1, mn

        
        dRodR(1:Ntz,0,ii) = cosi(1:Ntz,ii) * jireal(1:Ntz) - kjreal(1:Ntz) * jkreal(1:Ntz) * im(ii) * sini(1:Ntz,ii) / jireal(1:Ntz) ! dRodRjc;
        dRodR(1:Ntz,1,ii) = sini(1:Ntz,ii) * jireal(1:Ntz) + kjreal(1:Ntz) * jkreal(1:Ntz) * im(ii) * cosi(1:Ntz,ii) / jireal(1:Ntz) ! dRodRjs;
        
        ifail = 0
        call tfft( Nt, Nz, dRodR(1:Ntz,0,ii), dRodR(1:Ntz,1,ii), &
                  mn, im(1:mn), in(1:mn), dRadR(1:mn,0,0,ii), dRadR(1:mn,1,0,ii), dRadR(1:mn,0,1,ii), dRadR(1:mn,1,1,ii), ifail )

        dRadR(1:mn,0,0,ii) = dRadR(1:mn,0,0,ii) * ajk(1:mn) ! poloidal integration; 03 Nov 16;
        dRadR(1:mn,1,0,ii) = dRadR(1:mn,1,0,ii) * ajk(1:mn)
        dRadR(1:mn,0,1,ii) = dRadR(1:mn,0,1,ii) * ajk(1:mn)
        dRadR(1:mn,1,1,ii) = dRadR(1:mn,1,1,ii) * ajk(1:mn)

        call invfft( mn, im(1:mn), in(1:mn), dRadR(1:mn,0,0,ii), dRadR(1:mn,1,0,ii), dRadR(1:mn,0,1,ii), dRadR(1:mn,1,1,ii), &
                    Nt, Nz, dRodR(1:Ntz,0,ii), dRodR(1:Ntz,1,ii) ) ! R, Z; 03 Nov 16;

        dRodR(1:Ntz,0,ii) = dRodR(1:Ntz,0,ii) / jiimag(1:Ntz) ! divide by length; 03 Nov 16;
        dRodR(1:Ntz,1,ii) = dRodR(1:Ntz,1,ii) / jiimag(1:Ntz)


        dRodZ(1:Ntz,0,ii) =                                - kjreal(1:Ntz) * jkimag(1:Ntz) * im(ii) * sini(1:Ntz,ii) / jireal(1:Ntz) ! dRodZjc;
        dRodZ(1:Ntz,1,ii) =                                + kjreal(1:Ntz) * jkimag(1:Ntz) * im(ii) * cosi(1:Ntz,ii) / jireal(1:Ntz) ! dRodZjs;

        ifail = 0
        call tfft( Nt, Nz, dRodZ(1:Ntz,0,ii), dRodZ(1:Ntz,1,ii), &
                  mn, im(1:mn), in(1:mn), dRadZ(1:mn,0,0,ii), dRadZ(1:mn,1,0,ii), dRadZ(1:mn,0,1,ii), dRadZ(1:mn,1,1,ii), ifail )

        dRadZ(1:mn,0,0,ii) = dRadZ(1:mn,0,0,ii) * ajk(1:mn) ! poloidal integration; 03 Nov 16;
        dRadZ(1:mn,1,0,ii) = dRadZ(1:mn,1,0,ii) * ajk(1:mn)
        dRadZ(1:mn,0,1,ii) = dRadZ(1:mn,0,1,ii) * ajk(1:mn)
        dRadZ(1:mn,1,1,ii) = dRadZ(1:mn,1,1,ii) * ajk(1:mn)

        call invfft( mn, im(1:mn), in(1:mn), dRadZ(1:mn,0,0,ii), dRadZ(1:mn,1,0,ii), dRadZ(1:mn,0,1,ii), dRadZ(1:mn,1,1,ii), &
                    Nt, Nz, dRodZ(1:Ntz,0,ii), dRodZ(1:Ntz,1,ii) ) ! R, Z; 03 Nov 16;

        dRodZ(1:Ntz,0,ii) = dRodZ(1:Ntz,0,ii) / jiimag(1:Ntz) ! divide by length; 03 Nov 16;
        dRodZ(1:Ntz,1,ii) = dRodZ(1:Ntz,1,ii) / jiimag(1:Ntz)



        dZodR(1:Ntz,0,ii) =                                - kjimag(1:Ntz) * jkreal(1:Ntz) * im(ii) * sini(1:Ntz,ii) / jireal(1:Ntz) ! dZodRjc;
        dZodR(1:Ntz,1,ii) =                                + kjimag(1:Ntz) * jkreal(1:Ntz) * im(ii) * cosi(1:Ntz,ii) / jireal(1:Ntz) ! dZodRjs;

        ifail = 0
        call tfft( Nt, Nz, dZodR(1:Ntz,0,ii), dZodR(1:Ntz,1,ii), &
                  mn, im(1:mn), in(1:mn), dZadR(1:mn,0,0,ii), dZadR(1:mn,1,0,ii), dZadR(1:mn,0,1,ii), dZadR(1:mn,1,1,ii), ifail )

        dZadR(1:mn,0,0,ii) = dZadR(1:mn,0,0,ii) * ajk(1:mn) ! poloidal integration; 03 Nov 16;
        dZadR(1:mn,1,0,ii) = dZadR(1:mn,1,0,ii) * ajk(1:mn)
        dZadR(1:mn,0,1,ii) = dZadR(1:mn,0,1,ii) * ajk(1:mn)
        dZadR(1:mn,1,1,ii) = dZadR(1:mn,1,1,ii) * ajk(1:mn)

        call invfft( mn, im(1:mn), in(1:mn), dZadR(1:mn,0,0,ii), dZadR(1:mn,1,0,ii), dZadR(1:mn,0,1,ii), dZadR(1:mn,1,1,ii), &
                    Nt, Nz, dZodR(1:Ntz,0,ii), dZodR(1:Ntz,1,ii) ) ! R, Z; 03 Nov 16;

        dZodR(1:Ntz,0,ii) = dZodR(1:Ntz,0,ii) / jiimag(1:Ntz) ! divide by length; 03 Nov 16;
        dZodR(1:Ntz,1,ii) = dZodR(1:Ntz,1,ii) / jiimag(1:Ntz)


        dZodZ(1:Ntz,0,ii) = cosi(1:Ntz,ii) * jireal(1:Ntz) - kjimag(1:Ntz) * jkimag(1:Ntz) * im(ii) * sini(1:Ntz,ii) / jireal(1:Ntz) ! dZodZjc;
        dZodZ(1:Ntz,1,ii) = sini(1:Ntz,ii) * jireal(1:Ntz) + kjimag(1:Ntz) * jkimag(1:Ntz) * im(ii) * cosi(1:Ntz,ii) / jireal(1:Ntz) ! dZodZjs;

        ifail = 0
        call tfft( Nt, Nz, dZodZ(1:Ntz,0,ii), dZodZ(1:Ntz,1,ii), &
                  mn, im(1:mn), in(1:mn), dZadZ(1:mn,0,0,ii), dZadZ(1:mn,1,0,ii), dZadZ(1:mn,0,1,ii), dZadZ(1:mn,1,1,ii), ifail )

        dZadZ(1:mn,0,0,ii) = dZadZ(1:mn,0,0,ii) * ajk(1:mn) ! poloidal integration; 03 Nov 16;
        dZadZ(1:mn,1,0,ii) = dZadZ(1:mn,1,0,ii) * ajk(1:mn)
        dZadZ(1:mn,0,1,ii) = dZadZ(1:mn,0,1,ii) * ajk(1:mn)
        dZadZ(1:mn,1,1,ii) = dZadZ(1:mn,1,1,ii) * ajk(1:mn)

        call invfft( mn, im(1:mn), in(1:mn), dZadZ(1:mn,0,0,ii), dZadZ(1:mn,1,0,ii), dZadZ(1:mn,0,1,ii), dZadZ(1:mn,1,1,ii), &
                    Nt, Nz, dZodZ(1:Ntz,0,ii), dZodZ(1:Ntz,1,ii) ) ! R, Z; 03 Nov 16;

        dZodZ(1:Ntz,0,ii) = dZodZ(1:Ntz,0,ii) / jiimag(1:Ntz) ! divide by length; 03 Nov 16;
        dZodZ(1:Ntz,1,ii) = dZodZ(1:Ntz,1,ii) / jiimag(1:Ntz)


      enddo ! end of do ii; 03 Nov 16;
    end if !if (LComputeDerivatives) then
!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!
   else if ( Lrzaxis .eq. 2) then ! use Jacobian m=1 harmonic elimination method
    
    ! We need to back up a few things before we proceed.
    ! The complication is, iRbc and inRbc could refer to the same thing, due to the way rzaxis is used.
    ! Once iRbc is changed, inRbc could also change, so we should seperate them as two variables.
    tmpRbc = iRbc
    tmpZbs = iZbs
    tmpRbs = iRbs
    tmpZbc = iZbc

    jRbc = inRbc
    jZbs = inZbs
    jRbs = inRbs
    jZbc = inZbc
    ! Now, inRbc should never be used until the end of subroutine in which they get filled back

    ! determine the number of equations and initialize the matrix, temp variables and rhs
    if( YESstellsym ) then
      Njac = 2 * Ntoraxis + 1
    else
      Njac = 2 * (2 * Ntoraxis + 1)
    end if

    SALLOCATE( jacrhs, (1:Njac), zero )
    SALLOCATE( jacmat, (1:Njac, 1:Njac), zero )
    SALLOCATE( LU, (1:Njac, 1:Njac), zero )
    SALLOCATE( solution, (1:Njac), zero )
    SALLOCATE( ipiv, (1:Njac), 0)

    ! replace iRbc to use subroutine coords
    iRbc(1:mn,1) = jRbc(1:mn, ivol)
    iZbs(1:mn,1) = jZbs(1:mn, ivol)
    iRbs(1:mn,1) = jRbs(1:mn, ivol)
    iZbc(1:mn,1) = jZbc(1:mn, ivol)

    iRbc(1:mn,0) = zero
    iZbs(1:mn,0) = zero
    iRbs(1:mn,0) = zero
    iZbc(1:mn,0) = zero

    iRbc(1:Ntor+1,0) = jRbc(1:Ntor+1, ivol)
    iZbs(1:Ntor+1,0) = jZbs(1:Ntor+1, ivol)
    iRbs(1:Ntor+1,0) = jRbs(1:Ntor+1, ivol)
    iZbc(1:Ntor+1,0) = jZbc(1:Ntor+1, ivol)

    Lcoordinatesingularity = .true.
    Lcurvature = 1

    WCALL( rzaxis, coords, (1, one, Lcurvature, Ntz, mn ))

    jacbase = sg(1:Ntz,0) / Rij(1:Ntz,0,0)  ! extract the baseline 2D jacobian, note the definition here does not have the R factor

    call tfft( Nt, Nz, jacbase, Rij, &
               mn, im(1:mn), in(1:mn), jacbasec(1:mn), jacbases(1:mn), junkc(1:mn), junks(1:mn), ifail )

    ! fill in the right hand side with m=1 terms of Jacobian
    if (YESstellsym) then
      jacrhs = -jacbasec(2*(Ntor+1)-Ntoraxis:2*(Ntor+1)+Ntoraxis)
    else
      jacrhs(1:2*Ntoraxis+1) = -jacbasec(2*(Ntor+1)-Ntoraxis:2*(Ntor+1)+Ntoraxis)
      jacrhs(2*Ntoraxis+2:Njac) = -jacbases(2*(Ntor+1)-Ntoraxis:2*(Ntor+1)+Ntoraxis)
    end if !if (YESstellsym)

    if (YESstellsym) then
      
      do ii = -Ntoraxis, Ntoraxis
        do jj = 1, Ntoraxis

          if (ii-jj .ge. -Ntor) then
            id = 2 * (Ntor + 1) + ii - jj
            ! the DRcn' term
            jacmat(ii+Ntoraxis+1, jj+1) = jacmat(ii+Ntoraxis+1, jj+1) - jZbs(id,ivol)
            ! the DZsn' term
            jacmat(ii+Ntoraxis+1, Ntoraxis+1+jj) = jacmat(ii+Ntoraxis+1, Ntoraxis+1+jj) + jRbc(id,ivol)
          end if ! if (ii-jj .ge. -Ntor)

          if (ii+jj .le. Ntor) then
            id = 2 * (Ntor + 1) + ii + jj
            ! the DRcn' term
            jacmat(ii+Ntoraxis+1, jj+1) = jacmat(ii+Ntoraxis+1, jj+1) - jZbs(id,ivol)
            ! the DZsn' term
            jacmat(ii+Ntoraxis+1, Ntoraxis+1+jj) = jacmat(ii+Ntoraxis+1, Ntoraxis+1+jj) - jRbc(id,ivol)
          end if ! if (ii+jj .le. Ntor)

        end do ! jj
        
        ! the DR0 term
        id = 2 * (Ntor + 1) + ii
        jacmat(ii+Ntoraxis+1, 1) = - two * jZbs(id,ivol)

      end do ! ii

    endif ! if (YESstellsym)

    jacmat = jacmat * half ! because we are using (1+s)/2 instead of s

    LU = jacmat
    call DGETRF( Njac, Njac, LU, Njac, ipiv, idgetrf ) ! LU factorization
    solution = jacrhs
    call DGETRS('N', Njac, 1, LU, Njac, ipiv, solution, Njac, idgetrs ) ! sovle linear equation

    if( idgetrf .lt. 0 .or. idgetrs .lt. 0 ) then
    ;             write(ounit,1010) cput-cpus, myid, ivol, idgetrf, idgetrs, "input error ;     "
    elseif( idgetrf .gt. 0 ) then
    ;             write(ounit,1010) cput-cpus, myid, ivol, idgetrf, idgetrs,  "singular ;        "
    endif

1010 format("rzaxis : ",f10.2," : myid=",i3," ; ivol=",i3," idgetrf idgetrs=",i3,' ',i3," ; "a34)

    if (LComputeDerivatives) then
      ! copy the data to jRbc etc
      if (YESstellsym) then
        jRbc(1:Ntor+1,jvol) = zero
        jZbs(2:Ntor+1,jvol) = zero
        jRbc(1:Ntoraxis+1,jvol) = jRbc(1:Ntoraxis+1,ivol) - solution(1:Ntoraxis+1)
        jZbs(2:Ntoraxis+1 ,jvol) = jZbs(2:Ntoraxis+1,ivol) - solution(Ntoraxis+2:2*Ntoraxis+2)
      endif ! YESstellsym

      ! compute the derivative w.r.t. Rjc, Rjs, Zjc, Zjs using matrix perturbation theory
      ! clean up the result from last time
      dRodR = zero
      dRodZ = zero
      dZodR = zero
      dZodZ = zero
      dRadR = zero
      dRadZ = zero
      dZadR = zero
      dZadZ = zero

      ! allocate the temp matrices
      SALLOCATE( djacrhs, (1:Njac), zero )
      SALLOCATE( djacmat, (1:Njac, 1:Njac), zero )

      dBdX%L = .true. ! will need derivatives;
    
      do imn = 1, mn ! loop over deformations in Fourier harmonics; inside do vvol;
        dBdX%ii = imn ! controls construction of derivatives in subroutines called below;
        do irz = 0, 1 ! loop over deformations in R and Z; inside do imn;
          dBdX%irz = irz ! controls construction of derivatives;
          do issym = 0, 1 ! loop over stellarator and non-stellarator symmetric terms;
            if( issym.eq.1 .and. YESstellsym ) cycle ! no dependence on non-stellarator symmetric harmonics;
            if( imn.eq.1 .and. irz.ne.issym) cycle ! no m=n=0 sin terms
            dBdX%issym = issym ! controls construction of derivatives;

            ! clean up for every new loop
            djacmat = zero 
            djacrhs = zero

            Lcoordinatesingularity = .true.
            Lcurvature = 5 ! specially designed to drive subroutine "coords" to compute 2D jacobian derivative w.r.t. interface

            if (im(imn).eq.0) then ! the jacobian on the RHS does not depend on m=0 terms
              jacbase = zero
            else
              WCALL( rzaxis, coords, (1, one, Lcurvature, Ntz, mn )) ! the derivative of Jabobian w.r.t. geometry is computed by coords
              jacbase = sg(1:Ntz,1)
            end if

            call tfft( Nt, Nz, jacbase, Rij, &
                       mn, im(1:mn), in(1:mn), jacbasec(1:mn), jacbases(1:mn), junkc(1:mn), junks(1:mn), ifail )

            if (YESstellsym) then
              djacrhs = -jacbasec(2*(Ntor+1)-Ntoraxis:2*(Ntor+1)+Ntoraxis)
            else
              djacrhs(1:2*Ntoraxis+1) = -jacbasec(2*(Ntor+1)-Ntoraxis:2*(Ntor+1)+Ntoraxis)
              djacrhs(2*Ntoraxis+2:Njac) = -jacbases(2*(Ntor+1)-Ntoraxis:2*(Ntor+1)+Ntoraxis)
            end if !if (YESstellsym)

            if (im(imn).eq.1) then ! djacmat for m=1 terms 

              if (YESstellsym) then
                
                do ii = -Ntoraxis, Ntoraxis
                  do jj = 1, Ntoraxis

                    if (ii-jj .ge. -Ntor) then
                      id = 2 * (Ntor + 1) + ii - jj
                      ! the DRcn' term
                      if (id .eq. imn .and. irz .eq. 1) djacmat(ii+Ntoraxis+1, jj+1) = djacmat(ii+Ntoraxis+1, jj+1) - one
                      ! the DZsn' term
                      if (id .eq. imn .and. irz .eq. 0) djacmat(ii+Ntoraxis+1, Ntoraxis+1+jj) = djacmat(ii+Ntoraxis+1, Ntoraxis+1+jj) + one
                    end if ! if (ii-jj .ge. -Ntor)

                    if (ii+jj .le. Ntor) then
                      id = 2 * (Ntor + 1) + ii + jj
                      ! the DRcn' term
                      if (id .eq. imn .and. irz .eq. 1) djacmat(ii+Ntoraxis+1, jj+1) = djacmat(ii+Ntoraxis+1, jj+1) - one
                      ! the DZsn' term
                      if (id .eq. imn .and. irz .eq. 0) djacmat(ii+Ntoraxis+1, Ntoraxis+1+jj) = djacmat(ii+Ntoraxis+1, Ntoraxis+1+jj) - one
                    end if ! if (ii+jj .le. Ntor)

                  end do ! jj
                  
                  ! the DR0 term
                  id = 2 * (Ntor + 1) + ii
                  if (id .eq. imn .and. irz .eq. 1) djacmat(ii+Ntoraxis+1, 1) = - two

                end do ! ii

              endif ! if (YESstellsym)

              djacmat = djacmat * half ! because we are using (1+s)/2 instead of s

              ! use matrix perturbation theory to compute the analytical derivatives
              djacrhs = djacrhs - matmul(djacmat, solution)
            endif ! im(imn).eq.1

            call DGETRS('N', Njac, 1, LU, Njac, ipiv, djacrhs, Njac, idgetrs ) ! solve linear equation

            if (YESstellsym) then
              if (irz .eq. 0) then
                dRadR(1:Ntoraxis+1,0,0,imn) = -djacrhs(1:Ntoraxis+1)
                dZadR(2:Ntoraxis+1,1,0,imn) = -djacrhs(Ntoraxis+2:Njac)
                if (im(imn).eq.0) then ! addtional one
                  dRadR(imn,0,0,imn) = dRadR(imn,0,0,imn) + one
                end if
              else
                dRadZ(1:Ntoraxis+1,0,1,imn) = -djacrhs(1:Ntoraxis+1)
                dZadZ(2:Ntoraxis+1,1,1,imn) = -djacrhs(Ntoraxis+2:Njac)
                if (im(imn).eq.0) then ! addtional one
                  dZadZ(imn,1,1,imn) = dZadZ(imn,1,1,imn) + one
                end if
              end if
            else
              
            end if ! YESstellsym

            call invfft( mn, im(1:mn), in(1:mn), dRadR(1:mn,0,0,imn), dRadR(1:mn,1,0,imn), dRadR(1:mn,0,1,imn), dRadR(1:mn,1,1,imn), &
                         Nt, Nz, dRodR(1:Ntz,0,imn), dRodR(1:Ntz,1,imn) )
            call invfft( mn, im(1:mn), in(1:mn), dRadZ(1:mn,0,0,imn), dRadZ(1:mn,1,0,imn), dRadZ(1:mn,0,1,imn), dRadZ(1:mn,1,1,imn), &
                         Nt, Nz, dRodZ(1:Ntz,0,imn), dRodZ(1:Ntz,1,imn) )
            call invfft( mn, im(1:mn), in(1:mn), dZadR(1:mn,0,0,imn), dZadR(1:mn,1,0,imn), dZadR(1:mn,0,1,imn), dZadR(1:mn,1,1,imn), &
                         Nt, Nz, dZodR(1:Ntz,0,imn), dZodR(1:Ntz,1,imn) )
            call invfft( mn, im(1:mn), in(1:mn), dZadZ(1:mn,0,0,imn), dZadZ(1:mn,1,0,imn), dZadZ(1:mn,0,1,imn), dZadZ(1:mn,1,1,imn), &
                         Nt, Nz, dZodZ(1:Ntz,0,imn), dZodZ(1:Ntz,1,imn) )

!******* This part is used to benchmark the matrices perturbation result with finite difference *******
! #ifdef DEBUG
!             if (Lcheck .eq. 7) then ! check the analytical derivative with the finite difference
!               threshold = 1e-8 ! print with difference between FD and analytical more than this threshold
!               dx = 1e-8 * jRbc(1,ivol)

!               newRbc = jRbc
!               newRbs = jRbs
!               newZbc = jZbc
!               newZbs = jZbs

!               if (irz .eq. 0) then
!                 newRbc(imn, ivol) = jRbc(imn, ivol) + dx
!               else
!                 newZbs(imn, ivol) = jZbs(imn, ivol) + dx
!               end if
              
!               ! call the same subroutine recursively, but do not compute derivatives
!               call rzaxis( Mvol, mn, newRbc, newZbs, newRbs, newZbc, ivol, .false. )

!               ! compare the derivatives
!               do ii = 1, Ntoraxis+1
!                 if (irz.eq.0) then
!                   if (abs((newRbc(ii,0) - jRbc(ii,jvol))/dx -  dRadR(ii,0,0,imn))/jRbc(1,ivol) .ge. threshold) then
!                     write(ounit, *) 'dR/dR: ii,m,n', ii, im(imn), in(imn), (newRbc(ii,0) - jRbc(ii,jvol))/dx, dRadR(ii,0,0,imn)
!                   endif
!                   if (abs((newZbs(ii,0) - jZbs(ii,jvol))/dx -  dZadR(ii,1,0,imn))/jRbc(1,ivol) .ge. threshold) then
!                     write(ounit, *) 'dZ/dR: ii,m,n', ii, im(imn), in(imn), (newZbs(ii,0) - jZbs(ii,jvol))/dx, dZadR(ii,1,0,imn)
!                   endif
!                 else
!                   if (abs((newRbc(ii,0) - jRbc(ii,jvol))/dx -  dRadZ(ii,0,1,imn))/jRbc(1,ivol) .ge. threshold) then
!                     write(ounit, *) 'dR/dZ: ii,m,n', ii, im(imn), in(imn), (newRbc(ii,0) - jRbc(ii,jvol))/dx, dRadZ(ii,0,1,imn)
!                   endif
!                   if (abs((newZbs(ii,0) - jZbs(ii,jvol))/dx -  dZadZ(ii,1,1,imn))/jRbc(1,ivol) .ge. threshold) then
!                     write(ounit, *) 'dZ/dZ: ii,m,n', ii, im(imn), in(imn), (newZbs(ii,0) - jZbs(ii,jvol))/dx, dZadZ(ii,1,1,imn)
!                   endif
!                 endif
!               enddo

!             end if ! Lcheck .eq. 7
! #endif
!******* END part used to benchmark the matrices perturbation result with finite difference *******

          end do ! issym
        end do ! irz
      end do ! imn = 1, mn
      
      ! deallocate the matrices
      DALLOCATE( djacrhs )
      DALLOCATE( djacmat )
      
      dBdX%L = .FALSE.

    end if ! if (LcomputeDerivative)

!******* This part is used to check if the m=1 harmonics were successfully eliminated *******
! #ifdef DEBUG
!     if (Lcheck .eq. 7)
!       ! check if m=1 harmonic of Jacobian is eliminated
!       write(ounit, *) 'coords : Using Jacobian first harmonic elimination'
!       write(ounit, *) 'coords : before elimination m=1 harmonics:', jacrhs

!       iRbc(1:Ntoraxis+1,0) = -solution(1:Ntoraxis+1) + iRbc(1:Ntoraxis+1,0)
!       iZbs(2:Ntoraxis+1,0) = -solution(Ntoraxis+2:2*Ntoraxis+1) + iZbs(2:Ntoraxis+1,0)
!       WCALL( rzaxis, coords, (1, one, Lcurvature, Ntz, mn ))
!       jacbase = sg(1:Ntz,0) / Rij(1:Ntz,0,0)  ! extract the baseline 2D jacobian

!       call tfft( Nt, Nz, jacbase, Rij, &
!                 mn, im(1:mn), in(1:mn), jacbasec(1:mn), jacbases(1:mn), junkc(1:mn), junks(1:mn), ifail )

!       ! fill in the right hand side with m=1 terms of Jacobian
!       jacrhs = -jacbasec(2*(Ntor+1)-Ntoraxis:2*(Ntor+1)+Ntoraxis)

!       write(ounit,*) 'coords : after elimination m=1 harmonics', jacrhs
!     end if !Lcheck .eq. 7
! #endif
!******* End part used to check if the m=1 harmonics were successfully eliminated *******

    ! Clean up
    ! copy back the original data
    iRbc = tmpRbc
    iZbs = tmpZbs
    iRbs = tmpRbs
    iZbc = tmpZbc

    ! copy the data to output
    if (YESstellsym) then
      inRbc(1:Ntor+1,jvol) = zero
      inZbs(2:Ntor+1,jvol) = zero
      inRbc(1:Ntoraxis+1,jvol) = inRbc(1:Ntoraxis+1,ivol) - solution(1:Ntoraxis+1)
      inZbs(2:Ntoraxis+1 ,jvol) = inZbs(2:Ntoraxis+1,ivol) - solution(Ntoraxis+2:2*Ntoraxis+2)
    endif ! YESstellsym

    ! Deallocate
    DALLOCATE( jacrhs )
    DALLOCATE( jacmat )
    DALLOCATE( LU )
    DALLOCATE( solution )
    DALLOCATE( ipiv )
  
!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

   end if ! end of forking based on Lrzaxis ; 10 Jan 20

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!

  end select ! end of select case( Igeometry ) ; 08 Feb 16;
  
!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!
  
  RETURN(rzaxis)
  
!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!
  
end subroutine rzaxis

!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!