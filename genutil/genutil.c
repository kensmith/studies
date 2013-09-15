#include "genutil.h"

#ifdef GENUTIL

#  ifndef GENUTIL_REENTRANT
/* This variable records how deep we are in the function call stack. */
int GENUTIL_function_call_depth = 0;
#  else /* GENUTIL_REENTRANT */
#  endif /* GENUTIL_REENTRANT */

#else /* GENUTIL */

int ANSI_C_forbids_empty_source_files;

#endif /* GENUTIL */
