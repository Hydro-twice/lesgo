!**********************************************************************
module rns_base_ls
!**********************************************************************
use types, only : rprec

implicit none

save
private

public r_elem_t, beta_elem_t, b_elem_t

$if ($MPI)
  !--this dimensioning adds a ghost layer for finite differences
  !--its simpler to have all arrays dimensioned the same, even though
  !  some components do not need ghost layer
  $define $lbz 0
$else
  $define $lbz 1
$endif

!---------------------------------------------------
! RNS PARAMETERS
!---------------------------------------------------  
!logical, parameter :: clforce_calc = .true.
!integer, parameter :: clforce_nskip = 10

integer, parameter :: CD_ramp_nstep = 1000

!logical, parameter :: use_beta_sub_regions = .true.
logical, parameter :: use_single_beta_CD = .true.

real(rprec), parameter :: chi_cutoff = 1.e-9_rprec

!---------------------------------------------------
! 
!---------------------------------------------------  

! ---- Secondary structures ----
type ref_region
  integer :: npoint
  real(rprec), pointer, dimension(:,:) :: points !  3 ordered points
  real(rprec) :: u ! reference values
  real(rprec) :: area
end type ref_region

type force
  integer :: parent !  parent CD; for resolved branches 
  real(rprec) :: fD
  real(rprec) :: CD
  real(rprec) :: kappa ! Used for unresolved branches
end type force

type indx_array
  integer :: npoint
  integer, pointer, dimension(:,:) :: iarray
end type
! ---- Secondary structures ----

! ---- Primary structures ----
type primary_struct
  type(ref_plane)   :: ref_plane_t
  type(force)       :: force_t
  type(indx_array)  :: indx_array_t
end type primary_struct

type(primary_struct), pointer, dimension(:) :: reslv_elem_t
type(primary_struct), pointer, dimension(:) :: beta_elem_t
type(primary_struct), pointer, dimension(:) :: rbeta_elem_t
! ---- Primary structures ----

type child_elem
  integer :: nelem
  integer, pointer, dimension(:) :: iarray
end type child_elem

! ---- Secondary structures ----

! ---- Primary structures ----
type primary_struct_type_1
  type(ref_region)  :: ref_region_t
  type(force)       :: force_t
  type(indx_array)  :: indx_array_t
end type primary_struct_type_1

type primary_struct_type_2
  type(ref_region)  :: ref_region_t
  type(force)       :: force_t
  type(child_elem)  :: r_child_t
  type(child_elem)  :: beta_child_t
end type primary_struct_type_2

type(primary_struct_type_1), pointer, dimension(:) :: r_elem_t
type(primary_struct_type_1), pointer, dimension(:) :: beta_elem_t
type(primary_struct_type_2), pointer, dimension(:) :: b_elem_t
! ---- Primary structures ----

!integer, pointer, dimension(:) :: reslv_to_rbeta_map
!integer, pointer, dimension(:) :: beta_to_rbeta_map

real (rprec) :: chi(ld, ny, $lbz:nz)
logical :: chi_initialized = .false.

integer :: nr_elem, nbeta_elem, nb_elem

end module rns_base_ls
