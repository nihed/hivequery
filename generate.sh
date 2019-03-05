#!/bin/bash
databases=`beeline --showheader=false --outputformat=dsv --silent=true --verbose=false -u jdbc:hive2://localhost:10000/ -e "show databases"`
echo $databases
echo "" > result.sql
for database in $databases
do
    tables=`beeline --showheader=false --outputformat=dsv --silent=true --verbose=false -u jdbc:hive2://localhost:10000/ -e "use $database; show tables"`
    echo "====================database $database :: " >> result.sql
	echo "create database $database;" >> result.sql
	echo "use database $database;" >> result.sql
    for table in $tables
    do
	    create=`beeline --showheader=false --outputformat=dsv --silent=true --verbose=false -u jdbc:hive2://localhost:10000/ -e "use $database; show create table $table"`
		echo "====================table $table :: " >> result.sql
		echo "$create ;" >> result.sql
		partitions=`beeline --showheader=false --outputformat=dsv --silent=true --verbose=false -u jdbc:hive2://localhost:10000/ -e "use $database; show partitions $table"`
		for partition in $partitions
		do
		    echo "ALTER TABLE $table ADD PARTITION ($partition);" >> result.sql
		done
		
    done    		
done
