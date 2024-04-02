FROM kalilinux/kali-rolling

RUN apt-get update && apt-get install -y openssh-server

RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

RUN echo 'root:toor' | chpasswd

RUN service ssh start

RUN apt-get install -y wget

COPY detect.sh /detect.sh
RUN chmod +x /detect.sh

CMD ["/usr/sbin/sshd", "-D"]