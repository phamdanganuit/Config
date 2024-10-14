#!/bin/bash

# Cài đặt các gói cần thiết
sudo apt update
sudo apt install -y openjdk-11-jdk ssh wget

# Tải và giải nén Hadoop
HADOOP_VERSION="3.3.1"
wget https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
tar -xzf hadoop-${HADOOP_VERSION}.tar.gz
sudo mv hadoop-${HADOOP_VERSION} /usr/local/hadoop

# Thiết lập biến môi trường
echo "export HADOOP_HOME=/usr/local/hadoop" >> ~/.bashrc
echo "export PATH=\$PATH:\$HADOOP_HOME/bin" >> ~/.bashrc
echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> ~/.bashrc
source ~/.bashrc

# Tạo thư mục HDFS
sudo mkdir -p /usr/local/hadoop/tmp
sudo chown -R $USER:$USER /usr/local/hadoop/tmp
chmod 755 /usr/local/hadoop/tmp

# Cấu hình mapred-site.xml
cat <<EOL | sudo tee /usr/local/hadoop/etc/hadoop/mapred-site.xml
<?xml version="1.0"?>
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
    <property>
        <name>mapreduce.map.memory.mb</name>
        <value>1024</value>
    </property>
    <property>
        <name>mapreduce.reduce.memory.mb</name>
        <value>1024</value>
    </property>
    <property>
        <name>mapreduce.map.java.opts</name>
        <value>-Xmx800m</value>
    </property>
    <property>
        <name>mapreduce.reduce.java.opts</name>
        <value>-Xmx800m</value>
    </property>
</configuration>
EOL

# Cấu hình core-site.xml
cat <<EOL | sudo tee /usr/local/hadoop/etc/hadoop/core-site.xml
<?xml version="1.0"?>
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://localhost:9000</value>
    </property>
</configuration>
EOL

# Cấu hình hdfs-site.xml
cat <<EOL | sudo tee /usr/local/hadoop/etc/hadoop/hdfs-site.xml
<?xml version="1.0"?>
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
</configuration>
EOL

# Khởi động Hadoop
/usr/local/hadoop/sbin/start-dfs.sh
/usr/local/hadoop/sbin/start-yarn.sh

echo "Hadoop đã được cài đặt và khởi động thành công!"
