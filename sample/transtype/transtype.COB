       IDENTIFICATION      DIVISION.
       PROGRAM-ID.         TRZ2P.
      ******************************************************************
      * システム名    ：サンプル
      * サブシステム名：
      * プログラム名  ：転記時の型の自動変換
      * 作成日／作成者：２０２５年１０月２９日  システム技研
      * 変更日／変更者：
      *       変更内容：
      ******************************************************************
       ENVIRONMENT         DIVISION.
       INPUT-OUTPUT        SECTION.
       FILE-CONTROL.
      * 入力側は行順ファイルが取り扱いしやすい
           SELECT ITF-FILE ASSIGN TO ITF
               ORGANIZATION LINE SEQUENTIAL.
           SELECT OTF-FILE ASSIGN TO OTF.
      *
       DATA                DIVISION.
       FILE                SECTION.
       FD ITF-FILE.
       01  ITF-REC.
      *    入力データ。パック形式をゾーン形式で定義しなおす。
      *    もし、行末のFILLERは削除したものを定義する。
           03   SHOUHIN     PIC X(20).
           03   SURYO       PIC 9(5).

       FD OTF-FILE.
       01  OTF-REC.
      *    出力データ(本来のテストデータになるもの)
           03   SHOUHIN     PIC X(20).
           03   SURYO       PIC 9(5)    PACKED-DECIMAL.

       WORKING-STORAGE      SECTION.
       01  ITF-END-FLG     PIC   X     VALUE  'N'.

       PROCEDURE           DIVISION.
           OPEN  INPUT   ITF-FILE.
           OPEN  OUTPUT  OTF-FILE.

           PERFORM  UNTIL  ITF-END-FLG  =  "Y"
             READ  ITF-FILE
               AT  END
                 MOVE  "Y"  TO  ITF-END-FLG
               NOT  AT  END
                 MOVE  CORR  ITF-REC  TO  OTF-REC
                 WRITE  OTF-REC
             END-READ
           END-PERFORM.

           CLOSE  OTF-FILE.
           CLOSE  ITF-FILE.
      *
           STOP RUN.
