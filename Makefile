# usage:
#  make  -> make build=build
#  make build=<build_xxx> -> build in dir <build_xxx>
# P.S. /build_*/ has been added to .gitignore

# Special build:
#  build_dbg*	will add -g
#  build_MSVC	will use MS Visuall C++ Tools

# result exe filename
target_fn?=wordinter


src=src
headerDir=src
#build dir
build?=build

ifneq (,$(findstring build_dbg,$(build)))  # if contains build_dbg
CFLAGS+=-std=c99
CFLAGS+=-g
else
CFLAGS+=-O2
endif

outflag?=-o
outoflag?=-o

ifeq ($(build),build_MSVC)
	#CFLAGS=/std:c99  #XXX: vs17 not sup previous than c11
CFLAGS=/O2
CC=cl
outflag=/Fe:
outoflag=/Fo:
OPT_PRE=/
objSuf=obj
else
OPT_PRE=-
objSuf=o
endif

target=$(build)/$(target_fn)

# objCache will be used for check and make dir via `cmd` command
ifeq ($(OS), Windows_NT)
SHELL=cmd
objCache=$(build)\objs
else
objCache=$(build)/objs
endif

srcs=$(wildcard $(src)/*.c)

objs=$(patsubst $(src)/%.c,$(objCache)/%.$(objSuf),$(srcs)) 


# compile flag
to_obj=$(CC) $(OPT_PRE)c

incDirFlag=$(OPT_PRE)I

incDir=$(incDirFlag) $(headerDir)
#rm=rm
$(target):$(objs)
	$(CC) $(CFLAGS) $+ $(outflag)$@

$(objCache):
ifeq ($(OS), Windows_NT)
	if not exist $(objCache) ( md $(objCache) )
else
	mkdir -p $(objCache)
endif

$(objCache)/%.$(objSuf):$(src)/%.c $(src)/%.h | $(objCache)
	$(to_obj) $(CFLAGS) $(incDir) $< $(outoflag) $@



