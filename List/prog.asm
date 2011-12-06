
;CodeVisionAVR C Compiler V2.03.4 Standard
;(C) Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 11.059200 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : Yes
;char is unsigned       : Yes
;global const stored in FLASH  : No
;8 bit enums            : Yes
;Enhanced core instructions    : On
;Smart register allocation : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ANDI R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ORI  R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __CLRD1S
	LDI  R30,0
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+@1)
	LDI  R31,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	LDI  R22,BYTE3(2*@0+@1)
	LDI  R23,BYTE4(2*@0+@1)
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+@2)
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+@3)
	LDI  R@1,HIGH(@2+@3)
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+@3)
	LDI  R@1,HIGH(@2*2+@3)
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+@1
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+@1
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	LDS  R22,@0+@1+2
	LDS  R23,@0+@1+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+@2
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+@3
	LDS  R@1,@2+@3+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+@1
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	LDS  R24,@0+@1+2
	LDS  R25,@0+@1+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+@1,R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	STS  @0+@1+2,R22
	STS  @0+@1+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+@1,R0
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+@1,R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+@1,R@2
	STS  @0+@1+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __CLRD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _maxh=R5
	.DEF _rychlost_presunu=R4
	.DEF _rychlost_presunu_zrychlene=R7
	.DEF _rychlost_presunu_vzad=R6
	.DEF _prog=R9
	.DEF _smer=R8
	.DEF _x1=R10
	.DEF _rychlost=R13
	.DEF _rychl=R12

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x19C:
	.DB  0xD2,0x0,0xC8,0xD2,0x0,0x0,0x0,0x0
	.DB  0x0,0xC8
_0x0:
	.DB  0x25,0x73,0x0,0x64,0x61,0x74,0x61,0x0
	.DB  0x6B,0x69,0x63,0x6B,0x0,0x4C,0x31,0x65
	.DB  0x64,0x0,0x4C,0x30,0x65,0x64,0x0,0x4C
	.DB  0x45,0x44,0x30,0x0,0x4C,0x45,0x44,0x31
	.DB  0x0,0x73,0x6D,0x65,0x72,0x0,0x72,0x79
	.DB  0x63,0x68,0x0,0x6F,0x62,0x63,0x68,0x0
_0x202005F:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  _0x19C*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x202005F*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x800)
	LDI  R25,HIGH(0x800)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x85F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x85F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x260)
	LDI  R29,HIGH(0x260)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*****************************************************
;Project : Robot_sutaz Istambul
;Version : V1.2
;Date    : 21. 5. 2011
;Author  : Juraj Fojtik
;Company : PrianicSlovakia
;
;Chip type           : ATmega8535
;Program type        : Application
;Clock frequency     : 11,059200 MHz
;Memory model        : Small
;External RAM size   : 0
;Data Stack size     : 128
;*****************************************************/
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;// I2C Bus function
;#asm
   .equ __i2c_port=0x12 ;PORTD
   .equ __sda_bit=3
   .equ __scl_bit=2
