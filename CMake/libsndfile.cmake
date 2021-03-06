
include (CMake/check.cmake)

check_c_compiler_flag (-fembed-bitcode 		HAS_EMBED_BITCODE)

lsf_check_include_file (alsa/asoundlib.h	HAVE_ALSA_ASOUNDLIB_H)
lsf_check_include_file (byteswap.h			HAVE_BYTESWAP_H)
lsf_check_include_file (dlfcn.h				HAVE_DLFCN_H)
lsf_check_include_file (endian.h			HAVE_ENDIAN_H)
lsf_check_include_file (inttypes.h			HAVE_INTTYPES_H)
lsf_check_include_file (locale.h			HAVE_LOCALE_H)
lsf_check_include_file (memory.h			HAVE_MEMORY_H)
lsf_check_include_file (sndio.h				HAVE_SNDIO_H)
lsf_check_include_file (stdint.h			HAVE_STDINT_H)
lsf_check_include_file (stdlib.h			HAVE_STDLIB_H)
lsf_check_include_file (string.h			HAVE_STRING_H)
lsf_check_include_file (strings.h			HAVE_STRINGS_H)
lsf_check_include_file (sys/stat.h			HAVE_SYS_STAT_H)
lsf_check_include_file (sys/time.h			HAVE_SYS_TIME_H)
lsf_check_include_file (sys/types.h			HAVE_SYS_TYPES_H)
lsf_check_include_file (sys/wait.h			HAVE_SYS_WAIT_H)
lsf_check_include_file (unistd.h			HAVE_UNISTD_H)


lsf_check_type_size (double 		SIZEOF_DOUBLE)
lsf_check_type_size (float 			SIZEOF_FLOAT)
lsf_check_type_size (int 			SIZEOF_INT)
lsf_check_type_size (int64_t 		SIZEOF_INT64_T)
lsf_check_type_size (loff_t 		SIZEOF_LOFF_T)
lsf_check_type_size (long 			SIZEOF_LONG)
lsf_check_type_size (long\ long 	SIZEOF_LONG_LONG)
lsf_check_type_size (offt64_t 		SIZEOF_OFF64_T)
lsf_check_type_size (off_t 			SIZEOF_OFF_T)
lsf_check_type_size (short 			SIZEOF_SHORT)
lsf_check_type_size (size_t 		SIZEOF_SIZE_T)
lsf_check_type_size (ssize_t 		SIZEOF_SSIZE_T)
lsf_check_type_size (void* 			SIZEOF_VOIDP)
lsf_check_type_size (wchar_t 		SIZEOF_WCHAR_T)

set (SIZEOF_SF_COUNT_T ${SIZEOF_INT64_T})
set (TYPEOF_SF_COUNT_T int64_t)

# Can't figure out how to make CMAKE_COMPILER_IS_GNUCC set something to either
# 1 or 0 so we do this:
lsf_try_compile_c_result (CMake/compiler_is_gcc.c COMPILER_IS_GCC 1 0)

lsf_try_compile_c_result (CMake/have_decl_s_irgrp.c HAVE_DECL_S_IRGRP 1 0)

TEST_BIG_ENDIAN (BIGENDIAN)
if (${BIGENDIAN})
	set (WORDS_BIGENDIAN 1)
	set (CPU_IS_BIG_ENDIAN 1)
	set (CPU_IS_LITTLE_ENDIAN 0)
else (${BIGENDIAN})
	set (WORDS_BIGENDIAN 0)
	set (CPU_IS_LITTLE_ENDIAN 1)
	set (CPU_IS_BIG_ENDIAN 0)
	endif (${BIGENDIAN})

if (${WINDOWS})
	set (OS_IS_WIN32 1)
else (${WINDOWS})
	set (OS_IS_WIN32 0)
	endif (${WINDOWS})


lsf_check_library_exists (m floor "" HAVE_LIBM)
lsf_check_library_exists (sqlite3 sqlite3_close "" HAVE_SQLITE3)

lsf_check_function_exists (calloc		HAVE_CALLOC)
lsf_check_function_exists (free			HAVE_FREE)
lsf_check_function_exists (fstat		HAVE_FSTAT)
lsf_check_function_exists (fstat64		HAVE_FSTAT64)
lsf_check_function_exists (fsync		HAVE_FSYNC)
lsf_check_function_exists (ftruncate	HAVE_FTRUNCATE)
lsf_check_function_exists (getpagesize	HAVE_GETPAGESIZE)
lsf_check_function_exists (gettimeofday	HAVE_GETTIMEOFDAY)
lsf_check_function_exists (gmtime		HAVE_GMTIME)
lsf_check_function_exists (gmtime_r		HAVE_GMTIME_R)
lsf_check_function_exists (localtime	HAVE_LOCALTIME)
lsf_check_function_exists (localtime_r	HAVE_LOCALTIME_R)
lsf_check_function_exists (lseek		HAVE_LSEEK)
lsf_check_function_exists (lseek64		HAVE_LSEEK64)
lsf_check_function_exists (malloc		HAVE_MALLOC)
lsf_check_function_exists (mmap			HAVE_MMAP)
lsf_check_function_exists (open			HAVE_OPEN)
lsf_check_function_exists (pipe			HAVE_PIPE)
lsf_check_function_exists (read			HAVE_READ)
lsf_check_function_exists (realloc		HAVE_REALLOC)
lsf_check_function_exists (setlocale	HAVE_SETLOCALE)
lsf_check_function_exists (snprintf		HAVE_SNPRINTF)
lsf_check_function_exists (vsnprintf	HAVE_VSNPRINTF)
lsf_check_function_exists (waitpid		HAVE_WAITPID)
lsf_check_function_exists (write		HAVE_WRITE)

lsf_check_math_function_exists (ceil	HAVE_CEIL)
lsf_check_math_function_exists (floor 	HAVE_FLOOR)
lsf_check_math_function_exists (fmod  	HAVE_FMOD)
lsf_check_math_function_exists (lrint	HAVE_LRINT)
lsf_check_math_function_exists (lrintf	HAVE_LRINTF)
lsf_check_math_function_exists (lround	HAVE_LROUND)
