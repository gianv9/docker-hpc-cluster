#include <stdio.h>
#include <stdlib.h>

char st[512];
void encrypt(char *fl){
    char ch;    
    int i, key;

    key = 3;
    
    for(i = 0; fl[i] != '\0'; ++i){
        ch = fl[i];
        
        if(ch >= 'a' && ch <= 'z'){
            ch = ch + key;
            
            if(ch > 'z'){
                ch = ch - 'z' + 'a' - 1;
            }
                fl[i] = ch;
        }
        else if(ch >= 'A' && ch <= 'Z'){
            ch = ch + key;
            
            if(ch > 'Z'){
                ch = ch - 'Z' + 'A' - 1;
            }
            
                fl[i] = ch;
        }
    }
    
    printf("Encrypted message: %s\n", fl);
}

void encrypt2(char *fl){
    char ch;    
    int i, key;

    key = 4;
    
    for(i = 0; fl[i] != '\0'; ++i){
        ch = fl[i];
        
        if(ch >= 'a' && ch <= 'z'){
            ch = ch + key;
            
            if(ch > 'z'){
                ch = ch - 'z' + 'a' - 1;
            }
                fl[i] = ch;
        }
        else if(ch >= 'A' && ch <= 'Z'){
            ch = ch + key;
            
            if(ch > 'Z'){
                ch = ch - 'Z' + 'A' - 1;
            }
            
                fl[i] = ch;
        }
    }
    
    printf("Encrypted message: %s\n", fl);
}

void encrypt3(char *fl){
    char ch;    
    int i, key;

    key = 5;
    
    for(i = 0; fl[i] != '\0'; ++i){
        ch = fl[i];
        
        if(ch >= 'a' && ch <= 'z'){
            ch = ch + key;
            
            if(ch > 'z'){
                ch = ch - 'z' + 'a' - 1;
            }
                fl[i] = ch;
        }
        else if(ch >= 'A' && ch <= 'Z'){
            ch = ch + key;
            
            if(ch > 'Z'){
                ch = ch - 'Z' + 'A' - 1;
            }
            
                fl[i] = ch;
        }
    }
    
    printf("Encrypted message: %s\n", fl);
}
