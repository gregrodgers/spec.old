/*
* @@name:	ompd_types.h
*/
#include "ompd.h"

/* Kinds of device device address spaces */
typedef uint64_t ompd_device_kind_t;

#define OMPD_DEVICE_KIND_HOST 1
#define OMPD_DEVICE_KIND_CUDA 2
/* More devices... */
#define OMPD_DEVICE_RESERVED  1000000

/* Kinds of device threads  */
typedef uint64_t ompd_osthread_kind_t;
#define OMPD_OSTHREAD_PTHREAD 0
#define OMPD_OSTHREAD_LWP 1
#define OMPD_OSTHREAD_WINTHREAD 2
#define OMPD_OSTHREAD_CUDALOGICAL 3
/* More thread types... */
#define OMPD_OSTHREAD_RESERVED 1000000

/* Target device-specific thread identification */
typedef struct ompd_dim3_t {
    ompd_word_t x;
    ompd_word_t y;
    ompd_word_t z;
} ompd_dim3_t;

typedef struct ompd_cudathread_coord_t {
    ompd_word_t cudaDevId;
    ompd_word_t cudaContext;
    ompd_word_t warpSize;
    ompd_word_t gridId;
    ompd_word_t kernelId;
    ompd_dim3_t  gridDim;
    ompd_dim3_t  blockDim;
    ompd_dim3_t  blockIdx;
    ompd_dim3_t  threadIdx;
} ompd_cudathread_coord_t;

/* Memory Access Segment definitions for Host and Target Devices */
#define OMPD_SEGMENT_UNSPECIFIED             ((ompd_seg_t)0)

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
#define OMPD_SEGMENT_CUDA_PTX_MAX            ((ompd_seg_t)16)
