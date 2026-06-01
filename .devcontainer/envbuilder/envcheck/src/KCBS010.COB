       IDENTIFICATION         DIVISION.
       PROGRAM-ID.            KCBS010.
      ******************************************************************
      * システム名    ：研修
      * サブシステム名：共通
      * プログラム名  ：西暦日付チェック
      * 作成日／作成者：２０１３年４月３０日  システム技研
      * 変更日／変更者：
      *       変更内容：
      ******************************************************************
       ENVIRONMENT            DIVISION.
       INPUT-OUTPUT           SECTION.
      *
       DATA                   DIVISION.
       WORKING-STORAGE        SECTION.
       01  WK-AREA.
           03  WK-DD          PIC  9(02).
           03  WK-URU-FLG     PIC  X(01).
           03  WK-SHO         PIC S9(05) COMP-3.
           03  WK-AMARI       PIC S9(05) COMP-3.
      *
       LINKAGE                SECTION.
           COPY KCBS010P.
      ******************************************************************
      *    西暦日付チェック
      ******************************************************************
       PROCEDURE              DIVISION
                              USING  KCBS010-P1.
      *    戻り値を初期化
           MOVE  SPACE  TO  S010-RCD.
      *
           PERFORM  INPARM-CHK-RTN.
      *
           IF  (S010-RCD = SPACE)
             IF  (S010-P1-Y1 = ZERO)
               PERFORM  DATE8-CNV-RTN
             END-IF
             IF  (S010-D6-MM = 2) AND (S010-D8-DD = 29)
               PERFORM  URUDOSHI-CHK-RTN
             END-IF
           END-IF.
      *
           GOBACK.
      ******************************************************************
      *    入力パラメータチェック処理
      ******************************************************************
       INPARM-CHK-RTN         SECTION.
      *
      *    数値チェック
           IF  (S010-DATE NOT NUMERIC)
             MOVE  'E'  TO  S010-RCD
             GO TO EXT
           END-IF.
      *
      *    月範囲チェック
           IF  (S010-D6-MM < 1) OR (S010-D6-MM > 12)
             MOVE  'E'  TO  S010-RCD
             GO TO EXT
           END-IF.
      *
      *    日上限値セット
           EVALUATE TRUE
             WHEN  (S010-D6-MM = 2)
               MOVE  29  TO  WK-DD
             WHEN  (S010-D6-MM = 4 OR 6 OR 9 OR 11)
               MOVE  30  TO  WK-DD
             WHEN  OTHER
               MOVE  31  TO  WK-DD
           END-EVALUATE.
      *
      *    日範囲チェック
           IF  (S010-D6-DD < 1)  OR  (S010-D6-DD > WK-DD)
             MOVE  'E'  TO  S010-RCD
             GO TO EXT
           END-IF.
       EXT.
           EXIT.
      ******************************************************************
      *    西暦日付８桁変換処理
      ******************************************************************
       DATE8-CNV-RTN          SECTION.
           IF  (S010-P1-Y1 = ZERO)
             IF  (S010-D6-Y2 < 90)
                 MOVE  20  TO  S010-P1-Y1
             ELSE
                 MOVE  19  TO  S010-P1-Y1
             END-IF
           END-IF.
       EXT.
           EXIT.
      ******************************************************************
      *    閏年チェック処理
      ******************************************************************
       URUDOSHI-CHK-RTN       SECTION.
           MOVE  'N'  TO  WK-URU-FLG.
           DIVIDE  S010-D8-YY  BY  400
                   GIVING  WK-SHO  REMAINDER  WK-AMARI.
      *
           IF  (WK-AMARI = 0)
             MOVE  'Y'  TO  WK-URU-FLG
           ELSE
             DIVIDE  S010-D8-YY  BY  100
                     GIVING  WK-SHO  REMAINDER  WK-AMARI
             IF  (WK-AMARI NOT = 0)
               DIVIDE  S010-D8-YY  BY  4
                       GIVING  WK-SHO  REMAINDER  WK-AMARI
               IF  (WK-AMARI = 0)
                 MOVE  'Y'  TO  WK-URU-FLG
               END-IF
             END-IF
           END-IF.
      *
           IF  (WK-URU-FLG = 'N')
             MOVE  'E'  TO  S010-RCD
           END-IF.
       EXT.
           EXIT.
