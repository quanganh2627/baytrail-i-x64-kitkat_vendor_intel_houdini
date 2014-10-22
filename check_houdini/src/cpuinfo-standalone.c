
// ----------------------------------------------------------------------------------------
//
//   INTEL CONFIDENTIAL
//   Copyright (2012) Intel Corporation All Rights Reserved.
//
//   The source code contained or described herein and all documents related to the
//   source code ("Material") are owned by Intel Corporation or its suppliers or
//   licensors. Title to the Material remains with Intel Corporation or its suppliers
//   and licensors. The Material is protected by worldwide copyright and trade secret
//   laws and treaty provisions. No part of the Material may be used, copied, reproduced,
//   modified, published, uploaded, posted, transmitted, distributed, or disclosed in any
//   way without prior express written permission from Intel.
//
//   No license under any patent, copyright, trade secret or other intellectual property
//   right is granted to or conferred upon you by disclosure or delivery of the Materials,
//   either expressly, by implication, inducement, estoppel or otherwise. Any license under
//   such intellectual property rights must be express and approved by Intel in writing.
//
// ----------------------------------------------------------------------------------------

#include <sys/mman.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>

#define MMAP_MIN_ADDR   0x8000

int main()
{
    int i = 0;
    int fd = open("/system/lib/arm/cpuinfo", O_RDONLY, 0);
    if (fd < 0) {
        exit(-1);
    }

    int len = lseek(fd, 0, SEEK_END);

    void* ret = mmap((void*)MMAP_MIN_ADDR, len, PROT_READ, MAP_PRIVATE | MAP_FIXED, fd, 0);
    if (ret != (void*)MMAP_MIN_ADDR) {
        exit(-1);
    } else {
        for(i=0; i<len; i++)
            printf("%c", *(char*)(ret+i));
    }
}
