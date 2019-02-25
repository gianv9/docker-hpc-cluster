#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void decrypt (char *fld){
    char ch;
    long size;
    int i, key;

    key = 3;
    
    for(i = 0; fld[i] != '\0'; ++i){
        ch = fld[i];        
        
        if(ch >= 'a' && ch <= 'z'){
            ch = ch - key;
            
            if(ch < 'a'){
                ch = ch + 'z' - 'a' + 1;
            }
            
            fld[i] = ch;
        }
        else if(ch >= 'A' && ch <= 'Z'){
            ch = ch - key;
            
            if(ch < 'A'){
                ch = ch + 'Z' - 'A' + 1;
            }
            
            fld[i] = ch;
        }
    }
    
    printf("Decrypted message: %s\n", fld);
}

void decrypt2 (char *fld){
    char ch;
    long size;
    int i, key;

    key = 4;
    
    for(i = 0; fld[i] != '\0'; ++i){
        ch = fld[i];        
        
        if(ch >= 'a' && ch <= 'z'){
            ch = ch - key;
            
            if(ch < 'a'){
                ch = ch + 'z' - 'a' + 1;
            }
            
            fld[i] = ch;
        }
        else if(ch >= 'A' && ch <= 'Z'){
            ch = ch - key;
            
            if(ch < 'A'){
                ch = ch + 'Z' - 'A' + 1;
            }
            
            fld[i] = ch;
        }
    }
    
    printf("Decrypted message: %s\n", fld);
}

void decrypt3 (char *fld){
    char ch;
    long size;
    int i, key;

    key = 5;
    
    for(i = 0; fld[i] != '\0'; ++i){
        ch = fld[i];        
        
        if(ch >= 'a' && ch <= 'z'){
            ch = ch - key;
            
            if(ch < 'a'){
                ch = ch + 'z' - 'a' + 1;
            }
            
            fld[i] = ch;
        }
        else if(ch >= 'A' && ch <= 'Z'){
            ch = ch - key;
            
            if(ch < 'A'){
                ch = ch + 'Z' - 'A' + 1;
            }
            
            fld[i] = ch;
        }
    }
    
    printf("Decrypted message: %s\n", fld);
}
