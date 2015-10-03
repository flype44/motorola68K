;==========================================================
; ASM Testcase
; flype, 2015-10-03, v1.0
; Greatest Common Divisor
; GCD(15,24)=3
;==========================================================

;==========================================================
; Constants
;==========================================================

ASSERT_ZERO EQU $00D0000C

;==========================================================
; MAIN()
;==========================================================
    
    BRA MAIN

RESULT DS.W 1

MAIN:
    CLR.L   D0             ; Value 1
    CLR.L   D1             ; Value 2
    CLR.L   D2             ; Precalc GCD
    CLR.L   D3             ; Precalc SQRT(GCD)
    CLR.L   D4             ; POW Exponent
    CLR.L   D5             ; Precalc POW(GCD)
    CLR.L   D6             ; Number of values processed
    CLR.L   D7             ; Error counter
    LEA.L   VALUES,A0
MAIN_LOOP:
    MOVE.L  (A0)+,D0       ; Value 1
    BEQ.W   MAIN_EXIT      ; Exit if no more value
    MOVE.L  (A0)+,D1       ; Value 2
    MOVE.L  (A0)+,D2       ; Precalc GCD
    MOVE.L  (A0)+,D3       ; Precalc SQRT(GCD)
    MOVE.L  (A0)+,D4       ; POW Exponent
    MOVE.L  (A0)+,D5       ; Precalc POW(GCD)
    ADDQ.L  #1,D6          ; Increment Number of values processed
    JSR     GCD            ; GCD(D0,D1)
    SUB.W   D1,D2          ; D2 = Precalc GCD - Calc
    MOVE.W  D1,RESULT      ; 
    BEQ     MAIN_ASSERT    ; Branch to Assert if D2 = 0
    ADDQ.L  #1,D7          ; Increment Error counter
MAIN_ASSERT:
    MOVE.L  D2,ASSERT_ZERO ; Assert D2 = 0
    MOVE.W  D1,D0
    JSR     SQRT           ; SQRT(D1)
    SUB.W   D2,D3          ; D3 = Precalc SQRT(GCD) - Calc
    MOVE.L  D3,ASSERT_ZERO ; Assert D3 = 0
    MOVE.W  RESULT,D0      ; 
    MOVE.W  D4,D1          ; 
    JSR     POW            ; POW(D0, D1)
    SUB.L   D7,D5          ; D5 = Precalc POW(GCD) - Calc
    MOVE.L  D5,ASSERT_ZERO ; Assert D5 = 0
    BRA     MAIN_LOOP      ; Continue
MAIN_EXIT:
    SUB.L   #200,D6        ; D6 - Number of values processed
    MOVE.L  D6,ASSERT_ZERO ; Assert D6 = 0
    MOVE.L  D7,ASSERT_ZERO ; Assert D7 = 0
    STOP    #-1            ; Stop on Sim

;==========================================================
; D1 = GCD(D0,D1)
;==========================================================

GCD:
    TST.W   D0
    BEQ     GCD_EXIT
    CMP.W   D1,D0
    BGT     GCD_SKIP
    EXG     D0,D1
GCD_SKIP:
    SUB.W   D1,D0
    BRA     GCD
GCD_EXIT:
    RTS

;===================================================
; D2 = SQRT(D0)
;===================================================

SQRT:
    CLR.L   D1             ; D1 = 0
    CLR.L   D2             ; D2 = 0
SQRT_LOOP:
    ADDI.L  #1,D2          ; D2 + 1
    MOVE.L  D2,D1          ; D1 = D2
    MULU.W  D1,D1          ; D1 * D1
    CMP.L   D0,D1          ; If D1 <= D0
    BLE     SQRT_LOOP      ; Then continue
    SUBI.L  #1,D2          ; D2 - 1
    RTS                    ; Exit SubRoutine

;===================================================
; D7 = POW(D0, D1)
;===================================================

POW:
    MOVEM.L D0-D3,-(SP) ; Save registers
    CLR.L   D2          ; D2 = 0
    CLR.L   D3          ; D3 = 0
    CLR.L   D7          ; D7 = 0
    CMPI.L  #0,D0       ; Test Number
    BEQ     POWX        ; If D0 = 0 Then Exit
    MOVE.L  #1,D7       ; D7 = 1
POWE:
    CMPI.L  #0,D1       ; Test Exponent
    BEQ     POWX        ; If D1 = 0 Then Exit
    SUBI.L  #1,D1       ; D1 = D1 - 1
    MOVE.L  D0,D2       ; D2 = D0
    MOVE.L  D7,D3       ; D3 = D7
POWN:
    CMPI.L  #1,D2       ; Test Number
    BEQ     POWE        ; If D2 = 1 Then branch to PowE
    SUBI.L  #1,D2       ; D2 = D2 - 1
    ADD.L   D3,D7       ; D7 = D7 + D3
    BRA     POWN        ; Branch to PowN
POWX:
    MOVEM.L (SP)+,D0-D3 ; Restore registers
    RTS                 ; Exit SubRoutine

