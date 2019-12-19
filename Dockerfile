FROM slzcc/java:java-jdk-1.8.0.201 as jdk

FROM slzcc/sshd:latest

COPY --from=jdk /jdk1.8.0_201 /usr/local/jdk

ENV JAVA_HOME=/usr/local/jdk \
    JAVA_BIN=/usr/local/jdk/bin \
    JRE_HOME=/usr/local/jdk/jre

RUN echo "Acquire::http::Proxy \"http://192.168.7.24:44551\";" > /etc/apt/apt.conf && \
    apt update && \
    apt install -y wget openssh-server supervisor vim net-tools apt-transport-https netcat expect && \
    apt-get install -y fonts-baekmuk fonts-nanum language-pack-zh-hans && \
    rm -rf /var/lib/apt/lists/* && \
    apt clean

ENV TZ="Asia/Shanghai" \
    LANG="zh_CN.utf8"

ENV HADOOP_VERSION=3.2.1

ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION \
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/hadoop-$HADOOP_VERSION/bin:/usr/local/jdk/bin

RUN http_proxy=192.168.7.24:44551 wget -qO- http://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz | tar zx -C /opt/

RUN update-rc.d ssh defaults 98

RUN service ssh start && \
   ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys && \
    chmod 600 -R ~/.ssh/authorized_keys && \
    ssh-keyscan -t rsa localhost -p 22 > ~/.ssh/known_hosts && \
    ssh-keygen -H -f ~/.ssh/known_hosts

RUN echo "" > /etc/apt/apt.conf

COPY start-hadoop /start-hadoop
COPY start-supervisord /start-supervisord
COPY start-zkfc /start-zkfc
COPY check-ready /check-ready
COPY set-ssh-config /set-ssh-config
COPY set-ssh-keyscan /set-ssh-keyscan
