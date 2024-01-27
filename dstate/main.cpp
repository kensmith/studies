#include <signal.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#define EXIT_STRING "EXIT\n"

static void __attribute__((noinline)) run_child(void)
{
  char input[sizeof(EXIT_STRING)];

  while (1) {
    if (fgets(input, sizeof(input), stdin) == NULL ) {
      break;
    }
    if (strcmp(input, EXIT_STRING) == 0) {
      break;
    }
    if (strlen(input) == sizeof(input) - 1 &&
        input[strlen(input) - 1] != '\n') {
      int c;
      while ((c = getchar()) != '\n' && c != EOF)
        ;
    }
  }
  _exit(0);
}

int main()
{
  sigset_t set;

  sigfillset(&set);
  sigprocmask(SIG_BLOCK, &set, NULL);

  pid_t pid = vfork();
  if (pid == 0) {
    run_child();
  } else if (pid < 0) {
    return 1;
  }
  return 0;
}
