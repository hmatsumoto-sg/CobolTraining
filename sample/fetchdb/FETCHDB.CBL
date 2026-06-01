       IDENTIFICATION      DIVISION.
       PROGRAM-ID.         FETCHDB.
      ******************************************************************
      * システム名    ：サンプル
      * サブシステム名：
      * プログラム名  ：SQL FETCH を利用したサンプル
      * 作成日／作成者：２０２４年７月５日  システム技研
      * 変更日／変更者：
      *       変更内容：
      ******************************************************************
      *
       ENVIRONMENT         DIVISION.
       INPUT-OUTPUT        SECTION.
       FILE-CONTROL.
           SELECT OTF-FILE ASSIGN TO OTF.
       
       DATA                DIVISION.
       FILE                SECTION.
       FD  OTF-FILE.
       01 OTF-REC.
         COPY KJCF020.

       WORKING-STORAGE     SECTION.
       01 OTF-CNT          PIC  9(9) PACKED-DECIMAL VALUE 0.
       01 FETCH-CNT        PIC  9(9) PACKED-DECIMAL VALUE 0.
       01 FETCH-END        PIC  X VALUE 'N'.
      ******************************************************************
      *  データベースアクセス関連
      *     ※ COBOL ⇔ DB する変数は DECLARE SECTION で行う。
      ******************************************************************
       EXEC SQL  BEGIN DECLARE SECTION  END-EXEC.
      * DB接続用文字列 
       01 DSN              PIC  X(256).

      *EXEC SQL INCLUDE USERS-DECLARE END-EXEC.
      * FETCHした情報を格納するデータ項目の定義
       EXEC SQL  INCLUDE SALESDATA  END-EXEC.
      
      * FETCHする対象が記載された「カーソル」の定義
       EXEC SQL  DECLARE 
           SALES-CURSOR CURSOR FOR
               SELECT *
               FROM SALESDATA
       END-EXEC.
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
           PERFORM WRITE-TO-FILE-RTN  UNTIL FETCH-END = "Y".
           PERFORM SUCCESSFUL-TERM-RTN.
           STOP RUN.

      ******************************************************************
      * 初期化処理
      ******************************************************************
       INIT-RTN                SECTION.
      * プログラムの初期化
           DISPLAY  "*** FETCHDB START ***".
      *
           OPEN OUTPUT OTF-FILE.

           PERFORM DBCONNECT-RTN.
           PERFORM FETCH-RTN.
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
      * 取得する必要がある。研修の環境は'SJIS'のため、データ取得時の
      * 文字エンコードを'SJIS'に設定する。(しないと文字化けが発生する)
      * 文字エンコードを設定するには、
      *   CONNSETTINGS=SET CLIENT_ENCODING TO 'SJIS'
      * を接続文字列に追加する。
           STRING
             "DRIVER={Postgresql Unicode};"                             *> Postgresql ODBCドライバ
             "SERVER=db;"                                               *> 【要変更】サーバ名又はIPアドレス
             "DBQ=postgres;"                                            *> 【要変更】データベース名
             "UID=postgres;"                                            *> 【要変更】ユーザ名
             "PWD=postgres;"                                            *> 【要変更】パスワード
             "CONNSETTINGS=SET CLIENT_ENCODING to 'SJIS';"              *> クライアント文字コード
             INTO DSN
           END-STRING.
      ******************************************************************
           EXEC SQL CONNECT TO :DSN END-EXEC.
           IF SQLCODE NOT = ZERO
             PERFORM DBERR-TERM-RTN
           END-IF.

      *    SQLカーソルを開く
           EXEC SQL  OPEN SALES-CURSOR  END-EXEC.
       EXT.
           EXIT.

      ******************************************************************
      * 目的のカーソル(テーブル)から1レコード読み取る
      ******************************************************************
       FETCH-RTN               SECTION.
      * カーソルでFETCHしてデータを取得する。
      * COBOLの環境によってはFETCHした情報を集団項目に転記できないため、
      * その場合はそれぞれの項目に転記するように記述する。
           EXEC SQL  
               FETCH SALES-CURSOR 
                INTO :SALES-DATA-KBN,
                     :SALES-JUCHU-NO,
                     :SALES-JUCHU-YY,
                     :SALES-JUCHU-MM,
                     :SALES-JUCHU-DD,
                     :SALES-TOKU-COD,
                     :SALES-SHOHIN-NO,
                     :SALES-SURYO
           END-EXEC.

           EVALUATE SQLCODE
      *    SQLCODE = 0 ⇒ 正常終了。
             WHEN 0
               ADD 1 TO FETCH-CNT
      *    SQLCODE = 100 ⇒ これ以上データがない
             WHEN 100
               MOVE "Y" TO FETCH-END
      *    上記以外は何らかのエラー。ABEND対象。
             WHEN OTHER
               PERFORM DBERR-TERM-RTN
           END-EVALUATE.
       EXT.
           EXIT.
       
      ******************************************************************
      * 処理結果をファイルに出力
      ******************************************************************
       WRITE-TO-FILE-RTN       SECTION.
           INITIALIZE OTF-REC.

           MOVE SALES-DATA-KBN TO JF020-DATA-KBN.
           MOVE SALES-JUCHU-NO TO JF020-JUCHU-NO-X.
           MOVE SALES-JUCHU-YY TO JF020-JUCHU-Y2.
           MOVE SALES-JUCHU-MM TO JF020-JUCHU-MM.
           MOVE SALES-JUCHU-DD TO JF020-JUCHU-DD.
           MOVE SALES-TOKU-COD TO JF020-TOKU-COD.
           MOVE SALES-SHOHIN-NO TO JF020-SHOHIN-NO.
           MOVE SALES-SURYO TO JF020-SURYO-X.

           WRITE OTF-REC.
           ADD 1 TO OTF-CNT.

           PERFORM FETCH-RTN.
       EXT.
           EXIT.

      ******************************************************************
      * 問題なく処理が完了した時の終了処理
      ******************************************************************
       SUCCESSFUL-TERM-RTN     SECTION.
      *     EXEC SQL COMMIT END-EXEC.
           PERFORM TERM-RTN.
       EXT.
           EXIT.

      ******************************************************************
      * 処理宙にエラーが発生した時の終了処理
      ******************************************************************
       DBERR-TERM-RTN          SECTION.
      *     EXEC SQL ROLLBACK END-EXEC.
           DISPLAY "!!! FETCHDB ABEND : DATABSE ACCESS ERRROR !!!"
           DISPLAY "SQLCODE = " SQLCODE.
           DISPLAY "SQLERRMC = " SQLERRMC.
           PERFORM TERM-RTN.
       EXT.
           EXIT.

      *****************************************************************
      * 共通のプログラム終了処理
      ******************************************************************
       TERM-RTN                SECTION.
      *    カーソルを閉じる
           EXEC SQL  CLOSE SALES-CURSOR  END-EXEC.
      *    DBから切断する。
           EXEC SQL  DISCONNECT ALL      END-EXEC.
      *    ファイルを閉じる。
           CLOSE OTF-FILE.      
           DISPLAY "FETCHCNT=" FETCH-CNT.
           DISPLAY "OTFCNT  =" OTF-CNT.
           DISPLAY "*** FETCHDB END ***".
       EXT.
           STOP RUN.
