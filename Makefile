FC=mpiifort
#FC=mpif90
PREFIX=/home/nvarini/gnu_stack
#PETSC_ROOT=$(PWD)/petsc-install
PETSC_ROOT=/home/mguido/petsc-install-new
#HDF5_ROOT=$(PWD)/hdf5-install
HDF5_ROOT=/home/mguido/hdf5-install
PETSC=1


ifeq ($(PETSC),1)
PREPROCESS+=-DPETSC
#FCFLAGS_DEPS+=-I$(WORK)/petsc-install/include
#LDFLAGS_DEPS+=-L$(WORK)/petsc-install/lib -lpetsc
FCFLAGS_DEPS+=-I$(PETSC_ROOT)/include
LDFLAGS_DEPS+=-L$(PETSC_ROOT)/lib -lpetsc
# -llapack -lblas
OBJECTS=test_miniapp.o
endif



FCFLAGS=-I. -I$(HDF5_ROOT)/include   -g $(FCFLAGS_DEPS) $(PREPROCESS)

LDFLAGS=-L$(HDF5_ROOT)/lib64 -lhdf5 -lhdf5_fortran $(LDFLAGS_DEPS) -fopenmp

%.o: %.F90 
	$(FC) $(FCFLAGS) -c -o $@ $< 

%.o: %.cu 
	$(NVCC) $(FCFLAGS) -c -o $@ $< 

test_miniapp: $(OBJECTS)
	$(FC) -o test_miniapp $(OBJECTS) $(LDFLAGS)

clean:
	rm -rf *.o test_hypre

