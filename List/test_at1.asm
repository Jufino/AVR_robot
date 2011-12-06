
;CodeVisionAVR C Compiler V2.03.4 Standard
;(C) Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATtiny26L
;Clock frequency        : 1,000000 MHz
;Memory model           : Tiny
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 32 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : Yes
;char is unsigned       : Yes
;global const stored in FLASH  : No
;8 bit enums            : Yes
;Smart register allocation : Off
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATtiny26L
	#pragma AVRPART MEMORY PROG_FLASH 2048
	#pragma AVRPART MEMORY EEPROM 128
	#pragma AVRPART MEMORY INT_SRAM SIZE 128
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E

	.EQU WDTCR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
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
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	RCALL __EEPROMWRD
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
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	RCALL __EEPROMRDW
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
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __GETB1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOV  R30,R0
	MOV  R31,R1
	.ENDM

	.MACRO __GETB2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOV  R26,R0
	MOV  R27,R1
	.ENDM

	.MACRO __GETBRSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __LSLW8SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __CLRD1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __PUTB2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
	.ENDM

	.MACRO __PUTWSRX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOV  R26,R28
	MOV  R27,R29
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
	MOV  R26,R28
	MOV  R27,R29
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
	MOV  R26,R28
	MOV  R27,R29
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _motorymin=R4
	.DEF _kriticalmot=R6
	.DEF _cas=R8
	.DEF _poc=R10
	.DEF _mot1x=R12
	.DEF _mot2x=R13
	.DEF _mot3x=R14

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_0x6:
	.DB  0x3
_0x1B:
	.DB  0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x0A
	.DW  _0x1B*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x80)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM
	ADIW R30,1
	MOV  R24,R0
	LPM
	ADIW R30,1
	MOV  R25,R0
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM
	ADIW R30,1
	MOV  R26,R0
	LPM
	ADIW R30,1
	MOV  R27,R0
	LPM
	ADIW R30,1
	MOV  R1,R0
	LPM
	ADIW R30,1
	MOV  R22,R30
	MOV  R23,R31
	MOV  R31,R0
	MOV  R30,R1
__GLOBAL_INI_LOOP:
	LPM
	ADIW R30,1
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOV  R30,R22
	MOV  R31,R23
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0xDF)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x80)
	LDI  R29,HIGH(0x80)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x80

	.CSEG
