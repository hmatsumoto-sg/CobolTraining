       IDENTIFICATION          DIVISION.
       PROGRAM-ID.             KJBM011.
      ******************************************************************
      * システム名　　：研修
      * サブシステム名：受注
      * プログラム名　：受注チェックファイル作成(DB入力版)
      * 作成日／作成者：2026/06/11　松本 拓
      * 変更日／変更者：
      * 　　　変更内容：
      ******************************************************************

       ENVIRONMENT                DIVISION.
       INPUT-OUTPUT               SECTION.
       FILE-CONTROL.
           SELECT  OTF-FILE    ASSIGN TO EXTERNAL OTF
           ORGANIZATION SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

       FD  OTF-FILE.
       01  OTF-REC.
           COPY KJCF020.
           
       WORKING-STORAGE            SECTION.
           EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01  DB-NAME                 PIC X(256).
       01  H-REC.
           EXEC SQL INCLUDE KCCMJUCHU END-EXEC.
           EXEC SQL END DECLARE SECTION END-EXEC.

           EXEC SQL INCLUDE SQLCA END-EXEC.
       01  FLG-FETCH-END           PIC X       VALUE "N".
       01  WK-OUT-CNT              PIC 9(3)    VALUE ZERO.


      ******************************************************************
      * メイン処理
      ******************************************************************
       PROCEDURE                  DIVISION.
           PERFORM  INIT-RTN.
           PERFORM  MAIN-RTN.
           PERFORM  TERM-RTN.
           STOP RUN.
           
      ******************************************************************
      * 初期処理：開始メッセージ表示、DB接続、ファイルを開く
      ******************************************************************
       INIT-RTN                   SECTION.
           DISPLAY "*** KJBM011 START ***".
      *DB接続
           STRING
             "DRIVER={Postgresql Unicode};"
             "SERVER=db;"
             "DBQ=postgres;"
             "UID=postgres;"
             "PWD=postgres;"
             "CONNSETTINGS=SET CLIENT_ENCODING to 'SJIS';"
             INTO  DB-NAME
           END-STRING.
           EXEC SQL CONNECT TO :DB-NAME END-EXEC.
      *接続に失敗したらエラーメッセージを出す
           IF SQLCODE NOT = 0
             PERFORM  ABEND-RTN
           END-IF.
      *出力ファイルを開く
           OPEN OUTPUT OTF-FILE.      
       EXT.
           EXIT.
      ******************************************************************
      * 転送処理：カーソル、フェッチ、出力ファイルへの転記
      ******************************************************************
       MAIN-RTN                   SECTION.
      *カーソル宣言
           EXEC SQL
             DECLARE  CUR-JUCHU CURSOR FOR
             SELECT   CMJUCHU_DATA_KBN, CMJUCHU_JUCHU_NO, 
                      CMJUCHU_JUCHU_DATE, CMJUCHU_SHOHIN_NO,
                      CMJUCHU_SURYO
             FROM     KCCMJUCHU
             ORDER BY CMJUCHU_JUCHU_NO
           END-EXEC.
      *カーソルOPEN
           EXEC SQL OPEN CUR-JUCHU END-EXEC.
           IF SQLCODE NOT = 0
             DISPLAY "CURSOR OPEN ERROR: "
             PERFORM ABCLOSE-RTN
             PERFORM ABEND-RTN
           END-IF.

      *FETCHのループ処理で全行取得
           PERFORM  FETCH-RTN  UNTIL  FLG-FETCH-END = "Y".
       EXT.
           EXIT.
      ******************************************************************
      * 終了処理：カーソル・DB・ファイルを閉じる、メッセージ表示
      ******************************************************************
       TERM-RTN                   SECTION.
      *カーソルCLOSE
           EXEC SQL CLOSE CUR-SHOHIN END-EXEC.
      *DB切断
           EXEC SQL DISCONNECT ALL END-EXEC.
      *開いたファイルを閉じる 
           CLOSE OTF-FILE.

           DISPLAY " *** KJBM011 OTF: " WK-OUT-CNT.
           DISPLAY "*** KJBM011 END ***".
       EXT.
           EXIT.
      ******************************************************************
      * フェッチ処理：DBからレコードを1件とってくる
      ******************************************************************
       FETCH-RTN                  SECTION.
      *1行取得
           EXEC SQL
               FETCH CUR-SHOHIN
               INTO  :CMJUCHU-DATA-KBN,
                     :CMJUCHU-JUCHU-NO,
                     :CMJUCHU-JUCHU-DATE,
                     :CMJUCHU-SHOHIN-NO,
                     :CMJUCHU-SURYO
           END-EXEC.

           IF SQLCODE = 100
             MOVE 'Y' TO FLG-FETCH-END
           ELSE IF SQLCODE NOT = 0
             PERFORM ABCLOSE-RTN
             PERFORM ABEND-RTN
           ELSE
           SQLCODE = 0
             MOVE  SPACE              TO  OTF-REC
             MOVE  CMJUCHU-DATA-KBN   TO  JF020-DATA-KBN
             MOVE  CMJUCHU-JUCHU-NO   TO  JF020-JUCHU-NO-X
             MOVE  ZERO               TO  JF020-JUCHU-Y1
             MOVE  CMJUCHU-JUCHU-DATE TO  JF020-JUCHU-DATE6
             MOVE  CMJUCHU-SHOHIN-NO  TO  JF020-SHOHIN-NO-X
             MOVE  CMJUCHU-SURYO      TO  JF020-SURYO-X
             MOVE  SPACE              TO  JF020-ERR-KBN-TBL
             MOVE  SPACE              TO  JF020-SHOHIN-MEI
             MOVE  ZERO               TO  JF020-TANKA
             MOVE  ZERO               TO  JF020-KINGAKU
             PERFORM  WRITE-RTN
           END-IF.
       EXT.
           EXIT.

      ******************************************************************
      * 書き込み処理：ファイルに書き込む
      ******************************************************************
       WRITE-RTN                  SECTION.
           WRITE  OTF-REC
           ADD 1 TO WK-OUT-CNT.
       EXT.
           EXIT.
      ******************************************************************
      * 強制終了処理：エラー出力
      ******************************************************************
       ABEND-RTN                    SECTION.
           DISPLAY "SQLCODE: " SQLCODE.
           DISPLAY "SQLERRMC: " SQLERRMC.
           MOVE 9 TO RETURN-CODE.
           STOP RUN. 
       EXT.
           EXIT.
       
      ******************************************************************
      * 強制切断処理：ロールバック、サーバー切断
      ******************************************************************
       ABCLOSE-RTN                   SECTION.
           EXEC SQL ROLLBACK END-EXEC.
           EXEC SQL DISCONNECT ALL END-EXEC.
       EXT.
           EXIT.