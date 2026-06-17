       IDENTIFICATION          DIVISION.
       PROGRAM-ID.    KCBS010.

      ******************************************************************
      * システム名　　：研修
      * サブシステム名：共通
      * プログラム名　：日付チェック
      * 作成日／作成者：2026/06/16　松本 拓
      * 変更日／変更者：
      * 　　　変更内容：
      ******************************************************************
       

       DATA                    DIVISION.
       WORKING-STORAGE         SECTION.
       01  WK-MAX-DATE                PIC 9(2)    VALUE ZERO.
       01  WK-LEAP-FLG                PIC X(1)    VALUE "N".
       01  WK-RESULT           PIC 9(3)    VALUE ZERO.
       01  WK-REMAINDER400            PIC 9(3)    VALUE ZERO.
       01  WK-REMAINDER100            PIC 9(3)    VALUE ZERO.
       01  WK-REMAINDER4              PIC 9(3)    VALUE ZERO.
       
       LINKAGE                 SECTION.
       COPY  KCBS010P.
       
       PROCEDURE               DIVISION    USING
           KCBS010-P1.

      ******************************************************************
      * メイン処理：出力値のクリア、入力値チェック、司令塔
      ******************************************************************
           MOVE  SPACE  TO  S010-RCD.
           IF  S010-DATE IS NUMERIC
             PERFORM  DATE-CHECK-RTN
             IF  (S010-D6-MM >= 1 AND S010-D6-MM <= 12)
               AND  (S010-D6-DD >= 1 AND S010-D6-DD <= WK-MAX-DATE)
               PERFORM  EIGHT-DATE-RTN
               PERFORM  LEAP-YEAR-RTN
             ELSE
               MOVE  "E"  TO  S010-RCD
             END-IF
           ELSE
             MOVE  "E"  TO  S010-RCD
           END-IF.
           EXIT  PROGRAM.
      ******************************************************************
      * 日付確認処理：月の最後が何日か
      ******************************************************************
       DATE-CHECK-RTN           SECTION.
           EVALUATE  S010-D6-MM
             WHEN 1 WHEN 3 WHEN 5 WHEN 7 WHEN 8 WHEN 10 WHEN 12
               MOVE  31  TO  WK-MAX-DATE
             WHEN 4 WHEN 6 WHEN 9 WHEN 11
               MOVE  30  TO  WK-MAX-DATE
             WHEN 2
               MOVE  29  TO  WK-MAX-DATE
             WHEN  OTHER
               MOVE  0   TO  WK-MAX-DATE
           END-EVALUATE.
       EXT.
           EXIT.
      ******************************************************************
      * 年上2桁の処理：20XXか19XXか
      ******************************************************************
       EIGHT-DATE-RTN          SECTION.
           IF  S010-P1-Y1 = 0
             EVALUATE  TRUE
               WHEN  S010-D6-Y2 < 90
                 MOVE  20  TO  S010-P1-Y1
               WHEN  OTHER
                 MOVE  19  TO  S010-P1-Y1
             END-EVALUATE
           END-IF.
       EXT.
           EXIT.
      ******************************************************************
      * うるう年確認処理：うるう年かどうか
      ******************************************************************
       LEAP-YEAR-RTN           SECTION.
           IF  S010-D6-MM = 2 
             DIVIDE S010-D8-YY BY 400 GIVING WK-RESULT 
                                      REMAINDER WK-REMAINDER400
             DIVIDE S010-D8-YY BY 100 GIVING WK-RESULT 
                                      REMAINDER WK-REMAINDER100
             DIVIDE S010-D8-YY BY 4 GIVING WK-RESULT 
                                      REMAINDER WK-REMAINDER4
             EVALUATE  TRUE
               WHEN  WK-REMAINDER400 = 0
                 MOVE  "Y"  TO  WK-LEAP-FLG
               WHEN  WK-REMAINDER100 = 0
                 MOVE  "N"  TO  WK-LEAP-FLG
               WHEN  WK-REMAINDER4 = 0
                 MOVE  "Y"  TO  WK-LEAP-FLG
               WHEN  OTHER
                 MOVE  "N"  TO  WK-LEAP-FLG
             END-EVALUATE
      *うるう年じゃないのに29だとエラー   
             IF  (S010-D6-DD = 29) AND (WK-LEAP-FLG = "N")
               MOVE  "E"  TO  S010-RCD
             END-IF
           END-IF.
       EXT.
           EXIT.
      
      
      