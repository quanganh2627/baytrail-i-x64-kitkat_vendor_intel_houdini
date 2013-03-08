
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

/**
 * Patch Arm Mapped Symbols (PAMS)
 *
 * Description:
 *     Patch ARM library according to symbol offset and length.
 *     This is the last step to generate ARM libraies for Android BT.
 *
 * Usage:
 * patch function body:
 *     ./pams --pfb --dst-lib|-d dst_lib --src-lib|-s src_lib \
 *            [--dst-off|-o dst_off | --off-list|-l off_list] \
 *            --src-off|-r src_off --size|-z size
 * patch symbol table
 *    ./pams --pst --libname|-b libname --dyn-off|-n dynamic_off \
 *           [--whitelist|-w symbol_list | --whitesymbol|-m symbol_name]
 *
 * Args:
 * patch function body:
 *     dst_lib: the library need to patch;
 *     src_lib: the libarary the binary content copied from;
 *     dst_off: the offset in the binary to patch with;
 *     off_list: a file containing a list of offsets in the binary to patch with;
 *     src_off: the offset in the binary to read content from;
 *     size:    size of patch in bytes.
 * patch symbol table:
 *     libname: the library need to patch;
 *     dynamic_off: the offset of dynamic section of patched library;
 *     symbol_list: a file containing a list of offsets in the binary to patch with;
 *     symbol_name: the symbol name need to be patched
 *
 * Return:
 *     0 if success and -1 upon error.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <getopt.h>
#include <sys/mman.h>
#include <string.h>
#include <linux/elf.h>
#include <stdarg.h>

typedef struct my_soinfo my_soinfo;

struct my_soinfo {
    unsigned base;
    unsigned *dynamic;
    const char *strtab;
    Elf32_Sym *symtab;

    unsigned nbucket;
    unsigned nchain;
    unsigned *bucket;
    unsigned *chain;
};

static void usage();
static void my_exit(const char*, ...);
static unsigned elfhash(const char*);
static int get_libsize(FILE*);
static Elf32_Sym* patch_symbol(my_soinfo*, const char*, FILE*);
static void do_patch_symbol(my_soinfo*, unsigned, FILE*);

#define PAMS_BUF_LEN 1024
#define PAMS_SYMBOL_LEN 1024
#define PAMS_SO_LEN 128

int main(int argc, char *argv[])
{
    void *base;
    my_soinfo *si;
    Elf32_Sym *sym;
    size_t n;
    int c, option_index = 0;
    int fd, batch;
    int pst_flag = 0, pfb_flag = 0;
    int length = -1, off_src = -1, off_dst = -1, libsize = -1;
    FILE *src_file = NULL, *dst_file = NULL, *list_file = NULL;
    unsigned *d, hash, dynamic_off = 0;
    unsigned char buf[PAMS_BUF_LEN] = { 0 };
    unsigned char symbol[PAMS_SYMBOL_LEN] = {'N', 'U', 'L', 'L', '\0'};
    unsigned char so[PAMS_SO_LEN] = { 0 };
    struct option long_options[] = {
        {"pst", no_argument, &pst_flag, 1}, //patch symbol table option
        {"pfb", no_argument, &pfb_flag, 1}, //patch function body option

        {"dst-lib", required_argument, 0, 'd'},
        {"src-lib", required_argument, 0, 's'},
        {"dst-off", required_argument, 0, 'o'},
        {"off-list", required_argument, 0, 'l'},
        {"src-off", required_argument, 0, 'r'},
        {"size", required_argument, 0, 'z'},
        {"libname", required_argument, 0, 'b'},
        {"dyn-off", required_argument, 0, 'n'},
        {"whitelist", required_argument, 0, 'w'},
        {"whitesymbol", required_argument, 0, 'm'},
        {0, 0, 0, 0}
    };

    si = (my_soinfo*)malloc(sizeof(my_soinfo));
    if (si == NULL)
        my_exit("malloc failed!\n");

    while (1) {
        c = getopt_long(argc, argv, "d:s:o:l:r:z:b:n:w:m:", long_options, &option_index);

        if (c == -1)
            break;

        switch (c) {
            case 0:
                if (pst_flag == 1 && pfb_flag == 1)
                    my_exit("pst flag and pfb flag shouldn't be used at the same time!\n");

                if (long_options[option_index].flag != 0)
                    break;

                printf("option %s", long_options[option_index].name);
                if (optarg)
                    printf(" with arg %s", optarg);
                printf("\n");

                break;

            case 's':
                if (pfb_flag != 1)
                    my_exit("This option can only be used when you use --pfb option!\n");

                src_file = fopen(optarg, "r");
                if (src_file == NULL)
                    my_exit("fopen %s failed\n", optarg);

                break;

            case 'd':
                if (pfb_flag != 1)
                    my_exit("This option can only be used when you use --pfb option!\n");

                dst_file = fopen(optarg, "r+");
                if (dst_file == NULL)
                    my_exit("fopen %s failed\n", optarg);

                break;

            case 'o':
                if (pfb_flag != 1)
                    my_exit("This option can only be used when you use --pfb option!\n");

                batch = 0;
                sscanf(optarg, "%x", &off_dst);

                break;

            case 'r':
                if (pfb_flag != 1)
                    my_exit("This option can only be used when you use --pfb option!\n");

                sscanf(optarg, "%x", &off_src);

                break;

            case 'z':
                if (pfb_flag != 1)
                    my_exit("This option can only be used when you use --pfb option!\n");

                sscanf(optarg, "%x", &length);
                if (length <= 0 || length > 1024)
                    my_exit("get length failed.\n");

                break;

            case 'l':
                if (pfb_flag != 1)
                    my_exit("This option can only be used when you use --pfb option!\n");

                batch = 1;
                list_file = fopen(optarg, "r");

                if (list_file == NULL)
                    my_exit("fopen %s failed\n", optarg);

                break;

            case 'b':
                if (pst_flag != 1)
                    my_exit("This option can only be used when you use --pst option!\n");

                n = strlen(optarg);
                if (n >= PAMS_SO_LEN)
                    my_exit("library name length is longer than 127 bytes!\n");
                else
                    strncpy(so, optarg, n + 1);

                src_file = fopen(optarg, "r+");
                if (src_file == NULL)
                    my_exit("fopen %s failed\n", optarg);

                libsize = get_libsize(src_file);
                fd = fileno(src_file);
                if (fd < 0)
                    my_exit("fileno failed!\n");

                base = mmap(NULL, (size_t)libsize, PROT_READ, MAP_PRIVATE, fd, 0);
                if (base == NULL)
                    my_exit("mmap failed!\n");

                si->base = (unsigned)base;

                break;

            case 'n':
                if (pst_flag != 1)
                    my_exit("This option can only be used when you use --pst option!\n");

                sscanf(optarg, "%x", &dynamic_off);

                break;

            case 'w':
                if (pst_flag != 1)
                    my_exit("This option can only be used when you use --pst option!\n");

                list_file = fopen(optarg, "r");
                if (list_file == NULL)
                    my_exit("fopen %s failed\n", optarg);

                batch = 1;

                break;

            case 'm':
                if (pst_flag != 1)
                    my_exit("This option can only be used when you use --pst option!\n");

                batch = 0;

                n = strlen(optarg);
                if (n >= PAMS_SYMBOL_LEN)
                    my_exit("symbol length is longer than 255!\n");
                else
                    strncpy(symbol, optarg, n + 1);

                break;

            default:
                my_exit("Invalid argument.\n");
                break;
        }
    }

    if (optind < argc) {
        printf ("non-option ARGV-elements: ");
        while (optind < argc)
            printf ("%s ", argv[optind++]);
        putchar ('\n');
    }

    if (!pfb_flag && !pst_flag)
        my_exit("--pfb or --pst missed.\n");

    if(pfb_flag) {
        if (src_file == NULL || dst_file == NULL)
            my_exit("src-file or dst-file missed.\n");

        if (off_src < 0)
            my_exit("src-off missed.\n");

        if ((off_dst < 0) && (list_file == NULL))
            my_exit("dst-off or off-list missed.\n");

        if (length < 0)
            my_exit("length missed or invalid.\n");

        if (fseek(src_file, off_src, SEEK_SET) ||
            fread(buf, (size_t)length, 1, src_file) != 1)
            my_exit("fread failed.\n");

        if (batch) {
            printf("buf is 0x%x\n", *(unsigned*)buf);
            fscanf(list_file, "%x", &off_dst);
            while (!feof(list_file)) {
                if (fseek(dst_file, off_dst, SEEK_SET) ||
                    fwrite(buf, (size_t)length, 1, dst_file) != 1)
                    my_exit("write failed.\n");
                fscanf(list_file, "%x", &off_dst);
            }
        } else {
            if (fseek(dst_file, off_dst, SEEK_SET) ||
                fwrite(buf, (size_t)length, 1, dst_file) != 1)
                my_exit("write failed.\n");
        }

        fclose(src_file);
        fclose(dst_file);
        if (list_file)
            fclose(list_file);

        return 0;
    } else {
        if (src_file == NULL)
            my_exit("please provide library name!\n");

        if (dynamic_off == 0)
            my_exit("please provide dynamic offset!\n");

        if (list_file == NULL && !strcmp(symbol, "NULL"))
            my_exit("symbol name or list file is missed\n");

        si->dynamic = (unsigned*)(si->base + dynamic_off);

        // go through dynamic section to find string table and symbol table
        for (d = si->dynamic; *d; d++) {
            switch (*d++) {
                case DT_HASH:
                    si->nbucket = ((unsigned *) (si->base + *d))[0];
                    si->nchain = ((unsigned *) (si->base + *d))[1];
                    si->bucket = (unsigned *) (si->base + *d + 8);
                    si->chain = (unsigned *) (si->base + *d + 8 + si->nbucket * 4);
                    break;

                case DT_STRTAB:
                    si->strtab = (const char *) (si->base + *d);
                    break;

                case DT_SYMTAB:
                    si->symtab = (Elf32_Sym *) (si->base + *d);
                    break;

                default:
                    break;
            }
        }

        if (batch == 0) {
            sym = patch_symbol(si, symbol, src_file);
            if (sym == NULL)
                my_exit("Patch %s in %s failed!\n", symbol, so);
        } else {
            fscanf(list_file, "%255s\n", symbol);
            while (!feof(list_file)) {
                sym = patch_symbol(si, symbol, src_file);
                if (sym == NULL)
                    my_exit("Patch %s in %s failed!\n", symbol, so);
                fscanf(list_file, "%255s\n", symbol);
            }
        }

        fclose(src_file);
        if (batch)
            fclose(list_file);

        return 0;
    }
}

static Elf32_Sym* patch_symbol(my_soinfo *si, const char *name, FILE *file)
{
    unsigned hash = elfhash(name);
    Elf32_Sym *s;
    Elf32_Sym *symtab = si->symtab;
    const char *strtab = si->strtab;
    unsigned n;

    n = hash % si->nbucket;

    for (n = si->bucket[hash % si->nbucket]; n != 0; n = si->chain[n]) {
        s = symtab + n;
        if (strcmp(strtab + s->st_name, name))
            continue;
        /* only concern ourselves with global and weak symbol definitions */
        switch (ELF32_ST_BIND(s->st_info)) {
            case STB_GLOBAL:
            case STB_WEAK:
                /* no section == undefined */
                if (s->st_shndx == 0) continue;

                do_patch_symbol(si, n, file);
                return s;

            default:
                break;
        }
    }

    return NULL;
}

