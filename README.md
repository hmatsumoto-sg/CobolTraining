# COBOL言語実習環境

DevContainerを利用したCOBOL言語実習環境のテンプレートリポジトリです。

## 使用できるツール

* [GnuCOBOL 3.2 OSSCONS Patch.2](https://github.com/opensourcecobol/gnucobol-osscons-patch.git)
  * COBOL言語コンパイラ
  * オリジナルのGnuCOBOLは[こちら](https://sourceforge.net/projects/gnucobol/)
* [esqlOC](https://sourceforge.net/p/gnucobol/contrib/HEAD/tree/trunk/esql/) in [GnuCOBOL Contributions](https://sourceforge.net/p/gnucobol/contrib/HEAD/tree/trunk/)
  * ODBC接続を使用するSQLプリプロセッサ
* [GCSORT](https://sourceforge.net/p/gnucobol/contrib/HEAD/tree/trunk/tools/GCSORT/) in [GnuCOBOL Contributions](https://sourceforge.net/p/gnucobol/contrib/HEAD/tree/trunk/)
  * MFSORTのようなソートユーティリティ

## 必要なアプリ

* [Visual Studio Code](https://code.visualstudio.com/)
  * [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) 拡張もインストールしてください。
* Docker
  * Windows/Macをご利用の方は、[Docker Desktop](https://www.docker.com/products/docker-desktop/)をインストールしてください。
* Git
  * Windowsをご利用の方は、[Git for Windows](https://gitforwindows.org/)をインストールしてください。

## 使い方

1. 本リポジトリを適当なフォルダにクローンします。
2. VSCodeを開きクローンしたフォルダを開きます。
3. コマンドパレット(Ctrl + Shift + p)から「開発コンテナ―: コンテナ―で再度開く」を選択
4. エクスプローラにファイルが表示され、操作できるようになったら準備完了です。

## ライセンス

- GnuCOBOLは、`GPLv3`でライセンスされています。[COPYING](https://sourceforge.net/p/gnucobol/code/HEAD/tree/trunk/COPYING)を参照してください。
- esqlOCは、`GPLv3`でライセンスされています。[COPYING](https://sourceforge.net/p/gnucobol/contrib/HEAD/tree/trunk/esql/COPYING)ファイルを参照してください。
  - ランタイムライブラリの ocsql は `LGPLv3`でライセンスされています。[COPYING.LESSER](https://sourceforge.net/p/gnucobol/contrib/HEAD/tree/trunk/esql/COPYING.LESSER)を参照してください。
- GCSORTは、`GPLv3`でライセンスされています。[COPYING](https://sourceforge.net/p/gnucobol/contrib/HEAD/tree/trunk/tools/GCSORT/COPYING)を参照してください。
- 上位機以外のその他、設定ファイル、環境構築スクリプト(.devcontaienrフォルダ内)、サンプルプログラム(sampleフォルダ内)などは`MITライセンス`とします。