;/**************************************
;Project : Stavovy procesor
;Author  : Juraj Fojtik
;Chip type           : ATtiny26L
;Clock frequency     : 1,000 MHz
;**************************************/
;//------------kniznice-------
;#include <tiny26.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_mask=0x18
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x18
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#define ADC_VREF_TYPE 0x20
;//---------------------------
;unsigned char read_adc(unsigned char adc_input)
; 0000 000D {

	.CSEG
_read_adc:
; 0000 000E ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	RCALL SUBOPT_0x0
	ORI  R30,0x20
	OUT  0x7,R30
; 0000 000F // Delay needed for the stabilization of the ADC input voltage
; 0000 0010 delay_us(10);
	__DELAY_USB 3
; 0000 0011 // Start the AD conversion
; 0000 0012 ADCSR|=0x40;
	IN   R30,0x6
	RCALL SUBOPT_0x0
	ORI  R30,0x40
	OUT  0x6,R30
; 0000 0013 // Wait for the AD conversion to complete
; 0000 0014 while ((ADCSR & 0x10)==0);
_0x3:
	IN   R30,0x6
	RCALL SUBOPT_0x0
	ANDI R30,LOW(0x10)
	BREQ _0x3
; 0000 0015 ADCSR|=0x10;
	IN   R30,0x6
	RCALL SUBOPT_0x0
	ORI  R30,0x10
	OUT  0x6,R30
; 0000 0016 return ADCH;
	IN   R30,0x5
	ADIW R28,1
	RET
; 0000 0017 }
;//inicializacia mikroprocesora
;void init_attiny26(){
; 0000 0019 void init_attiny26(){
_init_attiny26:
; 0000 001A // Input/Output Ports initialization
; 0000 001B // Port A initialization
; 0000 001C // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 001D // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 001E PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 001F DDRA=0x00;
	OUT  0x1A,R30
; 0000 0020 
; 0000 0021 // Port B initialization
; 0000 0022 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=Out
; 0000 0023 // State7=T State6=T State5=T State4=T State3=T State2=T State1=0 State0=0
; 0000 0024 PORTB=0x00;
	OUT  0x18,R30
; 0000 0025 DDRB=0x8F;
	LDI  R30,LOW(143)
	OUT  0x17,R30
; 0000 0026 
; 0000 0027 // Timer/Counter 0 initialization
; 0000 0028 // Clock source: System Clock
; 0000 0029 // Clock value: Timer 0 Stopped
; 0000 002A TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 002B TCNT0=0x00;
	OUT  0x32,R30
; 0000 002C 
; 0000 002D // Timer/Counter 1 initialization
; 0000 002E // Clock source: System Clock
; 0000 002F // Clock value: Timer 1 Stopped
; 0000 0030 // Mode: Normal top=FFh
; 0000 0031 // OC1A output: Disconnected
; 0000 0032 // OC1B output: Disconnected
; 0000 0033 // Timer 1 Overflow Interrupt: Off
; 0000 0034 // Compare A Match Interrupt: Off
; 0000 0035 // Compare B Match Interrupt: Off
; 0000 0036 PLLCSR=0x00;
	OUT  0x29,R30
; 0000 0037 TCCR1A=0x00;
	OUT  0x30,R30
; 0000 0038 TCCR1B=0x00;
	OUT  0x2F,R30
; 0000 0039 TCNT1=0x00;
	OUT  0x2E,R30
; 0000 003A OCR1A=0x00;
	OUT  0x2D,R30
; 0000 003B OCR1B=0x00;
	OUT  0x2C,R30
; 0000 003C OCR1C=0x00;
	OUT  0x2B,R30
; 0000 003D 
; 0000 003E // External Interrupt(s) initialization
; 0000 003F // INT0: Off
; 0000 0040 // Interrupt on any change on pins PA3, PA6, PA7 and PB4-7: Off
; 0000 0041 // Interrupt on any change on pins PB0-3: Off
; 0000 0042 GIMSK=0x00;
	OUT  0x3B,R30
; 0000 0043 MCUCR=0x00;
	OUT  0x35,R30
; 0000 0044 
; 0000 0045 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0046 TIMSK=0x00;
	OUT  0x39,R30
; 0000 0047 
; 0000 0048 // Universal Serial Interface initialization
; 0000 0049 // Mode: Disabled
; 0000 004A // Clock source: Register & Counter=no clk.
; 0000 004B // USI Counter Overflow Interrupt: Off
; 0000 004C USICR=0x00;
	OUT  0xD,R30
; 0000 004D 
; 0000 004E // Analog Comparator initialization
; 0000 004F // Analog Comparator: Off
; 0000 0050 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0051 
; 0000 0052 // ADC initialization
; 0000 0053 // ADC Clock frequency: 500,000 kHz
; 0000 0054 // ADC Voltage Reference: AVCC pin
; 0000 0055 // Only the 8 most significant bits of
; 0000 0056 // the AD conversion result are used
; 0000 0057 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(32)
	OUT  0x7,R30
; 0000 0058 ADCSR=0x81;
	LDI  R30,LOW(129)
	OUT  0x6,R30
; 0000 0059 }
	RET
;//-----------------------
;int bateriamin[4];
;int bateriamin_indik[4];
;int motorymin;
;int kriticalmot;
;int cas;
;int poc = 0;
;unsigned char mot1x;
;unsigned char mot2x;
;unsigned char mot3x;
;unsigned char mot4x;
;int poc1=3;

	.DSEG
;//-----------------------
;//Ukazka vstupov a vystupov
;/*
;********Baterie************
;ADC3 <<----- Bat1
;ADC4 <<----- Bat2
;ADC5 <<----- Bat3
;ADC6 <<----- Bat4
;********Motory*************
;ADC0 <<----- Mot1
;ADC1 <<----- Mot2
;ADC2 <<----- Mot3
;ADC9 <<----- Mot4
;*******Vystupy*************
;PORTB.2 ------>> LED zelena
;PORTB.3 ------>> LED cervena
;PORTB.0 ------>> Bateria kriticky stav
;PORTB.1 ------>> Motor kriticky stav
;***************************
;*/
;//Definovanie------------
;#define Bat1 read_adc(3)
;#define Bat2 read_adc(4)
;#define Bat3 read_adc(5)
;#define Bat4 read_adc(6)
;//-----------------------
;#define Mot1 read_adc(0)
;#define Mot2 read_adc(1)
;#define Mot3 read_adc(2)
;#define Mot4 read_adc(9)
;//-----------------------
;#define Led_G PORTB.1
;#define Led_R PORTB.2
;//-----------------------
;#define Batx PORTB.3
;#define Motx PORTB.0
;//-----------------------
;void main(void)
; 0000 008C {

	.CSEG
_main:
; 0000 008D //--Kriticke napätie baterii--
; 0000 008E bateriamin[0] = 200;
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	STS  _bateriamin,R30
	STS  _bateriamin+1,R31
; 0000 008F bateriamin[1] = 200;
	__POINTB1MN _bateriamin,2
	LDI  R26,LOW(200)
	LDI  R27,HIGH(200)
	RCALL SUBOPT_0x1
; 0000 0090 bateriamin[2] = 213;
	__POINTB1MN _bateriamin,4
	LDI  R26,LOW(213)
	LDI  R27,HIGH(213)
	RCALL SUBOPT_0x1
; 0000 0091 bateriamin[3] = 213;
	__POINTB1MN _bateriamin,6
	LDI  R26,LOW(213)
	LDI  R27,HIGH(213)
	RCALL SUBOPT_0x1
; 0000 0092 //--Indikovanie stavu baterii--
; 0000 0093 bateriamin_indik[0] = 220;
	LDI  R30,LOW(220)
	LDI  R31,HIGH(220)
	STS  _bateriamin_indik,R30
	STS  _bateriamin_indik+1,R31
; 0000 0094 bateriamin_indik[1] = 220;
	__POINTB1MN _bateriamin_indik,2
	LDI  R26,LOW(220)
	LDI  R27,HIGH(220)
	RCALL SUBOPT_0x1
; 0000 0095 bateriamin_indik[2] = 230;
	__POINTB1MN _bateriamin_indik,4
	LDI  R26,LOW(230)
	LDI  R27,HIGH(230)
	RCALL SUBOPT_0x1
; 0000 0096 bateriamin_indik[3] = 230;
	__POINTB1MN _bateriamin_indik,6
	LDI  R26,LOW(230)
	LDI  R27,HIGH(230)
	RCALL SUBOPT_0x1
; 0000 0097 //-------------------------
; 0000 0098 cas = 4;          //cas ktory moze prekrocit prud na motoroch
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	__PUTW1R 8,9
; 0000 0099 motorymin = 12;      //prud na motoroch
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	__PUTW1R 4,5
; 0000 009A //-------------------------
; 0000 009B init_attiny26();    // inicializacia mikroprocesor
	RCALL _init_attiny26
; 0000 009C //-----------------------------
; 0000 009D //Baterie OK        -   B0 = 1
; 0000 009E //Baterie Vyp       -   B0 = 0
; 0000 009F //Prud motor Ok     -   B1 = 1
; 0000 00A0 //Prud motor Vyp    -   B1 = 0
; 0000 00A1 //-----------------------------
; 0000 00A2 while(1){
_0x7:
; 0000 00A3 //------------------kriticke stavy-----------------------------------------
; 0000 00A4 /*
; 0000 00A5         if (Bat1 > bateriamin[0] & Bat2 > bateriamin[1] &
; 0000 00A6             Bat3 > bateriamin[2] & Bat4 > bateriamin[3]){
; 0000 00A7             Batx = 1;
; 0000 00A8         }
; 0000 00A9         else{
; 0000 00AA             Batx = 0;
; 0000 00AB         }
; 0000 00AC         */
; 0000 00AD /*
; 0000 00AE if (poc1 == 0){
; 0000 00AF //------------------indikacia baterie--------------------------------------
; 0000 00B0         if (Bat1 > bateriamin_indik[0] & Bat2 > bateriamin_indik[1] &
; 0000 00B1             Bat3 > bateriamin_indik[2] & Bat4 > bateriamin_indik[3]){
; 0000 00B2 //-----------------------------
; 0000 00B3             Led_G = 1;
; 0000 00B4             Led_R = 0;
; 0000 00B5 //-----------------------------
; 0000 00B6         }
; 0000 00B7         else{
; 0000 00B8 //-----------------------------
; 0000 00B9             Led_G = 0;
; 0000 00BA             Led_R = 1;
; 0000 00BB //-----------------------------
; 0000 00BC         }
; 0000 00BD         poc1 = 1000;
; 0000 00BE }
; 0000 00BF else
; 0000 00C0     poc1 = poc1-1;
; 0000 00C1 */
; 0000 00C2 //Nacitaj stav-----------------
; 0000 00C3 //------------------Prudove obmedzenie motorov-----------------------------
; 0000 00C4        while (Mot1 > motorymin | Mot2 > motorymin |
_0xA:
; 0000 00C5                Mot3 > motorymin | Mot4 > motorymin){
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x2
	PUSH R30
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x2
	POP  R26
	OR   R30,R26
	PUSH R30
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x2
	POP  R26
	OR   R30,R26
	PUSH R30
	LDI  R30,LOW(9)
	RCALL SUBOPT_0x2
	POP  R26
	OR   R30,R26
	BREQ _0xC
; 0000 00C6 //--------------------------------
; 0000 00C7                 poc++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 10,11,30,31
; 0000 00C8                 Led_G = 1;
	SBI  0x18,1
; 0000 00C9                 Led_R = 1;
	SBI  0x18,2
; 0000 00CA                 if (poc > cas)
	__CPWRR 8,9,10,11
	BRGE _0x11
; 0000 00CB                 {
; 0000 00CC                     Motx = 0;
	CBI  0x18,0
; 0000 00CD                     delay_ms(70);
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 00CE                 }
; 0000 00CF //Nacitaj stav-----------------------------
; 0000 00D0                 delay_us(60);
_0x11:
	__DELAY_USB 20
; 0000 00D1                 delay_ms(49);
	LDI  R30,LOW(49)
	LDI  R31,HIGH(49)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 00D2 
; 0000 00D3 //-----------------------------------------
; 0000 00D4             }
	RJMP _0xA
_0xC:
; 0000 00D5         poc = 0;    //nulovanie pocitadlo
	CLR  R10
	CLR  R11
; 0000 00D6         Motx = 1;
	SBI  0x18,0
; 0000 00D7                 Led_G = 0;
	CBI  0x18,1
; 0000 00D8                 Led_R = 0;
	CBI  0x18,2
; 0000 00D9 //-------------------------------------------------------------------------
; 0000 00DA       };
	RJMP _0x7
; 0000 00DB //-------------------------------------------------------------------------
; 0000 00DC }
_0x1A:
	RJMP _0x1A

	.DSEG
_bateriamin:
	.BYTE 0x8
_bateriamin_indik:
	.BYTE 0x8

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x2:
	ST   -Y,R30
	RCALL _read_adc
	MOV  R26,R30
	__GETW1R 4,5
	LDI  R27,0
	RCALL __GTW12
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__GTW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BRLT __GTW12T
	CLR  R30
__GTW12T:
	RET

;END OF CODE MARKER
__END_OF_CODE:
