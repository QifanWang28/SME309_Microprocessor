	AREA    MYCODE, CODE, READONLY, ALIGN=9 
   	  ENTRY
	  
; ------- <code memory (ROM mapped to Instruction Memory) begins>

	LDR R1, constant1; R1=5
	LDR R2, constant2; R2=6
	LDR R3, addr1; 810
	LDR R4, addr2; 820
	LDR R12,addr3; 830
	ADD R5, R1, R2; R5 = a1 + a2;
	
	AND R5, R1, #0;
    EOR R6, R1, R3;
    SUB R7, R4, R3;
    RSB R8, R7, R1;
    ADD R5, R7, R8;
    SUB R6, R1, #6;
    ADD R6, R6, R6;
    ADC R6, R1, R2;
    SUB R6, R1, #6;
    SBC R7, R2, R1;
    SUB R9, R1, R2;
    RSC R7, R2, R1;
    TST R1, #0;
    ADD R10, R1, R2;
    TEQ R10, R10;
    CMP R5, R6;
    RSB R8, R5, #0;
    CMN R5, R8;
    ORR R9，R3，R1;
    MOV R12, R4;
    BIC R13, R4, R3;
    MVN R10, R2;
	
halt	
	B    halt
	
; ------- <code memory (ROM mapped to Instruction Memory) begins>
	
	
	
	

; ------- <code memory (ROM mapped to DATA Memory) begins>
	AREA    CONSTANTS, DATA, READONLY, ALIGN=9 


addr1
		DCD 0x00000810;
addr2 	
		DCD 0x00000820;
addr3
		DCD 0x00000830;
constant1
		DCD 0x00000005; 
constant2
		DCD 0x00000006;
constant3 
		DCD 0x00000003;

number0
		DCD 0x00000000;




		END	