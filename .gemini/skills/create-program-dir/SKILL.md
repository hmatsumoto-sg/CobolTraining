---
name: create-program-dir
description: 引数の１つ目に指定された文字列をプロジェクト名として、所定の場所にプロジェクト名のフォルダを作成し、スクリプトファイルを作成する。
---

- 引数の1つ目に指定された文字列をプロジェクト名を `[[PROJECT-NAME]]` とする。

- programs/[[PROJECT-NAME]] フォルダを作成する。

- programs/[[PROJECT-NAME]]/build.sh を以下の内容で作成し、実行権限をつける
```sh
#!/bin/bash
set -xEeuo pipefail

SCRIPTDIR=$(cd $(dirname $0); pwd)
BINDIR="${SCRIPTDIR}"
COPYLIBDIR="${SCRIPTDIR}/../../copylib"
DIRNAME=$(basename "${SCRIPTDIR}")

# SQLプリプロセス
esqlOC -Q -I "${COPYLIBDIR}" -I . -o "${DIRNAME}.COB" "${DIRNAME}.CBL"

# コンパイル
SRCFILE="${DIRNAME}.COB"
BINFILE=$(basename -s .COB $SRCFILE)

cobc -x -o "${BINDIR}/${BINFILE}" -I"${COPYLIBDIR}" -I. -Q "-Wl,--no-as-needed" -locsql "${SRCFILE}"
```

- programs/[[PROJECT-NAME]]/run.sh を以下の内容で作成し、実行権限をつける
```sh
#!/bin/bash
set -Eeuo pipefail

SCRIPTDIR=$(cd $(dirname $0); pwd)

PROGRAMNAME=$(basename "${SCRIPTDIR}")
BINDIR="${SCRIPTDIR}"
PROGRAM="${BINDIR}/${PROGRAMNAME}"

export ITF="${SCRIPTDIR}/../../data/TEMPLATE_I.dat"
export OTF="${SCRIPTDIR}/../../data/TEMPLATE_O.dat"

${PROGRAM} | iconv -f cp932
```
  - run.sh内の以下の場所**だけ**修正すること。
    - 入出力ファイルの指定(ITFなど)は、[[PROJECT-NAME]]に該当するプログラム設計書を読み込み、その内容にしたがって設定すること。
    - 埋め込みSQLを利用しない場合は、SQLプリプロセス部分のコマンドを削除すること。

- `[[PROGRAM-NAME]].COB`を作成し、内容を以下の通りにする。
```cobol
       IDENTIFICATION  DIVISION.
       PROGRAM-ID.  [[PROGRAM-NAME]].
      ********************************************************
      * システム名    ：研修
      * サブシステム名：
      * プログラム名  ：
      * 作成日／作成者：
      * 変更日／変更者：
      *       変更内容：
      ********************************************************
       ENVIRONMENT  DIVISION.
       INPUT-OUTPUT  SECTION.
      *
      *  編集してください。
      *
       DATA  DIVISION.
       FILE  SECTION.
      *
      *  編集してください。
      *
       WORKING-STORAGE  SECTION.
      *
      *  編集してください。
      *
      ********************************************************
      * コメント
      ********************************************************
       PROCEDURE  DIVISION.
      *
      *  編集してください。
      *
```

- `CHECKLIST.md`を作成する。
  - 以下Markdownを参考にし、[[PROGRAM-NAME]]に該当するプログラム設計書を参照し、チェック項目を作成する。
```markdown
# TEMPLATE 単体テストチェックリスト

## 確認内容の概要

<確認事項概要>

## テスト項目

### 1. 正常系：レコード編集の確認

<正常系確認事項>

- [ ] (1) データ区分が正しく転送されていること
- [ ] (2) 受注番号が正しく転送されていること
- [ ] (3) 受注日付の年上2桁に「0」がセットされ、以降にITFの受注日付（6桁）がセットされていること
- [ ] ...

### 2. 処理全体の確認

<処理全体確認事項>

- [ ] (1) 実行開始時に「*** KJBM010 START ***」が表示されること
- [ ] (2) 実行終了時に「*** KJBM010 END ***」が表示されること
- [ ] (3) 入出力レコード件数（ITF-CNT, OTF-CNT）が正しく表示され、入力件数と出力件数が一致すること
- [ ] (4) レコード作成前にレコード全体がスペースで初期化されていること（予備項目がスペースであること）
- [ ] (5) 数値項目（受注番号、数量）が文字項目として正しく転送（桁ずれ等がない）されていること
- [ ] ...

### 3. 異常系（必要に応じて追加）

<異常系確認事項>

- [ ] (1) 入力ファイルが空の場合でも、正常に終了（件数0件表示）すること
- [ ] ...

```