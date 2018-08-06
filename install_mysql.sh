#!/bin/bash
port=$1 

cwd=$(pwd)
conf_file="${cwd}/my.cnf"
installed_root=/opt/mysql/

echo "/opt/mysql/bin/mysqld_multi start $port " >>/etc/rc.local


datadir=/data/database/mysql_$port
[ -d $datadir ] &&  echo "The database dir is exsit already" && exit
mkdir -p $datadir
chown mysql:mysql $datadir -R

binlogdir=/data/mysql-binlog/mysql_$port
[ -d $binlogdir ] && echo "the log dir is exsit already" && exit
mkdir -p $binlogdir
chown mysql:mysql $binlogdir -R



sed -i "s#3306#$port#g" $conf_file

cd $installed_root
./scripts/mysql_install_db --defaults-file=$conf_file --user=mysql
./bin/mysqld_safe --defaults-file=$conf_file --user=mysql &

for((i=1;i<=30;i++))
do
    netstat -nltp|grep $port
    if [ $? == '0' ]
    then
        $installed_root/bin/mysql -uroot -S /tmp/mysql_$port.sock <<EOF
        drop database test;

        use mysql; 

        delete from user where user=''; 
	GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' IDENTIFIED BY  'NIG6icjeBVd41CuS' WITH GRANT OPTION;
	GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY  'NIG6icjeBVd41CuS' WITH GRANT OPTION;
        GRANT ALL PRIVILEGES ON *.* TO 'root'@'10.%.%.%' IDENTIFIED BY  'NIG6icjeBVd41CuS';
	GRANT ALL PRIVILEGES ON *.* TO 'cdsbapp_user'@'10.%.%.%' IDENTIFIED BY  'TqcJ3ph4H5iN4UgO';
        GRANT ALL PRIVILEGES ON *.* TO 'yanfa'@'%' IDENTIFIED BY  'ixyDA71JyLvKHzXW';
        delete from user where password=''; 
        flush privileges;
        quit
EOF
        break
    else
        sleep 10
    fi
done
