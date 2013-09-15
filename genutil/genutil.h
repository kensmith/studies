/* This file provides the following macros for use in debugging and
 * program execution path verification.
 *
 * entering_function(char* function_name);
 *     This should be called at the beginning of every function call
 *     that you wish to see on your execution path trace.
 * leaving_function(int return_code);
 *     This should be called just before every exit point from any
 *     function in which you have already called entering_function.
 *     To use this macro in any function that has not previously used
 *     entering_function, will result in a compile time error.  Also
 *     make sure to give only integers as the arguments to calls to
 *     leaving_function.
 * geninfo(format, data);
 *     This can be used similarly to a printf which only takes one
 *     vararg.  The usefulness of this macro lies in the its
 *     handily outputting the filename and source code line
 *     number of each call.
 *
 * To use this utility, define GENUTIL.  This is usually accomplished
 * by adding -DGENUTIL to the C preprocessor command line.
 *
 * ex. gcc -DGENUTIL file_that_uses_genutil.c genutil.o
 *
 * IMPORTANT NOTE:  If your program is multithreaded, also define
 *                  the variable GENUTIL_REENTRANT.  This will avoid
 *                  possible problems with the use of a global
 *                  variable for function call depth indication.
 * multithreaded ex. gcc -DGENUTIL -DGENUTIL_REENTRANT program.c
 *
 * GENERAL NOTES: While reading the following code, you may notice the
 * presence of "do {} while (0)" constructs.  This may not seem useful,
 * however, it is intentional and does serve a purpose.  The way to
 * call entering_function, for example, is to do the following.
 *
 * entering_function("function_name()");
 *
 * If entering_function expands simply to a compound statement, the
 * result would be:
 *
 * {
 *     code...
 * };
 *
 * This is perfectly legitamate C code.  The semicolon is interpreted
 * as a null statement.  However, the following usage of
 * entering_function would still also be valid.
 *
 * entering_function("function_name()")
 *
 * To avoid this ambiguity on which way to use the macro, I have
 * enclosed each macro within a do-while-zero loop construct.  The
 * code performs in exactly the same way as if the loop construct were
 * not there but its existence imposes a more consistent syntax.
 *
 *
 * When using genutil, if GENUTIL_REENTRANT is not defined, it is
 * imperitive to compile genutil.o into your program.  If it is not,
 * the linker will become confused when it encounters references to
 * GENUTIL_function_call_depth.
 *
 *
 * Also, if you plan to use genutil in a C project, do not write
 * functions whose names match the macros defined herein.  The results
 * will be strange.
 *
 *
 * Some reasons to use a utility like genutil are that it provides a
 * visual confirmation of program flow.  It does this in a clear and
 * consistent way.  Also, when you don't define GENUTIL, none of the
 * contained code evaluates to anything.  Due to this, it is easy to
 * riddle your code with calls the functions in here and remove them
 * all with no effort.  If your program behaves differently when you
 * define GENUTIL than when you do not, check out a utility like
 * electric fence or purify.  Chances are good that you are blowing
 * the stack if this is the case.  By "blowing the stack", I mean
 * reading or writing outside your allocated memory or some such.
 */
#ifndef __GENUTIL_H
#    define __GENUTIL_H

#    ifdef GENUTIL


#        include <stdio.h>

#        ifndef GENUTIL_REENTRANT
             extern int GENUTIL_function_call_depth;
#        endif /* GENUTIL_REENTRANT */


/* USER CONFIGURATION OPTIONS */
/* macro
 * GENUTIL_OUT
 * This is the FILE* upon which genutil will spew forth its output.
 *
 * macro
 * GENINFO_APPEND_NEWLINE
 * Define this macro to 1 or some such to coax geninfo() to
 * append a newline to its output.
 */
#        define GENUTIL_OUT stdout
#        define GENINFO_APPEND_NEWLINE
/*
 *TODO Evaluate whether or not entering_function should be all capital
 *TODO letters or not.  Some people don't like macros which are lower
 *TODO case for reasons of ambiguity, however, they break up the
 *TODO visual flow of the codes somewhat and therefore, I like the
 *TODO lowercase versions better.
 */

/* macro
 * entering_function
 *
 * To be utilized effectively, entering_function should be called at
 * the beginning of every function call.  For each function which
 * calls entering_function, a call to leaving_function should be made
 * at every exit point from a function.
 *
 * The variable GENUTIL_function_name will have function scope.  This
 * variable declaration enforces a few things that make the misuse of
 * genutil less likely.  Firstly, entering_function must be called
 * directly after all variable definitions and directly before any
 * code.  This is the appropriate place for entering_function
 * semantically, however, this variable definition enforces this
 * syntactically.  Secondly, since leaving_function uses
 * GENUTIL_function_name, it must only appear in functions which have
 * previously made a call to entering_function.
 */
