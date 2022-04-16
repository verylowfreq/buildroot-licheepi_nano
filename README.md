# Lichee Pi Nano Japanese Kanji Text editor system image builder (Linux, Buildroot)

6秒で起動するLicheePi Nanoの日本語テキストエディタ環境を、Buildrootで構築する。

<img src="https://user-images.githubusercontent.com/60875431/163665416-6fa9d501-efd6-4a31-9e03-1f97d7c6628f.jpg" width=600>

Buildroot 2020.02.1への外部ツリーとして構築されています。Buildrootのメインツリーを改変せずに、追加でこのツリーを読み込ませてビルドします。

Based on https://github.com/unframework/licheepi-nano-buildroot


特記事項：
 - **実質、USBデバイスを1台しか利用できません**。USBキーボードを接続することを想定しています。2台以上接続するとデバイスとして認識はしますがほぼ機能しません。これはAllwinner F1C100sの制約に起因します。
 - シリアルコンソールは ユーザー名 `root` パスワード `root` でログインできます。
 - 起動時点でルートファイルシステムは読み込み専用です。必要に応じて `mount -o remount,rw /` で再マウントしてください。

## ビルド環境の準備

`buildenv/Dockerfile` を参考に、ビルド環境を構築する。（※Dockerの利用は必須ではない。）

## ビルドしてブートする

Buildroot 2020.02.1をダウンロードし、ファイルを展開する。 https://buildroot.org/downloads/buildroot-2020.02.1.tar.bz2  

Buildrootのディレクトリ内へ移動する。

BR2_EXTERNALでこのレポジトリのパスを与えて、defconfigを読み込む。（このレポジトリがローカルの `/work/buildroot-licheepi_nano` にある場合：）
```
make BR2_EXTERNAL=/work/buildroot-licheepi_nano licheepi_nano_defconfig
```

ビルドする。初回はクロスコンパイルツールのビルドもするため、1時間以上かかる場合がある。
```
make
```

ビルドしたシステムイメージは `buildroot-2020.02.1/output/images/sdcard.img` に、microSDのディスクイメージとして出力される。

Linuxならddなど、WindowsならRuFusなどで書き込む。

Lichee Pi Nanoへイメージを書き込んだmicroSDを差し込み、通電すると起動する。

## ハードウェア構成
 - Lichee Pi Nano (Allwinner F1C100s; ARM926EJ-S (ARMv5TE) 533MHz, DDR 32MB)
 - LCDは40pin 480x272のいわゆるPSP液晶系。（秋月電子 ATM0430D25 など。）
 - microSD/SDHC/SDXC 容量80MB以上。
 - （あると便利）USBシリアルアダプタ。UART0に接続する。115200bpsでフロー制御なし。

## システムソフトウェア構成
 - 日本語入力環境: Vim + skk.vim + SKK-JISYO.ML
 - フレームバッファターミナル: yaft (https://github.com/uobikiemukot/yaft)
 - UART0 (dev/ttyS0), UART2 (/dev/ttyS1; CTS/RTS有効) が利用可能
 - qrencode, MicroPython v1.18, micropython-lib

## 既知の問題・制約
 - SPIとI2Cは機能しない。
 - USBデバイスは実質1台しか動作しない。USBハブ自体は利用できる。
   - F1C100sの制約で、内蔵するUSBコントローラの利用可能なエンドポイントの数が極端に少ないため。
 - VimでSKKの日本語入力をする際、最初の変換だけ非常に時間がかかる。

## その他
 - ブートローダ u-bootのキー入力待ちが3秒あるため、起動時間を短縮するならばu-bootコンソールで`setenv bootdelay 0` `saveenv`する。0にしても一瞬だけキー入力判定はある。
 - LCDは5インチの800x480も利用可能。DTSファイルで指定しているパネルの種類を書き換える。I2Cが動作していないためタッチ機能は利用不可。5インチLCDにすると文字サイズが小さくなるかもしれないが、yaftのフォントはビルド時に埋め込みなため、適切なBDFフォントを探したうえで再ビルドが必要。

## このレポジトリのファイル構成（抜粋）
 - buildenv/Dockerfile : ビルド環境を構築するためのDockerfile
 - board/licheepi_nano/
   - boot.cmd : u-bootの起動スクリプト
   - post-build.sh : Buildrootでパッケージをビルドした後の、ルートファイルシステムの改変用
   - post-image.sh : ディスクイメージ作成用
   - licheepi_nano_linux_defconfig : Linuxカーネルコンフィグ
   - suniv-f1c100s-licheepi-nano-custom.dts : カーネルのデバイス認識に関する追加記述（Device Tree）
 - configs/ : Buildrootのコンフィグ
 - patches/ : Buildrootでビルドする際に適用するパッチ
 - package/ : Buildrootでビルドする追加のパッケージ
   - yaft/ : フレームバッファコンソール
   - micropython118/ : MicroPython v1.18（Buildroot 2020.02.1の標準パッケージではv1.12のため）
 - rootfs-overlay/ : ルートファイルシステムに配置するファイル

## ライセンス

GPL v3
