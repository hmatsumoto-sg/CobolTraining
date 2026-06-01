# UPDATEDB - SQL UPDATE Sample Program

PostgreSQLテーブルを更新するCOBOLプログラムのサンプルです。

## 概要

このプログラムは、SALESDATA テーブルのレコードを対話的に更新するサンプルです。
`FETCHDB` プログラムがSELECT/FETCHの例であるのに対し、このプログラムはUPDATE文の使用例を示します。

## 機能

- 受注番号（JUCHU_NO）を指定してレコードを検索
- 現在のデータを表示
- 数量（SURYO）を更新
- 更新後のデータを表示
- トランザクションのコミット/ロールバック処理

## ビルド方法

```bash
make
```

## 実行方法

```bash
make run
# または
./UPDATEDB
```

## 使用例

```
*** UPDATEDB START ***

DB connected.

JUCHU-NO (0=END):
1                          # 受注番号を入力
--------------------------------------
JUCHU-NO  : 0001
JUCHU-DATE: 24-01-15
TOKU-COD  : T001
SHOHIN-NO : S0001
SURYO     : 00100
--------------------------------------

NEW SURYO:
150                        # 新しい数量を入力

UPDATED (COUNT: 000000001)

--------------------------------------
JUCHU-NO  : 0001
JUCHU-DATE: 24-01-15
TOKU-COD  : T001
SHOHIN-NO : S0001
SURYO     : 00150         # 更新されたことを確認
--------------------------------------

JUCHU-NO (0=END):
0                          # 終了
END PROCESS.

TRANSACTION COMMITTED.
TOTAL UPDATES=000000001
*** UPDATEDB END ***
```

## データベース構造

SALESDATA テーブル:
- DATA_KBN (CHAR(1)) - データ区分
- JUCHU_NO (NUMERIC(4)) - 受注番号（主キー）
- JUCHU_YY (NUMERIC(2)) - 受注年
- JUCHU_MM (NUMERIC(2)) - 受注月
- JUCHU_DD (NUMERIC(2)) - 受注日
- TOKU_COD (CHAR(4)) - 得意先コード
- SHOHIN_NO (CHAR(5)) - 商品番号
- SURYO (NUMERIC(5)) - 数量

## プログラムの特徴

### 入力検証

ユーザー入力に対して `IS NUMERIC` チェックを実施しています：
```cobol
IF USER-INPUT IS NOT NUMERIC
  DISPLAY "ERROR: NUMERIC INPUT REQUIRED."
  PERFORM UPDATE-PROCESS-RTN
END-IF.
```

英数字項目から数値項目への転記は直接 `MOVE` を使用しています。
`NUMVAL` 関数は使用していません（非数値データでABENDするリスクがあるため）。

### 埋込SQL (Embedded SQL)

- `EXEC SQL ... END-EXEC` で囲んでSQL文を記述
- esqlOCプリプロセッサでSQL部分を処理
- `:変数名` でCOBOL変数とSQL間でデータをやり取り

### DECLARE SECTION

SQL文で使用する変数は全て `EXEC SQL BEGIN DECLARE SECTION` と `EXEC SQL END DECLARE SECTION` の間で宣言する必要があります。

### トランザクション制御

- 正常終了時: `EXEC SQL COMMIT END-EXEC`
- エラー発生時: `EXEC SQL ROLLBACK END-EXEC`

### エラー処理

- `SQLCODE`: SQL文の実行結果コード
  - 0: 成功
  - 100: データなし (NOT FOUND)
  - その他: エラー
- `SQLERRMC`: エラーメッセージ

## クリーンアップ

```bash
make clean
```

## 参考

- `../fetchdb/FETCHDB.CBL` - SELECT/FETCHの例
- `../fetchdb/SALESDATA.cpy` - テーブル定義
