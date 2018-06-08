org 0000h
ajmp START

;11h: false ;1fh: true
;50H:个位数设置flag 51H:十位数设置flag 52H:个位数地址 53H:十位数地址
;58H-67H :保存键盘扫描数据
org 10h
START:
	MOV R0, #11h ;个位数设置flag
	MOV R1, #11h ;十位数设置flag
	MOV R6, #00h ;个位初始值
	MOV R7, #00h ;十位初始值
	MOV R2, #1fh
	MOV 40H, R0 ;设置*键输入检测
	MOV 41H, R0 ;0号键倒计时符号为
	MOV 42H, R6 ;个位temp
	MOV 43H, R7 ;十位temp
	MOV 50H, R0
	MOV 51H, R1
	MOV 52H, R6
	MOV 53H, R7
	MOV 45H, #11H ;*号键，锁止位
	MOV 46H, #01H ;

	CALL INPUT
	MOV 45H, #1fh
	CALL COUNT_DOWN
	CALL FINAL_PROC
	JMP EXIT

;功能描述：在user按下‘*’键之前，不断地搜索键盘输入。
;具体：1.持续扫描键盘 -- SCAN
;     2.扫描完毕后进行处理，根据个位百位flag对数据进行分配 -- SCAN_PROCESS
;     2-1.当按下‘*’键后，但实际上没有有效输入，置个位为5，直接进入倒计时部件。
;     3.绘制LED部分
INPUT:
	CALL LED_P	;获取数据位，绘制LED图
	CALL SCAN ;扫描键盘输入
	CALL SCAN_PROCESS ;处理键盘输入
	MOV R0, 40H ;判断*是否已经输入
	CJNE R0, #1fH,INPUT
RET

;SCAN: 11H not_input 1fH:input_happen
;输入发生时C电平为低
SCAN: 
	MOV R0, #11H
	MOV R1, #1fH

	CLR P2.0 ;搜索第一列键盘输入!!!!
	
	CLR C ;1,1
	MOV C, P2.4
	JC R1_L1_NI
	MOV 58H, R1
	JMP R1_L1_I
	R1_L1_NI:
	MOV 58H, R0
	R1_L1_I:
	

	CLR C ;1,2
	MOV C, P2.5
	JC R2_L1_NI
	MOV 59H, R1
	JMP R2_L1_I
	R2_L1_NI:
	MOV 59H, R0
	R2_L1_I:

	CLR C ;1,3
	MOV C, P2.6
	JC R3_L1_NI
	MOV 5AH, R1
	JMP R3_L1_I
	R3_L1_NI:
	MOV 5AH, R0
	R3_L1_I:

	CLR C ;1,4
	MOV C, P2.7
	JC R4_L1_NI
	MOV 5BH, R1
	JMP R4_L1_I
	R4_L1_NI:
	MOV 5BH, R0
	R4_L1_I:
	MOV R3, 58H

	SETB P2.0 ;结束第一列的搜索!!!!
	
	CLR P2.1 ;开始第二列的搜索!!!!

	CLR C ;2,1
	MOV C, P2.4
	JC R1_L2_NI
	MOV 5CH, R1
	JMP R1_L2_I
	R1_L2_NI:
	MOV 5CH, R0
	R1_L2_I:

	CLR C ;2,2
	MOV C, P2.5
	JC R2_L2_NI
	MOV 5DH, R1
	JMP R2_L2_I
	R2_L2_NI:
	MOV 5DH, R0
	R2_L2_I:

	CLR C ;2,3
	MOV C, P2.6
	JC R3_L2_NI
	MOV 5EH, R1
	JMP R3_L2_I
	R3_L2_NI:
	MOV 5EH, R0
	R3_L2_I:

	CLR C ;2,4
	MOV C, P2.7
	JC R4_L2_NI
	MOV 5FH, R1
	JMP R4_L2_I
	R4_L2_NI:
	MOV 5FH, R0
	R4_L2_I:
	SETB P2.1 ;结束第二列搜索!!!!

	CLR P2.2 ;开始第三列搜索!!!!

	CLR C ;3,1
	MOV C, P2.4
	JC R1_L3_NI
	MOV 60H, R1
	JMP R1_L3_I
	R1_L3_NI:
	MOV 60H, R0
	R1_L3_I:

	CLR C ;3,2
	MOV C, P2.5
	JC R2_L3_NI
	MOV 61H, R1
	JMP R2_L3_I
	R2_L3_NI:
	MOV 61H, R0
	R2_L3_I:

	CLR C ;3,3
	MOV C, P2.6
	JC R3_L3_NI
	MOV 62H, R1
	JMP R3_L3_I
	R3_L3_NI:
	MOV 62H, R0
	R3_L3_I:

	CLR C ;3,4
	MOV C, P2.7
	JC R4_L3_NI
	MOV 63H, R1
	JMP R4_L3_I
	R4_L3_NI:
	MOV 63H, R0
	R4_L3_I:

	SETB P2.2 ;结束第三列搜索!!!!

	CLR P2.3 ;开始第四列搜索!!!!

	CLR C ;4,1
	MOV C, P2.4
	JC R1_L4_NI
	MOV 64H, R1
	JMP R1_L4_I
	R1_L4_NI:
	MOV 64H, R0
	R1_L4_I:

	CLR C ;4,2
	MOV C, P2.5
	JC R2_L4_NI
	MOV 65H, R1
	JMP R4_L3_I
	R2_L4_NI:
	MOV 65H, R0
	R2_L4_I:

	CLR C ;4,3
	MOV C, P2.6
	JC R3_L4_NI
	MOV 66H, R1
	JMP R3_L4_I
	R3_L4_NI:
	MOV 66H, R0
	R3_L4_I:

	CLR C ;4,4
	MOV C, P2.7
	JC R4_L4_NI
	MOV 67H, R1
	JMP R4_L4_I
	R4_L4_NI:
	MOV 67H, R0
	R4_L4_I:
	SETB P2.3 ;结束搜索第四行
