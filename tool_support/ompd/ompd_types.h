/*
* @@name:	ompd_example_types.1c
* @@type:	C
* @@compilable:	no
* @@linkable:	no
* @@expect:	nothing
*/
#include "cudadebugger.h"
#include "ompd.h"

/* Kinds of device device address spaces */
typedef enum ompd_device_kind_t {
  ompd_device_kind_host = 1,
  ompd_device_kind_cuda = 2
  /* More devices... */
} ompd_device_kind_t;

/* Kinds of device threads  */
typedef enum ompd_osthread_kind_t {
  ompd_osthread_pthread=0,
  ompd_osthread_lwp=1,
  ompd_osthread_winthread=2,
  ompd_osthread_cudalogical=3
} ompd_osthread_kind_t;

/* Target device-specific thread identification */
typedef struct ompd_dim3_t {
    ompd_tword_t x;
    ompd_tword_t y;
    ompd_tword_t z;
} ompd_dim3_t;

typedef struct ompd_cudathread_coord_t {
    ompd_taddr_t cudaDevId;
    ompd_taddr_t cudaContext;
    ompd_taddr_t warpSize;
    ompd_taddr_t gridId;
    ompd_taddr_t kernelId;
    ompd_dim3_t  gridDim;
    ompd_dim3_t  blockDim;
    ompd_dim3_t  blockIdx;
    ompd_dim3_t  threadIdx;
} ompd_cudathread_coord_t;

/* Target device-specific Memory Access */
#define OMPD_SEGMENT_CUDA_PTX_UNSPECIFIED    ((ompd_taddr_t)0)
#define OMPD_SEGMENT_CUDA_PTX_CODE           ((ompd_taddr_t)1)
#define OMPD_SEGMENT_CUDA_PTX_REG            ((ompd_taddr_t)2)
#define OMPD_SEGMENT_CUDA_PTX_SREG           ((ompd_taddr_t)3)
#define OMPD_SEGMENT_CUDA_PTX_CONST          ((ompd_taddr_t)4)
#define OMPD_SEGMENT_CUDA_PTX_GLOBAL         ((ompd_taddr_t)5)
#define OMPD_SEGMENT_CUDA_PTX_LOCAL          ((ompd_taddr_t)6)
#define OMPD_SEGMENT_CUDA_PTX_PARAM          ((ompd_taddr_t)7)
#define OMPD_SEGMENT_CUDA_PTX_SHARED         ((ompd_taddr_t)8)
#define OMPD_SEGMENT_CUDA_PTX_SURF           ((ompd_taddr_t)9)
#define OMPD_SEGMENT_CUDA_PTX_TEX            ((ompd_taddr_t)10)
#define OMPD_SEGMENT_CUDA_PTX_TEXSAMPLER     ((ompd_taddr_t)11)
#define OMPD_SEGMENT_CUDA_PTX_GENERIC        ((ompd_taddr_t)12)
#define OMPD_SEGMENT_CUDA_PTX_IPARAM         ((ompd_taddr_t)13)
#define OMPD_SEGMENT_CUDA_PTX_OPARAM         ((ompd_taddr_t)14)
#define OMPD_SEGMENT_CUDA_PTX_FRAME          ((ompd_taddr_t)15)
#define OMPD_SEGMENT_CUDA_PTX_MAX            ((ompd_taddr_t)16)
