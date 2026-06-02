       IDENTIFICATION DIVISION.
       PROGRAM-ID. PURI.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  ARY-TABLE.
           03 ARY-NUM     PIC 9(3) OCCURS   10 TIMES.
       
       01  WK-IDX          PIC 9(2)  VALUE ZERO.
       01  WK-MAX          PIC 9(3)    VALUE ZERO.


       PROCEDURE DIVISION.
           MOVE 8 TO ARY-NUM(1).
           MOVE 2 TO ARY-NUM(2).
           MOVE 67 TO ARY-NUM(3).
           MOVE 281 TO ARY-NUM(4).
           MOVE 90 TO ARY-NUM(5).
           MOVE 34 TO ARY-NUM(6).
           MOVE 64 TO ARY-NUM(7).
           MOVE 67 TO ARY-NUM(8).
           MOVE 352 TO ARY-NUM(9).
           MOVE 121 TO ARY-NUM(10).

           PERFORM VARYING WK-IDX FROM 1 BY 1
                   UNTIL WK-IDX > 10
               IF ARY-NUM(WK-IDX) > WK-MAX
                   MOVE ARY-NUM(WK-IDX) TO WK-MAX
               END-IF
           END-PERFORM.
            
           
           DISPLAY "MAX SCORE".
           DISPLAY WK-MAX.
           STOP RUN.
           