; 0000 0016 #endasm
;
;//---------------------------------
;//zmena rychlosti Uart
;//---------------------------------
;void nastav_9600(){
; 0000 001B void nastav_9600(){

	.CSEG
; 0000 001C UCSRA=0x00;
; 0000 001D UCSRB=0x18;
; 0000 001E UCSRC=0x86;
; 0000 001F UBRRH=0x00;
; 0000 0020 UBRRL=0x47;
; 0000 0021 }
;void nastav_115200(){
; 0000 0022 void nastav_115200(){
; 0000 0023 UCSRA=0x00;
; 0000 0024 UCSRB=0x18;
; 0000 0025 UCSRC=0x86;
; 0000 0026 UBRRH=0x00;
; 0000 0027 UBRRL=0x05;
; 0000 0028 }
;//---------------------------------
;//--------------------------------
;// Kniznice
;//--------------------------------
;#include <i2c.h>
;#include <stdio.h>
;#include <stdlib.h>
;#include <delay.h>
;#include <string.h>
;#define ADC_VREF_TYPE 0x60
;#include "library_snimace.c"
;#define Senzor_8 read_adc(3)
;#define Senzor_7 read_adc(2)
;#define Senzor_6 read_adc(1)
;#define Senzor_5 read_adc(0)
;#define Senzor_4 read_adc(4)
;#define Senzor_3 read_adc(5)
;#define Senzor_2 read_adc(6)
;#define Senzor_1 read_adc(7)
;#define Kick_sens   PINB.5                     //kicker senzor
;#define Mot_sens    PINB.6                     //motor prudova ochrana
;
;//---------------------------------
;// Nacitavanie ADC - 8bit
;//---------------------------------
;unsigned char read_adc(unsigned char adc_input)
; 0000 0033 {
_read_adc:
;ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	CALL SUBOPT_0x0
	ORI  R30,LOW(0x60)
	OUT  0x7,R30
;// Delay needed for the stabilization of the ADC input voltage
;delay_us(10);
	__DELAY_USB 37
;// Start the AD conversion
;ADCSRA|=0x40;
	CALL SUBOPT_0x1
	ORI  R30,0x40
	OUT  0x6,R30
;// Wait for the AD conversion to complete
;while ((ADCSRA & 0x10)==0);
_0x3:
	CALL SUBOPT_0x1
	ANDI R30,LOW(0x10)
	BREQ _0x3
;ADCSRA|=0x10;
	CALL SUBOPT_0x1
	ORI  R30,0x10
	OUT  0x6,R30
;return ADCH;
	IN   R30,0x5
	RJMP _0x20A0009
;}
;//senzory lopty
;//------------------------------
;unsigned char maxh;
;unsigned char inrange(unsigned char a, unsigned char b, unsigned char range){
_inrange:
;if (a <= b && b <= (a+range))
;	a -> Y+2
;	b -> Y+1
;	range -> Y+0
	LDD  R30,Y+1
	LDD  R26,Y+2
	CP   R30,R26
	BRLO _0x7
	CLR  R27
	CALL SUBOPT_0x0
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Y+1
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x8
_0x7:
	RJMP _0x6
_0x8:
;    return 1;
	LDI  R30,LOW(1)
	RJMP _0x20A0008
;if (b <= a && a <= (b+range))
_0x6:
	LDD  R30,Y+2
	LDD  R26,Y+1
	CP   R30,R26
	BRLO _0xA
	CLR  R27
	CALL SUBOPT_0x0
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Y+2
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BRGE _0xB
_0xA:
	RJMP _0x9
_0xB:
;    return 1;
	LDI  R30,LOW(1)
	RJMP _0x20A0008
;else
_0x9:
;    return 0;
	LDI  R30,LOW(0)
	RJMP _0x20A0008
;}
;unsigned char maxx(unsigned char maxvid/*maximalna hodnota videnia*/){
_maxx:
;    unsigned char sens = 17;
;    unsigned char s[8];
;    unsigned char rozptyl = 8;
;    maxh = 255;
	SBIW R28,8
	ST   -Y,R17
	ST   -Y,R16
;	maxvid -> Y+10
;	sens -> R17
;	s -> Y+2
;	rozptyl -> R16
	LDI  R17,17
	LDI  R16,8
	LDI  R30,LOW(255)
	MOV  R5,R30
;    s[0] = Senzor_1;
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _read_adc
	STD  Y+2,R30
;    if (s[0] < maxvid ){
	LDD  R30,Y+10
	LDD  R26,Y+2
	CP   R26,R30
	BRSH _0xD
;        if (s[0] <= maxh){
	CP   R5,R26
	BRLO _0xE
;            sens = 1;
	LDI  R17,LOW(1)
;            maxh = s[0];
	LDD  R5,Y+2
;            }
;    }
_0xE:
;    s[1] = Senzor_2;
_0xD:
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL _read_adc
	STD  Y+3,R30
;    if (s[1] < maxvid ){
	LDD  R30,Y+10
	LDD  R26,Y+3
	CP   R26,R30
	BRSH _0xF
;        if (s[1] <= maxh){
	CP   R5,R26
	BRLO _0x10
;            sens = 3;
	LDI  R17,LOW(3)
;            maxh = s[1];
	LDD  R5,Y+3
;            }
;    }
_0x10:
;    s[2] = Senzor_3;
_0xF:
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _read_adc
	STD  Y+4,R30
;    if (s[2] < maxvid ){
	LDD  R30,Y+10
	LDD  R26,Y+4
	CP   R26,R30
	BRSH _0x11
;        if (s[2] < maxh){
	CP   R26,R5
	BRSH _0x12
;            sens = 5;
	LDI  R17,LOW(5)
;            maxh = s[2];
	LDD  R5,Y+4
;            }
;    }
_0x12:
;    s[3] = Senzor_4;
_0x11:
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL _read_adc
	STD  Y+5,R30
;    if (s[3] < maxvid ){
	LDD  R30,Y+10
	LDD  R26,Y+5
	CP   R26,R30
	BRSH _0x13
;        if (s[3] <= maxh){
	CP   R5,R26
	BRLO _0x14
;            sens = 7;
	LDI  R17,LOW(7)
;            maxh = s[3];
	LDD  R5,Y+5
;            }
;    }
_0x14:
;    s[4] = Senzor_5;
_0x13:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _read_adc
	STD  Y+6,R30
;    if (s[4] < maxvid ){
	LDD  R30,Y+10
	LDD  R26,Y+6
	CP   R26,R30
	BRSH _0x15
;        if (s[4] <= maxh){
	CP   R5,R26
	BRLO _0x16
;            sens = 9;
	LDI  R17,LOW(9)
;            maxh = s[4];
	LDD  R5,Y+6
;            }
;    }
_0x16:
;    s[5] = Senzor_6;
_0x15:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _read_adc
	STD  Y+7,R30
;    if (s[5] < maxvid ){
	LDD  R30,Y+10
	LDD  R26,Y+7
	CP   R26,R30
	BRSH _0x17
;        if (s[5] <= maxh){
	CP   R5,R26
	BRLO _0x18
;            sens = 11;
	LDI  R17,LOW(11)
;            maxh = s[5];
	LDD  R5,Y+7
;            }
;    }
_0x18:
;    s[6] = Senzor_7;
_0x17:
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _read_adc
	STD  Y+8,R30
;    if (s[6] < maxvid ){
	LDD  R30,Y+10
	LDD  R26,Y+8
	CP   R26,R30
	BRSH _0x19
;        if (s[6] <= maxh){
	CP   R5,R26
	BRLO _0x1A
;            sens = 13;
	LDI  R17,LOW(13)
;            maxh = s[6];
	LDD  R5,Y+8
;            }
;    }
_0x1A:
;    s[7] = Senzor_8;
_0x19:
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _read_adc
	STD  Y+9,R30
;    if (s[7] < maxvid ){
	LDD  R30,Y+10
	LDD  R26,Y+9
	CP   R26,R30
	BRSH _0x1B
;        if (s[7] <= maxh){
	CP   R5,R26
	BRLO _0x1C
;            sens = 15;
	LDI  R17,LOW(15)
;            maxh = s[7];
	LDD  R5,Y+9
;            }
;    }
_0x1C:
;    if (sens == 1){
_0x1B:
	CPI  R17,1
	BRNE _0x1D
;        if (inrange(s[0],s[1],rozptyl) == 1)
	CALL SUBOPT_0x2
	BRNE _0x1E
;            sens = 2;
	LDI  R17,LOW(2)
;        else if(inrange(s[7],s[0],rozptyl) == 1)
	RJMP _0x1F
_0x1E:
	CALL SUBOPT_0x3
	BRNE _0x20
;            sens = 16;
	LDI  R17,LOW(16)
;            }
_0x20:
_0x1F:
;    else if (sens == 3){
	RJMP _0x21
_0x1D:
	CPI  R17,3
	BRNE _0x22
;        if (inrange(s[1],s[2],rozptyl) == 1)
	CALL SUBOPT_0x4
	BRNE _0x23
;            sens = 4;
	LDI  R17,LOW(4)
;        else if(inrange(s[0],s[1],rozptyl) == 1)
	RJMP _0x24
_0x23:
	CALL SUBOPT_0x2
	BRNE _0x25
;            sens = 2;
	LDI  R17,LOW(2)
;            }
_0x25:
_0x24:
;    else if (sens == 5){
	RJMP _0x26
_0x22:
	CPI  R17,5
	BRNE _0x27
;        if (inrange(s[2],s[3],rozptyl) == 1)
	CALL SUBOPT_0x5
	BRNE _0x28
;            sens = 6;
	LDI  R17,LOW(6)
;        else if(inrange(s[1],s[2],rozptyl) == 1)
	RJMP _0x29
_0x28:
	CALL SUBOPT_0x4
	BRNE _0x2A
;            sens = 4;
	LDI  R17,LOW(4)
;            }
_0x2A:
_0x29:
;    else if (sens == 7){
	RJMP _0x2B
_0x27:
	CPI  R17,7
	BRNE _0x2C
;        if (inrange(s[3],s[4],rozptyl) == 1)
	CALL SUBOPT_0x6
	BRNE _0x2D
;            sens = 8;
	LDI  R17,LOW(8)
;        else if(inrange(s[2],s[3],rozptyl) == 1)
	RJMP _0x2E
_0x2D:
	CALL SUBOPT_0x5
	BRNE _0x2F
;            sens = 6;
	LDI  R17,LOW(6)
;            }
_0x2F:
_0x2E:
;    else if (sens == 9){
	RJMP _0x30
_0x2C:
	CPI  R17,9
	BRNE _0x31
;        if (inrange(s[4],s[5],rozptyl) == 1)
	CALL SUBOPT_0x7
	BRNE _0x32
;            sens = 10;
	LDI  R17,LOW(10)
;        else if(inrange(s[3],s[4],rozptyl) == 1)
	RJMP _0x33
_0x32:
	CALL SUBOPT_0x6
	BRNE _0x34
;            sens = 8;
	LDI  R17,LOW(8)
;            }
_0x34:
_0x33:
;    else if (sens == 11){
	RJMP _0x35
_0x31:
	CPI  R17,11
	BRNE _0x36
;        if (inrange(s[5],s[6],rozptyl) == 1)
	CALL SUBOPT_0x8
	BRNE _0x37
;            sens = 12;
	LDI  R17,LOW(12)
;        else if(inrange(s[4],s[5],rozptyl) == 1)
	RJMP _0x38
_0x37:
	CALL SUBOPT_0x7
	BRNE _0x39
;            sens = 10;
	LDI  R17,LOW(10)
;            }
_0x39:
_0x38:
;    else if (sens == 13){
	RJMP _0x3A
_0x36:
	CPI  R17,13
	BRNE _0x3B
;        if (inrange(s[6],s[7],rozptyl) == 1)
	CALL SUBOPT_0x9
	BRNE _0x3C
;            sens = 14;
	LDI  R17,LOW(14)
;        else if(inrange(s[5],s[6],rozptyl) == 1)
	RJMP _0x3D
_0x3C:
	CALL SUBOPT_0x8
	BRNE _0x3E
;            sens = 12;
	LDI  R17,LOW(12)
;            }
_0x3E:
_0x3D:
;    else if (sens == 15){
	RJMP _0x3F
_0x3B:
	CPI  R17,15
	BRNE _0x40
;        if (inrange(s[7],s[0],rozptyl) == 1)
	CALL SUBOPT_0x3
	BRNE _0x41
;            sens = 16;
	LDI  R17,LOW(16)
;        else if(inrange(s[6],s[7],rozptyl) == 1)
	RJMP _0x42
_0x41:
	CALL SUBOPT_0x9
	BRNE _0x43
;            sens = 14;
	LDI  R17,LOW(14)
;            }
_0x43:
_0x42:
;return sens;
_0x40:
_0x3F:
_0x3A:
_0x35:
_0x30:
_0x2B:
_0x26:
_0x21:
	MOV  R30,R17
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,11
	RET
;}
;//kompas
;//------------------------------
;unsigned char compass_2(){
;    unsigned char value;
;    i2c_start();
;	value -> R17
;    i2c_write(0xC0);
;    i2c_write(1);
;    i2c_start();
;    i2c_write(0xC1);
;    value = i2c_read(0);
;    i2c_stop();
;    return value;
;}
;//------------------------------
;void cmps03_scanmode(unsigned char mode){
_cmps03_scanmode:
;        i2c_start();
;	mode -> Y+0
	CALL SUBOPT_0xA
;        i2c_write(0xC0);
;        i2c_write(0x12);
;        i2c_write(0x55);
;        i2c_write(0x5A);
;        i2c_write(0xA5);
;        i2c_write(0x09 + mode);
	CALL SUBOPT_0x0
	ADIW R30,9
	ST   -Y,R30
	CALL _i2c_write
;        i2c_stop();
	CALL _i2c_stop
;}
_0x20A0009:
	ADIW R28,1
	RET
;void cmps03_reset(void){
_cmps03_reset:
;        i2c_start();
	CALL SUBOPT_0xA
;        i2c_write(0xC0);
;        i2c_write(0x12);
;        i2c_write(0x55);
;        i2c_write(0x5A);
;        i2c_write(0xA5);
;        i2c_write(0xF2);
	LDI  R30,LOW(242)
	ST   -Y,R30
	CALL _i2c_write
;        i2c_stop();
	CALL _i2c_stop
;}
	RET
;int cmps03_read(unsigned char mode){
_cmps03_read:
;    unsigned char a,b;
;    if (mode==1){
	CALL SUBOPT_0xB
;	mode -> Y+2
;	a -> R17
;	b -> R16
	BRNE _0x44
;        i2c_start();
	CALL SUBOPT_0xC
;        i2c_write(0xC0);
;        i2c_write(0x01);
	LDI  R30,LOW(1)
	CALL SUBOPT_0xD
;        i2c_start();
;        i2c_write(0xC1);
;        a = i2c_read(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _i2c_read
	MOV  R17,R30
;        i2c_stop();
	CALL _i2c_stop
;        return a;
	MOV  R30,R17
	LDI  R31,0
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20A0008:
	ADIW R28,3
	RET
;    }
;    else if(mode==2){
_0x44:
	LDD  R26,Y+2
	CPI  R26,LOW(0x2)
	BRNE _0x46
;        i2c_start();
	CALL SUBOPT_0xC
;        i2c_write(0xC0);
;        i2c_write(0x02);
	LDI  R30,LOW(2)
	CALL SUBOPT_0xD
;        i2c_start();
;        i2c_write(0xC1);
;        a = i2c_read(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _i2c_read
	MOV  R17,R30
;        b = i2c_read(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _i2c_read
	MOV  R16,R30
;        i2c_stop();
	CALL _i2c_stop
;        return (a * 256 + b);
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(256)
	LDI  R31,HIGH(256)
	CALL __MULW12
	MOVW R26,R30
	MOV  R30,R16
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x20A0004
;    }
;    else{
_0x46:
;        return -1;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x20A0004
;    }
;}
;int prepocetcompasu(int stupen, unsigned char mode){
_prepocetcompasu:
;    int prepocet;
;    if (mode == 1){
	CALL SUBOPT_0xB
;	stupen -> Y+3
;	mode -> Y+2
;	prepocet -> R16,R17
	BRNE _0x48
;        prepocet = cmps03_read(1) - stupen;
	LDI  R30,LOW(1)
	CALL SUBOPT_0xE
;        if (prepocet >= 255){
	__CPWRN 16,17,255
	BRLT _0x49
;            prepocet = prepocet - 255;
	__SUBWRN 16,17,255
;        }
;        if (prepocet < 0){
_0x49:
	TST  R17
	BRPL _0x4A
;            prepocet = prepocet + 255;
	__ADDWRN 16,17,255
;        }
;    }
_0x4A:
;    else {
	RJMP _0x4B
_0x48:
;        prepocet = cmps03_read(2) - stupen;
	LDI  R30,LOW(2)
	CALL SUBOPT_0xE
;        if (prepocet > 3599){
	__CPWRN 16,17,3600
	BRLT _0x4C
;            prepocet = prepocet - 3599;
	__SUBWRN 16,17,3599
;        }
;        if (prepocet < 0){
_0x4C:
	TST  R17
	BRPL _0x4D
;            prepocet = prepocet + 3599;
	__ADDWRN 16,17,3599
;        }
;    }
_0x4D:
_0x4B:
;
;
;    return prepocet;
	MOVW R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x20A0003
;}
;//------------------------------
;//Ultrazvuky
;//------------------------------
;int ult_lavy()
;{
;   char ulth[3];
;   int vysl;
;   nastav_9600();
;	ulth -> Y+2
;	vysl -> R16,R17
;    PORTC.5 = 1 ;
;    delay_ms(10);
;    while(getchar() != 0x52);
;    ulth[0] = getchar();
;    ulth[1] = getchar();
;    ulth[2] = getchar();
;    PORTC.5 = 0 ;
;    vysl = atoi(ulth);
;          nastav_115200();
;    delay_ms(5);
;    return vysl;
;}
;int ult_zadny()
;{
;   char ulth[3];
;   int vysl;
;   nastav_9600();
;	ulth -> Y+2
;	vysl -> R16,R17
;   PORTC.7 = 1 ;
;   delay_ms(10);
;    while(getchar() != 0x52);
;    ulth[0] = getchar();
;    ulth[1] = getchar();
;    ulth[2] = getchar();
;    PORTC.7 = 0 ;
;    vysl = atoi(ulth);
;          nastav_115200();
;    delay_ms(5);
;    return vysl;
;}
;//------------------------------
;#include "protocol.c"
;#include <string.h>
;
;#define byte_for_dat 1        //2 na bit_for_dat = pocet dat ktore sa daju prenpiest
;#define byte_for_char 1        //2 na bit_for_char = pocet znakov v jednotlivych datach
;#define char_for_array 10    //pocet znakov pre pole
;
;//funkcia zakoduje data do klastroveho protokolu, data_vystup = tu su zakodovane data, data_vstup=je to
;//vstup vo forme multiarray, size = velkost pola
;int zakoduj(char data_vystup[],char data_vstup[][char_for_array],int size){
; 0000 0034 int zakoduj(char data_vystup[],char data_vstup[][10    ],int size){
;    int posun = 0;
;    int i=0;
;    int z=0;
;//urcuje pocet dat-----------------------
;    data_vystup[posun] = size&0xFF;
;	data_vystup -> Y+10
;	data_vstup -> Y+8
;	size -> Y+6
;	posun -> R16,R17
;	i -> R18,R19
;	z -> R20,R21
;    posun++;
;//----------------------------------------
;    for(i=0;i < size;i++){
;//pocet znakov v nasledujucom data------------------
;        data_vystup[posun] = strlen(data_vstup[i])&0xFF;
;        posun++;
;//vkladanie data do znakov--------------------------
;        for(z=0;z< strlen(data_vstup[i]);z++){
;            data_vystup[posun] = data_vstup[i][z];    //vlozi hodnotu znaku
;            posun++;
;        }
;//--------------------------------------------------
;    }
;}
;//data_vystup je multiarray = vystupne rozkodovane data
;//data_vstup je char = zakodovane data v klastrovom protokole
;int dekoduj(char data_vystup[][char_for_array],char data_vstup[]){
_dekoduj:
;    int posun=0;
;    int size=0;
;    int poc_znakov=0;
;    int i=0;
;    int z=0;
;//nacita pocet dat--------------------
;    size=data_vstup[posun];
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	CALL __SAVELOCR6
;	data_vystup -> Y+12
;	data_vstup -> Y+10
;	posun -> R16,R17
;	size -> R18,R19
;	poc_znakov -> R20,R21
;	i -> Y+8
;	z -> Y+6
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	CALL SUBOPT_0xF
	LD   R18,X
	CLR  R19
;    posun++;
	__ADDWRN 16,17,1
;//------------------------------------
;    for(i=0;i < size;i++){
	LDI  R30,0
	STD  Y+8,R30
	STD  Y+8+1,R30
_0x63:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CP   R26,R18
	CPC  R27,R19
	BRGE _0x64
;//------------------------------------
;        poc_znakov=data_vstup[posun];
	CALL SUBOPT_0xF
	LD   R20,X
	CLR  R21
;        posun++;
	__ADDWRN 16,17,1
;//prijma znaky----------------------
;        for(z=0;z< poc_znakov;z++){
	LDI  R30,0
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x66:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CP   R26,R20
	CPC  R27,R21
	BRGE _0x67
;            data_vystup[i][z] = data_vstup[posun];
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	__GETWRS 22,23,12
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12U
	ADD  R30,R22
	ADC  R31,R23
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	CALL SUBOPT_0xF
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
;            posun++;
	__ADDWRN 16,17,1
;        }
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x66
_0x67:
;//------------------------------------------
;    }
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RJMP _0x63
_0x64:
;}
	CALL __LOADLOCR6
	RJMP _0x20A0006
;void odosli_data_beagle(char data[][char_for_array],int pocet_dat){
;    char buffer[128];
;    zakoduj(buffer,data,pocet_dat);
;	data -> Y+130
;	pocet_dat -> Y+128
;	buffer -> Y+0
;    puts(buffer);
;}
;char datax[5][char_for_array];
;void prijem_dat(){
_prijem_dat:
;//---------------------------
;    char str[128];
;    scanf ("%s",str);
	SBIW R28,63
	SBIW R28,63
	SBIW R28,2
;	str -> Y+0
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,2
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _scanf
	ADIW R28,6
;    dekoduj(datax,str);
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
	RCALL _dekoduj
;}
	ADIW R28,63
	ADIW R28,63
	ADIW R28,2
	RET
;//------------------------------
;//------------------------------
;#include "library_motor.c"
;//kniznice pre riadeie motorov
;//---------------------------------
;void motor1(int rychlost ){
; 0000 0035 void motor1(int rychlost ){
_motor1:
;    if (rychlost > 0){
;	rychlost -> Y+0
	CALL SUBOPT_0x12
	BRGE _0x68
;        PORTC.3 = 1;
	SBI  0x15,3
;        PORTC.4 = 0;
	CBI  0x15,4
;    }
;    else if(rychlost == 0){
	RJMP _0x6D
_0x68:
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BRNE _0x6E
;        PORTC.3 = 0;
	CBI  0x15,3
;        PORTC.4 = 0;
	CBI  0x15,4
;    }
;    else{
	RJMP _0x73
_0x6E:
;        PORTC.3 = 0;
	CBI  0x15,3
;        PORTC.4 = 1;
	SBI  0x15,4
;        rychlost = rychlost*(-1);
	CALL SUBOPT_0x13
;    }
_0x73:
_0x6D:
;    OCR1B = rychlost;
	LD   R30,Y
	LDD  R31,Y+1
	OUT  0x28+1,R31
	OUT  0x28,R30
;}
	RJMP _0x20A0007
;void motor3(int rychlost){
_motor3:
;    if (rychlost > 0){
;	rychlost -> Y+0
	CALL SUBOPT_0x12
	BRGE _0x78
;        PORTC.2 = 0;
	CBI  0x15,2
;        PORTD.6 = 1;
	SBI  0x12,6
;    }
;    else if(rychlost == 0){
	RJMP _0x7D
_0x78:
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BRNE _0x7E
;        PORTC.2 = 0;
	CBI  0x15,2
;        PORTD.6 = 0;
	CBI  0x12,6
;    }
;    else{
	RJMP _0x83
_0x7E:
;        PORTC.2 = 1;
	SBI  0x15,2
;        PORTD.6 = 0;
	CBI  0x12,6
;        rychlost = rychlost*(-1);
	CALL SUBOPT_0x13
;    }
_0x83:
_0x7D:
;    OCR1A = rychlost;
	LD   R30,Y
	LDD  R31,Y+1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
;}
	RJMP _0x20A0007
;void motor2(int rychlost){
_motor2:
;    if (rychlost > 0){
;	rychlost -> Y+0
	CALL SUBOPT_0x12
	BRGE _0x88
;        PORTC.1 = 1;
	SBI  0x15,1
;        PORTC.0 = 0;
	CBI  0x15,0
;    }
;    else if(rychlost == 0){
	RJMP _0x8D
_0x88:
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BRNE _0x8E
;        PORTC.1 = 0;
	CBI  0x15,1
;        PORTC.0 = 0;
	CBI  0x15,0
;    }
;    else{
	RJMP _0x93
_0x8E:
;        PORTC.1 = 0;
	CBI  0x15,1
;        PORTC.0 = 1;
	SBI  0x15,0
;        rychlost = rychlost*(-1);
	CALL SUBOPT_0x13
;    }
_0x93:
_0x8D:
;    OCR2 = rychlost;
	LD   R30,Y
	LDD  R31,Y+1
	OUT  0x23,R30
;}
	RJMP _0x20A0007
;void motor4(int rychlost){
_motor4:
;    if (rychlost > 0){
;	rychlost -> Y+0
	CALL SUBOPT_0x12
	BRGE _0x98
;        PORTB.1 = 0;
	CBI  0x18,1
;        PORTB.2 = 1;
	SBI  0x18,2
;    }
;    else if(rychlost == 0){
	RJMP _0x9D
_0x98:
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BRNE _0x9E
;        PORTB.1 = 0;
	CBI  0x18,1
;        PORTB.2 = 0;
	CBI  0x18,2
;    }
;    else{
	RJMP _0xA3
_0x9E:
;        PORTB.1 = 1;
	SBI  0x18,1
;        PORTB.2 = 0;
	CBI  0x18,2
;        rychlost = rychlost*(-1);
	CALL SUBOPT_0x13
;    }
_0xA3:
_0x9D:
;    OCR0 = rychlost;
	LD   R30,Y
	LDD  R31,Y+1
	OUT  0x3C,R30
;}
	RJMP _0x20A0007
;void m_0(unsigned char rychlost){
_m_0:
;motor1(-rychlost);
;	rychlost -> Y+0
	CALL SUBOPT_0x0
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
;motor2(-rychlost);
	CALL SUBOPT_0x14
	CALL SUBOPT_0x16
;motor3(rychlost);
	CALL SUBOPT_0x17
;motor4(rychlost);
	CALL SUBOPT_0x18
;}
	JMP  _0x20A0005
;void m_45(unsigned char rychlost){
_m_45:
;motor1(0);
;	rychlost -> Y+0
	CALL SUBOPT_0x19
	CALL SUBOPT_0x15
;motor2(-rychlost);
	CALL SUBOPT_0x14
	CALL SUBOPT_0x1A
;motor3(0);
;motor4(rychlost);
	CALL SUBOPT_0x18
;}
	JMP  _0x20A0005
;void m_90(unsigned char rychlost){
_m_90:
;motor1(rychlost);
;	rychlost -> Y+0
	CALL SUBOPT_0x0
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x15
;motor2(-rychlost);
	CALL SUBOPT_0x14
	CALL SUBOPT_0x16
;motor3(-rychlost);
	CALL SUBOPT_0x14
	RCALL _motor3
;motor4(rychlost);
	CALL SUBOPT_0x0
	CALL SUBOPT_0x18
;}
	JMP  _0x20A0005
;void m_135(unsigned char rychlost){
_m_135:
;motor1(rychlost);
;	rychlost -> Y+0
	CALL SUBOPT_0x0
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1B
;motor2(0);
	CALL SUBOPT_0x16
;motor3(-rychlost);
	CALL SUBOPT_0x14
	CALL SUBOPT_0x1C
;motor4(0);
;}
	JMP  _0x20A0005
;void m_180(unsigned char rychlost){
_m_180:
;motor1(rychlost);
;	rychlost -> Y+0
	CALL SUBOPT_0x0
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x15
;motor2(rychlost);
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x16
;motor3(-rychlost);
	CALL SUBOPT_0x14
	RCALL _motor3
;motor4(-rychlost);
	CALL SUBOPT_0x0
	CALL SUBOPT_0x14
	RCALL _motor4
;}
	JMP  _0x20A0005
;void m_225(unsigned char rychlost){
_m_225:
;motor1(0);
;	rychlost -> Y+0
	CALL SUBOPT_0x19
	CALL SUBOPT_0x15
;motor2(rychlost);
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1A
;motor3(0);
;motor4(-rychlost);
	CALL SUBOPT_0x14
	RCALL _motor4
;}
	JMP  _0x20A0005
;void m_270(unsigned char rychlost){
_m_270:
;motor1(-rychlost);
;	rychlost -> Y+0
	CALL SUBOPT_0x0
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
;motor2(rychlost);
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x16
;motor3(rychlost);
	CALL SUBOPT_0x17
;motor4(-rychlost);
	CALL SUBOPT_0x14
	RCALL _motor4
;}
	JMP  _0x20A0005
;void m_315(unsigned char rychlost){
_m_315:
;motor1(-rychlost);
;	rychlost -> Y+0
	CALL SUBOPT_0x0
	CALL SUBOPT_0x14
	CALL SUBOPT_0x1B
;motor2(0);
	CALL SUBOPT_0x16
;motor3(rychlost);
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1C
;motor4(0);
;}
	JMP  _0x20A0005
;void m_ot(int rychlost){
_m_ot:
;motor1(rychlost);
;	rychlost -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _motor1
;motor2(rychlost/3);
	CALL SUBOPT_0x1D
	RCALL _motor2
;motor3(rychlost/3);
	CALL SUBOPT_0x1D
	RCALL _motor3
;motor4(rychlost);
	LD   R30,Y
	LDD  R31,Y+1
	CALL SUBOPT_0x18
;}
	RJMP _0x20A0007
;void m_vyp(){
_m_vyp:
;motor1(0);
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1B
;motor2(0);
	RCALL _motor2
;motor3(0);
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1C
;motor4(0);
;}
	RET
;//------------------------------
;//--------------------------------
;//Definovanie
;//--------------------------------
;#define LED         PORTB.4
;#define Kick        PORTB.0                    //kicker riadeni
;//---------------------------------
;// Premenne
;//---------------------------------
;eeprom int branka=0;
;unsigned char rychlost_presunu = 210;
;unsigned char rychlost_presunu_zrychlene = 210;
;unsigned char rychlost_presunu_vzad = 200;
;unsigned char prog=0;
;unsigned char smer=0;
;unsigned int x1;
;unsigned char rychlost=200;
;unsigned char rychl;
;eeprom char on = 0;
;//---------------------------------
;//inicializacia procesoru
;//---------------------------------
;void init_8535(){
; 0000 004B void init_8535(){
_init_8535:
; 0000 004C // Input/Output Ports initialization
; 0000 004D // Port A initialization
; 0000 004E // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 004F // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0050 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0051 DDRA=0x00;
	OUT  0x1A,R30
; 0000 0052 
; 0000 0053 // Port B initialization
; 0000 0054 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0055 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0056 PORTB=0x20;
	LDI  R30,LOW(32)
	OUT  0x18,R30
; 0000 0057 DDRB=0x1F;
	LDI  R30,LOW(31)
	OUT  0x17,R30
; 0000 0058 
; 0000 0059 // Port C initialization
; 0000 005A // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 005B // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 005C PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 005D DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 005E 
; 0000 005F // Port D initialization
; 0000 0060 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 0061 // State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=T
; 0000 0062 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0063 DDRD=0xF0;
	LDI  R30,LOW(240)
	OUT  0x11,R30
; 0000 0064 
; 0000 0065 // Timer/Counter 0 initialization
; 0000 0066 // Clock source: System Clock
; 0000 0067 // Clock value: 1382,400 kHz
; 0000 0068 // Mode: Fast PWM top=FFh
; 0000 0069 // OC0 output: Non-Inverted PWM
; 0000 006A TCCR0=0x6A;
	LDI  R30,LOW(106)
	OUT  0x33,R30
; 0000 006B TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 006C OCR0=0x00;
	OUT  0x3C,R30
; 0000 006D 
; 0000 006E // Timer/Counter 1 initialization
; 0000 006F // Clock source: System Clock
; 0000 0070 // Clock value: 1382,400 kHz
; 0000 0071 // Mode: Fast PWM top=00FFh
; 0000 0072 // OC1A output: Non-Inv.
; 0000 0073 // OC1B output: Non-Inv.
; 0000 0074 // Noise Canceler: Off
; 0000 0075 // Input Capture on Falling Edge
; 0000 0076 // Timer 1 Overflow Interrupt: Off
; 0000 0077 // Input Capture Interrupt: Off
; 0000 0078 // Compare A Match Interrupt: Off
; 0000 0079 // Compare B Match Interrupt: Off
; 0000 007A TCCR1A=0xA1;
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0000 007B TCCR1B=0x0A;
	LDI  R30,LOW(10)
	OUT  0x2E,R30
; 0000 007C TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 007D TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 007E ICR1H=0x00;
	OUT  0x27,R30
; 0000 007F ICR1L=0x00;
	OUT  0x26,R30
; 0000 0080 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0081 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0082 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0083 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0084 
; 0000 0085 // Timer/Counter 2 initialization
; 0000 0086 // Clock source: System Clock
; 0000 0087 // Clock value: 1382,400 kHz
; 0000 0088 // Mode: Fast PWM top=FFh
; 0000 0089 // OC2 output: Non-Inverted PWM
; 0000 008A ASSR=0x00;
	OUT  0x22,R30
; 0000 008B TCCR2=0x6A;
	LDI  R30,LOW(106)
	OUT  0x25,R30
; 0000 008C TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 008D OCR2=0x00;
	OUT  0x23,R30
; 0000 008E 
; 0000 008F // External Interrupt(s) initialization
; 0000 0090 // INT0: Off
; 0000 0091 // INT1: Off
; 0000 0092 // INT2: Off
; 0000 0093 MCUCR=0x00;
	OUT  0x35,R30
; 0000 0094 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 0095 
; 0000 0096 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0097 TIMSK=0x00;
	OUT  0x39,R30
; 0000 0098 
; 0000 0099 // USART initialization
; 0000 009A // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 009B // USART Receiver: On
; 0000 009C // USART Transmitter: On
; 0000 009D // USART Mode: Asynchronous
; 0000 009E // USART Baud Rate: 115200
; 0000 009F UCSRA=0x00;
	OUT  0xB,R30
; 0000 00A0 UCSRB=0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 00A1 UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 00A2 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 00A3 UBRRL=0x05;
	LDI  R30,LOW(5)
	OUT  0x9,R30
; 0000 00A4 
; 0000 00A5 // Analog Comparator initialization
; 0000 00A6 // Analog Comparator: Off
; 0000 00A7 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00A8 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00A9 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00AA 
; 0000 00AB // ADC initialization
; 0000 00AC // ADC Clock frequency: 691,200 kHz
; 0000 00AD // ADC Voltage Reference: AVCC pin
; 0000 00AE // ADC High Speed Mode: On
; 0000 00AF // ADC Auto Trigger Source: None
; 0000 00B0 // Only the 8 most significant bits of
; 0000 00B1 // the AD conversion result are used
; 0000 00B2 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(96)
	OUT  0x7,R30
; 0000 00B3 ADCSRA=0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 00B4 SFIOR&=0xEF;
	IN   R30,0x30
	LDI  R31,0
	ANDI R30,LOW(0xEF)
	ANDI R31,HIGH(0xEF)
	OUT  0x30,R30
; 0000 00B5 SFIOR|=0x10;
	IN   R30,0x30
	LDI  R31,0
	ORI  R30,0x10
	OUT  0x30,R30
; 0000 00B6 
; 0000 00B7 // I2C Bus initialization
; 0000 00B8 i2c_init();
	CALL _i2c_init
; 0000 00B9 }
	RET
;//---------------------------------
;//------------------------------
;//kicker
;//------------------------------
;void kick(){
; 0000 00BE void kick(){
; 0000 00BF int senzory;
; 0000 00C0 if (Kick_sens == 0){
;	senzory -> R16,R17
; 0000 00C1     m_vyp();
; 0000 00C2     Kick = 1;
; 0000 00C3     LED = 0;
; 0000 00C4     delay_ms(200);
; 0000 00C5     while (Kick_sens == 0);
; 0000 00C6     Kick = 0;
; 0000 00C7     LED = 1;
; 0000 00C8     x1 = 400;
; 0000 00C9     while(x1 != 0 ){
; 0000 00CA         senzory = maxx(200);
; 0000 00CB         if (maxh < 75){
; 0000 00CC         switch (senzory){
; 0000 00CD             case 1: m_0(rychlost_presunu);          break;
; 0000 00CE     //---------------------------------------------------------------------
; 0000 00CF             case 2: m_90(rychlost_presunu);              break;
; 0000 00D0             case 3: m_135(rychlost_presunu);                 break;
; 0000 00D1             case 4: m_135(rychlost_presunu);                 break;
; 0000 00D2             case 5: m_180(rychlost_presunu);                 break;  //stvrtina z kruhu
; 0000 00D3     //---------------------------------------------------------------------
; 0000 00D4             case 6: m_225(rychlost_presunu);                 break;
; 0000 00D5             case 7: m_225(rychlost_presunu);                break;
; 0000 00D6             case 8: m_270(rychlost_presunu);                 break;
; 0000 00D7             case 9: m_270(rychlost_presunu);                 break;  //polovica kruhu
; 0000 00D8     //----------------------------------------------------------------------
; 0000 00D9             case 10: m_90(rychlost_presunu);               break;
; 0000 00DA             case 11: m_135(rychlost_presunu);                break;
; 0000 00DB             case 12: m_135(rychlost_presunu);                break;
; 0000 00DC             case 13: m_180(rychlost_presunu);                 break;  //tretina kruhu
; 0000 00DD     //----------------------------------------------------------------------
; 0000 00DE             case 14: m_225(rychlost_presunu);                break;
; 0000 00DF             case 15: m_225(rychlost_presunu);                break;
; 0000 00E0             case 16: m_270(rychlost_presunu);             break;  //cely kruh
; 0000 00E1     //----------------------------------------------------------------------
; 0000 00E2             case 17: m_vyp();                                break;
; 0000 00E3         }
; 0000 00E4     }
; 0000 00E5         else{
; 0000 00E6        switch (senzory){
; 0000 00E7             case 1: m_0(rychlost_presunu);        break;
; 0000 00E8     //---------------------------------------------------------------------
; 0000 00E9             case 2: m_90(rychlost_presunu);              break;
; 0000 00EA             case 3: m_90(rychlost_presunu);                 break;
; 0000 00EB             case 4: m_90(rychlost_presunu);                 break;
; 0000 00EC             case 5: m_90(rychlost_presunu);                 break;  //stvrtina z kruhu
; 0000 00ED     //---------------------------------------------------------------------
; 0000 00EE             case 6: m_135(rychlost_presunu);                 break;
; 0000 00EF             case 7: m_135(rychlost_presunu);                break;
; 0000 00F0             case 8: m_135(rychlost_presunu);                 break;
; 0000 00F1             case 9: m_180(rychlost_presunu);                 break;  //polovica kruhu
; 0000 00F2     //----------------------------------------------------------------------
; 0000 00F3             case 10: m_225(rychlost_presunu);               break;
; 0000 00F4             case 11: m_225(rychlost_presunu);                break;
; 0000 00F5             case 12: m_225(rychlost_presunu);                break;
; 0000 00F6             case 13: m_270(rychlost_presunu);                 break;  //tretina kruhu
; 0000 00F7     //----------------------------------------------------------------------
; 0000 00F8             case 14: m_315(rychlost_presunu);                break;
; 0000 00F9             case 15: m_315(rychlost_presunu);                break;
; 0000 00FA             case 16: m_315(rychlost_presunu);             break;  //cely kruh
; 0000 00FB     //----------------------------------------------------------------------
; 0000 00FC             case 17: m_vyp();                                break;
; 0000 00FD         }
; 0000 00FE     }
; 0000 00FF         x1=x1-1;
; 0000 0100         delay_ms(2);
; 0000 0101         }
; 0000 0102     }
; 0000 0103 else{
; 0000 0104     Kick = 0;
; 0000 0105 }
; 0000 0106 }
;void kick_no(){
; 0000 0107 void kick_no(){
_kick_no:
; 0000 0108     Kick = 1;
	SBI  0x18,0
; 0000 0109     LED = 0;
	CBI  0x18,4
; 0000 010A     delay_ms(200);
	CALL SUBOPT_0x1E
; 0000 010B     while (Kick_sens == 0);
_0xE8:
	SBIS 0x16,5
	RJMP _0xE8
; 0000 010C     Kick = 0;
	CBI  0x18,0
; 0000 010D     LED = 1;
	SBI  0x18,4
; 0000 010E }
	RET
;//------------------------------
;//------------------------------
;int nastav_podla_kompasu(int kompas){             //prepocetcompasu(branka,1)*0.71
; 0000 0111 int nastav_podla_kompasu(int kompas){
_nastav_podla_kompasu:
; 0000 0112     int komp_ret = 0;
; 0000 0113     if (kompas > 180)
	ST   -Y,R17
	ST   -Y,R16
;	kompas -> Y+2
;	komp_ret -> R16,R17
	__GETWRN 16,17,0
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0xB5)
	LDI  R30,HIGH(0xB5)
	CPC  R27,R30
	BRLT _0xEF
; 0000 0114         kompas = 180;
	LDI  R30,LOW(180)
	LDI  R31,HIGH(180)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 0115     //prepocet rychlost kolies pre kompas------------------
; 0000 0116     if (kompas < 90){
_0xEF:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0x5A)
	LDI  R30,HIGH(0x5A)
	CPC  R27,R30
	BRGE _0xF0
; 0000 0117         rychl = kompas + 100;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	RJMP _0x196
; 0000 0118     }
; 0000 0119     else{
_0xF0:
; 0000 011A         rychl = (180 - kompas) + 100;
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(180)
	LDI  R31,HIGH(180)
	SUB  R30,R26
	SBC  R31,R27
_0x196:
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	MOV  R12,R30
; 0000 011B     }
; 0000 011C     //------------------------------------------------------
; 0000 011D     if (kompas <= 10){
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,11
	BRLT _0x197
; 0000 011E         LED = 1;
; 0000 011F         komp_ret = 1;
; 0000 0120     }
; 0000 0121     else{
; 0000 0122         if( kompas <= 90){
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0x5B)
	LDI  R30,HIGH(0x5B)
	CPC  R27,R30
	BRGE _0xF6
; 0000 0123             LED = 0;
	CBI  0x18,4
; 0000 0124             m_ot(-rychl);
	MOV  R30,R12
	LDI  R31,0
	CALL SUBOPT_0x14
	RCALL _m_ot
; 0000 0125         }
; 0000 0126         else{
	RJMP _0xF9
_0xF6:
; 0000 0127             if (kompas <= 170){
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0xAB)
	LDI  R30,HIGH(0xAB)
	CPC  R27,R30
	BRGE _0xFA
; 0000 0128                 LED = 0;
	CBI  0x18,4
; 0000 0129                 m_ot(rychl);
	MOV  R30,R12
	CALL SUBOPT_0x1F
	RCALL _m_ot
; 0000 012A             }
; 0000 012B             else {
	RJMP _0xFD
_0xFA:
; 0000 012C                 LED = 1;
_0x197:
	SBI  0x18,4
; 0000 012D                 komp_ret = 1;
	__GETWRN 16,17,1
; 0000 012E             }
_0xFD:
; 0000 012F         }
_0xF9:
; 0000 0130     }
; 0000 0131     return komp_ret;
	MOVW R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
; 0000 0132 }
;void obchadzanie(int senzory){
; 0000 0133 void obchadzanie(int senzory){
_obchadzanie:
; 0000 0134     if (maxh < 80){
;	senzory -> Y+0
	LDI  R30,LOW(80)
	CP   R5,R30
	BRLO PC+3
	JMP _0x100
; 0000 0135             switch (senzory){
	LD   R30,Y
	LDD  R31,Y+1
; 0000 0136                 case 1: m_0(rychlost_presunu);          break;
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x104
	ST   -Y,R4
	RCALL _m_0
	RJMP _0x103
; 0000 0137         //---------------------------------------------------------------------
; 0000 0138                 case 2: m_90(rychlost_presunu-10);              break;
_0x104:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x105
	CALL SUBOPT_0x20
	RCALL _m_90
	RJMP _0x103
; 0000 0139                 case 3: m_135(rychlost_presunu);                break;
_0x105:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x106
	ST   -Y,R4
	RCALL _m_135
	RJMP _0x103
; 0000 013A                 case 4: m_135(rychlost_presunu);                break;
_0x106:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x107
	ST   -Y,R4
	RCALL _m_135
	RJMP _0x103
; 0000 013B                 case 5: m_180(rychlost_presunu);                break;
_0x107:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x108
	ST   -Y,R4
	RCALL _m_180
	RJMP _0x103
; 0000 013C         //---------------------------------------------------------------------
; 0000 013D                 case 6: m_225(rychlost_presunu_vzad);           break;
_0x108:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x109
	ST   -Y,R6
	RCALL _m_225
	RJMP _0x103
; 0000 013E                 case 7: m_225(rychlost_presunu_vzad);           break;
_0x109:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x10A
	ST   -Y,R6
	RCALL _m_225
	RJMP _0x103
; 0000 013F                 case 8: m_270(rychlost_presunu_vzad);           break;
_0x10A:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x10B
	ST   -Y,R6
	RCALL _m_270
	RJMP _0x103
; 0000 0140                 case 9: m_270(rychlost_presunu_vzad);           break;
_0x10B:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x10C
	ST   -Y,R6
	RCALL _m_270
	RJMP _0x103
; 0000 0141                 case 10: m_90(rychlost_presunu_vzad);           break;
_0x10C:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x10D
	ST   -Y,R6
	RCALL _m_90
	RJMP _0x103
; 0000 0142                 case 11: m_135(rychlost_presunu_vzad);          break;
_0x10D:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x10E
	ST   -Y,R6
	RCALL _m_135
	RJMP _0x103
; 0000 0143                 case 12: m_135(rychlost_presunu_vzad);          break;
_0x10E:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x10F
	ST   -Y,R6
	RCALL _m_135
	RJMP _0x103
; 0000 0144         //----------------------------------------------------------------------
; 0000 0145                 case 13: m_180(rychlost_presunu);               break;
_0x10F:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x110
	ST   -Y,R4
	RCALL _m_180
	RJMP _0x103
; 0000 0146                 case 14: m_225(rychlost_presunu);               break;
_0x110:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x111
	ST   -Y,R4
	RCALL _m_225
	RJMP _0x103
; 0000 0147                 case 15: m_225(rychlost_presunu);               break;
_0x111:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x112
	ST   -Y,R4
	RCALL _m_225
	RJMP _0x103
; 0000 0148                 case 16: m_270(rychlost_presunu-10);            break;
_0x112:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0x113
	CALL SUBOPT_0x20
	RCALL _m_270
	RJMP _0x103
; 0000 0149         //----------------------------------------------------------------------
; 0000 014A                 case 17: m_vyp();                               break;
_0x113:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0x103
	RCALL _m_vyp
; 0000 014B             }
_0x103:
; 0000 014C        }
; 0000 014D     else{
	RJMP _0x115
_0x100:
; 0000 014E            switch (senzory){
	LD   R30,Y
	LDD  R31,Y+1
; 0000 014F                 case 1: m_0(rychlost_presunu_zrychlene);         break;
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x119
	ST   -Y,R7
	RCALL _m_0
	RJMP _0x118
; 0000 0150         //---------------------------------------------------------------------
; 0000 0151                 case 2: m_45(rychlost_presunu_zrychlene);                 break;
_0x119:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x11A
	ST   -Y,R7
	RCALL _m_45
	RJMP _0x118
; 0000 0152                 case 3: m_45(rychlost_presunu_zrychlene);                 break;
_0x11A:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x11B
	ST   -Y,R7
	RCALL _m_45
	RJMP _0x118
; 0000 0153                 case 4: m_90(rychlost_presunu_zrychlene);                 break;
_0x11B:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x11C
	ST   -Y,R7
	RCALL _m_90
	RJMP _0x118
; 0000 0154                 case 5: m_90(rychlost_presunu_zrychlene);                 break;
_0x11C:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x11D
	ST   -Y,R7
	RCALL _m_90
	RJMP _0x118
; 0000 0155         //---------------------------------------------------------------------
; 0000 0156                 case 6: m_135(rychlost_presunu);                     break;
_0x11D:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x11E
	ST   -Y,R4
	RCALL _m_135
	RJMP _0x118
; 0000 0157                 case 7: m_135(rychlost_presunu);                     break;
_0x11E:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x11F
	ST   -Y,R4
	RCALL _m_135
	RJMP _0x118
; 0000 0158                 case 8: m_135(rychlost_presunu);                          break;
_0x11F:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x120
	ST   -Y,R4
	RCALL _m_135
	RJMP _0x118
; 0000 0159                 case 9: m_180(rychlost_presunu);                          break;
_0x120:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x121
	ST   -Y,R4
	RCALL _m_180
	RJMP _0x118
; 0000 015A                 case 10: m_225(rychlost_presunu);                         break;
_0x121:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x122
	ST   -Y,R4
	RCALL _m_225
	RJMP _0x118
; 0000 015B                 case 11: m_225(rychlost_presunu);                         break;
_0x122:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x123
	ST   -Y,R4
	RCALL _m_225
	RJMP _0x118
; 0000 015C                 case 12: m_225(rychlost_presunu);                         break;
_0x123:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x124
	ST   -Y,R4
	RCALL _m_225
	RJMP _0x118
; 0000 015D         //----------------------------------------------------------------------
; 0000 015E                 case 13: m_270(rychlost_presunu_zrychlene);               break;
_0x124:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x125
	ST   -Y,R7
	RCALL _m_270
	RJMP _0x118
; 0000 015F                 case 14: m_270(rychlost_presunu_zrychlene);               break;
_0x125:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x126
	ST   -Y,R7
	RCALL _m_270
	RJMP _0x118
; 0000 0160                 case 15: m_315(rychlost_presunu_zrychlene);               break;
_0x126:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x127
	ST   -Y,R7
	RCALL _m_315
	RJMP _0x118
; 0000 0161                 case 16: m_315(rychlost_presunu_zrychlene);               break;
_0x127:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0x128
	ST   -Y,R7
	RCALL _m_315
	RJMP _0x118
; 0000 0162         //----------------------------------------------------------------------
; 0000 0163                 case 17: m_vyp();                                         break;
_0x128:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0x118
	RCALL _m_vyp
; 0000 0164         }
_0x118:
; 0000 0165     }
_0x115:
; 0000 0166 }
_0x20A0007:
	ADIW R28,2
	RET
;//------------------------------
;//------------------------------
;//odosielanie do PC
;//------------------------------
;char bolo_nacita = 0;
;void odosli_dataPC(){
; 0000 016C void odosli_dataPC(){
_odosli_dataPC:
; 0000 016D     char data[12];
; 0000 016E     int test;
; 0000 016F //--prijem_dat------------------------
; 0000 0170     prijem_dat();
	SBIW R28,12
	ST   -Y,R17
	ST   -Y,R16
;	data -> Y+2
;	test -> R16,R17
	RCALL _prijem_dat
; 0000 0171 //------------------------------------
; 0000 0172 //printf("test\n");
; 0000 0173 //spracovanie dat---------------------
; 0000 0174 //------------------------------------
; 0000 0175     if (strcmpf(datax[0],"data") == 0){
	CALL SUBOPT_0x10
	__POINTW1FN _0x0,3
	CALL SUBOPT_0x21
	BRNE _0x12A
; 0000 0176         data[0] = Senzor_1;
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _read_adc
	STD  Y+2,R30
; 0000 0177         data[1] = Senzor_2;
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL _read_adc
	STD  Y+3,R30
; 0000 0178         data[2] = Senzor_3;
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _read_adc
	STD  Y+4,R30
; 0000 0179         data[3] = Senzor_4;
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL _read_adc
	STD  Y+5,R30
; 0000 017A         data[4] = Senzor_5;
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _read_adc
	STD  Y+6,R30
; 0000 017B         data[5] = Senzor_6;
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _read_adc
	STD  Y+7,R30
; 0000 017C         data[6] = Senzor_7;
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _read_adc
	STD  Y+8,R30
; 0000 017D         data[7] = Senzor_8;
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _read_adc
	STD  Y+9,R30
; 0000 017E         data[8] = maxx(200);
	CALL SUBOPT_0x22
	STD  Y+10,R30
; 0000 017F         data[9] = Kick_sens+20;
	LDI  R30,0
	SBIC 0x16,5
	LDI  R30,1
	SUBI R30,-LOW(20)
	STD  Y+11,R30
; 0000 0180         data[10] = (int)(prepocetcompasu(branka,1)*0.71);
	CALL SUBOPT_0x23
	CLR  R22
	CLR  R23
	STD  Y+12,R30
; 0000 0181         puts(data);
	CALL SUBOPT_0x11
	CALL _puts
; 0000 0182         bolo_nacita = 1;
	LDI  R30,LOW(1)
	STS  _bolo_nacita,R30
; 0000 0183         }
; 0000 0184     else if (strcmpf(datax[0],"kick") == 0)     kick_no();
	RJMP _0x12B
_0x12A:
	CALL SUBOPT_0x10
	__POINTW1FN _0x0,8
	CALL SUBOPT_0x21
	BRNE _0x12C
	RCALL _kick_no
; 0000 0185     else if (strcmpf(datax[0],"L1ed") == 0){     on = 1; }
	RJMP _0x12D
_0x12C:
	CALL SUBOPT_0x10
	__POINTW1FN _0x0,13
	CALL SUBOPT_0x21
	BRNE _0x12E
	LDI  R26,LOW(_on)
	LDI  R27,HIGH(_on)
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
; 0000 0186     else if (strcmpf(datax[0],"L0ed") == 0){      on = 0;}
	RJMP _0x12F
_0x12E:
	CALL SUBOPT_0x10
	__POINTW1FN _0x0,18
	CALL SUBOPT_0x21
	BRNE _0x130
	LDI  R26,LOW(_on)
	LDI  R27,HIGH(_on)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 0187     else if (strcmpf(datax[0],"LED0") == 0)     LED = 1;
	RJMP _0x131
_0x130:
	CALL SUBOPT_0x10
	__POINTW1FN _0x0,23
	CALL SUBOPT_0x21
	BRNE _0x132
	SBI  0x18,4
; 0000 0188     else if (strcmpf(datax[0],"LED1") == 0)     LED = 0;
	RJMP _0x135
_0x132:
	CALL SUBOPT_0x10
	__POINTW1FN _0x0,28
	CALL SUBOPT_0x21
	BRNE _0x136
	CBI  0x18,4
; 0000 0189     else if (strcmpf(datax[0],"smer") == 0)    {
	RJMP _0x139
_0x136:
	CALL SUBOPT_0x10
	__POINTW1FN _0x0,33
	CALL SUBOPT_0x21
	BREQ PC+3
	JMP _0x13A
; 0000 018A         smer = atoi(datax[1]);
	CALL SUBOPT_0x24
	MOV  R8,R30
; 0000 018B         switch(smer){
	MOV  R30,R8
	LDI  R31,0
; 0000 018C             case 0:
	SBIW R30,0
	BRNE _0x13E
; 0000 018D                 m_vyp();
	RCALL _m_vyp
; 0000 018E                 break;
	RJMP _0x13D
; 0000 018F             case 1:
_0x13E:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x13F
; 0000 0190                 m_0(rychlost);
	ST   -Y,R13
	RCALL _m_0
; 0000 0191                 break;
	RJMP _0x13D
; 0000 0192             case 2:
_0x13F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x140
; 0000 0193                 m_45(rychlost);
	ST   -Y,R13
	RCALL _m_45
; 0000 0194                 break;
	RJMP _0x13D
; 0000 0195             case 3:
_0x140:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x141
; 0000 0196                 m_90(rychlost);
	ST   -Y,R13
	RCALL _m_90
; 0000 0197                 break;
	RJMP _0x13D
; 0000 0198             case 4:
_0x141:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x142
; 0000 0199                 m_135(rychlost);
	ST   -Y,R13
	RCALL _m_135
; 0000 019A                 break;
	RJMP _0x13D
; 0000 019B             case 5:
_0x142:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x143
; 0000 019C                 m_180(rychlost);
	ST   -Y,R13
	RCALL _m_180
; 0000 019D                 break;
	RJMP _0x13D
; 0000 019E             case 6:
_0x143:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x144
; 0000 019F                 m_225(rychlost);
	ST   -Y,R13
	RCALL _m_225
; 0000 01A0                 break;
	RJMP _0x13D
; 0000 01A1             case 7:
_0x144:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x145
; 0000 01A2                 m_270(rychlost);
	ST   -Y,R13
	RCALL _m_270
; 0000 01A3                 break;
	RJMP _0x13D
; 0000 01A4             case 8:
_0x145:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x146
; 0000 01A5                 m_315(rychlost);
	ST   -Y,R13
	RCALL _m_315
; 0000 01A6                 break;
	RJMP _0x13D
; 0000 01A7             case 10:
_0x146:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x147
; 0000 01A8                 m_ot(170);
	LDI  R30,LOW(170)
	LDI  R31,HIGH(170)
	RJMP _0x198
; 0000 01A9                 break;
; 0000 01AA             case 9:
_0x147:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x13D
; 0000 01AB                 m_ot(-170);
	LDI  R30,LOW(65366)
	LDI  R31,HIGH(65366)
	SER  R31
_0x198:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _m_ot
; 0000 01AC                 break;
; 0000 01AD             }
_0x13D:
; 0000 01AE         }
; 0000 01AF     else if (strcmpf(datax[0],"rych") == 0)    {
	RJMP _0x149
_0x13A:
	CALL SUBOPT_0x10
	__POINTW1FN _0x0,38
	CALL SUBOPT_0x21
	BREQ PC+3
	JMP _0x14A
; 0000 01B0         rychlost = atoi(datax[1]);
	CALL SUBOPT_0x24
	MOV  R13,R30
; 0000 01B1         switch(smer){
	MOV  R30,R8
	LDI  R31,0
; 0000 01B2             case 0:
	SBIW R30,0
	BRNE _0x14E
; 0000 01B3                 m_vyp();
	RCALL _m_vyp
; 0000 01B4                 break;
	RJMP _0x14D
; 0000 01B5             case 1:
_0x14E:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x14F
; 0000 01B6                 m_0(rychlost);
	ST   -Y,R13
	RCALL _m_0
; 0000 01B7                 break;
	RJMP _0x14D
; 0000 01B8             case 2:
_0x14F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x150
; 0000 01B9                 m_45(rychlost);
	ST   -Y,R13
	RCALL _m_45
; 0000 01BA                 break;
	RJMP _0x14D
; 0000 01BB             case 3:
_0x150:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x151
; 0000 01BC                 m_90(rychlost);
	ST   -Y,R13
	RCALL _m_90
; 0000 01BD                 break;
	RJMP _0x14D
; 0000 01BE             case 4:
_0x151:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x152
; 0000 01BF                 m_135(rychlost);
	ST   -Y,R13
	RCALL _m_135
; 0000 01C0                 break;
	RJMP _0x14D
; 0000 01C1             case 5:
_0x152:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x153
; 0000 01C2                 m_180(rychlost);
	ST   -Y,R13
	RCALL _m_180
; 0000 01C3                 break;
	RJMP _0x14D
; 0000 01C4             case 6:
_0x153:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x154
; 0000 01C5                 m_225(rychlost);
	ST   -Y,R13
	RCALL _m_225
; 0000 01C6                 break;
	RJMP _0x14D
; 0000 01C7             case 7:
_0x154:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x155
; 0000 01C8                 m_270(rychlost);
	ST   -Y,R13
	RCALL _m_270
; 0000 01C9                 break;
	RJMP _0x14D
; 0000 01CA             case 8:
_0x155:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x156
; 0000 01CB                 m_315(rychlost);
	ST   -Y,R13
	RCALL _m_315
; 0000 01CC                 break;
	RJMP _0x14D
; 0000 01CD             case 10:
_0x156:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x157
; 0000 01CE                 m_ot(170);
	LDI  R30,LOW(170)
	LDI  R31,HIGH(170)
	RJMP _0x199
; 0000 01CF                 break;
; 0000 01D0             case 9:
_0x157:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x14D
; 0000 01D1                 m_ot(-170);
	LDI  R30,LOW(65366)
	LDI  R31,HIGH(65366)
	SER  R31
_0x199:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _m_ot
; 0000 01D2                 break;
; 0000 01D3             }
_0x14D:
; 0000 01D4         }
; 0000 01D5     else if (strcmpf(datax[0],"obch") == 0)     obchadzanie(maxx(200));
	RJMP _0x159
_0x14A:
	CALL SUBOPT_0x10
	__POINTW1FN _0x0,43
	CALL SUBOPT_0x21
	BRNE _0x15A
	CALL SUBOPT_0x22
	CALL SUBOPT_0x1F
	RCALL _obchadzanie
; 0000 01D6     else{
	RJMP _0x15B
_0x15A:
; 0000 01D7         data[0] = 0;
	LDI  R30,LOW(0)
	STD  Y+2,R30
; 0000 01D8         data[1] = 0;
	STD  Y+3,R30
; 0000 01D9         data[2] = 0;
	STD  Y+4,R30
; 0000 01DA         data[3] = 0;
	STD  Y+5,R30
; 0000 01DB         data[4] = 0;
	STD  Y+6,R30
; 0000 01DC         data[5] = 0;
	STD  Y+7,R30
; 0000 01DD         data[6] = 0;
	STD  Y+8,R30
; 0000 01DE         data[7] = 0;
	STD  Y+9,R30
; 0000 01DF         data[8] = 0;
	STD  Y+10,R30
; 0000 01E0         data[9] = 0;
	STD  Y+11,R30
; 0000 01E1         data[10] = 0;
	STD  Y+12,R30
; 0000 01E2         puts(data);
	CALL SUBOPT_0x11
	CALL _puts
; 0000 01E3     }
_0x15B:
_0x159:
_0x149:
_0x139:
_0x135:
_0x131:
_0x12F:
_0x12D:
_0x12B:
; 0000 01E4         if (on == 1){
	LDI  R26,LOW(_on)
	LDI  R27,HIGH(_on)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x15C
; 0000 01E5             if (bolo_nacita == 1){
	LDS  R26,_bolo_nacita
	CPI  R26,LOW(0x1)
	BRNE _0x15D
; 0000 01E6             if (0 != nastav_podla_kompasu(data[10])){
	LDD  R30,Y+12
	CALL SUBOPT_0x1F
	RCALL _nastav_podla_kompasu
	SBIW R30,0
	BREQ _0x15E
; 0000 01E7                 obchadzanie(data[8]);
	LDD  R30,Y+10
	CALL SUBOPT_0x1F
	RCALL _obchadzanie
; 0000 01E8             }
; 0000 01E9            }
_0x15E:
; 0000 01EA            else{
	RJMP _0x15F
_0x15D:
; 0000 01EB                 obchadzanie(maxx(200));
	CALL SUBOPT_0x22
	CALL SUBOPT_0x1F
	RCALL _obchadzanie
; 0000 01EC            }
_0x15F:
; 0000 01ED         }
; 0000 01EE     }
_0x15C:
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20A0006:
	ADIW R28,14
	RET
;//---------------------------------
;void kalibracia_kompas(unsigned char mode){
; 0000 01F0 void kalibracia_kompas(unsigned char mode){
_kalibracia_kompas:
; 0000 01F1     int kompas;
; 0000 01F2     if (mode == 1){
	CALL SUBOPT_0xB
;	mode -> Y+2
;	kompas -> R16,R17
	BRNE _0x160
; 0000 01F3         if (Kick_sens == 0){
	SBIC 0x16,5
	RJMP _0x161
; 0000 01F4         while (Kick_sens == 0){
_0x162:
	SBIC 0x16,5
	RJMP _0x164
; 0000 01F5             delay_ms(20);
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x25
; 0000 01F6             branka = cmps03_read(1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x26
; 0000 01F7                     }
	RJMP _0x162
_0x164:
; 0000 01F8         while(1){
_0x165:
; 0000 01F9             kompas = prepocetcompasu(branka,1)*0.71;
	CALL SUBOPT_0x23
	MOVW R16,R30
; 0000 01FA             if (kompas > 180)
	__CPWRN 16,17,181
	BRLT _0x168
; 0000 01FB                 kompas = 180;
	__GETWRN 16,17,180
; 0000 01FC             if (kompas < 20){
_0x168:
	__CPWRN 16,17,20
	BRLT _0x19A
; 0000 01FD                 LED = 0;
; 0000 01FE             }
; 0000 01FF             else{
; 0000 0200                 if( kompas < 90){
	__CPWRN 16,17,90
	BRGE _0x16D
; 0000 0201                     LED = 1;
	SBI  0x18,4
; 0000 0202                 }
; 0000 0203                 else
	RJMP _0x170
_0x16D:
; 0000 0204                 {
; 0000 0205                     if (kompas < 160){
	__CPWRN 16,17,160
	BRGE _0x171
; 0000 0206                         LED = 1;
	SBI  0x18,4
; 0000 0207                     }
; 0000 0208                     else {
	RJMP _0x174
_0x171:
; 0000 0209                         LED = 0;
_0x19A:
	CBI  0x18,4
; 0000 020A                         }
_0x174:
; 0000 020B                 }
_0x170:
; 0000 020C             }
; 0000 020D         }
	RJMP _0x165
; 0000 020E         }
; 0000 020F         }
_0x161:
; 0000 0210     else{
	RJMP _0x177
_0x160:
; 0000 0211          while (Kick_sens == 0){
_0x178:
	SBIC 0x16,5
	RJMP _0x17A
; 0000 0212                     branka = cmps03_read(2);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x26
; 0000 0213                     delay_ms(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x25
; 0000 0214                             }
	RJMP _0x178
_0x17A:
; 0000 0215          delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0x25
; 0000 0216          while(1){
_0x17B:
; 0000 0217                     kompas = prepocetcompasu(branka,2);
	LDI  R26,LOW(_branka)
	LDI  R27,HIGH(_branka)
	CALL __EEPROMRDW
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _prepocetcompasu
	MOVW R16,R30
; 0000 0218                     if (kompas < 200){
	__CPWRN 16,17,200
	BRLT _0x19B
; 0000 0219                         LED = 0;
; 0000 021A                     }
; 0000 021B                     else{
; 0000 021C                         if( kompas < 1800){
	__CPWRN 16,17,1800
	BRGE _0x182
; 0000 021D                             LED = 1;
	SBI  0x18,4
; 0000 021E                         }
; 0000 021F                         else
	RJMP _0x185
_0x182:
; 0000 0220                         {
; 0000 0221                             if (kompas < 3400){
	__CPWRN 16,17,3400
	BRGE _0x186
; 0000 0222                                 LED = 1;
	SBI  0x18,4
; 0000 0223                             }
; 0000 0224                             else {
	RJMP _0x189
_0x186:
; 0000 0225                                 LED = 0;
_0x19B:
	CBI  0x18,4
; 0000 0226                                 }
_0x189:
; 0000 0227                         }
_0x185:
; 0000 0228                     }
; 0000 0229                 }
	RJMP _0x17B
; 0000 022A     }
_0x177:
; 0000 022B }
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x20A0004
;//--------------------------------------------------
;void main(void)
; 0000 022E {
_main:
; 0000 022F init_8535();
	RCALL _init_8535
; 0000 0230 // pre odosielanie do pc nastav 1
; 0000 0231 prog = 1;
	LDI  R30,LOW(1)
	MOV  R9,R30
; 0000 0232 //kompas reset, nastavenie rychlosti na 33ms
; 0000 0233 cmps03_reset();
	RCALL _cmps03_reset
; 0000 0234 cmps03_scanmode(3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _cmps03_scanmode
; 0000 0235 //-----------------------------------
; 0000 0236 delay_ms(200);
	CALL SUBOPT_0x1E
; 0000 0237 kalibracia_kompas(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _kalibracia_kompas
; 0000 0238 //-----------------------------------
; 0000 0239 testmotor:
_0x18C:
; 0000 023A     while(1){
; 0000 023B     /*
; 0000 023C         if (Mot_sens == 1)  {
; 0000 023D           goto zaciatok;
; 0000 023E         }
; 0000 023F         else{
; 0000 0240             switch (senzory){
; 0000 0241                 case 1:     goto zaciatok;                  break;
; 0000 0242         //---------------------------------------------------------------------
; 0000 0243                 case 2:     m_0(255);          break;
; 0000 0244                 case 3:     m_0(255);          break;
; 0000 0245                 case 4:     m_45(255);          break;
; 0000 0246                 case 5:     m_45(255);         break;
; 0000 0247         //---------------------------------------------------------------------
; 0000 0248                 case 6:     m_vyp();                        break;
; 0000 0249                 case 7:     m_vyp();                        break;
; 0000 024A                 case 8:     m_vyp();                        break;
; 0000 024B                 case 9:     m_vyp();                        break;
; 0000 024C                 case 10:    m_vyp();                        break;
; 0000 024D                 case 11:    m_vyp();                        break;
; 0000 024E                 case 12:    m_vyp();                        break;
; 0000 024F         //----------------------------------------------------------------------
; 0000 0250                 case 13:    m_315(255);        break;
; 0000 0251                 case 14:    m_315(255);          break;
; 0000 0252                 case 15:    m_0(255);          break;
; 0000 0253                 case 16:    m_0(255);          break;
; 0000 0254         //----------------------------------------------------------------------
; 0000 0255                 case 17:    m_vyp();                        break;
; 0000 0256             }
; 0000 0257             if (senzory != 1){
; 0000 0258                 delay_ms(400);
; 0000 0259             }
; 0000 025A         }
; 0000 025B         */
; 0000 025C //        while(1){
; 0000 025D           odosli_dataPC();
	RCALL _odosli_dataPC
; 0000 025E     //    }
; 0000 025F goto testmotor;
	RJMP _0x18C
; 0000 0260 goto zaciatok;
; 0000 0261 }
; 0000 0262 //-----------------------------------
; 0000 0263 zaciatok:
; 0000 0264     while (1){
_0x191:
; 0000 0265         if (0 != nastav_podla_kompasu((int)(prepocetcompasu(branka,1)*0.71))){
	CALL SUBOPT_0x23
	ST   -Y,R31
	ST   -Y,R30
	RCALL _nastav_podla_kompasu
	SBIW R30,0
	BREQ _0x194
; 0000 0266             obchadzanie(maxx(200));
	CALL SUBOPT_0x22
	CALL SUBOPT_0x1F
	RCALL _obchadzanie
; 0000 0267         }
; 0000 0268         delay_ms(30);
_0x194:
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL SUBOPT_0x25
; 0000 0269 };
	RJMP _0x191
; 0000 026A //-----------------------------------
; 0000 026B }
_0x195:
	RJMP _0x195
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_getchar:
     sbis usr,rxc
     rjmp _getchar
     in   r30,udr
	RET
_putchar:
     sbis usr,udre
     rjmp _putchar
     ld   r30,y
     out  udr,r30
_0x20A0005:
	ADIW R28,1
	RET
_puts:
	ST   -Y,R17
_0x2000003:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000005
	ST   -Y,R17
	RCALL _putchar
	RJMP _0x2000003
_0x2000005:
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _putchar
	LDD  R17,Y+0
_0x20A0004:
	ADIW R28,3
	RET
__get_G100:
	ST   -Y,R17
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LD   R30,X
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000073
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x2000074
_0x2000073:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000075
	CALL __GETW1P
	LD   R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000076
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2000076:
	RJMP _0x2000077
_0x2000075:
	RCALL _getchar
	MOV  R17,R30
_0x2000077:
_0x2000074:
	MOV  R30,R17
	LDD  R17,Y+0
_0x20A0003:
	ADIW R28,5
	RET
__scanf_G100:
	SBIW R28,4
	CALL __SAVELOCR6
	LDI  R30,LOW(0)
	STD  Y+9,R30
	MOV  R20,R30
_0x2000078:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R19,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x200007A
	CALL SUBOPT_0x27
	BREQ _0x200007B
_0x200007C:
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x28
	POP  R20
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x200007F
	CALL SUBOPT_0x27
	BRNE _0x2000080
_0x200007F:
	RJMP _0x200007E
_0x2000080:
	RJMP _0x200007C
_0x200007E:
	MOV  R20,R19
	RJMP _0x2000081
_0x200007B:
	CPI  R19,37
	BREQ PC+3
	JMP _0x2000082
	LDI  R21,LOW(0)
_0x2000083:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R19,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	CPI  R19,48
	BRLO _0x2000087
	CPI  R19,58
	BRLO _0x2000086
_0x2000087:
	RJMP _0x2000085
_0x2000086:
	MOV  R26,R21
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	MULS R30,R26
	MOVW R30,R0
	MOV  R21,R30
	MOV  R22,R21
	CLR  R23
	CALL SUBOPT_0x29
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R22
	ADD  R30,R26
	MOV  R21,R30
	RJMP _0x2000083
_0x2000085:
	CPI  R19,0
	BRNE _0x2000089
	RJMP _0x200007A
_0x2000089:
_0x200008A:
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x28
	POP  R20
	MOV  R18,R30
	ST   -Y,R30
	CALL _isspace
	CPI  R30,0
	BRNE _0x200008A
	CPI  R18,0
	BRNE _0x200008D
	RJMP _0x200008E
_0x200008D:
	MOV  R20,R18
	CPI  R21,0
	BRNE _0x200008F
	LDI  R21,LOW(255)
_0x200008F:
	CALL SUBOPT_0x2A
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BRNE _0x2000093
	CALL SUBOPT_0x2B
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x28
	POP  R20
	MOVW R26,R16
	ST   X,R30
	RJMP _0x2000092
_0x2000093:
	CPI  R30,LOW(0x73)
	LDI  R26,HIGH(0x73)
	CPC  R31,R26
	BRNE _0x200009B
	CALL SUBOPT_0x2B
_0x2000095:
	MOV  R30,R21
	SUBI R21,1
	CPI  R30,0
	BREQ _0x2000097
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x28
	POP  R20
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x2000099
	CALL SUBOPT_0x27
	BREQ _0x2000098
_0x2000099:
	RJMP _0x2000097
_0x2000098:
	PUSH R17
	PUSH R16
	__ADDWRN 16,17,1
	MOV  R30,R19
	POP  R26
	POP  R27
	ST   X,R30
	RJMP _0x2000095
_0x2000097:
	MOVW R26,R16
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x2000092
_0x200009B:
	LDI  R30,LOW(1)
	STD  Y+8,R30
	CALL SUBOPT_0x2A
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BREQ _0x20000A0
	CPI  R30,LOW(0x69)
	LDI  R26,HIGH(0x69)
	CPC  R31,R26
	BRNE _0x20000A1
_0x20000A0:
	LDI  R30,LOW(0)
	STD  Y+8,R30
	RJMP _0x20000A2
_0x20000A1:
	CPI  R30,LOW(0x75)
	LDI  R26,HIGH(0x75)
	CPC  R31,R26
	BRNE _0x20000A3
_0x20000A2:
	LDI  R18,LOW(10)
	RJMP _0x200009E
_0x20000A3:
	CPI  R30,LOW(0x78)
	LDI  R26,HIGH(0x78)
	CPC  R31,R26
	BRNE _0x20000A4
	LDI  R18,LOW(16)
	RJMP _0x200009E
_0x20000A4:
	CPI  R30,LOW(0x25)
	LDI  R26,HIGH(0x25)
	CPC  R31,R26
	BRNE _0x20000A7
	RJMP _0x20000A6
_0x20000A7:
	RJMP _0x20A0002
_0x200009E:
	LDI  R30,0
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x20000A8:
	MOV  R30,R21
	SUBI R21,1
	CPI  R30,0
	BRNE PC+3
	JMP _0x20000AA
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x28
	POP  R20
	MOV  R19,R30
	CPI  R30,LOW(0x21)
	BRLO _0x20000AC
	LDD  R30,Y+8
	CPI  R30,0
	BRNE _0x20000AD
	CPI  R19,45
	BRNE _0x20000AE
	LDI  R30,LOW(255)
	STD  Y+8,R30
	RJMP _0x20000A8
_0x20000AE:
	LDI  R30,LOW(1)
	STD  Y+8,R30
_0x20000AD:
	CPI  R18,16
	BRNE _0x20000B0
	ST   -Y,R19
	CALL _isxdigit
	CPI  R30,0
	BREQ _0x20000AC
	RJMP _0x20000B2
_0x20000B0:
	ST   -Y,R19
	CALL _isdigit
	CPI  R30,0
	BRNE _0x20000B3
_0x20000AC:
	MOV  R20,R19
	RJMP _0x20000AA
_0x20000B3:
_0x20000B2:
	CPI  R19,97
	BRLO _0x20000B4
	CALL SUBOPT_0x29
	LDI  R30,LOW(87)
	LDI  R31,HIGH(87)
	RJMP _0x20000C0
_0x20000B4:
	CPI  R19,65
	BRLO _0x20000B6
	CALL SUBOPT_0x29
	LDI  R30,LOW(55)
	LDI  R31,HIGH(55)
	RJMP _0x20000C0
_0x20000B6:
	CALL SUBOPT_0x29
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
_0x20000C0:
	CALL __SWAPW12
	SUB  R30,R26
	MOV  R19,R30
	MOV  R30,R18
	LDI  R31,0
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __MULW12U
	MOVW R26,R30
	CALL SUBOPT_0x2A
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x20000A8
_0x20000AA:
	CALL SUBOPT_0x2B
	LDD  R30,Y+8
	LDI  R31,0
	SBRC R30,7
	SER  R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __MULW12U
	MOVW R26,R16
	ST   X+,R30
	ST   X,R31
_0x2000092:
	LDD  R30,Y+9
	SUBI R30,-LOW(1)
	STD  Y+9,R30
	RJMP _0x20000B8
_0x2000082:
_0x20000A6:
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x28
	POP  R20
	CP   R30,R19
	BREQ _0x20000B9
_0x200008E:
	LDD  R30,Y+9
	CPI  R30,0
	BRNE _0x20000BA
	LDI  R30,LOW(255)
	RJMP _0x20A0001
_0x20000BA:
	RJMP _0x200007A
_0x20000B9:
_0x20000B8:
_0x2000081:
	RJMP _0x2000078
_0x200007A:
_0x20A0002:
	LDD  R30,Y+9
_0x20A0001:
	CALL __LOADLOCR6
	ADIW R28,16
	RET
_scanf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,2
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,0
	STD  Y+2,R30
	STD  Y+2+1,R30
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	RCALL __scanf_G100
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	POP  R15
	RET

	.CSEG
_atoi:
   	ldd  r27,y+1
   	ld   r26,y
__atoi0:
   	ld   r30,x
	ST   -Y,R30
	CALL _isspace
   	tst  r30
   	breq __atoi1
   	adiw r26,1
   	rjmp __atoi0
__atoi1:
   	clt
   	ld   r30,x
   	cpi  r30,'-'
   	brne __atoi2
   	set
   	rjmp __atoi3
__atoi2:
   	cpi  r30,'+'
   	brne __atoi4
__atoi3:
   	adiw r26,1
__atoi4:
   	clr  r22
   	clr  r23
__atoi5:
   	ld   r30,x
	ST   -Y,R30
	CALL _isdigit
   	tst  r30
   	breq __atoi6
   	movw r30,r22
   	lsl  r22
   	rol  r23
   	lsl  r22
   	rol  r23
   	add  r22,r30
   	adc  r23,r31
   	lsl  r22
   	rol  r23
   	ld   r30,x+
   	clr  r31
   	subi r30,'0'
   	add  r22,r30
   	adc  r23,r31
   	rjmp __atoi5
__atoi6:
   	movw r30,r22
   	brtc __atoi7
   	com  r30
   	com  r31
   	adiw r30,1
__atoi7:
   	adiw r28,2
   	ret

	.DSEG

	.CSEG

	.CSEG
_strcmpf:
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
strcmpf0:
    ld   r1,x+
	lpm  r0,z+
    cp   r0,r1
    brne strcmpf1
    tst  r0
    brne strcmpf0
strcmpf3:
    clr  r30
    ret
strcmpf1:
    sub  r1,r0
    breq strcmpf3
    ldi  r30,1
    brcc strcmpf2
    subi r30,2
strcmpf2:
    ret

	.CSEG
_isdigit:
    ldi  r30,1
    ld   r31,y+
    cpi  r31,'0'
    brlo isdigit0
    cpi  r31,'9'+1
    brlo isdigit1
isdigit0:
    clr  r30
isdigit1:
    ret
_isspace:
    ldi  r30,1
    ld   r31,y+
    cpi  r31,' '
    breq isspace1
    cpi  r31,9
    brlo isspace0
    cpi  r31,13+1
    brlo isspace1
isspace0:
    clr  r30
isspace1:
    ret
_isxdigit:
    ldi  r30,1
    ld   r31,y+
    subi r31,0x30
    brcs isxdigit0
    cpi  r31,10
    brcs isxdigit1
    andi r31,0x5f
    subi r31,7
    cpi  r31,10
    brcs isxdigit0
    cpi  r31,16
    brcs isxdigit1
isxdigit0:
    clr  r30
isxdigit1:
    ret

	.CSEG

	.DSEG
_datax:
	.BYTE 0x32

	.ESEG
_branka:
	.DW  0x0
_on:
	.DB  0x0

	.DSEG
_bolo_nacita:
	.BYTE 0x1
__seed_G101:
	.BYTE 0x4
_p_S1020024:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x0:
	LD   R30,Y
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	IN   R30,0x6
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+4
	ST   -Y,R30
	ST   -Y,R16
	CALL _inrange
	CPI  R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDD  R30,Y+9
	ST   -Y,R30
	LDD  R30,Y+3
	ST   -Y,R30
	ST   -Y,R16
	CALL _inrange
	CPI  R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R30,Y+5
	ST   -Y,R30
	ST   -Y,R16
	CALL _inrange
	CPI  R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R30,Y+6
	ST   -Y,R30
	ST   -Y,R16
	CALL _inrange
	CPI  R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R30,Y+7
	ST   -Y,R30
	ST   -Y,R16
	CALL _inrange
	CPI  R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	LDD  R30,Y+6
	ST   -Y,R30
	LDD  R30,Y+8
	ST   -Y,R30
	ST   -Y,R16
	CALL _inrange
	CPI  R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDD  R30,Y+7
	ST   -Y,R30
	LDD  R30,Y+9
	ST   -Y,R30
	ST   -Y,R16
	CALL _inrange
	CPI  R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	LDD  R30,Y+8
	ST   -Y,R30
	LDD  R30,Y+10
	ST   -Y,R30
	ST   -Y,R16
	CALL _inrange
	CPI  R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xA:
	CALL _i2c_start
	LDI  R30,LOW(192)
	ST   -Y,R30
	CALL _i2c_write
	LDI  R30,LOW(18)
	ST   -Y,R30
	CALL _i2c_write
	LDI  R30,LOW(85)
	ST   -Y,R30
	CALL _i2c_write
	LDI  R30,LOW(90)
	ST   -Y,R30
	CALL _i2c_write
	LDI  R30,LOW(165)
	ST   -Y,R30
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	CALL _i2c_start
	LDI  R30,LOW(192)
	ST   -Y,R30
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xD:
	ST   -Y,R30
	CALL _i2c_write
	CALL _i2c_start
	LDI  R30,LOW(193)
	ST   -Y,R30
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xE:
	ST   -Y,R30
	CALL _cmps03_read
	MOVW R26,R30
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	SUB  R26,R30
	SBC  R27,R31
	MOVW R16,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	MOVW R30,R16
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(_datax)
	LDI  R31,HIGH(_datax)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x13:
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CALL __MULW12
	ST   Y,R30
	STD  Y+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x14:
	CALL __ANEGW1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x15:
	CALL _motor1
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x16:
	CALL _motor2
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x17:
	ST   -Y,R31
	ST   -Y,R30
	CALL _motor3
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x18:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _motor4

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	CALL _motor2
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	CALL _motor1
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1C:
	CALL _motor3
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __DIVW21
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1F:
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x20:
	MOV  R26,R4
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x21:
	ST   -Y,R31
	ST   -Y,R30
	CALL _strcmpf
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(200)
	ST   -Y,R30
	JMP  _maxx

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x23:
	LDI  R26,LOW(_branka)
	LDI  R27,HIGH(_branka)
	CALL __EEPROMRDW
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _prepocetcompasu
	CALL __CWD1
	CALL __CDF1
	__GETD2N 0x3F35C28F
	CALL __MULF12
	CALL __CFD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	__POINTW1MN _datax,10
	ST   -Y,R31
	ST   -Y,R30
	JMP  _atoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x25:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x26:
	ST   -Y,R30
	CALL _cmps03_read
	LDI  R26,LOW(_branka)
	LDI  R27,HIGH(_branka)
	CALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	ST   -Y,R19
	CALL _isspace
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x28:
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  __get_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x29:
	MOV  R26,R19
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	MOV  R30,R19
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2B:
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	SBIW R30,4
	STD  Y+12,R30
	STD  Y+12+1,R31
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	ADIW R26,4
	LD   R16,X+
	LD   R17,X
	RET


	.CSEG
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2
_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,18
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,37
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	ld   r23,y+
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ld   r30,y+
	ldi  r23,8
__i2c_write0:
	lsl  r30
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	ret

_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xACD
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
