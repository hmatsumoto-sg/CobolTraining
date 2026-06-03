       IDENTIFICATION DIVISION.
       PROGRAM-ID.    KJBM010.
      ******************************************************************
      * システム名　　：研修
      * サブシステム名：受注
      * プログラム名　：受注チェックファイル作成
      * 作成日／作成者：2026/06/03　松本 拓
      * 変更日／変更者：
      * 　　　変更内容：
      ******************************************************************

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT  ITF-FILE    ASSIGN TO ITF
           ORGANIZATION LINE SEQUENTIAL.

           SELECT  OTF-FILE    ASSIGN TO OTF
           ORGANIZATION SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  ITF-FILE.
       01  ITF-REC.
           COPY KJCF010.

       FD  OTF-FILE.
       01  OTF-REC.
           COPY KJCF020.
           
       WORKING-STORAGE SECTION.
       01  WK-EOF              PIC X(1)    VALUE "N".
       01  WK-CNT              PIC 9(2)    VALUE ZERO.


       PROCEDURE DIVISION.

       INIT-RTN SECTION.
           DISPLAY "*** KJBM010 START ***"
      *ファイルの読み込み
           OPEN INPUT ITF-FILE.
           OPEN OUTPUT OTF-FILE.
       
      *ファイルの中が空だったら処理をやめる
           READ ITF-FILE
               AT END
                   MOVE "Y" TO WK-EOF
               END-READ.
       EXT.
           EXIT.
       
       MAIN-RTN SECTION.
      *転送処理
           PERFORM UNTIL WK-EOF = "Y"
      *レコードのクリア
               MOVE " " TO OTF-REC
               
               MOVE ZERO TO JF020-JUCHU-Y1
               MOVE ZERO TO JF020-TANKA
               MOVE ZERO TO JF020-KINGAKU
               MOVE JF010-DATA-KBN TO JF020-DATA-KBN
               MOVE JF010-JUCHU-NO-X TO JF020-JUCHU-NO-X
               MOVE JF010-JUCHU-DATE TO JF020-JUCHU-DATE6
               MOVE JF010-SHOHIN-NO TO JF020-SHOHIN-NO-X
               MOVE JF010-SURYO-X TO JF020-SURYO-X
               WRITE  OTF-REC
               ADD 1 TO WK-CNT
               READ ITF-FILE
                   AT END MOVE "Y" TO WK-EOF
               END-READ
           END-PERFORM.
       EXT.
           EXIT.

       TERM-RTN SECTION.
      *開いたファイルを閉じる 
           CLOSE ITF-FILE.
           CLOSE OTF-FILE.
           
           DISPLAY "***KJBM010 ITF: <" WK-CNT ">".
           DISPLAY "*** KJBM010 END ***".

           STOP RUN.
       EXT.
           EXIT.






