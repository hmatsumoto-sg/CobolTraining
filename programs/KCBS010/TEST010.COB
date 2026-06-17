       IDENTIFICATION  DIVISION.
       PROGRAM-ID.     TEST010.
      ******************************************************************
      * システム名　　：研修
      * サブシステム名：共通
      * プログラム名　：日付チェック
      * 作成日／作成者：2026/06/17　松本 拓
      ******************************************************************
       DATA            DIVISION.
       WORKING-STORAGE SECTION.
       COPY KCBS010P.
   
       PROCEDURE       DIVISION.
      ******************************************************************
      * メイン処理
      ******************************************************************
       MAIN-RTN  SECTION.
           DISPLAY "*** TEST010 START ***".
   
           DISPLAY "2026/06/17"
           INITIALIZE KCBS010-P1
           MOVE 2026 TO S010-D8-YY
           MOVE 06   TO S010-D8-MM
           MOVE 17   TO S010-D8-DD
           PERFORM CALL-RTN
           DISPLAY "  RESULT: RCD='" S010-RCD "' DATE=" S010-DATE8
   
           DISPLAY "*** TEST010 END ***".
           STOP RUN.
       EXT.
           EXIT.
   
      ******************************************************************
      * サブプログラム呼び出しセクション
      ******************************************************************
       CALL-RTN  SECTION.
           CALL 'KCBS010' USING KCBS010-P1.
       EXT.
           EXIT.
