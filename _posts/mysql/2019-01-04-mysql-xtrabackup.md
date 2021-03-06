---
layout: post
title: mysql_xtrabackup
categories: Mysql
date: 2019-01-04 15:49:32
tags:
keywords:
description:
---
```
1、安装源
rpm -Uhv http://www.percona.com/downloads/percona-release/percona-release-0.0-1.x86_64.rpm

2、yum -y install percona-xtrabackup

3、完全备份
innobackupex --user=DBUSER --password=DBUSERPASS /path/to/BACKUP-DIR/

注意，如果只想该命令时报如下这样的错误：
Can't load '/usr/local/lib64/perl5/auto/DBD/mysql/mysql.so' for module DBD::mysql: libmysqlclient.so.18: 无法打开共享对象 at /usr/bin/innobackupex line 18
需要拷贝libmysqlclient.so.18至/usr/lib64:
[root@localhost ~]# cp /usr/local/mysql/lib/libmysqlclient.so.18 /usr/lib64/

各文件说明：
(1)xtrabackup_checkpoints —— 备份类型（如完全或增量）、备份状态（如是否已经为prepared状态）和LSN(日志序列号)范围信息；
每个InnoDB页(通常为16k大小)都会包含一个日志序列号，即LSN。LSN是整个数据库系统的系统版本号，每个页面相关的LSN能够表明此页面最近是如何发生改变的。
(2)xtrabackup_binlog_info —— mysql服务器当前正在使用的二进制日志文件及至备份这一刻为止二进制日志事件的位置。
(3)xtrabackup_binlog_pos_innodb —— 二进制日志文件及用于InnoDB或XtraDB表的二进制日志文件的当前position。
(4)xtrabackup_binary —— 备份中用到的xtrabackup的可执行文件；
(5)backup-my.cnf —— 备份命令用到的配置选项信息；
在使用innobackupex进行备份时，还可以使用--no-timestamp选项来阻止命令自动创建一个以时间命名的目录；如此一来，innobackupex命令将会创建一个BACKUP-DIR目录来存储备份数据。

另外还需注意：备份数据库的用户需要具有相应权限，如果要使用一个最小权限的用户进行备份，则可基于如下命令创建此类用户：

mysql> CREATE USER ‘bkpuser'@'localhost’ IDENTIFIED BY ‘newpasswd’;
mysql> REVOKE ALL PRIVILEGES, GRANT OPTION FROM ‘bkpuser’;
mysql> GRANT RELOAD, LOCK TABLES, REPLICATION CLIENT ON *.* TO ‘bkpuser’@’localhost’;
mysql> FLUSH PRIVILEGES;

5、准备(prepare)一个完全备份
一般情况下，在备份完成后，数据尚且不能用于恢复操作，因为备份的数据中可能会包含尚未提交的事务或已经提交但尚未同步至数据文件中的事务。因此，此时数据文件仍处理不一致状态。“准备”的主要作用正是通过回滚未提交的事务及同步已经提交的事务至数据文件也使得数据文件处于一致性状态。

innobakupex命令的--apply-log选项可用于实现上述功能。如下面的命令：

# innobackupex --apply-log /path/to/BACKUP-DIR



6、对完全备份的后数据库更改进行二进制日志增量备份：

查看完全备份时日志位置：
[root@localhost 2013-10-04_20-31-56]# cat xtrabackup_binlog_info
mysql-bin.000005 107

模拟数据库修改：

mysql> use jiaowu;
Database changed
mysql> INSERT INTO tutors (Tname) VALUES ('stu01');
Query OK, 1 row affected (0.11 sec)

mysql> INSERT INTO tutors (Tname) VALUES ('stu02');
Query OK, 1 row affected (0.00 sec)

增量备份二进制文件：

[root@localhost 2013-10-04_20-31-56]# mysqlbinlog --start-position=107 /data/mysql/mysql-bin.000005 >`date +%F`.sql

注：--start-position=107 可以不指定，因为107是一个日志的默认起始位置。

7、还原数据库
还原完全备份：
innobackupex命令的--copy-back选项用于执行恢复操作，其通过复制所有数据相关的文件至mysql服务器DATADIR目录中来执行恢复过程。innobackupex通过backup-my.cnf来获取DATADIR目录的相关信息。

3.2.1 还原数据库语法：

# innobackupex --copy-back /path/to/BACKUP-DIR
修改还原后的数据目录权限:

8、还原增量备份

为了防止还原时产生大量的二进制日志，在还原时可临时关闭二进制日志后再还原：
mysql> set sql_log_bin=0;
Query OK, 0 rows affected (0.00 sec)
mysql> SOURCE /data/backup/2013-10-04_20-31-56/2013-10-04.sql

重新启动二进制日志并验证还原数据：

mysql> set sql_log_bin=1;
Query OK, 0 rows affected (0.00 sec)


9、使用innobackupex进行增量备份
前面我们进行增量备份时，使用的还是老方法：备份二进制日志。其实xtrabackup还支持进行增量备份。

每个InnoDB的页面都会包含一个LSN信息，每当相关的数据发生改变，相关的页面的LSN就会自动增长。这正是InnoDB表可以进行增量备份的基础，即innobackupex通过备份上次完全备份之后发生改变的页面来实现。

4.1 基本语法：
增量备份前应进行一次完全备份。增量备份语法如下：

innobackupex --incremental /backup --incremental-basedir=BASEDIR

其中，BASEDIR指的是完全备份所在的目录，此命令执行结束后，innobackupex命令会在/backup目录中创建一个新的以时间命名的目录以存放所有的增量备份数据。另外，在执行过增量备份之后再一次进行增量备份时，其--incremental-basedir应该指向上一次的增量备份所在的目录。

需要注意的是，增量备份仅能应用于InnoDB或XtraDB表，对于MyISAM表而言，执行增量备份时其实进行的是完全备份。

为了演示，我们先进行一次完全备份，并在完全备份后对数据做些修改：

[root@localhost ~]# innobackupex --user=root /data/backup

mysql> use jiaowu;
Database changed

mysql> INSERT INTO tutors (Tname) VALUES ('stu03');
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO tutors (Tname) VALUES ('stu04');
Query OK, 1 row affected (0.00 sec)

mysql> INSERT INTO tutors (Tname) VALUES ('stu05');
Query OK, 1 row affected (0.01 sec)

进行增量备份：

[root@localhost ~]# innobackupex --incremental /data/backup --incremental-basedir=/data/backup/2013-10-04_21-45-03/




“准备”(prepare)增量备份与整理完全备份有着一些不同，尤其要注意的是： 
(1)需要在每个备份(包括完全和各个增量备份)上，将已经提交的事务进行“重放”。“重放”之后，所有的备份数据将合并到完全备份上。 
(2)基于所有的备份将未提交的事务进行“回滚”。
于是，操作就变成了，执行完全备份的redo：
# innobackupex --apply-log --redo-only BASE-DIR
接着执行第一个增量：
# innobackupex --apply-log --redo-only BASE-DIR --incremental-dir=INCREMENTAL-DIR-1
而后是第二个增量：
# innobackupex --apply-log --redo-only BASE-DIR --incremental-dir=INCREMENTAL-DIR-2
其中BASE-DIR指的是完全备份所在的目录，而INCREMENTAL-DIR-1指的是第一次增量备份的目录，INCREMENTAL-DIR-2指的是第二次增量备份的目录，其它依次类推，即如果有多次增量备份，每一次都要执行如上操作。
4.3 还原：
在准备步骤完成后，还原时只需要还原完全备份即可，步骤后同3.2，这里不再演示。
# innobackupex --copy-back  /path/to/BACKUP-DIR
5、Xtrabackup的“流”及“备份压缩”功能
Xtrabackup对备份的数据文件支持“流”功能，即可以将备份的数据通过STDOUT传输给tar程序进行归档，而不是默认的直接保存至某备份目录中。要使用此功能，仅需要使用--stream选项即可。如：
# innobackupex --stream=tar  /backup | gzip > /backup/`date +%F_%H-%M-%S`.tar.gz
甚至也可以使用类似如下命令将数据备份至其它服务器：
# innobackupex --stream=tar  /backup | ssh user@www.magedu.com  "cat -  > /backups/`date +%F_%H-%M-%S`.tar"
此外，在执行本地备份时，还可以使用--parallel选项对多个文件进行并行复制。此选项用于指定在复制时启动的线程数目。当然，在实际进行备份时要利用此功能的便利性，也需要启用innodb_file_per_table选项或共享的表空间通过innodb_data_file_path选项存储在多个ibdata文件中。对某一数据库的多个文件的复制无法利用到此功能。其简单使用方法如下：
# innobackupex --parallel  /path/to/backup
同时，innobackupex备份的数据文件也可以存储至远程主机，这可以使用--remote-host选项来实现：
# innobackupex --remote-host=root@www.magedu.com  /path/IN/REMOTE/HOST/to/backup   
6、导入或导出单张表
默认情况下，InnoDB表不能通过直接复制表文件的方式在mysql服务器之间进行移植，即便使用了innodb_file_per_table选项。而使用Xtrabackup工具可以实现此种功能，不过，此时需要“导出”表的mysql服务器启用了innodb_file_per_table选项（严格来说，是要“导出”的表在其创建之前，mysql服务器就启用了innodb_file_per_table选项），并且“导入”表的服务器同时启用了innodb_file_per_table和innodb_expand_import选项。
6.1 “导出”表
导出表是在备份的prepare阶段进行的，因此，一旦完全备份完成，就可以在prepare过程中通过--export选项将某表导出了：
# innobackupex --apply-log --export /path/to/backup
此命令会为每个innodb表的表空间创建一个以.exp结尾的文件，这些以.exp结尾的文件则可以用于导入至其它服务器。
6.2“导入”表
要在mysql服务器上导入来自于其它服务器的某innodb表，需要先在当前服务器上创建一个跟原表表结构一致的表，而后才能实现将表导入：
mysql> CREATE TABLE mytable (...)  ENGINE=InnoDB;
然后将此表的表空间删除：
mysql> ALTER TABLE mydatabase.mytable  DISCARD TABLESPACE;
接下来，将来自于“导出”表的服务器的mytable表的mytable.ibd和mytable.exp文件复制到当前服务器的数据目录，然后使用如下命令将其“导入”：
mysql> ALTER TABLE mydatabase.mytable  IMPORT TABLESPACE;
7、使用Xtrabackup对数据库进行部分备份
Xtrabackup也可以实现部分备份，即只备份某个或某些指定的数据库或某数据库中的某个或某些表。但要使用此功能，必须启用innodb_file_per_table选项，即每张表保存为一个独立的文件。同时，其也不支持--stream选项，即不支持将数据通过管道传输给其它程序进行处理。
此外，还原部分备份跟还原全部数据的备份也有所不同，即你不能通过简单地将prepared的部分备份使用--copy-back选项直接复制回数据目录，而是要通过导入表的方向来实现还原。当然，有些情况下，部分备份也可以直接通过--copy-back进行还原，但这种方式还原而来的数据多数会产生数据不一致的问题，因此，无论如何不推荐使用这种方式。
7.1 创建部分备份
创建部分备份的方式有三种：正则表达式(--include), 枚举表文件(--tables-file)和列出要备份的数据库(--databases)。
7.1.1 使用--include
使用--include时，要求为其指定要备份的表的完整名称，即形如databasename.tablename，如：
# innobackupex --include='^mageedu[.]tb1'  /path/to/backup
7.1.2 使用--tables-file
此选项的参数需要是一个文件名，此文件中每行包含一个要备份的表的完整名称；如：
# echo -e 'mageedu.tb1\nmageedu.tb2' > /tmp/tables.txt 
# innobackupex --tables-file=/tmp/tables.txt  /path/to/backup
7.1.3 使用--databases
此选项接受的参数为数据名，如果要指定多个数据库，彼此间需要以空格隔开；同时，在指定某数据库时，也可以只指定其中的某张表。此外，此选项也可以接受一个文件为参数，文件中每一行为一个要备份的对象。如：
# innobackupex --databases="mageedu testdb"  /path/to/backup
7.2 整理(preparing)部分备份
prepare部分备份的过程类似于导出表的过程，要使用--export选项进行：
# innobackupex --apply-log --export  /pat/to/partial/backup
此命令执行过程中，innobackupex会调用xtrabackup命令从数据字典中移除缺失的表，因此，会显示出许多关于“表不存在”类的警告信息。同时，也会显示出为备份文件中存在的表创建.exp文件的相关信息。
7.3 还原部分备份
还原部分备份的过程跟导入表的过程相同。当然，也可以通过直接复制prepared状态的备份直接至数据目录中实现还原，不要此时要求数据目录处于一致状态。






还原：还原之前，停掉mysqld，然后清空数据目录！恢复的顺序不太一样

Ø 使用innobackupex-1.5.1进行apply-log
innobackupex-1.5.1 --user=root --apply-log /home/db_backup/2011-05-02_21-01-24
Ø 使用xtrabackup将增量备份应用到全备目录2011-05-02_21-01-24中去

xtrabackup --prepare --target-dir=/home/db_backup/2011-05-02_21-01-24/ --incremental-dir=/home/db_backup/2

增量备份应用以后，可以到2011-05-02_21-01-24目录下去看下检查点的信息，比如：

backup_type = full-prepared
from_lsn = 0:0
to_lsn = 6:2510228844
# to_lsn = 6:2510228502变成了6:2510228844

Ø 使用innobackupex-1.5.1进行还原

innobackupex-1.5.1 --user=root --copy-back /home/db_backup/2011-05-02_21-01-24

执行这一步后，大功告成，呵呵！