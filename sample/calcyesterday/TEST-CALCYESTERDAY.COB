       IDENTIFICATION DIVISION.
       PROGRAM-ID. TEST-CALCYESTERDAY.
      ******************************************************************
      * システム名    ：サンプル
      * サブシステム名：
      * プログラム名  ：末日を計算するサブプログラムのスタブ
      * 作成日／作成者：２０２５年１０月２９日  システム技研
      * 変更日／変更者：
      *       変更内容：
      ******************************************************************
       ENVIRONMENT DIVISION.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY  CALCYESTERDAY-PARAMS.

       PROCEDURE DIVISION.
           DISPLAY "*** SYSTEM-DATE ***".

           MOVE  FUNCTION CURRENT-DATE  TO  DATE-YYYYMMDD.
           PERFORM CALL-CALCYESTERDAY.
       
           DISPLAY "*** FOR LEAP-YEAR ***".

           MOVE  "20000301"  TO  DATE-YYYYMMDD.
           PERFORM CALL-CALCYESTERDAY.

           MOVE  "20200301"  TO  DATE-YYYYMMDD.
           PERFORM CALL-CALCYESTERDAY.
       
           MOVE  "21000301"  TO  DATE-YYYYMMDD.
           PERFORM CALL-CALCYESTERDAY.

           MOVE  "20210301"  TO  DATE-YYYYMMDD.
           PERFORM CALL-CALCYESTERDAY.

           DISPLAY "*** FOR INVALID PARAM ***".
           MOVE  "2021030A"  TO  DATE-YYYYMMDD.
           PERFORM CALL-CALCYESTERDAY.

           MOVE  "A021030A"  TO  DATE-YYYYMMDD.
           PERFORM CALL-CALCYESTERDAY.

           MOVE  "20241332"  TO  DATE-YYYYMMDD.
           PERFORM CALL-CALCYESTERDAY.

           STOP RUN.
       
       CALL-CALCYESTERDAY SECTION.
           CALL  "CALCYESTERDAY"  USING  CALCYESTERDAY-P1.
           DISPLAY DATE-YYYYMMDD " -> " YESTERDAY-YYYYMMDD " ERR=" ERR.
           EXIT.