RET

;11h: false ;1fh: true
;58H-67H :键盘扫描数据
SCAN_PROCESS:
	MOV R0, 50H ;个位数设置flag，
	MOV R1, 51H ;十位数设置flag
	MOV R3, #2fH ;temp保存寄存器
	MOV R4, #11H ;输入确认寄存器

	MOV R5, 58H
	CJNE R5, #1fH, K1_F
	MOV R4, #1fH
	MOV R3, #01H ;键盘‘1’发生
	K1_F:

	MOV R5, 59H
	CJNE R5, #1fH, K4_F
	MOV R4, #1fH
	MOV R3, #04H ;键盘‘4’发生
	K4_F:

	MOV R5, 5AH
	CJNE R5, #1fh, K7_F
	MOV R4, #1fh
	MOV R3, #07H ;键盘‘7’发生
	K7_F:

	MOV R5, 5BH
	CJNE R5, #1fh, Ke_F
	JMP KE_T
	Ke_F:

	MOV R5, 5CH
	CJNE R5, #1fh, K2_F
	MOV R4, #1fh
	MOV R3, #02H ;键盘‘2’发生
	K2_F:

	MOV R5, 5DH
	CJNE R5, #1fh, K5_F
	MOV R4, #1fh
	MOV R3, #05H ;键盘‘5’发生
	K5_F:

	MOV R5, 5EH
	CJNE R5, #1fh, K8_F
	MOV R4, #1fh
	MOV R3, #08H ;键盘‘8’发生
	K8_F:

	MOV R5, 5FH
	CJNE R5, #1fh, K0_F
	MOV R4, #1fh
	MOV R3, #00H ;键盘‘0’发生
	K0_F:

	MOV R5, 60H
	CJNE R5, #1fh, K3_F
	MOV R4, #1fh
	MOV R3, #03H ;键盘‘3’发生
	K3_F:

	MOV R5, 61H
	CJNE R5, #1fh, K6_F
	MOV R4, #1fh
	MOV R3, #06H ;键盘‘6’发生
	K6_F:

	MOV R5, 62H
	CJNE R5, #1fh, K9_F
	MOV R4, #1fh
	MOV R3, #09H ;键盘‘9’发生
	K9_F:

	CJNE R4, #1fh, PROCESS_END
	CJNE R0, #1fh, L_SET
	JMP H_SET
	

