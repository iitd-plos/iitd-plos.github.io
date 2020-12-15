/* This program creates  a pipe which is a unidirectional data channel that can be used
   for interprocess communication (IPC). */

#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <errno.h>

int main(int argc, char const *argv[]) {

  int pipefd[2];

  if (pipe(pipefd) == -1)
    // print error code defined in error.h
    printf("Could No create pipe. Error Number %d\n", errno);

    printf("File Opened with file descriptor (pipefd[0] = %d) and pipefd[1] = %d \n",
      pipefd[0], pipefd[1]);

  // create copy of the process
  int pid = fork();
  if (pid == 0) {

    close(pipefd[1]); //close write end of file

    char buff[100];
    read(pipefd[0], buff, 100);
    printf("Read from Child = %s\n", buff);
  } else if(pid > 0) {

    close(pipefd[0]); // close read end of pipe
    write(pipefd[1], "Hello", 5);
    wait(0);  // wait for child process to exit
  } else
    printf("error in fork %d\n", errno);

  return 0;
}
