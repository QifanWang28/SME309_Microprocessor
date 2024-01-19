## Clock signal 
##Bank = 35, Pin name = IO_L12P_T1_MRCC_35,					Sch name = CLK100MHZ
set_property PACKAGE_PIN E3 [get_ports CLK_undiv]
set_property IOSTANDARD LVCMOS33 [get_ports CLK_undiv]

## Switches
#Bank = 34, Pin name = IO_L23P_T3_34,						Sch name = SW2
set_property PACKAGE_PIN M13 [get_ports {DIP[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DIP[0]}]
#Bank = 34, Pin name = IO_L19P_T3_34,						Sch name = SW3
set_property PACKAGE_PIN R15 [get_ports {DIP[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DIP[1]}]
#Bank = 34, Pin name = IO_L19N_T3_VREF_34,					Sch name = SW4
set_property PACKAGE_PIN R17 [get_ports {DIP[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DIP[2]}]
#Bank = 34, Pin name = IO_L20P_T3_34,						Sch name = SW5
set_property PACKAGE_PIN T18 [get_ports {DIP[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DIP[3]}]
#Bank = 34, Pin name = IO_L20N_T3_34,						Sch name = SW6
set_property PACKAGE_PIN U18 [get_ports {DIP[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DIP[4]}]
#Bank = 34, Pin name = IO_L10P_T1_34,						Sch name = SW7
set_property PACKAGE_PIN R13 [get_ports {DIP[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DIP[5]}]
#Bank = 34, Pin name = IO_L8P_T1-34,						Sch name = SW8
set_property PACKAGE_PIN T8 [get_ports {DIP[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {DIP[6]}]


## LEDs
#Bank = 34, Pin name = IO_L24N_T3_34,						Sch name = LED0
set_property PACKAGE_PIN H17 [get_ports {LED[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[0]}]
#Bank = 34, Pin name = IO_L21N_T3_DQS_34,					Sch name = LED1
set_property PACKAGE_PIN K15 [get_ports {LED[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[1]}]
#Bank = 34, Pin name = IO_L24P_T3_34,						Sch name = LED2
set_property PACKAGE_PIN J13 [get_ports {LED[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[2]}]
#Bank = 34, Pin name = IO_L23N_T3_34,						Sch name = LED3
set_property PACKAGE_PIN N14 [get_ports {LED[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[3]}]
#Bank = 34, Pin name = IO_L12P_T1_MRCC_34,					Sch name = LED4
set_property PACKAGE_PIN R18 [get_ports {LED[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[4]}]
#Bank = 34, Pin name = IO_L12N_T1_MRCC_34,					Sch	name = LED5
set_property PACKAGE_PIN V17 [get_ports {LED[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[5]}]
#Bank = 34, Pin name = IO_L22P_T3_34,						Sch name = LED6
set_property PACKAGE_PIN U17 [get_ports {LED[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[6]}]
#Bank = 34, Pin name = IO_L22N_T3_34,						Sch name = LED7
set_property PACKAGE_PIN U16 [get_ports {LED[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[7]}]
#Bank = 34, Pin name = IO_L10N_T1_34,						Sch name = LED8
set_property PACKAGE_PIN V16 [get_ports {LED[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[8]}]
#Bank = 34, Pin name = IO_L8N_T1_34,						Sch name = LED9
set_property PACKAGE_PIN T15 [get_ports {LED[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[9]}]
#Bank = 34, Pin name = IO_L7N_T1_34,						Sch name = LED10
set_property PACKAGE_PIN U14 [get_ports {LED[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[10]}]
#Bank = 34, Pin name = IO_L17P_T2_34,						Sch name = LED11
set_property PACKAGE_PIN T16 [get_ports {LED[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[11]}]
#Bank = 34, Pin name = IO_L13N_T2_MRCC_34,					Sch name = LED12
set_property PACKAGE_PIN V15 [get_ports {LED[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[12]}]
#Bank = 34, Pin name = IO_L7P_T1_34,						Sch name = LED13
set_property PACKAGE_PIN V14 [get_ports {LED[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[13]}]
#Bank = 34, Pin name = IO_L15N_T2_DQS_34,					Sch name = LED14
set_property PACKAGE_PIN V12 [get_ports {LED[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[14]}]
#Bank = 34, Pin name = IO_L15P_T2_DQS_34,					Sch name = LED15
set_property PACKAGE_PIN V11 [get_ports {LED[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[15]}]

##7 segment display
#Bank = 34, Pin name = IO_L2N_T0_34,						Sch name = CA
set_property PACKAGE_PIN T10 [get_ports {SevenSegCat[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SevenSegCat[0]}]
#Bank = 34, Pin name = IO_L3N_T0_DQS_34,					Sch name = CB
set_property PACKAGE_PIN R10 [get_ports {SevenSegCat[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SevenSegCat[1]}]
#Bank = 34, Pin name = IO_L6N_T0_VREF_34,					Sch name = CC
set_property PACKAGE_PIN K16 [get_ports {SevenSegCat[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SevenSegCat[2]}]
#Bank = 34, Pin name = IO_L5N_T0_34,						Sch name = CD
set_property PACKAGE_PIN K13 [get_ports {SevenSegCat[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SevenSegCat[3]}]
#Bank = 34, Pin name = IO_L2P_T0_34,						Sch name = CE
set_property PACKAGE_PIN P15 [get_ports {SevenSegCat[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SevenSegCat[4]}]
#Bank = 34, Pin name = IO_L4N_T0_34,						Sch name = CF
set_property PACKAGE_PIN T11 [get_ports {SevenSegCat[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SevenSegCat[5]}]
#Bank = 34, Pin name = IO_L6P_T0_34,						Sch name = CG
set_property PACKAGE_PIN L18 [get_ports {SevenSegCat[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SevenSegCat[6]}]

#Bank = 34, Pin name = IO_L18N_T2_34,						Sch name = AN0
set_property PACKAGE_PIN J17 [get_ports {SevenSegAn[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SevenSegAn[0]}]
#Bank = 34, Pin name = IO_L18P_T2_34,						Sch name = AN1
set_property PACKAGE_PIN J18 [get_ports {SevenSegAn[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SevenSegAn[1]}]
#Bank = 34, Pin name = IO_L4P_T0_34,						Sch name = AN2
set_property PACKAGE_PIN T9 [get_ports {SevenSegAn[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SevenSegAn[2]}]
#Bank = 34, Pin name = IO_L13_T2_MRCC_34,					Sch name = AN3
set_property PACKAGE_PIN J14 [get_ports {SevenSegAn[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SevenSegAn[3]}]
#Bank = 34, Pin name = IO_L3P_T0_DQS_34,					Sch name = AN4
set_property PACKAGE_PIN P14 [get_ports {SevenSegAn[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SevenSegAn[4]}]
#Bank = 34, Pin name = IO_L16N_T2_34,						Sch name = AN5
set_property PACKAGE_PIN T14 [get_ports {SevenSegAn[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SevenSegAn[5]}]
#Bank = 34, Pin name = IO_L1P_T0_34,						Sch name = AN6
set_property PACKAGE_PIN K2 [get_ports {SevenSegAn[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SevenSegAn[6]}]
#Bank = 34, Pin name = IO_L1N_T034,							Sch name = AN7
set_property PACKAGE_PIN U13 [get_ports {SevenSegAn[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SevenSegAn[7]}]



##Buttons
##Bank = 15, Pin name = IO_L14P_T2_SRCC_15,					Sch name = BTNU
set_property PACKAGE_PIN M18 [get_ports {PAUSE}]
set_property IOSTANDARD LVCMOS33 [get_ports {PAUSE}]
#Bank = 14, Pin name = IO_L21P_T3_DQS_14,					Sch name = BTND
set_property PACKAGE_PIN P18 [get_ports {RESET}]
set_property IOSTANDARD LVCMOS33 [get_ports {RESET}]
