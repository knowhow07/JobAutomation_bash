#!/bin/sh
#SBATCH --partition=szlufarska    # default "univ2", if not specified
#SBATCH --time=7-00:00:00         # run time in days-hh:mm:ss
#SBATCH --nodes=1                 # require N nodes
#SBATCH --ntasks-per-node=40      # cpus per node (by default, "ntasks"="cpus")
#SBATCH --error=job.%J.err
#SBATCH --output=job.%J.out

module load CMG_VASP/vasp_5.4.4vtst180_oneapi2023.0.0
>rst.out
cp KPOINTS KPOINTS_low
cat >INCAR<<!
general: geometry optimation-Calculation
Start Parameters for this run
   ISTART = 0              # ISTART=0 --> begin from scratch
   ICHARG = 2              # ICHARGE=2 --> Take superposition of atomic charge densities.
   INIWAV = 1              # INIWAV=1 --> Fill the Kohn-Sham–orbital arrays with random numbers
   PREC = Normal         # PREC = Accurate --> The most precise option in VASP
   ALGO = Fast             # ALGO=Fast --> electronic minization algorithm
   ISYM = 0                # ISYM=0 --> VASP does not use symmetry, but it will assume that (psi)_(k) = (psi)^*_(-k)
   ISMEAR = -5             # ISMEAR=-5 -->  tetrahedron method with Blöchl corrections (SIGMA is ignored for the tetrahedron method)
   SIGMA = 0.05            # SIGMA=0.05 --> specifies the width of the smearing in eV.
   NSIM = 4                # NSIM=4 --> sets the number of bands that are optimized simultaneously by the RMM-DIIS algorithm
   LPLANE = .TRUE.         # LPLANE=.TRUE. --> switches on the plane-wise data distribution in real space
   NPAR = 4                # NPAR=4 --> determines the number of bands that are treated in parallel.

Electronic minimisation
  ENCUT = 500              # ENCUT=450 --> specifies the cutoff energy for the plane-wave-basis set in eV.
  NELM  = 100             # NELM=1000 --> sets the maximum number of electronic SC steps
  LREAL = .FALSE.          # LREAL=.FALSE. --> projection done in reciprocal space
  EDIFF = 1E-4             # EDIFF=1E-6 --> specifies the global break condition for the electronic SC-loop
  LWAVE =.FALSE.           # LWAVE=.FALSE. --> determines whether the wavefunctions are written to the WAVECAR file at the end of a run.
  LCHARG =.FALSE.          # LCHARGE=.FALSE. --> determines whether the charge densities (files CHGCAR and CHG) are written.
   
Ionic relaxation
  ISIF  = 3                # ISIF=2 --> during the ionic relaxation only ions move
  ISPIN = 2                # ISPIN=2 --> spin-polarized calculations (collinear) are performed.
  NSW = 500                # NSW=500 --> sets the maximum number of ionic steps.
  IBRION = 2               # IBRION=2 --> ionic relaxation (conjugate gradient algorithm).
  EDIFFG = -5E-2           # EDIFFG=-5E-3 --> defines the break condition for the ionic relaxation loop.
!

mpirun vasp_std > output_low.out

cp XDATCAR XDATCAR_low
cp CONTCAR CONTCAR_low
cp OUTCAR OUTCAR_low
E=$(grep "TOTEN" OUTCAR)
echo low $E >>rst.out

cp KPOINTS_high KPOINTS
cp CONTCAR POSCAR
cat >INCAR<<!
general: geometry optimation-Calculation
Start Parameters for this run
   ISTART = 0              # ISTART=0 --> begin from scratch
   ICHARG = 2              # ICHARGE=2 --> Take superposition of atomic charge densities.
   INIWAV = 1              # INIWAV=1 --> Fill the Kohn-Sham–orbital arrays with random numbers
   PREC = Normal         # PREC = Accurate --> The most precise option in VASP
   ALGO = Fast             # ALGO=Fast --> electronic minization algorithm
   ISYM = 0                # ISYM=0 --> VASP does not use symmetry, but it will assume that (psi)_(k) = (psi)^*_(-k)
   ISMEAR = -5             # ISMEAR=-5 -->  tetrahedron method with Blöchl corrections (SIGMA is ignored for the tetrahedron method)
   SIGMA = 0.05            # SIGMA=0.05 --> specifies the width of the smearing in eV.
   NSIM = 4                # NSIM=4 --> sets the number of bands that are optimized simultaneously by the RMM-DIIS algorithm
   LPLANE = .TRUE.         # LPLANE=.TRUE. --> switches on the plane-wise data distribution in real space
   NPAR = 4                # NPAR=4 --> determines the number of bands that are treated in parallel.

Electronic minimization
  ENCUT = 500              # ENCUT=450 --> specifies the cutoff energy for the plane-wave-basis set in eV.
  NELM  = 100             # NELM=1000 --> sets the maximum number of electronic SC steps
  LREAL = .FALSE.          # LREAL=.FALSE. --> projection done in reciprocal space
  EDIFF = 1E-6             # EDIFF=1E-6 --> specifies the global break condition for the electronic SC-loop
  LWAVE =.FALSE.           # LWAVE=.FALSE. --> determines whether the wavefunctions are written to the WAVECAR file at the end of a run.
  LCHARG =.FALSE.          # LCHARGE=.FALSE. --> determines whether the charge densities (files CHGCAR and CHG) are written.
   
Ionic relaxation
  ISIF  = 3                # ISIF=2 --> during the ionic relaxation only ions move
  ISPIN = 2                # ISPIN=2 --> spin-polarized calculations (collinear) are performed.
  NSW = 100                # NSW=500 --> sets the maximum number of ionic steps.
  IBRION = 2               # IBRION=2 --> ionic relaxation (conjugate gradient algorithm).
  EDIFFG = -5E-3           # EDIFFG=-5E-3 --> defines the break condition for the ionic relaxation loop.
  POTIM = 0.05
!

mpirun vasp_std > output_high.out

cp XDATCAR XDATCAR_high
cp CONTCAR CONTCAR_high
cp OUTCAR OUTCAR_high
E=$(grep "TOTEN" OUTCAR)
echo low $E >>rst.out