L_SET: ;个位数确定
	MOV 52H, R3
	MOV 42H, R3
	MOV 70H, R3
	MOV R0, #1fh
	MOV 50H, R0
	JMP PROCESS_END
H_SET: ;十位数确定
	MOV 53H, R3
	MOV 43H, R3
	MOV 70H, R3
	MOV R1, #1fh
	MOV 51H, R1
	JMP PROCESS_END
KE_T: ;输入终止符号'*‘
	CJNE R0, #11h, KE_T_A ;判断个位是否已经设置，若有设置，则跳转结束
	MOV R3, #05H
	MOV 52H, R3
	MOV 42H, R3
	KE_T_A:
	MOV 50H, #1fh
	MOV 51H, #1fh
	MOV 40H, #1fh
PROCESS_END:	
RET

LED_P:
	CLR P1.0
	CLR P1.7
	MOV R0, 52H ;获取个位数据
	MOV R1, 53H ;获取十位数据
	MOV R2, 44H ;获取终结标志位
	CJNE R2, #1FH, NP_NE
	SETB P1.0
	SETB P1.7
	CLR P0.1
	CLR P0.2
	CLR P0.3
	CLR P0.4
	CLR P0.5
	CLR P0.6

	SETB P1.0
	SETB P1.7
	SETB P0.0
	SETB P0.1
	SETB P0.2
	SETB P0.3
	SETB P0.4
	SETB P0.5
	SETB P0.6
	SETB P0.7
	JMP P_END
