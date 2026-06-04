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
       01  WK-IN-CNT              PIC 9(3)    VALUE ZERO.
       01  WK-OUT-CNT              PIC 9(3)    VALUE ZERO.


       PROCEDURE DIVISION.
      ******************************************************************
      * メイン処理
      ******************************************************************
           PERFORM INIT-RTN .
           PERFORM MAIN-RTN UNTIL WK-EOF = "Y".
           PERFORM TERM-RTN .
           STOP RUN.
           

       INIT-RTN SECTION.
      ******************************************************************
      * 初期処理：開始メッセージ表示、ファイルの読み込み・中身チェック
      ******************************************************************
           DISPLAY "*** KJBM010 START ***".
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
      ******************************************************************
      * 転送処理：レコードのクリア、出力ファイルへの転記
      ******************************************************************
      *レコードのクリア
           MOVE SPACE TO OTF-REC
               
           MOVE ZERO TO JF020-JUCHU-Y1
           MOVE SPACE TO JF020-ERR-KBN-TBL
           MOVE SPACE TO JF020-SHOHIN-MEI
           MOVE ZERO TO JF020-TANKA
           MOVE ZERO TO JF020-KINGAKU
           MOVE JF010-DATA-KBN TO JF020-DATA-KBN
           MOVE JF010-JUCHU-NO-X TO JF020-JUCHU-NO-X
           MOVE JF010-JUCHU-DATE TO JF020-JUCHU-DATE6
           MOVE JF010-SHOHIN-NO TO JF020-SHOHIN-NO-X
           MOVE JF010-SURYO-X TO JF020-SURYO-X
           WRITE  OTF-REC
           ADD 1 TO WK-IN-CNT
           READ ITF-FILE
             AT END
               ADD 1 TO WK-OUT-CNT 
               MOVE "Y" TO WK-EOF
             NOT AT END 
               ADD 1 TO WK-OUT-CNT
           END-READ.
       EXT.
           EXIT.

       TERM-RTN SECTION.
      ******************************************************************
      * 終了処理：ファイルを閉じる、メッセージ表示、通常処理
      ******************************************************************
      *開いたファイルを閉じる 
           CLOSE ITF-FILE.
           CLOSE OTF-FILE.
           
           DISPLAY " *** KJBM010 ITF: " WK-IN-CNT.
           DISPLAY " *** KJBM010 OTF: " WK-OUT-CNT.

           DISPLAY "*** KJBM010 END ***".
       EXT.
           EXIT.





