#/usr/sh

########################## ABOUT #############################
#
# This script configure BIServer with postgresql
#
##############################################################

# Try get 5 arguments to configure data integration, they
# are essential to run mysql, so if you don't entry with 5 arguments:
# YOU SHALL NOT PASS!

if [ "$#" -eq 5 ];
then
	# Directory where is installed Esquadro
	WORK_DIR=$1
	HOST_DB=$2
	PORT_DB=$3
	USER_DB=$4
	PASSWORD_DB=$5
else
	echo "It is needed 5 arguments... Please try again!"
	exit 0;
fi

# Locate of postgres sqls
POSTGRES_CFG_DIR=biserver-ce/data/postgresql

# The follow scripts will create basic settings.
# The last sql will generate an basic schemma to an database OLAP
#
# The following sql files have UTF-8 encoding that can not be supported by
# some systems. To resolve this, it's need remove or change encoding,
# entering into the folder linked by $POSTGRES_CFG_DIR.

echo "Performing the necessary files sqls..."

psql -U postgres -f $WORK_DIR/$POSTGRES_CFG_DIR/create_jcr_postgresql.sql
psql -U postgres -f $WORK_DIR/$POSTGRES_CFG_DIR/create_quartz_postgresql.sql
psql -U postgres -f $WORK_DIR/$POSTGRES_CFG_DIR/create_repository_postgresql.sql

echo "Database was created!"

echo "Copy files required by biserver with right configuration..."

# Copy new files, with right configuration!
# BIServer needs some settings to run with MYSQL, so the follow archives copy this
FILES_CONFIG=filesToConfigurePostgreSQL

# Folder of biserver
BISERVER_DIR=$WORK_DIR/biserver-ce

cp -avr $FILES_CONFIG/context.xml $BISERVER_DIR/tomcat/webapps/pentaho/META-INF/
cp -avr $FILES_CONFIG/applicationContext-spring-security-hibernate.properties $BISERVER_DIR/pentaho-solutions/system/
cp -avr $FILES_CONFIG/hibernate-settings.xml $BISERVER_DIR/pentaho-solutions/system/hibernate/
cp -avr $FILES_CONFIG/postgresql.hibernate.cfg.xml $BISERVER_DIR/pentaho-solutions/system/hibernate/
cp -avr $FILES_CONFIG/quartz.properties $BISERVER_DIR/pentaho-solutions/system/quartz/
cp -avr $FILES_CONFIG/repository.xml $BISERVER_DIR/pentaho-solutions/system/jackrabbit/
cp -avr $FILES_CONFIG/workspace.xml $BISERVER_DIR/pentaho-solutions/system/jackrabbit/repository/workspaces/default/

echo "Finish..."