NP_NE:
	CJNE R0, #00H, NP_0A
	CLR P1.0 ;p a0
	CLR P1.7
	CLR P0.7
	CLR P0.4
	CLR P1.2
	CLR P1.3
	CLR P1.4
	CLR P1.5
	CLR P0.5
	CLR P0.6

	SETB P0.4
	SETB P0.5
	SETB P0.6
	SETB P0.7

	SETB P1.1
	SETB P1.2
	SETB P1.3
	SETB P1.4
	SETB P1.5
	SETB P1.6
	NP_0a:

	CJNE R0, #01H, NP_1A
	CLR P0.7;p a1
	SETB P0.7
	NP_1a:

	CJNE R0, #02H, NP_2A
	CLR P1.2;p a2 先画三条杠
	CLR P1.4
	CLR P1.5
	CLR P0.4
	CLR P0.5
	CLR P0.6
	CLR P0.7 ;画完三条杠

	SETB P0.4 ;画右上杠
	SETB P0.5
	SETB P0.6
	SETB P1.1
	SETB P1.2
	SETB P1.3
	CLR P1.4
	CLR P1.5
	CLR P1.6
	CLR P0.7

	SETB P0.7 ;画左下杠
	CLR P1.1
	CLR P1.2
	CLR P1.3
	SETB P1.4
	SETB P1.5
	SETB P1.6
	CLR P0.4

	SETB P0.4
	SETB P0.5
	SETB P0.6
	SETB P0.7

	SETB P1.1
	SETB P1.2
	SETB P1.3
	SETB P1.4
	SETB P1.5
	SETB P1.6
	NP_2a:

	CJNE R0, #03H, NP_3A
	CLR P1.2 ;p a3
	
	CLR P1.4
	CLR P1.5

	CLR P0.4
	CLR P0.5
	CLR P0.6
	CLR P0.7

	SETB P0.4
	SETB P0.5
	SETB P0.6

	SETB P1.1
	SETB P1.2
	SETB P1.3
	SETB P1.4
	SETB P1.5
	SETB P1.6
	CLR P0.7

	SETB P0.4
	SETB P0.5
	SETB P0.6
	SETB P0.7
	
	SETB P1.1
	SETB P1.2
	SETB P1.3
	SETB P1.4
	SETB P1.5
	SETB P1.6
	NP_3a:

	CJNE R0, #04H, NP_4A
	CLR P0.7;p a4

	CLR P1.4
	CLR P1.5
	CLR P1.6
	CLR P0.4

	CLR P1.1
	CLR P1.2
	CLR P0.5
	CLR P0.6

	SETB P0.4
	SETB P0.5
	SETB P0.6
	SETB P0.7

	SETB P1.1
	SETB P1.2
	SETB P1.3
	SETB P1.4
	SETB P1.5
	SETB P1.6
	NP_4a:

	CJNE R0, #05H, NP_5A
	CLR P1.2 ;p a5
	CLR P1.4
	CLR P1.5
	CLR P0.4
	CLR P0.5
	CLR P0.6
	CLR P0.7

	SETB P0.5
	SETB P0.6
	SETB P0.7
	SETB P1.1
	SETB P1.2

	SETB P0.4
	CLR P1.1
	CLR P1.2
	SETB P1.4
	SETB P1.5
	SETB P1.6
	CLR P0.7

	SETB P0.4
	SETB P0.5
	SETB P0.6
	SETB P0.7

	SETB P1.1
	SETB P1.2
	SETB P1.3
	SETB P1.4
	SETB P1.5
	SETB P1.6
	NP_5a:

	CJNE R0, #06H, NP_6A
	CLR P0.4;p a6
	CLR P1.2
	CLR P1.4
	CLR P1.5
	CLR P0.4
	CLR P0.5
	CLR P0.6
	CLR P0.7

	CLR P1.1
	CLR P1.2
	SETB P1.3
	SETB P0.5
	SETB P0.6
	SETB P1.4
	SETB P1.5
	SETB P1.6
	CLR P0.7

	SETB P0.4
	SETB P0.5
	SETB P0.6
	SETB P0.7

	SETB P1.1
	SETB P1.2
	SETB P1.3
	SETB P1.4
	SETB P1.5
	SETB P1.6	
	NP_6a:

	CJNE R0, #07H, NP_7A
	CLR P0.7;p a7
	CLR P1.2
	CLR P1.3
	CLR P1.4
	CLR P1.5
	CLR P1.6
	CLR P0.4
	CLR P0.5
	CLR P0.6
	CLR P0.7

	SETB P0.4
	SETB P0.5
	SETB P0.6
	SETB P0.7

	SETB P1.1
	SETB P1.2
	SETB P1.3
	SETB P1.4
	SETB P1.5
	SETB P1.6
	NP_7a:

	CJNE R0, #08H, NP_8A
	CLR P0.4;p a8
	CLR P1.2
	CLR P1.4
	CLR P1.5
	CLR P0.4
	CLR P0.5
	CLR P0.6
	CLR P0.7

	SETB P0.5
	SETB P0.6
	SETB P1.1
	SETB P1.2
	SETB P1.3
	SETB P1.4
	SETB P1.5
	SETB P1.6

	SETB P0.4
	SETB P0.5
	SETB P0.6
	SETB P0.7

	SETB P1.1
	SETB P1.2
	SETB P1.3
	SETB P1.4
	SETB P1.5
	SETB P1.6
	NP_8a:

	CJNE R0, #09H, NP_9A
	CLR P0.7;p a9

	CLR P1.2
	CLR P1.4
	CLR P1.5
	CLR P1.6

	CLR P0.4
	CLR P0.5
	CLR P0.6

	SETB P0.5
	SETB P0.6
	SETB P1.1
	SETB P1.2
	CLR P0.4

	SETB P0.4
	SETB P0.5
	SETB P0.6
	SETB P0.7

	SETB P1.1
	SETB P1.2
	SETB P1.3
	SETB P1.4
	SETB P1.5
	SETB P1.6
	NP_9a:

	CJNE R1, #00H, NP_0b
	CLR P0.3;p b0
	CLR P0.0
	CLR P1.2
	CLR P1.3
	CLR P1.4
	CLR P1.5
	CLR P0.1
	CLR P0.2

	SETB P0.0
	SETB P0.1
	SETB P0.2
	SETB P0.3

	SETB P1.1
	SETB P1.2
	SETB P1.3
	SETB P1.4
	SETB P1.5
	SETB P1.6
	NP_0b:

	CJNE R1, #01H, NP_1b
	CLR P0.3;p b1
	SETB P0.3
	NP_1b:

	CJNE R1, #02H, NP_2b
	CLR P1.2;p b2 先画三条杠
	CLR P1.4
	CLR P1.5
	CLR P0.0
	CLR P0.1
	CLR P0.2
	CLR P0.3 ;画完三条杠

	SETB P0.0 ;画右上杠
	SETB P0.1
	SETB P0.2
	SETB P1.1
	SETB P1.2
	SETB P1.3
	CLR P1.4
	CLR P1.5
	CLR P1.6
	CLR P0.3

	SETB P0.3 ;画左下杠
	CLR P1.1
	CLR P1.2
	CLR P1.3
	SETB P1.4
	SETB P1.5
	SETB P1.6
	CLR P0.0

	SETB P0.0
	SETB P0.1
	SETB P0.2
	SETB P0.3

	SETB P1.1
	SETB P1.2
	SETB P1.3
	SETB P1.4
	SETB P1.5
	SETB P1.6
	NP_2b:

	CJNE R1, #03H, NP_3b
	CLR P1.2 ;p b3
	
	CLR P1.4
	CLR P1.5

	CLR P0.0
	CLR P0.1
	CLR P0.2
	CLR P0.3

	SETB P0.0
	SETB P0.1
	SETB P0.2

	SETB P1.1
	SETB P1.2
	SETB P1.3
	SETB P1.4
	SETB P1.5
	SETB P1.6
	CLR P0.3

	SETB P0.0
	SETB P0.1
	SETB P0.2
	SETB P0.3

	SETB P1.1
	SETB P1.2
	SETB P1.3
	SETB P1.4
	SETB P1.5
	SETB P1.6
	NP_3b:

	CJNE R1, #04H, NP_4b
	CLR P0.3;p b4

	CLR P1.4
	CLR P1.5
	CLR P1.6
	CLR P0.0

	CLR P1.1
	CLR P1.2
	CLR P0.1
	CLR P0.2

	SETB P0.0
	SETB P0.1
	SETB P0.2
	SETB P0.3

	SETB P1.1
	SETB P1.2
	SETB P1.3
	SETB P1.4
	SETB P1.5
	SETB P1.6
	NP_4b:

	CJNE R1, #05H, NP_5b
	CLR P1.2;p b5
	CLR P1.4
	CLR P1.5
	CLR P0.0
	CLR P0.1
	CLR P0.2
	CLR P0.3

	SETB P0.1
	SETB P0.2
	SETB P0.3
	SETB P1.0
	SETB P1.1
	SETB P1.2

	SETB P0.0
	CLR P1.1
	CLR P1.2
	SETB P1.4
	SETB P1.5
	SETB P1.6
	CLR P0.3

	SETB P0.0
	SETB P0.1
	SETB P0.2
	SETB P0.3

	SETB P1.1
	SETB P1.2
	SETB P1.3
	SETB P1.4
	SETB P1.5
	SETB P1.6
	NP_5b:

	CJNE R1, #06H, NP_6b
	CLR P0.0;p b6
	CLR P1.2
	CLR P1.4
	CLR P1.5
	CLR P0.0
	CLR P0.1
	CLR P0.2
	CLR P0.3

	CLR P1.1
	CLR P1.2
	SETB P1.3
	SETB P0.1
	SETB P0.2
	SETB P1.4
	SETB P1.5
	SETB P1.6
	CLR P0.3

	SETB P0.0
	SETB P0.1
	SETB P0.2
	SETB P0.3

	SETB P1.1
	SETB P1.2
	SETB P1.3
	SETB P1.4
	SETB P1.5
	SETB P1.6
	NP_6b:

	CJNE R1, #07H, NP_7b
	CLR P0.3;p b7

	CLR P1.2
	CLR P1.3
	CLR P1.4
	CLR P1.5
	CLR P1.6
	CLR P0.0
	CLR P0.1
	CLR P0.2
	CLR P0.3

	SETB P0.0
	SETB P0.1
	SETB P0.2
	SETB P0.3

	SETB P1.1
	SETB P1.2
	SETB P1.3
	SETB P1.4
	SETB P1.5
	SETB P1.6	
	NP_7b:

	CJNE R1, #08H, NP_8b
	CLR P0.0;p b8
	CLR P0.3
	
	CLR P1.2
	CLR P1.4
	CLR P1.5
	CLR P0.0
	CLR P0.1
	CLR P0.2
	CLR P0.3

	SETB P0.1
	SETB P0.2
	SETB P1.1
	SETB P1.2
	SETB P1.3
	SETB P1.4
	SETB P1.5
	SETB P1.6

	SETB P0.0
	SETB P0.1
	SETB P0.2
	SETB P0.3

	SETB P1.0
	SETB P1.1
	SETB P1.2
	SETB P1.3
	SETB P1.4
	SETB P1.5
	SETB P1.6
	SETB P1.7
	NP_8b:

	CJNE R1, #09H, NP_9b
	CLR P0.3;p b9
	CLR P1.2
	CLR P1.4
	CLR P1.5
	CLR P1.6
	CLR P0.0
	CLR P0.1
	CLR P0.2

	SETB P0.1
	SETB P0.2
	SETB P1.1
	SETB P1.2
	CLR P0.0

	SETB P0.0
	SETB P0.1
	SETB P0.2
	SETB P0.3

	SETB P1.1
	SETB P1.2
	SETB P1.3
	SETB P1.4
	SETB P1.5
	SETB P1.6
	NP_9b:
	
