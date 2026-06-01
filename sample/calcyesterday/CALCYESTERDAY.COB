       IDENTIFICATION DIVISION.
       PROGRAM-ID. CALCYESTERDAY.
      ******************************************************************
      * システム名    ：サンプル
      * サブシステム名：
      * プログラム名  ：末日を計算するサブプログラム
      * 作成日／作成者：２０２５年１０月２９日  システム技研
      * 変更日／変更者：
      *       変更内容：
      ******************************************************************
       ENVIRONMENT DIVISION.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 N-DATE                PIC      9(08)   VALUE 0.
       01 I-DATE                PIC      9(08)   VALUE 0.
       01 YESTERDAY             PIC      9(08)   VALUE 0.
       01 TMP                   PIC      9(08)   VALUE 0.

       LINKAGE SECTION.
       COPY  CALCYESTERDAY-PARAMS.

       PROCEDURE  DIVISION  USING  CALCYESTERDAY-P1.
           MOVE  SPACE  TO  YESTERDAY-YYYYMMDD.
           MOVE  SPACE  TO  ERR.
           MOVE  DATE-YYYYMMDD  TO  N-DATE.

           PERFORM PARAM-CHECK.
           IF  ERR  =  "E"
               GO TO  EXT
           END-IF.

           MOVE  FUNCTION INTEGER-OF-DATE(N-DATE)  TO  I-DATE.
           COMPUTE  YESTERDAY  =  
                       FUNCTION DATE-OF-INTEGER(I-DATE - 1).
           IF  YESTERDAY  =  0
               MOVE  "E"  TO  ERR
               GO TO  EXT
           END-IF.
               
           MOVE  YESTERDAY  TO  YESTERDAY-YYYYMMDD.
       EXT.
           EXIT PROGRAM.

       PARAM-CHECK  SECTION.
           IF  N-DATE  IS  NOT  NUMERIC
               MOVE  "E"  TO  ERR
               GO TO  EXT
           END-IF.

           COMPUTE TMP = N-DATE / 10000. 
           IF  TMP < 1900  OR  TMP > 9999
               MOVE  "E"  TO  ERR
               GO TO   EXT
           END-IF.

           COMPUTE TMP = FUNCTION  MOD(N-DATE / 100 100). 
           IF  TMP < 1  OR  TMP > 12
               MOVE  "E"  TO  ERR
               GO TO   EXT
           END-IF.

           COMPUTE TMP = FUNCTION  MOD(N-DATE 100). 
           IF  TMP < 1  OR  TMP > 31
               MOVE  "E"  TO  ERR
               GO TO   EXT
           END-IF.
       EXT.
           EXIT.
