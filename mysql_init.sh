
#!/bin/bash
yum -y install make gcc-c++ cmake bison-devel ncurses-devel libaio libaio-devel
useradd mysql -s /sbin/nologin
cd /usr/local/src
tar -zxvf mysql-5.6.30.tar.gz
cd mysql-5.6.30
cmake -DCMAKE_INSTALL_PREFIX=/opt/mysql -DMYSQL_DATADIR=/data/mysql/data -DSYSCONFDIR=/etc -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_MEMORY_STORAGE_ENGINE=1 -DWITH_READLINE=1 -DMYSQL_UNIX_ADDR=/tmp/mysql.sock -DMYSQL_TCP_PORT=3306 -DENABLED_LOCAL_INFILE=1 -DWITH_PARTITION_STORAGE_ENGINE=1 -DEXTRA_CHARSETS=all -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_READLINE=1

make && make install