P_END:
RET


COUNT_DOWN:
	CALL LED_P
	CALL DELAY

	CLR P2.0
	CLR C ;1,4
	MOV C, P2.7
	JC R4_L1_NI_E
	MOV 5BH, #1fh
	JMP R4_L1_I_E
	R4_L1_NI_E:
	MOV 5BH, #11h
	R4_L1_I_E:
	SETB P2.0

	MOV R0, 5BH
	CJNE R0, #11h, COUNT_DOWN
	
COUNT_DOWN_CC:
	MOV R0, #11H
	MOV R1, #1fH
	CLR P2.1
	CLR C ;2,4
	MOV C, P2.7
	JC R4_L2_NI_D
	MOV 41H, R1
	JMP R4_L2_I_D
	R4_L2_NI_D:
	MOV 41H, R0
	R4_L2_I_D:
	SETB P2.1 ;结束第二列搜索!!!!
	MOV R0, 41H
	CJNE R0, #1fh, COUNT_DOWN_CONTINUE
	MOV R0, 42H 
	MOV R1, 43H
	MOV 52H, R0
	MOV 53H, R1
	JMP COUNT_DOWN
	
COUNT_DOWN_CONTINUE:
	MOV R0, 52H ;个位
	MOV R1, 53H ;十位


	CJNE R0, #00h, L_NZERO ;判断底位是否为0，如果不为0则，正常倒计时
	CJNE R1, #00h, H_NZERO ;判断底位为0的情况下，高位是否为0，为0则推出循环，否则借位给低位
	jmp COUNT_END
L_NZERO:
	DEC R0
	MOV 52H, R0
	jmp count_down
H_NZERO:
	DEC R1
	MOV 53H, R1
	MOV R0, #09H
	MOV 52H, R0
	jmp count_down
COUNT_END:
RET

DELAY:
	MOV R1, #02h
DELAY2_f:
	MOV R2, #1fh
DELAY2:
	DEC R2
	CJNE R2, #00h, DELAY2
	DEC R1
	CJNE R1, #00h, DELAY2_F
RET

FINAL_PROC:
	MOV R0, #1fh
	MOV 44H, R0 ;终结标志位
	MOV R0, #04h
	MOV 52H, R0
	MOV R0, #00h
	MOV 53H, R0
count_down_E:
	CALL LED_P
	;CALL DELAY

	CJNE R0, #00h, L_NZERO_E
	CJNE R1, #00h, H_NZERO_E
	jmp COUNT_END_E
L_NZERO_E:
	DEC R0
	MOV 52H, R0
	jmp count_down_E
H_NZERO_E:
	DEC R1
	MOV 53H, R1
	MOV R0, #09H
	MOV 52H, R0
	jmp count_down_E
COUNT_END_E:
RET

EXIT:
END