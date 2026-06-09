       IDENTIFICATION          DIVISION.
       PROGRAM-ID.    KUBM020.

      ******************************************************************
      * システム名　　：研修
      * サブシステム名：売上
      * プログラム名　：売上集計
      * 作成日／作成者：2026/06/08　松本 拓
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
           COPY KUCF010.

       FD  OTF-FILE.
       01  OTF-REC.
           COPY KUCF020.

       WORKING-STORAGE         SECTION.
       01  WK-EOF                       PIC X(1)    VALUE "N".
       01  WK-IN-CNT                    PIC 9(3)    VALUE ZERO.
       01  WK-OUT-CNT                   PIC 9(3)    VALUE ZERO.
       01  WK-GOUKEI-KINGAKU            PIC 9(12)   VALUE ZERO.
       01  WK-HOLD-KEY                              VALUE LOW-VALUES.
           03  WK-HOLD-SHOHIN-NO        PIC 9(5).
           03  WK-HOLD-JUCHU-YM.
               05  WK-HOLD-JUCHU-Y      PIC 9(4).
               05  WK-HOLD-JUCHU-M      PIC 9(2).
       01  WK-CUR-KEY.
           03  WK-CUR-SHOHIN-NO         PIC 9(5)    VALUE ZERO.
           03  WK-CUR-JUCHU-YM.
               05  WK-CUR-JUCHU-Y       PIC 9(4)    VALUE ZERO.
               05  WK-CUR-JUCHU-M       PIC 9(2)    VALUE ZERO.

       PROCEDURE               DIVISION.
      ******************************************************************
      * メイン処理：司令塔の役割
      ******************************************************************
           PERFORM   INIT-RTN.
           PERFORM   MAIN-RTN  UNTIL  WK-EOF = "Y".
           PERFORM   TERM-RTN.
           STOP  RUN.
      ******************************************************************
      * 初期処理：ログの表示、ファイルの読み込み・保持キー設定、初期化
      ******************************************************************
       INIT-RTN                SECTION.
           DISPLAY  "*** KUBM020 START ***".

           OPEN  INPUT   ITF-FILE.
           OPEN  OUTPUT  OTF-FILE.
           
           PERFORM  READ-RTN.
       EXT.
           EXIT.
      ******************************************************************
      * 集計処理：商品番号と受注年月が合うものの金額を足す
      ******************************************************************
       MAIN-RTN                SECTION.
      *出力ファイルの全項目をスペースクリア
           MOVE  SPACE  TO  OTF-REC.
      *カレントキーに現在の数値を転記
           MOVE UF010-SHOHIN-NO OF ITF-REC TO WK-CUR-SHOHIN-NO.
           MOVE UF010-JUCHU-YY  OF ITF-REC TO WK-CUR-JUCHU-Y.
           MOVE UF010-JUCHU-MM  OF ITF-REC TO WK-CUR-JUCHU-M.

      *キーがあっているかの判別
           IF  WK-CUR-KEY  NOT = WK-HOLD-KEY
      *前のグループの内容を編集して出力
               MOVE WK-HOLD-SHOHIN-NO  TO UF020-SHOHIN-NO   OF OTF-REC
               MOVE WK-HOLD-JUCHU-YM   TO UF020-JUCHU-DATE  OF OTF-REC
               MOVE WK-GOUKEI-KINGAKU  TO UF020-KINGAKU     OF OTF-REC
               PERFORM  WRITE-RTN             
      *合計エリアのクリア
               MOVE  ZERO  TO  WK-GOUKEI-KINGAKU
      *保持キーを更新
               MOVE  WK-CUR-KEY  TO  WK-HOLD-KEY
           END-IF.

      *読み込んでいるレコードの加算/減算
           EVALUATE  UF010-DATA-KBN
             WHEN "1"
               ADD  UF010-KINGAKU  OF  ITF-REC  TO  WK-GOUKEI-KINGAKU
             WHEN "9"
               SUBTRACT  UF010-KINGAKU  OF  ITF-REC  
                                              FROM  WK-GOUKEI-KINGAKU
           END-EVALUATE.
           
           PERFORM  READ-RTN.
       EXT.
           EXIT.

      ******************************************************************
      * 終了処理：ファイルを閉じる、件数表示、終了ログ表示
      ******************************************************************
       TERM-RTN                SECTION.
      *最後のグループの内容を編集して出力
           IF  WK-IN-CNT > 0
             MOVE  SPACE  TO  OTF-REC.
             MOVE WK-HOLD-SHOHIN-NO TO UF020-SHOHIN-NO   OF OTF-REC
             MOVE WK-HOLD-JUCHU-YM  TO UF020-JUCHU-DATE  OF OTF-REC
             MOVE WK-GOUKEI-KINGAKU TO UF020-KINGAKU     OF OTF-REC
             PERFORM  WRITE-RTN        
           END-IF.

           CLOSE  ITF-FILE.
           CLOSE  OTF-FILE.
           DISPLAY  "*** ITF = " WK-IN-CNT " ***".
           DISPLAY  "*** OTF = " WK-OUT-CNT " ***".
           DISPLAY  "*** KUBM020 END ***".
       EXT.
           EXIT.

      ******************************************************************
      * 入力処理：ファイルを読み込む
      ******************************************************************
       READ-RTN                SECTION.  
           READ  ITF-FILE
               AT END
                   MOVE "Y" TO WK-EOF
               NOT AT END 
               IF  WK-HOLD-KEY = LOW-VALUES
                 MOVE UF010-SHOHIN-NO OF ITF-REC TO WK-HOLD-SHOHIN-NO
                 MOVE UF010-JUCHU-YY  OF ITF-REC TO WK-HOLD-JUCHU-Y
                 MOVE UF010-JUCHU-MM  OF ITF-REC TO WK-HOLD-JUCHU-M
               END-IF
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
