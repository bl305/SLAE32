rm RSA_decrypt
gcc -ggdb -Wall -Wextra -o RSA_decrypt RSA_decrypt.c -lcrypto -fno-stack-protector -z execstack
./RSA_decrypt
