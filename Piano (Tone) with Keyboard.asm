.MODEL TINY

.STACK 100H

ORG     100H

.DATA

    PETUNJUK_1  DB 'Petunjuk' ,13,10, 'DO = C' ,13,10, 'Tekan q Hingga u untuk Nada Do hingga Si Oktaf Pertama' ,13,10, 'Tekan a Hingga j untuk Nada Do hingga Si Oktaf Kedua' ,13,10, 'Tekan z Hingga m untuk Nada Do hingga Si Oktaf Ketiga' ,13,10, '$'
    PETUNJUK_2  DB 'Huruf i sama dengan a, Huruf k sama dengan z', 13,10, 'Karakter "," adalah Do Oktaf Keempat' ,13,10, 'Huruf atau karakter lain tidak akan mengeluarkan bunyi' ,13,10, 'Tekan 0 untuk keluar dari Program' ,13,10,13,10, 'PERHATIAN!!! Huruf Kapital akan mengeluarkan kunci Kres untuk nada tersebut' ,13,10, 'Selamat Menikmati' ,13,10, '$'
    NADA        DW ?
        
.CODE 

    CURSOR_OFF PROC NEAR
        MOV     CH, 10h         
        MOV     AH, 01H         
        INT     10h             
        RET
    CURSOR_OFF ENDP                         

    CURSOR_ON PROC NEAR
        MOV     CX, 0506h       
        MOV     AH, 01H         
        INT     10H             
        RET                         
    CURSOR_ON ENDP
    
    SOUNDER PROC NEAR
        MOV     AL, 0B6H        
        OUT     43H, Al         
        MOV     AX, NADA        
        OUT     42H, AL         
        MOV     AL, AH          
        OUT     42H, AL         
        IN      AL, 061H        
        OR      AL, 03H         
        OUT     61H, AL         
        CALL    DELAY           
        AND     AL, 0FCH        
        OUT     61H, AL         
        CALL    CLEAR_KEYBOARD        
        RET
    SOUNDER ENDP                         

    DELAY PROC NEAR
        MOV     AH, 00H         
        INT     01AH            
        ADD     DX, 4           
        MOV     BX, DX
        CALL    PZ 
        RET
    DELAY ENDP          

    PZ PROC NEAR
        INT     01AH            
        CMP     DX, BX          
        JL      PZ              
        RET                         
    PZ ENDP
    
    CLEAR_KEYBOARD PROC NEAR
        PUSH    ES                      
        PUSH    DI                      
        MOV     AX, 40H                 
        MOV     ES, AX                  
        MOV     AX, 1AH                 
        MOV     DI, AX                  
        MOV     AX, 1EH                 
        MOV     ES: WORD PTR [DI], AX   
        INC     DI                      
        INC     DI                      
        MOV     ES: WORD PTR [DI], AX   
        POP     DI                      
        POP     ES                      
        RET
    CLEAR_KEYBOARD ENDP                                 
   
    EXIT PROC NEAR
        CALL    CURSOR_ON         
        JMP KELUAR
        RET
    EXIT ENDP
                         
