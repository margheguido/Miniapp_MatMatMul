
program test
#include <petsc/finclude/petscksp.h>
  use petscksp
  use HDF5
  use mpi
  implicit none


  double precision ::  t1, t2, t_AQ, t_AQ2
  integer :: i, ierr, myid, num_procs, mpicomm
  PetscViewer ::  viewer_A, viewer_Q
  Mat :: A, Q, AQ
  PetscInt :: n, m, j
  Vec ::  q_vec, aq_vec

  n = 46816
  m = 6
  call MPI_INIT(ierr)
  call MPI_COMM_RANK(MPI_COMM_WORLD, myid, ierr)
  call MPI_COMM_SIZE(MPI_COMM_WORLD, num_procs, ierr)
  mpicomm = MPI_COMM_WORLD



  ! Files for output
  open(1, file="Output/timers_AQ.dat", position="append", action="write")


  call PetscInitialize(PETSC_NULL_CHARACTER, ierr)
  if (ierr .ne. 0) then
    print*,'Unable to initialize PETSc'
    stop
  endif

  if (myid == 0) then 
    print*, 'Running with ', num_procs, ' processors'
  end if 
  
  call MatCreate(PETSC_COMM_WORLD,A,ierr)
  call MatSetSizes(A, PETSC_DETERMINE, PETSC_DETERMINE, n, n,ierr)
  call MatCreate(PETSC_COMM_WORLD,Q,ierr)
  call MatSetSizes(Q, PETSC_DETERMINE, PETSC_DETERMINE, n, m,ierr)
  call MatCreate(PETSC_COMM_WORLD,AQ,ierr)
  call MatSetSizes(AQ, PETSC_DETERMINE, PETSC_DETERMINE, n, m,ierr)



  ! Read binary data from GBS
  call PetscViewerBinaryOpen(PETSC_COMM_WORLD,"data/matrices.dat",FILE_MODE_READ,viewer_A,ierr)
  call PetscViewerBinaryOpen(PETSC_COMM_WORLD,"data/basis.dat",FILE_MODE_READ,viewer_Q,ierr)

  call MatLoad(A,viewer_A,ierr)
  call MatLoad(Q,viewer_Q,ierr)


  ! Perform multiplication AQ with MatMatMul
  t1 = MPI_Wtime()
  call MatMatMult(A,Q,MAT_INITIAL_MATRIX, PETSC_DEFAULT_REAL, AQ, ierr )
  t2 = MPI_Wtime()   

  ! Write time in output 
  if (myid == 0) then 
    t_AQ = t2-t1
    print*, 'AQ time using MatMatMul', t_AQ
    write(1,*) t_AQ
  end if 

  ! Perform multiplication AQ with m times MatMul(A, Q(:,j))
  call MatCreateVecs(A, q_vec, aq_vec, ierr)
  t_AQ2 = 0.0
  
  ! Loop on the columns of Q
  do j = 0, m-1

    call MatGetColumnVector(Q, q_vec, j, ierr)
    
    ! Multiplication A qi
    t1 = MPI_Wtime()
    call MatMult(A, q_vec, aq_vec, ierr) 
    t2 = MPI_Wtime()
    
    if (myid == 0) then 
      t_AQ2 = t_AQ2 + t2-t1
    end if 
    
  end do

  ! Write time in output 
  if (myid == 0) then 
    print*, 'AQ time using 6 MatMul', t_AQ2
  write(1,*) t_AQ2
  end if


  call PetscFinalize(ierr)
  call MPI_Finalize(ierr)
  close(1)

end program test
