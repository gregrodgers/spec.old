/*
* @@name:	omp_types.h
*/
#ifndef __OMP_TYPES_H
#define __OMP_TYPES_H

#define OMP_TYPES_VERSION   20170927 /* YYYYMMDD Format */

/* Kinds of device device address spaces */
#define OMP_DEVICE_KIND_HOST     ((omp_device_kind_t)1)
#define OMP_DEVICE_KIND_CUDA     ((omp_device_kind_t)2)
/* The range of non-standard implementation defined values */
#define OMP_DEVICE_IMPL_LO       ((omp_device_kind_t)1000000)
#define OMP_DEVICE_IMPL_HI       ((omp_device_kind_t)1100000)

#endif
