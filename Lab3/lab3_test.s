	AREA    MYCODE, CODE, READONLY, ALIGN=9
   	  ENTRY
	  
; ------- <code memory (ROM mapped to Instruction Memory) begins>

	LDR R1, constant1; R1=5
	LDR R2, constant2; R2=6
	LDR R3, addr1; 810
	LDR R4, addr2; 820
	LDR R12,addr3; 830
	ADD R5, R1, R2; R5 = a1 + a2;
	LDR R6, number0;

	STR R5, [R3,#-4];
    ADD R3, R3, #12;
    LDR R7, [R3, #-16];

    STR R1, [R6];
    STR R2, [R6, #20];
    STR R3, [R6, #40];
    STR R4, [R6, #80];
	ADD R6, R6, #10;
	ADD R6, R6, #20;
	NOP;
	NOP;
    ;STR R5, [R6];
    ;STR R12, [R6, #1024];
	
	SUB R6, R6, #30;
    LDR R7, [R6];
    LDR R8, [R6, #20];
    LDR R9, [R6, #40];
    LDR R10, [R6, #80];
	NOP;
	NOP;
    ;LDR R11, [R6];
    ;LDR R12, [R6, #1024];



    
	
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