;==========================================================
; Data Section
;==========================================================

VALUES:
    DC.L 519,692,173,13,3,5177717
    DC.L 825,525,75,8,5,2373046875
    DC.L 126,462,42,6,3,74088
    DC.L 715,330,55,7,2,3025
    DC.L 390,624,78,8,1,78
    DC.L 425,510,85,9,2,7225
    DC.L 110,660,110,10,2,12100
    DC.L 513,912,57,7,5,601692057
    DC.L 310,186,62,7,1,62
    DC.L 868,806,62,7,3,238328
    DC.L 451,205,41,6,2,1681
    DC.L 459,306,153,12,2,23409
    DC.L 386,772,386,19,2,148996
    DC.L 364,728,364,19,5,6390089165824
    DC.L 920,552,184,13,5,210906087424
    DC.L 855,380,95,9,2,9025
    DC.L 805,644,161,12,1,161
    DC.L 265,477,53,7,5,418195493
    DC.L 264,836,44,6,4,3748096
    DC.L 368,138,46,6,4,4477456
    DC.L 423,893,47,6,3,103823
    DC.L 595,850,85,9,2,7225
    DC.L 424,530,106,10,2,11236
    DC.L 600,500,100,10,4,100000000
    DC.L 658,987,329,18,4,11716114081
    DC.L 53,265,53,7,1,53
    DC.L 756,972,108,10,5,14693280768
    DC.L 336,840,168,12,5,133827821568
    DC.L 779,164,41,6,4,2825761
    DC.L 427,366,61,7,3,226981
    DC.L 312,884,52,7,5,380204032
    DC.L 943,902,41,6,1,41
    DC.L 420,720,60,7,3,216000
    DC.L 873,388,97,9,5,8587340257
    DC.L 67,670,67,8,2,4489
    DC.L 235,940,235,15,4,3049800625
    DC.L 420,660,60,7,1,60
    DC.L 77,462,77,8,2,5929
    DC.L 434,930,62,7,1,62
    DC.L 968,748,44,6,1,44
    DC.L 832,988,52,7,4,7311616
    DC.L 496,186,62,7,3,238328
    DC.L 576,336,48,6,4,5308416
    DC.L 348,406,58,7,5,656356768
    DC.L 506,874,46,6,3,97336
    DC.L 532,684,76,8,2,5776
    DC.L 780,585,195,13,2,38025
    DC.L 56,840,56,7,3,175616
    DC.L 60,540,60,7,3,216000
    DC.L 276,644,92,9,4,71639296
    DC.L 672,144,48,6,1,48
    DC.L 246,697,41,6,5,115856201
    DC.L 234,312,78,8,4,37015056
    DC.L 561,306,51,7,1,51
    DC.L 82,943,41,6,4,2825761
    DC.L 106,901,53,7,4,7890481
    DC.L 189,441,63,7,3,250047
    DC.L 364,156,52,7,1,52
    DC.L 312,988,52,7,3,140608
    DC.L 612,136,68,8,2,4624
    DC.L 66,462,66,8,3,287496
    DC.L 242,968,242,15,3,14172488
    DC.L 682,496,62,7,5,916132832
    DC.L 82,123,41,6,1,41
    DC.L 793,915,61,7,3,226981
    DC.L 495,297,99,9,3,970299
    DC.L 885,118,59,7,5,714924299
    DC.L 174,986,58,7,3,195112
    DC.L 810,648,162,12,4,688747536
    DC.L 504,392,56,7,1,56
    DC.L 871,603,67,8,4,20151121
    DC.L 969,102,51,7,1,51
    DC.L 360,405,45,6,3,91125
    DC.L 891,243,81,9,5,3486784401
    DC.L 960,576,192,13,5,260919263232
    DC.L 672,896,224,14,4,2517630976
    DC.L 884,624,52,7,4,7311616
    DC.L 936,884,52,7,1,52
    DC.L 379,758,379,19,5,7819807277899
    DC.L 329,188,47,6,2,2209
    DC.L 294,210,42,6,1,42
    DC.L 972,756,108,10,3,1259712
    DC.L 340,765,85,9,3,614125
    DC.L 325,130,65,8,4,17850625
    DC.L 244,488,244,15,4,3544535296
    DC.L 930,558,186,13,4,1196883216
    DC.L 450,540,90,9,2,8100
    DC.L 426,639,213,14,5,438427732293
    DC.L 371,689,53,7,3,148877
    DC.L 402,603,201,14,3,8120601
    DC.L 452,678,226,15,4,2608757776
    DC.L 214,321,107,10,4,131079601
    DC.L 152,380,76,8,2,5776
    DC.L 495,855,45,6,4,4100625
    DC.L 833,196,49,7,4,5764801
    DC.L 252,714,42,6,5,130691232
    DC.L 714,476,238,15,1,238
    DC.L 684,513,171,13,4,855036081
    DC.L 605,770,55,7,3,166375
    DC.L 306,408,102,10,2,10404
    DC.L 430,860,430,20,1,430
    DC.L 330,385,55,7,2,3025
    DC.L 237,632,79,8,5,3077056399
    DC.L 312,546,78,8,3,474552
    DC.L 960,880,80,8,3,512000
    DC.L 385,154,77,8,1,77
    DC.L 448,320,64,8,4,16777216
    DC.L 333,999,333,18,3,36926037
    DC.L 141,940,47,6,1,47
    DC.L 192,512,64,8,2,4096
    DC.L 296,518,74,8,3,405224
    DC.L 272,340,68,8,5,1453933568
    DC.L 500,750,250,15,2,62500
    DC.L 153,357,51,7,2,2601
    DC.L 715,220,55,7,3,166375
    DC.L 106,159,53,7,5,418195493
    DC.L 284,568,284,16,4,6505390336
    DC.L 690,460,230,15,1,230
    DC.L 188,141,47,6,1,47
    DC.L 495,675,45,6,2,2025
    DC.L 215,688,43,6,1,43
    DC.L 737,603,67,8,5,1350125107
    DC.L 340,850,170,13,3,4913000
    DC.L 167,334,167,12,5,129891985607
    DC.L 110,495,55,7,2,3025
    DC.L 765,935,85,9,1,85
    DC.L 272,544,272,16,3,20123648
    DC.L 408,153,51,7,2,2601
    DC.L 648,891,81,9,5,3486784401
    DC.L 780,845,65,8,2,4225
    DC.L 704,576,64,8,2,4096
    DC.L 305,854,61,7,1,61
    DC.L 247,988,247,15,4,3722098081
    DC.L 375,600,75,8,1,75
    DC.L 539,231,77,8,4,35153041
    DC.L 833,588,49,7,4,5764801
    DC.L 564,705,141,11,2,19881
    DC.L 188,893,47,6,2,2209
    DC.L 138,621,69,8,2,4761
    DC.L 625,250,125,11,2,15625
    DC.L 370,148,74,8,1,74
    DC.L 77,462,77,8,3,456533
    DC.L 469,402,67,8,2,4489
    DC.L 660,88,44,6,3,85184
    DC.L 525,150,75,8,2,5625
    DC.L 750,550,50,7,2,2500
    DC.L 992,558,62,7,2,3844
    DC.L 160,640,160,12,4,655360000
    DC.L 420,780,60,7,4,12960000
    DC.L 290,986,58,7,2,3364
    DC.L 874,322,46,6,5,205962976
    DC.L 96,336,48,6,4,5308416
    DC.L 114,342,114,10,5,19254145824
    DC.L 99,495,99,9,2,9801
    DC.L 950,900,50,7,2,2500
    DC.L 840,448,56,7,2,3136
    DC.L 873,388,97,9,1,97
    DC.L 294,882,294,17,2,86436
    DC.L 284,852,284,16,5,1847530855424
    DC.L 780,676,52,7,1,52
    DC.L 70,980,70,8,1,70
    DC.L 328,574,82,9,5,3707398432
    DC.L 573,955,191,13,3,6967871
    DC.L 288,672,96,9,5,8153726976
    DC.L 704,836,44,6,4,3748096
    DC.L 90,495,45,6,1,45
    DC.L 180,540,180,13,4,1049760000
    DC.L 704,512,64,8,5,1073741824
    DC.L 864,792,72,8,4,26873856
    DC.L 555,740,185,13,4,1171350625
    DC.L 715,660,55,7,5,503284375
    DC.L 801,445,89,9,4,62742241
    DC.L 90,540,90,9,4,65610000
    DC.L 504,112,56,7,5,550731776
    DC.L 576,504,72,8,3,373248
    DC.L 473,860,43,6,1,43
    DC.L 380,228,76,8,4,33362176
    DC.L 86,172,86,9,4,54700816
    DC.L 73,365,73,8,1,73
    DC.L 605,770,55,7,3,166375
    DC.L 533,697,41,6,1,41
    DC.L 445,623,89,9,3,704969
    DC.L 708,885,177,13,5,173726604657
    DC.L 924,594,66,8,1,66
    DC.L 605,550,55,7,1,55
    DC.L 799,423,47,6,1,47
    DC.L 198,297,99,9,2,9801
    DC.L 399,513,57,7,5,601692057
    DC.L 497,923,71,8,1,71
    DC.L 630,140,70,8,5,1680700000
    DC.L 675,990,45,6,3,91125
    DC.L 611,752,47,6,4,4879681
    DC.L 120,180,60,7,5,777600000
    DC.L 440,990,110,10,4,146410000
    DC.L 408,153,51,7,2,2601
    DC.L 405,765,45,6,3,91125
    DC.L 237,553,79,8,3,493039
    DC.L 770,980,70,8,1,70
    DC.L 376,893,47,6,2,2209
    DC.L 64,768,64,8,1,64
    DC.L 0

;==========================================================
; End of file
;==========================================================
    
    END
