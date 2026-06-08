       IDENTIFICATION          DIVISION.
       PROGRAM-ID.    KJBM020.

      ******************************************************************
      * システム名　　：研修
      * サブシステム名：受注
      * プログラム名　：受注データ形式チェック
      * 作成日／作成者：2026/06/05　松本 拓
      * 変更日／変更者：
      * 　　　変更内容：
      ******************************************************************
       
       ENVIRONMENT             DIVISION.
       INPUT-OUTPUT            SECTION.
       FILE-CONTROL.
           SELECT   ITF-FILE   ASSIGN  TO  ITF
             ORGANIZATION  SEQUENTIAL.

           SELECT   OTF-FILE   ASSIGN  TO  OTF
             ORGANIZATION  SEQUENTIAL.

       DATA                    DIVISION.
       FILE                    SECTION.
       FD  ITF-FILE.
       01  ITF-REC.
           COPY KJCF020.

       FD  OTF-FILE.
       01  OTF-REC.
           COPY KJCF020.

       WORKING-STORAGE         SECTION.
       01  WK-EOF                       PIC X(1)    VALUE "N".
       01  WK-IN-CNT                    PIC 9(3)    VALUE ZERO.
       01  WK-OUT-CNT                   PIC 9(3)    VALUE ZERO.
       COPY KCBS010P.

       PROCEDURE               DIVISION.
      ******************************************************************
      * メイン処理：司令塔の役割
      ******************************************************************
           PERFORM   INIT-RTN.
           PERFORM   MAIN-RTN  UNTIL  WK-EOF = "Y".
           PERFORM   TERM-RTN.
           STOP  RUN.
      ******************************************************************
      * 初期処理：開始メッセージの表示、ファイルの読み込み
      ******************************************************************
       INIT-RTN                SECTION.
           DISPLAY  "*** KJBM020 START ***".

           OPEN  INPUT   ITF-FILE.
           OPEN  OUTPUT  OTF-FILE.
           
           PERFORM  READ-RTN.
       EXT.
           EXIT.
      ******************************************************************
      * 転送・確認処理：入力レコードの各項目を出力レコードに転送する
      ******************************************************************
       MAIN-RTN                SECTION.
      *項目すべてのデータをセット
           MOVE  ITF-REC  TO  OTF-REC.
      *入力ファイルのエラーテーブルに何か入っていた時の対策
           MOVE  SPACE  TO  JF020-ERR-KBN-TBL  OF  OTF-REC.

      *サブプログラムに値をセットする
           INITIALIZE  KCBS010-P1.
           MOVE  JF020-JUCHU-DATE  OF  OTF-REC  TO  S010-DATE.
       
      *サブプログラムの呼び出し
           CALL  "KCBS010"  USING  KCBS010-P1.

      *仕様書[チェック詳細]に基づく各項目のチェック
           IF  NOT  (JF020-DATA-KBN  OF  OTF-REC = "1"  
                       OR  JF020-DATA-KBN  OF  OTF-REC = "9")
             MOVE  "1"  TO  JF020-ERR-KBN  OF  OTF-REC (1)
           END-IF.

           IF  JF020-JUCHU-NO  OF  OTF-REC IS NOT NUMERIC  
                       OR  JF020-JUCHU-NO  OF  OTF-REC = ZERO
             MOVE  "1"  TO  JF020-ERR-KBN  OF  OTF-REC (2)
           END-IF.

           IF  NOT  S010-RCD = "E"
             MOVE  S010-DATE8  TO  JF020-JUCHU-DATE  OF  OTF-REC
           ELSE    
             MOVE "1"  TO  JF020-ERR-KBN  OF  OTF-REC (3)
           END-IF.

           IF  JF020-SHOHIN-NO  OF  OTF-REC IS NOT NUMERIC  
                       OR  JF020-SHOHIN-NO  OF  OTF-REC = ZERO
             MOVE  "1"  TO  JF020-ERR-KBN  OF  OTF-REC (5)
           END-IF.

           IF  NOT  (JF020-SURYO  OF  OTF-REC IS NUMERIC
                       AND  JF020-SURYO  OF  OTF-REC >= 1 
                       AND  JF020-SURYO  OF  OTF-REC <= 999)
             MOVE  "1"  TO  JF020-ERR-KBN  OF  OTF-REC (6)
           END-IF.
           
           PERFORM  WRITE-RTN.
           PERFORM  READ-RTN.
       EXT.
           EXIT.

      ******************************************************************
      * 終了処理：ファイルを閉じる、件数表示、終了ログ表示
      ******************************************************************
       TERM-RTN                SECTION.
           CLOSE  ITF-FILE.
           CLOSE  OTF-FILE.
           DISPLAY  "*** ITF = " WK-IN-CNT " ***".
           DISPLAY  "*** OTF = " WK-OUT-CNT " ***".
           DISPLAY  "*** KJBM020 END ***".
       EXT.
           EXIT.

      ******************************************************************
      * 入力処理：ファイルを読み込む、中身が空ならやめる
      ******************************************************************
       READ-RTN                SECTION.
           READ  ITF-FILE
               AT END
                   MOVE "Y" TO WK-EOF
               NOT AT END 
                   ADD 1 TO WK-IN-CNT
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