.STARTUP

    MAIN:
        
        MOV AX, @DATA
        MOV DS, AX
        
        MOV DX, OFFSET PETUNJUK_1
        MOV AH, 09H
        INT 21H
        
        MOV DX, OFFSET PETUNJUK_2
        MOV AH, 09H
        INT 21H
        
        JMP START
                
        START:
        CALL CURSOR_OFF 
        
        GET_INPUT:
            MOV AH, 01H
            INT 21H
            CMP AL,"0"
            JE  EXIT_1
            JNE GET_INPUT_1
        
        EXIT_1:
            CALL EXIT
        
        GET_INPUT_1:
            CMP AL,"q"         
            JE DO_1
            CMP AL,"Q"         
            JE DO_1_KRES    
            CMP AL,"w"         
            JE RE_1
            CMP AL,"W"         
            JE RE_1_KRES    
            CMP AL,"e"         
            JE MI_1
            CMP AL,"r"         
            JE FA_1
            CMP AL,"R"         
            JE FA_1_KRES        
            JNE GET_INPUT_1_1     
        DO_1:
            MOV     AX, 9121        
            MOV     NADA, AX
            CALL    SOUNDER         
            JMP     GET_INPUT       
        DO_1_KRES:
            MOV     AX, 8609
            MOV     NADA, AX
            CALL    SOUNDER
            JMP     GET_INPUT
        RE_1:
            MOV     AX, 8126        
            MOV     NADA, AX
            CALL    SOUNDER         
            JMP     GET_INPUT           
        RE_1_KRES:
            MOV     AX, 8609
            MOV     NADA, AX
            CALL    SOUNDER
            JMP     GET_INPUT
        MI_1:
            MOV     AX, 7239         
            MOV     NADA, AX
            CALL    SOUNDER          
            JMP     GET_INPUT               
        FA_1:
            MOV     AX, 6833         
            MOV     NADA, AX
            CALL    SOUNDER          
            JMP     GET_INPUT        
        FA_1_KRES:
            MOV     AX, 8609
            MOV     NADA, AX
            CALL    SOUNDER
            JMP     GET_INPUT
            
        GET_INPUT_1_1:
            CMP AL,"t" 
            JE SOL_1
            CMP AL,"T"         
            JE SOL_1_KRES
            CMP AL,"y"         
            JE LA_1
            CMP AL,"Y"         
            JE LA_1_KRES
            CMP AL,"u"          
            JE SI_1
            JNE GET_INPUT_2
        SOL_1:
            MOV     AX, 6087         
            MOV     NADA, AX
            CALL    SOUNDER          
            JMP     GET_INPUT        
        SOL_1_KRES:
            MOV     AX, 8609
            MOV     NADA, AX
            CALL    SOUNDER
            JMP     GET_INPUT
        LA_1:
            MOV     AX, 5423         
            MOV     NADA, AX
            CALL    SOUNDER          
            JMP     GET_INPUT         
        LA_1_KRES:
            MOV     AX, 8609
            MOV     NADA, AX
            CALL    SOUNDER
            JMP     GET_INPUT     
        SI_1:
            MOV     AX, 4831         
            MOV     NADA, AX
            CALL    SOUNDER          
            JMP     GET_INPUT
        
        GET_INPUT_2:
            CMP AL,"i"          
            JE DO_2
            CMP AL,"I"
            JE DO_2_KRES 
            CMP AL,"a"          
            JE DO_2
            CMP AL,"A"          
            JE DO_2_KRES    
            CMP AL,"s"          
            JE RE_2
            CMP AL,"S"          
            JE RE_2_KRES    
            CMP AL,"d"          
            JE MI_2
            CMP AL,"f"          
            JE FA_2
            CMP AL,"F"          
            JE FA_2_KRES
            JNE GET_INPUT_2_2     
        DO_2:
            MOV     AX, 4560         
            MOV     NADA, AX
            CALL    SOUNDER          
            JMP     GET_INPUT        
        DO_2_KRES:
            MOV     AX, 4304
            MOV     NADA, AX
            CALL    SOUNDER
            JMP     GET_INPUT
        RE_2:
            MOV     AX, 4063         
            MOV     NADA, AX
            CALL    SOUNDER          
            JMP     GET_INPUT            
        RE_2_KRES:
            MOV     AX, 3834
            MOV     NADA, AX
            CALL    SOUNDER
            JMP     GET_INPUT
        MI_2:
            MOV     AX, 3619         
            MOV     NADA, AX
            CALL    SOUNDER          
            JMP     GET_INPUT               
        FA_2:
            MOV     AX, 3416         
            MOV     NADA, AX
            CALL    SOUNDER          
            JMP     GET_INPUT        
        FA_2_KRES:
            MOV     AX, 3223
            MOV     NADA, AX
            CALL    SOUNDER
            JMP     GET_INPUT       
        
        GET_INPUT_2_2:
            CMP AL,"g"          
            JE SOL_2
            CMP AL,"G"          
            JE SOL_2_KRES
            CMP AL,"h"          
            JE LA_2
            CMP AL,"H"          
            JE LA_2_KRES
            CMP AL,"j"          
            JE SI_2
            JNE GET_INPUT_3
        SOL_2:
            MOV     AX, 3043         
            MOV     NADA, AX
            CALL    SOUNDER          
            JMP     GET_INPUT        
        SOL_2_KRES:
            MOV     AX, 2873
            MOV     NADA, AX
            CALL    SOUNDER
            JMP     GET_INPUT
        LA_2:
            MOV     AX, 2711         
            MOV     NADA, AX
            CALL    SOUNDER          
            JMP     GET_INPUT  
        LA_2_KRES:
            MOV     AX, 2559
            MOV     NADA, AX
            CALL    SOUNDER
            JMP     GET_INPUT
        SI_2:
            MOV     AX, 2415         
            MOV     NADA, AX
            CALL    SOUNDER          
            JMP     GET_INPUT 

        GET_INPUT_3:
            CMP AL,"k"          
            JE DO_3
            CMP AL,"K"          
            JE DO_3_KRES
            CMP AL,"z"          
            JE DO_3
            CMP AL,"Z"          
            JE DO_3_KRES    
            CMP AL,"x"          
            JE RE_3
            CMP AL,"X"          
            JE RE_3_KRES    
            CMP AL,"c"          
            JE MI_3
            CMP AL,"v"          
            JE FA_3
            CMP AL,"V"          
            JE FA_3_KRES
            JNE GET_INPUT_3_3    
        DO_3:
            MOV     AX, 2280         
            MOV     NADA, AX
            CALL    SOUNDER          
            JMP     GET_INPUT        
        DO_3_KRES:
            MOV     AX, 2152
            MOV     NADA, AX
            CALL    SOUNDER
            JMP     GET_INPUT
        RE_3:
            MOV     AX, 2031         
            MOV     NADA, AX
            CALL    SOUNDER          
            JMP     GET_INPUT            
        RE_3_KRES:
            MOV     AX, 1917
            MOV     NADA, AX
            CALL    SOUNDER
            JMP     GET_INPUT
        MI_3:
            MOV     AX, 1809         
            MOV     NADA, AX
            CALL    SOUNDER          
            JMP     GET_INPUT               
        FA_3:
            MOV     AX, 1715         
            MOV     NADA, AX
            CALL    SOUNDER          
            JMP     GET_INPUT        
        FA_3_KRES:
            MOV     AX, 1612
            MOV     NADA, AX
            CALL    SOUNDER
            JMP     GET_INPUT         
             
        GET_INPUT_3_3:
            CMP AL,"b"          
            JE SOL_3
            CMP AL,"B"          
            JE SOL_3_KRES
            CMP AL,"n"          
            JE LA_3
            CMP AL,"N"          
            JE LA_3_KRES
            CMP AL,"m"          
            JE SI_3
            CMP AL,","
            JE DO_4
            JMP GET_INPUT
        SOL_3:
            MOV     AX, 1521         
            MOV     NADA, AX
            CALL    SOUNDER          
            JMP     GET_INPUT        
        SOL_3_KRES:
            MOV     AX, 1436
            MOV     NADA, AX
            CALL    SOUNDER
            JMP     GET_INPUT
        LA_3:
            MOV     AX, 1355         
            MOV     NADA, AX
            CALL    SOUNDER          
            JMP     GET_INPUT 
        LA_3_KRES:
            MOV     AX, 1292
            MOV     NADA, AX
            CALL    SOUNDER
            JMP     GET_INPUT
        SI_3:
            MOV     AX, 1207         
            MOV     NADA, AX
            CALL    SOUNDER          
            JMP     GET_INPUT
        DO_4:
            MOV     AX, 1140
            MOV     NADA, AX
            CALL    SOUNDER
            JMP     GET_INPUT                 

KELUAR :
        
.EXIT                
END