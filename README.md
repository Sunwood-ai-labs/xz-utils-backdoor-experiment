# xz-utils-backdoor-experiment


## setup

docker-compose build


## experiment

┌──(root㉿cedc0a23c1c3)-[/]
└─# /usr/sbin/sshd

┌──(root㉿cedc0a23c1c3)-[/]
└─# ./detect.sh
probably not vulnerable



wget https://snapshot.debian.org/archive/debian/20240328T025657Z/pool/main/x/xz-utils/liblzma5_5.6.1-1_amd64.deb
apt-get install --allow-downgrades --yes ./liblzma5_5.6.1-1_amd64.deb

┌──(root㉿cedc0a23c1c3)-[/]
└─# ps -aux | grep sshd
root        19  0.0  0.0  16388  1396 ?        Ss   16:03   0:00 sshd: /usr/sbin/sshd [listener] 0 of 10-100 startups
root        80  0.0  0.0   3752  1844 pts/1    S+   16:04   0:00 grep --color=auto sshd

┌──(root㉿cedc0a23c1c3)-[/]
└─# kill 19

┌──(root㉿cedc0a23c1c3)-[/]
└─# ps -aux | grep sshd
root        86  0.0  0.0   3752  1936 pts/1    S+   16:04   0:00 grep --color=auto sshd

┌──(root㉿cedc0a23c1c3)-[/]
└─# /usr/sbin/sshd


┌──(root㉿cedc0a23c1c3)-[/]
└─# ./detect.sh
probably vulnerable


┌──(root㉿cedc0a23c1c3)-[/]
└─# time ssh nonexistant@localhost
The authenticity of host 'localhost (127.0.0.1)' can't be established.
ED25519 key fingerprint is SHA256:f8+JlnuHFQM5FkZemF4Vo+kVdqHEK+vHjNb4AiKh+dk.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'localhost' (ED25519) to the list of known hosts.
nonexistant@localhost: Permission denied (publickey).

real    0m2.382s
user    0m0.110s
sys     0m0.020s


sudo apt update && sudo apt install --yes liblzma5
time ssh nonexistant@localhost


┌──(root㉿cedc0a23c1c3)-[/]
└─# time ssh nonexistant@localhost
nonexistant@localhost: Permission denied (publickey).

real    0m0.139s
user    0m0.096s
sys     0m0.011s



## Discussion
1. バックドアが含まれているliblzmaライブラリを使用した場合、存在しないユーザーに対するSSHログインの試行に約2.382秒かかりました。これは、バックドアによって追加された悪意のあるコードが実行されたためと考えられます。

2. 一方、正規のliblzmaライブラリをインストールした後に同様のSSHログインを試行したところ、わずか0.139秒で完了しました。これは、バックドアが除去され、SSHデーモンが正常に動作していることを示しています。

3. バックドアの有無によるSSHログイン時間の顕著な差は、バックドアがシステムのパフォーマンスに悪影響を与えていることを示唆しています。バックドアによって追加された悪意のあるコードが、SSHデーモンの処理を遅延させていると考えられます。

## Conclusion
1. xz-utilsのバックドアは、SSHデーモンのパフォーマンスに重大な影響を与えます。感染したシステムでは、SSHログインの処理時間が大幅に増加します。

2. バックドアを含むliblzmaライブラリを正規のバージョンに置き換えることで、SSHデーモンのパフォーマンスが回復し、システムが正常に動作するようになります。

3. このような実験は、バックドアの影響を実証的に示し、感染したソフトウェアを特定して対処する重要性を浮き彫りにしています。システム管理者は、定期的にソフトウェアを更新し、信頼できるソースからのみパッケージを入手することが不可欠です。

4. セキュリティ研究者にとって、このようなバックドアの詳細な分析と検証は、悪意のあるコードの動作を理解し、効果的な防御策を開発するために重要な情報を提供します。

以上の考察と結論は、実験結果に基づいていますが、より確実な結論を導き出すためには、追加の実験と分析が必要となる場合があります。