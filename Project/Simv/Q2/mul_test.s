	AREA    MYCODE, CODE, READONLY, ALIGN=9 
   	  ENTRY
	  
; ------- <code memory (ROM mapped to Instruction Memory) begins>

	LDR R1, constant1; R1=5
	LDR R2, constant2; R2=6
	LDR R3, addr1; 810
	LDR R4, addr2; 820
	LDR R12,addr3; 830
	ADD R5, R1, R2; R5 = a1 + a2;
	
	MUL R7,R5,R2;R7=66
	LDR R8,constant3; R8=3
	LDR R3,number0;R3=0
	MULEQ R7,R1,R8; not execute,R7=66
	ADDS R3,R3,#0; SET Z FLAG = 1
	MULEQ R10,R1,R8; R10=15;
	ADDS R10,R10,R7; R10 =66+15=81,flags are 0
    ADD R1,R1,#1; R1 =82
    ADD R1,R1,#1; R1 =83
    ADD R1,R1,#1; R1 =84
    ADD R1,R1,#1; R1 =85
    ADD R1,R1,#1; R1 =82
    ADD R1,R1,#1; R1 =82
    ADD R1,R1,#1; R1 =82
    ADD R1,R1,#1; R1 =82
    ADD R1,R1,#1; R1 =82
    ADD R1,R1,#1; R1 =82
    ADD R1,R1,#1; R1 =82
    ADD R1,R1,#1; R1 =82
    ADD R1,R1,#1; R1 =82
    ADD R1,R1,#1; R1 =82
    ADD R1,R1,#1; R1 =82
    ADD R1,R1,#1; R1 =82
    ADD R1,R1,#1; R1 =83
    ADD R1,R1,#1; R1 =84
    ADD R1,R1,#1; R1 =85
    ADD R1,R1,#1; R1 =82
    ADD R1,R1,#1; R1 =82
    ADD R1,R1,#1; R1 =82
    ADD R1,R1,#1; R1 =82
    ADD R1,R1,#1; R1 =82
    ADD R1,R1,#1; R1 =82
    ADD R1,R1,#1; R1 =82
    ADD R1,R1,#1; R1 =82
    ADD R1,R1,#1; R1 =82
    ADD R1,R1,#1; R1 =82
    ADD R1,R1,#1; R1 =82
    ADD R1,R1,#1; R1 =82
    ADD R1,R1,#1; R1 =82
    ADD R1,R1,#1; R1 =82
    ADD R1,R1,#1; R1 =82
    ADD R1,R1,#1; R1 =82
    ADD R1,R1,#1; R1 =82
	MUL R7,R5,R2;R7=66
    
    LDR R1,number0; R1 =0
    ADD R1,R1,#1; R1 =0
    ADD R1,R7,R1;
	
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