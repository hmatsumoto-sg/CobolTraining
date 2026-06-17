       IDENTIFICATION  DIVISION.
       PROGRAM-ID.     TEST010.
      ******************************************************************
      * システム名　　：研修
      * サブシステム名：共通
      * プログラム名　：日付チェックテストドライバ（全網羅版）
      * 作成日／作成者：2026/06/17　松本 拓
      ******************************************************************
       DATA            DIVISION.
       WORKING-STORAGE SECTION.
      * サブプログラムとやり取りするためのデータ定義（コピー句）
       COPY KCBS010P.

       PROCEDURE       DIVISION.
      ******************************************************************
      * メイン処理
      ******************************************************************
       MAIN-RTN  SECTION.
           DISPLAY "*** KCBS010 TEST START ***".

      * --- 1. 妥当性チェック（エラー系：境界値） ---
           DISPLAY "<< 1. ERROR CASES >>"
      * 数字以外
           PERFORM TEST-INIT
           MOVE "2023A617" TO S010-DATE
           PERFORM CALL-AND-SHOW

      * 月：00 / 13
           PERFORM TEST-INIT
           MOVE 2023 TO S010-D8-YY
           MOVE 00 TO S010-D8-MM
           MOVE 01 TO S010-D8-DD
           PERFORM CALL-AND-SHOW
           PERFORM TEST-INIT
           MOVE 2023 TO S010-D8-YY
           MOVE 13 TO S010-D8-MM
           MOVE 01 TO S010-D8-DD
           PERFORM CALL-AND-SHOW

      * 日：00 / 各月末+1
           PERFORM TEST-INIT
           MOVE 2023 TO S010-D8-YY
           MOVE 01 TO S010-D8-MM
           MOVE 00 TO S010-D8-DD
           PERFORM CALL-AND-SHOW
           PERFORM TEST-INIT
           MOVE 2023 TO S010-D8-YY
           MOVE 01 TO S010-D8-MM
           MOVE 32 TO S010-D8-DD
           PERFORM CALL-AND-SHOW
           PERFORM TEST-INIT
           MOVE 2023 TO S010-D8-YY
           MOVE 04 TO S010-D8-MM
           MOVE 31 TO S010-D8-DD
           PERFORM CALL-AND-SHOW

      * 平年の2/29
           PERFORM TEST-INIT
           MOVE 2023 TO S010-D8-YY
           MOVE 02 TO S010-D8-MM
           MOVE 29 TO S010-D8-DD
           PERFORM CALL-AND-SHOW

      * --- 2. 妥当性チェック（正常系：境界値） ---
           DISPLAY "<< 2. NORMAL CASES >>"
      * 月の境界：01 / 12
           PERFORM TEST-INIT
           MOVE 2023 TO S010-D8-YY
           MOVE 01 TO S010-D8-MM
           MOVE 01 TO S010-D8-DD
           PERFORM CALL-AND-SHOW
           PERFORM TEST-INIT
           MOVE 2023 TO S010-D8-YY
           MOVE 12 TO S010-D8-MM
           MOVE 31 TO S010-D8-DD
           PERFORM CALL-AND-SHOW

      * 各月の月末：31日 / 30日
           PERFORM TEST-INIT
           MOVE 2023 TO S010-D8-YY
           MOVE 11 TO S010-D8-MM
           MOVE 30 TO S010-D8-DD
           PERFORM CALL-AND-SHOW

      * 閏年判定：400 / 100 / 4 で割り切れる場合
           PERFORM TEST-INIT
           MOVE 2000 TO S010-D8-YY
           MOVE 02 TO S010-D8-MM
           MOVE 29 TO S010-D8-DD
           PERFORM CALL-AND-SHOW
           PERFORM TEST-INIT
           MOVE 1900 TO S010-D8-YY
           MOVE 02 TO S010-D8-MM
           MOVE 29 TO S010-D8-DD
           PERFORM CALL-AND-SHOW
           PERFORM TEST-INIT
           MOVE 2024 TO S010-D8-YY
           MOVE 02 TO S010-D8-MM
           MOVE 29 TO S010-D8-DD
           PERFORM CALL-AND-SHOW

      * --- 3. 西暦日付8桁変換（閾値：90） ---
           DISPLAY "<< 3. CONVERSION CASES >>"
      * 閾値：90 / 89
           PERFORM TEST-INIT
           MOVE 00 TO S010-P1-Y1
           MOVE 90 TO S010-D6-Y2
           MOVE 01 TO S010-D6-MM
           MOVE 01 TO S010-D6-DD
           PERFORM CALL-AND-SHOW
           PERFORM TEST-INIT
           MOVE 00 TO S010-P1-Y1
           MOVE 89 TO S010-D6-Y2
           MOVE 01 TO S010-D6-MM
           MOVE 01 TO S010-D6-DD
           PERFORM CALL-AND-SHOW

      * 上2桁あり（変換されない）
           PERFORM TEST-INIT
           MOVE 20230617 TO S010-DATE8
           PERFORM CALL-AND-SHOW

           DISPLAY "*** KCBS010 TEST END ***".
           STOP RUN.
       EXT.
           EXIT.

      ******************************************************************
      * 初期化処理
      ******************************************************************
       TEST-INIT SECTION.
           INITIALIZE KCBS010-P1.
       EXT.
           EXIT.
      ******************************************************************
      * サブプログラム呼び出し処理
      ******************************************************************
       CALL-AND-SHOW SECTION.
           CALL 'KCBS010' USING KCBS010-P1.
           DISPLAY "IN:" S010-DATE " -> OUT: RCD=" S010-RCD
                   " DATE=" S010-DATE8.
       EXT.
           EXIT.
