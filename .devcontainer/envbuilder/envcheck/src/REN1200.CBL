       IDENTIFICATION DIVISION.
       PROGRAM-ID. REN1200.
       DATA DIVISION.

       WORKING-STORAGE SECTION.
      ******** (1)ホスト変数の定義 ********
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01 TID       PIC 9(6).
       01 TNAME     PIC X(10).

       01 DBNAME    PIC X(32) VALUE "test_conn@localhost".
       01 USERNAME  PIC X(32) VALUE "test_conn".
       01 PASSWORD  PIC X(32) VALUE "test_conn".
       
       EXEC SQL END DECLARE SECTION END-EXEC.
      *************************************
      ******** (2)共通領域の定義 **********
       EXEC SQL INCLUDE SQLCA END-EXEC.
      *************************************
       PROCEDURE DIVISION.
           DISPLAY "CONNECTING DATABASE ..."
           EXEC SQL
           CONNECT :USERNAME
               IDENTIFIED BY :PASSWORD
               USING :DBNAME
           END-EXEC.
           PERFORM SQLCA-DISP-RTN
           IF SQLCODE NOT = 0
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
      