static void do_patch_symbol(my_soinfo *si, unsigned n, FILE *file)
{
    unsigned offset;
    int ret;
    offset = (unsigned)si->symtab - (unsigned)si->base;
    offset += n * sizeof(Elf32_Sym);
    Elf32_Sym s;

    ret = fseek(file, (long)offset, SEEK_SET);
    if (ret < 0)
        my_exit("fseek failed!\n");

    ret = (int)fread(&s, sizeof(s), 1, file);
    if (ret != 1)
        my_exit("fread failed!\n");

    s.st_other = 1;
    ret = fseek(file, (long)offset, SEEK_SET);
    if (ret < 0)
        my_exit("fseek failed!\n");

    ret = (int)fwrite(&s, sizeof(s), 1, file);
    if (ret != 1)
        my_exit("fwrite failed!\n");
}

static unsigned elfhash(const char *_name)
{
    const unsigned char *name = (const unsigned char *) _name;
    unsigned h = 0, g;

    while(*name) {
        h = (h << 4) + *name++;
        g = h & 0xf0000000;
        h ^= g;
        h ^= g >> 24;
    }
    return h;
}

static int get_libsize(FILE *file)
{
    int ret;

    ret = fseek(file, 0, SEEK_END);
    if (ret < 0)
        my_exit("fseek failed!\n");

    ret = ftell(file);
    if (ret < 0)
        my_exit("ftell failed!\n");

    return ret;
}

