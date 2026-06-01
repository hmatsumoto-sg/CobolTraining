       IDENTIFICATION      DIVISION.
       PROGRAM-ID. PICN.
      ******************************************************************
      * システム名    ：サンプル
      * サブシステム名：
      * プログラム名  ：N(National) 型の確認
      * 作成日／作成者：２０２５年１０月２９日  システム技研
      * 変更日／変更者：
      *       変更内容：
      ******************************************************************

       ENVIRONMENT         DIVISION.
       INPUT-OUTPUT        SECTION.
       FILE-CONTROL.
           SELECT OTF-FILE ASSIGN TO OTF.

       DATA                DIVISION.
       FILE                SECTION.
       FD  OTF-FILE.
       01  OTF-REC.
      *  ZONED
         03  JMSG          PIC  N(10)  VALUE  SPACE.

       PROCEDURE           DIVISION.
           OPEN  OUTPUT  OTF-FILE.
      *
           MOVE  SPACE    TO OTF-REC.
      *
           MOVE  "こんにちは"  TO  JMSG.
      *
           WRITE  OTF-REC.
           CLOSE  OTF-FILE.
      *
           STOP RUN.
