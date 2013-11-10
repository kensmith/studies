#ifndef __printk_h__
#define __printk_h__

#if defined(__cplusplus)
extern "C" {
#endif

void printk(const char * buffer);
void printhex(const char * name, unsigned x);
void printchar(char c);

#if defined(__cplusplus)
}
#endif

#endif // __printk_h__
