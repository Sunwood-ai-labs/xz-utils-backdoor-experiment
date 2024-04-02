<p align="center">

<br>
<h1 align="center">xz-utils Vuln Test Lab.</h1>
<h2 align="center">～バックドアの実験～</h2>
<img src="docs/icon/icon1.png" width="100%">

</p>

## 概要

本リポジトリは、xz-utilsのバックドアが及ぼす影響を検証するための実験環境を提供します。バックドアを含むliblzmaライブラリを使用した場合のSSHデーモンのパフォーマンスを測定し、正規のライブラリを使用した場合と比較します。

## 実験環境

- OS: Windows
- ディレクトリ構成:
  ```
  C:\Prj\xz-utils-backdoor-experiment
  ├─ detect.sh
  ├─ docker-compose.yml
  ├─ Dockerfile
  ├─ README.md
  ```

## セットアップ

1. リポジトリをクローンまたはダウンロードします。
2. 以下のコマンドを実行して、Dockerイメージをビルドします。
   ```
   docker-compose build
   ```


## 実験手順

1. Dockerコンテナを起動し、コンテナ内でSSHデーモンを起動します。
   ```
   docker-compose up -d
   docker-compose exec kali /bin/bash
   /usr/sbin/sshd
   ```

2. `detect.sh`スクリプトを実行し、現在のliblzmaライブラリがバックドアに感染しているかを確認します。
   ```
   ./detect.sh
   ```
   実行結果:
   ```
   probably not vulnerable
   ```

3. バックドアを含むliblzmaライブラリをダウンロードし、インストールします。
   ```
   wget https://snapshot.debian.org/archive/debian/20240328T025657Z/pool/main/x/xz-utils/liblzma5_5.6.1-1_amd64.deb
   apt-get install --allow-downgrades --yes ./liblzma5_5.6.1-1_amd64.deb
   ```

4. SSHデーモンを再起動し、`detect.sh`スクリプトを再度実行して、バックドアの存在を確認します。
   ```
   ps -aux | grep sshd
   kill <sshd_process_id>
   /usr/sbin/sshd
   ./detect.sh
   ```
   実行結果:
   ```
   probably vulnerable
   ```

5. 存在しないユーザーに対してSSHログインを試行し、処理時間を計測します。
   ```
   time ssh nonexistant@localhost
   ```
   実行結果:
   ```
   The authenticity of host 'localhost (127.0.0.1)' can't be established.
   ED25519 key fingerprint is SHA256:f8+JlnuHFQM5FkZemF4Vo+kVdqHEK+vHjNb4AiKh+dk.
   This key is not known by any other names.
   Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
   Warning: Permanently added 'localhost' (ED25519) to the list of known hosts.
   nonexistant@localhost: Permission denied (publickey).

   real    0m2.382s
   user    0m0.110s
   sys     0m0.020s
   ```

6. 正規のliblzmaライブラリをインストールし、SSHデーモンを再起動します。
   ```
   sudo apt update && sudo apt install --yes liblzma5
   ps -aux | grep sshd
   kill <sshd_process_id>
   /usr/sbin/sshd
   ```

7. 再度、存在しないユーザーに対してSSHログインを試行し、処理時間を計測します。
   ```
   time ssh nonexistant@localhost
   ```
   実行結果:
   ```
   nonexistant@localhost: Permission denied (publickey).

   real    0m0.139s
   user    0m0.096s
   sys     0m0.011s
   ```

初心者にも分かりやすいように、各ステップでの実行コマンドと結果を記載しました。これにより、実験の流れと各コマンドの役割が明確になり、バックドアの影響を確認するプロセスが理解しやすくなります。


## 実験結果と考察

1. バックドアが含まれているliblzmaライブラリを使用した場合、存在しないユーザーに対するSSHログインの試行に約2.382秒かかりました。これは、バックドアによって追加された悪意のあるコードが実行されたためと考えられます。

2. 正規のliblzmaライブラリをインストールした後に同様のSSHログインを試行したところ、わずか0.139秒で完了しました。これは、バックドアが除去され、SSHデーモンが正常に動作していることを示しています。

3. バックドアの有無によるSSHログイン時間の顕著な差は、バックドアがシステムのパフォーマンスに悪影響を与えていることを示唆しています。

## 結論

1. xz-utilsのバックドアは、SSHデーモンのパフォーマンスに重大な影響を与えます。感染したシステムでは、SSHログインの処理時間が大幅に増加します。

2. バックドアを含むliblzmaライブラリを正規のバージョンに置き換えることで、SSHデーモンのパフォーマンスが回復し、システムが正常に動作するようになります。

3. このような実験は、バックドアの影響を実証的に示し、感染したソフトウェアを特定して対処する重要性を浮き彫りにしています。

4. セキュリティ研究者にとって、このようなバックドアの詳細な分析と検証は、悪意のあるコードの動作を理解し、効果的な防御策を開発するために重要な情報を提供します。

本実験は、xz-utilsバックドアの影響を実証的に示しましたが、より確実な結論を導き出すためには、追加の実験と分析が必要となる場合があります。

## 免責事項

本リポジトリは、教育および研究目的で提供されています。実験で使用されるバックドアを含むソフトウェアは、悪意のある目的で使用してはいけません。実験の実行は、自己責任で行ってください。