       IDENTIFICATION      DIVISION.
       PROGRAM-ID.         UPDATEDB.
      ******************************************************************
      * システム名    ：サンプル
      * サブシステム名：
      * プログラム名  ：SQL EXECUTE を利用したデータ更新サンプル
      * 作成日／作成者：２０２５年１０月２９日  システム技研
      * 変更日／変更者：
      *       変更内容：
      ******************************************************************
      *
       ENVIRONMENT         DIVISION.
       INPUT-OUTPUT        SECTION.
       FILE-CONTROL.

       DATA                DIVISION.
       FILE                SECTION.

       WORKING-STORAGE     SECTION.
       01 UPD-CNT          PIC  9(9) PACKED-DECIMAL VALUE 0.
       01 USER-INPUT-JUCHUNO PIC  X(4).
       01 USER-INPUT-SURYO PIC  X(5).
       01 END-FLG          PIC  X   VALUE  "N".
       01 WK-SQLCODE       PIC S9(9) COMP-5.
      ******************************************************************
      *  データベースアクセス関連
      *     ※ COBOL ⇔ DB する変数は DECLARE SECTION で行う。
      ******************************************************************
       EXEC SQL  BEGIN DECLARE SECTION  END-EXEC.
      * DB接続文字列
       01 DSN              PIC  X(256).

      * FETCHした情報を格納するデータ項目の定義
       EXEC SQL  INCLUDE SALESDATA  END-EXEC.

      * UPDATE文で参照されるデータ項目
       01 INPUT-JUCHU-NO   PIC  9(4).
       01 INPUT-SURYO      PIC  9(5).
      *
       EXEC SQL  END DECLARE SECTION  END-EXEC.
      *
      * DBの状態を保存するデータ項目は DECLARE SECTION 外に記述する。
      * プリコンパイル時にエラーになる。 
       EXEC SQL  INCLUDE SQLCA  END-EXEC.
      ******************************************************************

      ******************************************************************
      * メインルーチン
      ******************************************************************
       PROCEDURE               DIVISION.
           PERFORM INIT-RTN.
           PERFORM UPDATE-PROCESS-RTN UNTIL END-FLG = "Y".
           PERFORM SUCCESSFUL-TERM-RTN.
           STOP RUN.

      ******************************************************************
      * 初期化処理
      ******************************************************************
       INIT-RTN                SECTION.
      * Program initialization
           DISPLAY  "*** UPDATEDB START ***".
           DISPLAY  " ".
      *
           PERFORM DBCONNECT-RTN.
       EXT.
           EXIT.

      ******************************************************************
      * データベースへ接続する処理
      ******************************************************************
       DBCONNECT-RTN           SECTION.
      * ESQLOCはODBC経由でDBへ接続するコードを生成するため、データベース
      * への接続にODBC接続文字列を作成する必要がある。詳細は下記URL参照。
      * https://www.microfocus.co.jp/manuals/ED60/VS2017/GUID-2B444A32-4991-4396-B9F1-68AB643B5EBA.html
      *
      * なお、埋込SQLを処理するプリプロセッサによって、データベースへの
      * 接続方法が異なるので、その場所で利用しているプリプロセッサの
      * ドキュメントを確認すること。
      *
      * Ubuntu 22.04では、odbc-postgresqlパッケージのインストールが必要。
      *
      * 埋込SQLを利用する場合は、COBOL側の文字コードに合わせてデータを
      * 崇徳する必要がある。研修の環境は'SJIS'のため、データ取得時の
      * 文字エンコードを'SJIS'に設定する。(しないと文字化けが発生する)
      * 文字エンコードを設定するには、
      *   CONNSETTINGS=SET CLIENT_ENCODING TO 'SJIS'
      * を接続文字列に追加する。
           STRING
             "DRIVER={Postgresql Unicode};"
             "SERVER=db;"
             "DBQ=postgres;"
             "UID=postgres;"
             "PWD=postgres;"
             "CONNSETTINGS=SET CLIENT_ENCODING to 'SJIS';"
             INTO DSN
           END-STRING.

           EXEC SQL CONNECT TO :DSN END-EXEC.

           DISPLAY "SQLRET:" SQLCODE.

           IF SQLCODE NOT = ZERO
             PERFORM DBERR-TERM-RTN
           END-IF.

           DISPLAY "DB connected.".
           DISPLAY " ".
       EXT.
           EXIT.

      ******************************************************************
      * テーブルデータの更新処理
      ******************************************************************
       UPDATE-PROCESS-RTN      SECTION.
      * ユーザから受注Noの入力
           DISPLAY "JUCHU-NO (0000=END)"
                   " *** INPUT FULL COLUMN REQUIRED *** :".
           ACCEPT USER-INPUT-JUCHUNO.

      * 数値かどうか確認
           IF USER-INPUT-JUCHUNO IS NOT NUMERIC
             DISPLAY "ERROR: NUMERIC INPUT REQUIRED."
             DISPLAY " "
             GO TO  EXT 
           END-IF.

           IF USER-INPUT-JUCHUNO = ZERO
             DISPLAY "END PROCESS."
             MOVE "Y" TO  END-FLG
             GO TO  EXT
           END-IF.

      * 指定した受注Noに該当するデータを検索して表示
           MOVE USER-INPUT-JUCHUNO TO INPUT-JUCHU-NO.

           PERFORM CHECK-RECORD-RTN.

           EVALUATE WK-SQLCODE
             WHEN ZERO
               CONTINUE 
             WHEN 100
      *        データベースに問い合わせしてデータがなかったときは、
      *        100 が返ってくることを利用する。
               DISPLAY "JUCHU-NO " INPUT-JUCHU-NO " NOT FOUND."
               DISPLAY " "
               GO TO  EXT
             WHEN OTHER
               PERFORM DBERR-TERM-RTN
           END-EVALUATE.
           
      * 新たな数量を入力させる
           DISPLAY " ".
           DISPLAY "NEW SURYO (EX. 00100) "
                   "*** INPUT FULL COLUMN REQUIRED *** : ".
           ACCEPT USER-INPUT-SURYO.

      * 数値かどうか確認
           IF USER-INPUT-SURYO IS NOT NUMERIC
             DISPLAY "ERROR: NUMERIC INPUT REQUIRED."
             DISPLAY " "
             GO TO  EXT
           END-IF.

           MOVE USER-INPUT-SURYO TO INPUT-SURYO.

           PERFORM UPDATE-RECORD-RTN.
           PERFORM CHECK-RECORD-RTN.
       EXT.
           EXIT.

      ******************************************************************
      * 入力された受注Noのデータの存在の確認と表示
      ******************************************************************
       CHECK-RECORD-RTN        SECTION.
           EXEC SQL
               SELECT DATA_KBN,
                      JUCHU_NO,
                      JUCHU_YY,
                      JUCHU_MM,
                      JUCHU_DD,
                      TOKU_COD,
                      SHOHIN_NO,
                      SURYO
                 INTO :SALES-DATA-KBN,
                      :SALES-JUCHU-NO,
                      :SALES-JUCHU-YY,
                      :SALES-JUCHU-MM,
                      :SALES-JUCHU-DD,
                      :SALES-TOKU-COD,
                      :SALES-SHOHIN-NO,
                      :SALES-SURYO
                 FROM SALESDATA
                WHERE JUCHU_NO = :INPUT-JUCHU-NO
           END-EXEC.

           DISPLAY "SQLRET:" SQLCODE.

           MOVE SQLCODE TO WK-SQLCODE.

           IF SQLCODE = ZERO
             DISPLAY "--------------------------------------"
             DISPLAY "JUCHU-NO  : " SALES-JUCHU-NO
             DISPLAY "JUCHU-DATE: " SALES-JUCHU-YY "-"
                     SALES-JUCHU-MM "-" SALES-JUCHU-DD
             DISPLAY "TOKU-COD  : " SALES-TOKU-COD
             DISPLAY "SHOHIN-NO : " SALES-SHOHIN-NO
             DISPLAY "SURYO     : " SALES-SURYO
             DISPLAY "--------------------------------------"
           END-IF.
       EXT.
           EXIT.

      ******************************************************************
      * テーブルの更新処理
      ******************************************************************
       UPDATE-RECORD-RTN       SECTION.
           EXEC SQL
               UPDATE SALESDATA
                  SET SURYO = :INPUT-SURYO
                WHERE JUCHU_NO = :INPUT-JUCHU-NO
           END-EXEC.

           DISPLAY "SQLRET:" SQLCODE.

           EVALUATE SQLCODE
      *      SQLCODE が 0 の時は更新成功
             WHEN 0
               ADD 1 TO UPD-CNT
               DISPLAY " "
               DISPLAY "UPDATED (COUNT: " UPD-CNT ")"
               DISPLAY " "
      *     その他はエラー
             WHEN OTHER
               PERFORM DBERR-TERM-RTN
           END-EVALUATE.
       EXT.
           EXIT.

      ******************************************************************
      * 通常終了処理
      ******************************************************************
       SUCCESSFUL-TERM-RTN     SECTION.
           EXEC SQL COMMIT END-EXEC.
           DISPLAY "SQLRET:" SQLCODE.
           DISPLAY " ".
           DISPLAY "TRANSACTION COMMITTED.".
           PERFORM TERM-RTN.
       EXT.
           EXIT.

      ******************************************************************
      * 異常終了処理 
      ******************************************************************
       DBERR-TERM-RTN          SECTION.
           EXEC SQL ROLLBACK END-EXEC.
           DISPLAY "!!! UPDATEDB ABEND : DATABASE ERROR !!!".
           DISPLAY "SQLCODE = " SQLCODE.
           DISPLAY "SQLERRMC = " SQLERRMC.
           PERFORM TERM-RTN.
       EXT.
           EXIT.

      *****************************************************************
      * 共通終了処理
      ******************************************************************
       TERM-RTN                SECTION.
      *    Disconnect from DB
           EXEC SQL  DISCONNECT ALL      END-EXEC.
           DISPLAY "SQLRET:" SQLCODE.
           DISPLAY "TOTAL UPDATES=" UPD-CNT.
           DISPLAY "*** UPDATEDB END ***".
       EXT.
           EXIT.
