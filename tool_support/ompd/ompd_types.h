/*
* @@name:	ompd_types.h
*/
#ifndef __OPMD_TYPES_H
#define __OPMD_TYPES_H
#include "omp_types.h"
#include "ompd.h"

#define OMPD_TYPES_VERSION_MAJOR  5
#define OMPD_TYPES_VERSION_MINOR  0

/* Kinds of device threads  */
#define OMPD_OSTHREAD_PTHREAD     ((ompd_osthread_kind_t)1)
#define OMPD_OSTHREAD_LWP         ((ompd_osthread_kind_t)2)
#define OMPD_OSTHREAD_WINTHREAD   ((ompd_osthread_kind_t)3)
#define OMPD_OSTHREAD_CUDALOGICAL ((ompd_osthread_kind_t)4)
/* The range of non-standard implementation defined values */
#define OMPD_OSTHREAD_IMPL_LO       ((ompd_osthread_kind_t)1000000)
#define OMPD_OSTHREAD_IMPL_HI       ((ompd_osthread_kind_t)1100000)

/* Target Cuda device-specific thread identification */
typedef struct ompd_dim3_t {
    ompd_addr_t x;
    ompd_addr_t y;
    ompd_addr_t z;
} ompd_dim3_t;

typedef struct ompd_cudathread_coord_t {
    ompd_addr_t cudaDevId;
    ompd_addr_t cudaContext;
    ompd_addr_t warpSize;
    ompd_addr_t gridId;
    ompd_addr_t kernelId;
    ompd_dim3_t  gridDim;
    ompd_dim3_t  blockDim;
    ompd_dim3_t  blockIdx;
    ompd_dim3_t  threadIdx;
} ompd_cudathread_coord_t;

/* Memory Access Segment definitions for Host and Target Devices */
#define OMPD_SEGMENT_UNSPECIFIED             ((ompd_seg_t)0)

/* Cuda-specific values consistent with those defined in cudadebugger.h */
#define OMPD_SEGMENT_CUDA_PTX_UNSPECIFIED    ((ompd_seg_t)0)
#define OMPD_SEGMENT_CUDA_PTX_CODE           ((ompd_seg_t)1)
#define OMPD_SEGMENT_CUDA_PTX_REG            ((ompd_seg_t)2)
#define OMPD_SEGMENT_CUDA_PTX_SREG           ((ompd_seg_t)3)
#define OMPD_SEGMENT_CUDA_PTX_CONST          ((ompd_seg_t)4)
#define OMPD_SEGMENT_CUDA_PTX_GLOBAL         ((ompd_seg_t)5)
#define OMPD_SEGMENT_CUDA_PTX_LOCAL          ((ompd_seg_t)6)
#define OMPD_SEGMENT_CUDA_PTX_PARAM          ((ompd_seg_t)7)
#define OMPD_SEGMENT_CUDA_PTX_SHARED         ((ompd_seg_t)8)
#define OMPD_SEGMENT_CUDA_PTX_SURF           ((ompd_seg_t)9)
#define OMPD_SEGMENT_CUDA_PTX_TEX            ((ompd_seg_t)10)
#define OMPD_SEGMENT_CUDA_PTX_TEXSAMPLER     ((ompd_seg_t)11)
#define OMPD_SEGMENT_CUDA_PTX_GENERIC        ((ompd_seg_t)12)
#define OMPD_SEGMENT_CUDA_PTX_IPARAM         ((ompd_seg_t)13)
#define OMPD_SEGMENT_CUDA_PTX_OPARAM         ((ompd_seg_t)14)
#define OMPD_SEGMENT_CUDA_PTX_FRAME          ((ompd_seg_t)15)
#endif
