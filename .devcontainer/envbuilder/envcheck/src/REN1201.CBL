       IDENTIFICATION DIVISION.
       PROGRAM-ID. REN1201.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01 DSN       PIC X(256).
       01 TID       PIC 9(6).
       01 TNAME     PIC X(10).
       EXEC SQL END DECLARE SECTION END-EXEC.
       EXEC SQL INCLUDE SQLCA END-EXEC.


       PROCEDURE DIVISION.
           STRING
             "DRIVER={Postgresql Unicode};"                             *> Postgresql ODBCドライバ
             "SERVER=db;"                                               *> 【要変更】サーバ名又はIPアドレス
             "DATABASE=test_conn;"                                      *> 【要変更】データベース名
             "UID=test_conn;"                                           *> 【要変更】ユーザ名
             "PWD=test_conn;"                                           *> 【要変更】パスワード
             "CONNSETTINGS=SET CLIENT_ENCODING to 'SJIS';"              *> クライアント文字コード
             INTO DSN
           END-STRING.

           DISPLAY "CONNECTING DATABASE ..."
           EXEC SQL CONNECT TO :DSN END-EXEC. 
           
           PERFORM SQLCA-DISP-RTN.

           IF SQLCODE NOT = ZERO
             GO TO EXT
           END-IF.

           DISPLAY "SELECTING DATA FROM TABLE ..."
           EXEC SQL
             SELECT id, name
             INTO :TID, :TNAME
             FROM test
             WHERE id='1'
           END-EXEC.
           DISPLAY TID TNAME.

           PERFORM SQLCA-DISP-RTN.
       EXT.
           STOP RUN.

       SQLCA-DISP-RTN  SECTION.
           DISPLAY "SQLCODE: "   SQLCODE
                   " SQLSTATE: " SQLSTATE
                   " SQLERRM: "  SQLERRM.
           EXIT.
      