static void usage()
{
    fprintf(stderr, "\n"                                                                        \
            " Usage: \n"                                                                        \
            "patch function body: \n"                                                           \
            "./pams --pfb --dst-lib|-d dst_lib --src-lib|-s src_lib \\"                         \
            "[--dst-off|-o dst_off | --off-list|-l off_list] --src-off|-r src_off \\"           \
            "--size|-z size \n"                                                                 \
            "patch symbol table: \n"                                                            \
            "./pams --pst --libname|-b libname --dyn-off|-n dynamic_off \\"                     \
            " [--whitelist|-w symbol_list | --whitesymbol|-m symbol_name] \n"                   \
            "\n"                                                                                \
            "Args: \n"                                                                          \
            "patch function body: \n"                                                           \
            "dst_lib: the library need to patch; \n"                                            \
            "src_lib: the libarary the binary content copied from; \n"                          \
            "dst_off: the offset in the binary to patch with; \n"                               \
            "off_list: a file containing a list of offsets in the binary to patch with; \n"     \
            "src_off: the offset in the binary to read content from; \n"                        \
            "size:    size of patch in bytes. \n"                                               \
            "patch symbol table: \n"                                                            \
            "libname: the library need to patch; \n"                                            \
            "dynamic_off: the offset of dynamic section of patched library; \n"                 \
            "symbol_list: a file containing a list of offsets in the binary to patch with; \n"  \
            "symbol_name: the symbol name need to be patched \n"                                \
            "\n"                                                                                \
            "Return: \n"                                                                        \
            "0 if success and -1 upon error. \n"                                                \
            "\n");
}

void my_exit(const char *s, ...)
{
    va_list ap = NULL;
    va_start(ap, s);
    vfprintf(stderr, s, ap);
    usage();
    va_end(ap);
    exit(-1);
}