#        ifdef entering_function
#            error "entering_function is multiply defined."
#        else /* entering_function */
#            ifndef GENUTIL_REENTRANT
#                define entering_function(function_name)\
                        char *GENUTIL_function_name = function_name;\
                        do {\
                            int GENUTIL_i;\
                            fprintf(GENUTIL_OUT, "%s(%d): ENTERING",\
                                    __FILE__, __LINE__);\
                            if (GENUTIL_function_call_depth < 0)\
			    {\
				fprintf(GENUTIL_OUT,"genutil: The function call depth indicator fell to %d, this indicates that not\n"\
					"genutil: all of the functions are utilizing the entering_function and\n"\
					"genutil: leaving_function macros correctly.  Make sure that all function\n"\
					"genutil: entrance points contain a call to entering_function and that all\n"\
					"genutil: function exit points contain a call to leaving_function.\n", GENUTIL_function_call_depth);\
			        exit(-1);\
			    }\
                            fprintf(GENUTIL_OUT, "(depth:%d)",\
				    GENUTIL_function_call_depth);\
			    for (GENUTIL_i = 0;\
				 GENUTIL_i < GENUTIL_function_call_depth;\
				 GENUTIL_i++)\
			    {\
				fprintf(GENUTIL_OUT, ".");\
			    }\
			    fprintf(GENUTIL_OUT, "> ");\
			    fprintf(GENUTIL_OUT, "%s\n",\
				    GENUTIL_function_name);\
			    fflush(GENUTIL_OUT);\
                            GENUTIL_function_call_depth++;\
                        } while (0)
#            else /* GENUTIL_REENTRANT */
#                define entering_function(function_name)\
                        char *GENUTIL_function_name = function_name;\
                        do {\
                            fprintf(GENUTIL_OUT, "%s(%d): ENTERING %s\n",\
                                    __FILE__, __LINE__,\
				    GENUTIL_function_name);\
			    fflush(GENUTIL_OUT);\
                        } while (0)
#            endif /* GENUTIL_REENTRANT */

#        endif /* entering_function */

/*
 *TODO In the instructional output, add a note saying not to modify
 *TODO the GENUTIL_* variables and to make sure that there aren't any
 *TODO errors in genutil itself.
 */

/* macro
 * leaving_function
 *
 * This macro should be called at every exit point from a function.
 * It must only be called from within functions which have previously
 * made a call to entering_function.
 */
#        ifdef leaving_function
#            error "leaving_function is multiply defined"
#        else /* leaving_function */
#            ifndef GENUTIL_REENTRANT
#                define leaving_function(return_value_cast_to_int)\
                        GENUTIL_function_call_depth--;\
                        do {\
                            int GENUTIL_i;\
                            fprintf(GENUTIL_OUT, "%s(%d): LEAVING",\
                                    __FILE__, __LINE__);\
                            if (GENUTIL_function_call_depth < 0)\
			    {\
				fprintf(GENUTIL_OUT,"genutil: The function call depth indicator fell to %d, this indicates that not\n"\
					"genutil: all of the functions are utilizing the entering_function and\n"\
					"genutil: leaving_function macros correctly.  Make sure that all function\n"\
					"genutil: entrance points contain a call to entering_function and that all\n"\
					"genutil: function exit points contain a call to leaving_function.\n", GENUTIL_function_call_depth);\
			        exit(-1);\
			    }\
                            fprintf(GENUTIL_OUT, "(depth:%d)",\
				    GENUTIL_function_call_depth);\
			    for (GENUTIL_i = 0;\
				 GENUTIL_i < GENUTIL_function_call_depth;\
				 GENUTIL_i++)\
			    {\
				fprintf(GENUTIL_OUT, ".");\
			    }\
			    fprintf(GENUTIL_OUT, "> ");\
			    fprintf(GENUTIL_OUT, "%s [%d]\n",\
				    GENUTIL_function_name,\
				    (int) return_value_cast_to_int);\
			    fflush(GENUTIL_OUT);\
                        } while (0)
#            else /* GENUTIL_REENTRANT */
#                define leaving_function(return_value_cast_to_int) \
                        do {\
                            fprintf(GENUTIL_OUT, "%s(%d): LEAVING %s [%d]\n",\
                                    __FILE__, __LINE__,\
				    GENUTIL_function_name,\
				    (int) return_value_cast_to_int);\
			    fflush(GENUTIL_OUT);\
                        } while (0)
#            endif /* GENUTIL_REENTRANT */

#        endif /* leaving_function */

#        ifdef geninfo
#            error "geninfo is multiply defined"
#        else /* geninfo */
#            ifdef GENINFO_APPEND_NEWLINE
#                define geninfo(format, data)\
                        do {\
                            fprintf(GENUTIL_OUT, "%s(%d): ",\
                                    __FILE__,\
                                    __LINE__);\
                            fprintf(GENUTIL_OUT, format, data);\
                            fprintf(GENUTIL_OUT, "\n");\
                            fflush(GENUTIL_OUT);\
                        } while (0)
#            else /* GENINFO_APPEND_NEWLINE */
#                define geninfo(format, data)\
                        do {\
                            fprintf(GENUTIL_OUT, "%s(%d): ",\
                                    __FILE__,\
                                    __LINE__);\
                            fprintf(GENUTIL_OUT, format, data);\
                            fflush(GENUTIL_OUT);\
                        } while (0)
#            endif /* GENINFO_APPEND_NEWLINE */
#        endif /* geninfo */

#    else /* GENUTIL */
/*       If GENUTIL is not defined, define the macros as empty space
 */

#        ifdef entering_function
#            error "entering_function is multiply defined"
#        else
#            define entering_function(hi)
#        endif

#        ifdef leaving_function
#            error "leaving_function is multiply defined"
#        else
#            define leaving_function(hello)
#        endif

#        ifdef geninfo
#            error "geninfo is multiply defined"
#        else
#            define geninfo(hello, again)
#        endif

#    endif /* GENUTIL */

#endif /* __GENUTIL_H */
