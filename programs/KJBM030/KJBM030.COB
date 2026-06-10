       IDENTIFICATION          DIVISION.
       PROGRAM-ID.    KJBM030.

      ******************************************************************
      * システム名　　：研修
      * サブシステム名：受注
      * プログラム名　：受注データ商品番号チェック
      * 作成日／作成者：2026/06/10　松本 拓
      * 変更日／変更者：
      * 　　　変更内容：
      ******************************************************************
       
       ENVIRONMENT             DIVISION.
       INPUT-OUTPUT            SECTION.
       FILE-CONTROL.
           SELECT   ITF-FILE   ASSIGN  TO  ITF
             ORGANIZATION  SEQUENTIAL.

           SELECT   IMF-FILE   ASSIGN  TO  IMF
             ORGANIZATION  SEQUENTIAL.

           SELECT   OTF-FILE   ASSIGN  TO  OTF
             ORGANIZATION  SEQUENTIAL.

       DATA                    DIVISION.
       FILE                    SECTION.
       FD  ITF-FILE.
       01  ITF-REC.
           COPY KJCF020.

       FD  IMF-FILE.
       01  IMF-REC.
           COPY KCCFSHO.

       FD  OTF-FILE.
       01  OTF-REC.
           COPY KJCF020.

       WORKING-STORAGE         SECTION.
       01  WK-ITF-EOF                      PIC X(1)   VALUE "N".
       01  WK-IMF-EOF                      PIC X(1)   VALUE "N".
       01  WK-ITF-CNT                      PIC 9(3)   VALUE ZERO.
       01  WK-IMF-CNT                      PIC 9(3)   VALUE ZERO.

       01  WK-OUT-CNT                      PIC 9(3)   VALUE ZERO.
       01  WK-TRS-KEY                                 VALUE LOW-VALUES.
           03  WK-TRS-SHOHIN-NO            PIC 9(5).
       01  WK-MST-KEY                                 VALUE LOW-VALUES.
           03  WK-MST-SHOHIN-NO            PIC 9(5).
       01  WK-GOUKEI-KINGAKU               PIC 9(9)  VALUE ZERO.

       PROCEDURE               DIVISION.
      ******************************************************************
      * メイン処理：司令塔の役割
      ******************************************************************
           PERFORM   INIT-RTN.
           PERFORM   MAIN-RTN  UNTIL  WK-ITF-EOF = "Y".
           PERFORM   TERM-RTN.
           STOP  RUN.
      ******************************************************************
      * 初期処理：ログの表示、ファイルの読み込み・保持キー設定、初期化
      ******************************************************************
       INIT-RTN                SECTION.
           DISPLAY  "*** KJBM030 START ***".

           OPEN  INPUT   ITF-FILE.
           OPEN  INPUT   IMF-FILE.
           OPEN  OUTPUT  OTF-FILE.
           
           PERFORM  READ-ITF-RTN.
           PERFORM  READ-IMF-RTN.
       EXT.
           EXIT.
      ******************************************************************
      * マッチング処理：受注チェックファイルと商品マスタを突合する
      ******************************************************************
       MAIN-RTN                SECTION.
      *エラー区分(5)のレコードは処理せずに出力する
           IF  NOT  JF020-ERR-KBN  OF  ITF-REC (5) = " "
             MOVE  ITF-REC  TO  OTF-REC
             PERFORM  WRITE-RTN
             PERFORM  READ-ITF-RTN
           ELSE
             EVALUATE  TRUE
               WHEN  WK-TRS-KEY = WK-MST-KEY
                 MOVE  ITF-REC  TO  OTF-REC
                 MOVE  CFSHO-SHOHIN-MEI TO 
                       JF020-SHOHIN-MEI  OF  OTF-REC
                 MOVE  CFSHO-TANKA  TO  JF020-TANKA  OF  OTF-REC  
                 IF  JF020-ERR-KBN  OF  ITF-REC (6) = " "
                   COMPUTE  WK-GOUKEI-KINGAKU = JF020-SURYO OF ITF-REC 
                                                * CFSHO-TANKA
                 ELSE
                   MOVE  ZERO  TO  WK-GOUKEI-KINGAKU
                 END-IF
                 MOVE  WK-GOUKEI-KINGAKU  TO  JF020-KINGAKU OF OTF-REC
                 PERFORM  WRITE-RTN
                 PERFORM  READ-ITF-RTN
               WHEN  WK-TRS-KEY < WK-MST-KEY
                 MOVE  ITF-REC  TO  OTF-REC
                 MOVE  "2"  TO  JF020-ERR-KBN  OF  OTF-REC (5)
                 PERFORM  WRITE-RTN
                 PERFORM  READ-ITF-RTN
               WHEN  WK-TRS-KEY > WK-MST-KEY
                 PERFORM  READ-IMF-RTN
             END-EVALUATE
           END-IF.
           
       EXT.
           EXIT.

      ******************************************************************
      * 終了処理：ファイルを閉じる、件数表示、終了ログ表示
      ******************************************************************
       TERM-RTN                SECTION.

           CLOSE  ITF-FILE.
           CLOSE  IMF-FILE.
           CLOSE  OTF-FILE.
           DISPLAY  "*** ITF = " WK-ITF-CNT " ***".
           DISPLAY  "*** IMF = " WK-IMF-CNT " ***".
           DISPLAY  "*** OTF = " WK-OUT-CNT " ***".
           DISPLAY  "*** KJBM030 END ***".
       EXT.
           EXIT.

      ******************************************************************
      * 入力ファイルの入力処理：ファイルを読み込む
      ******************************************************************
       READ-ITF-RTN            SECTION.  
           READ  ITF-FILE
               AT END
                 MOVE "Y" TO WK-ITF-EOF
                 MOVE  HIGH-VALUES TO WK-TRS-KEY
               NOT AT END 
                 MOVE JF020-SHOHIN-NO OF ITF-REC TO WK-TRS-SHOHIN-NO
                 ADD 1 TO WK-ITF-CNT
           END-READ.
       EXT.
           EXIT.
      ******************************************************************
      * マスタファイルの入力処理：ファイルを読み込む
      ******************************************************************
       READ-IMF-RTN            SECTION.  
           READ  IMF-FILE
               AT END
                 MOVE "Y" TO WK-IMF-EOF
                 MOVE  HIGH-VALUES TO WK-MST-KEY
               NOT AT END
                 MOVE CFSHO-SHOHIN-NO TO WK-MST-SHOHIN-NO
                 ADD 1 TO WK-IMF-CNT
           END-READ.
       EXT.
           EXIT.
      ******************************************************************
      * 出力処理：ファイルに書き込む
      ******************************************************************
       WRITE-RTN               SECTION.
           WRITE  OTF-REC
           ADD 1 TO WK-OUT-CNT.
       EXT.
           EXIT.
