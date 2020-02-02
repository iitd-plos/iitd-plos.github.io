/* This program shares file discriptors for Inter Process
Communictions (IPC) */

#include <stdio.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <errno.h>

int main(int argc, char const *argv[]) {

  // if file foo.txt does not exist then it is created with permission of 644. Prefix by 0 for octal.
  int fd = open("foo.txt", O_RDWR | O_CREAT, 0644);
  if (fd ==-1)
    // print error code defined in error.h
    printf("Error Number %d\n", errno);

  printf("File Opened with file descriptor (fd) = %d \n", fd);

  // create copy of the process
  int pid = fork();
  if (pid == 0) {
    sleep(5);   // Wait for Parent to write into the file
    char buff[100];
    lseek(fd, 0, SEEK_SET);
    read(fd, buff, 100);
    printf("Read from Child. Data = %s\n", buff);
  } else if(pid > 0) {
    // The wait() system call suspends execution of the current process until
    // one of its children terminates.
    // sleep(5);  // strange behaviour if sleep is put here
    write(fd, "Hello", 5);
    wait(0);
  } else
    printf("error in fork %d\n", errno);

  return 0;
}
