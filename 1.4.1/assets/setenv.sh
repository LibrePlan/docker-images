#!/bin/sh

LIBREPLAN_XML=$CATALINA_HOME/conf/Catalina/localhost/libreplan.xml

if [ "$LIBREPLAN_DBUSER" ]; then
  sed -i "s/username=\"[^\"]*\"/username=\"$LIBREPLAN_DBUSER\"/" $LIBREPLAN_XML
fi

if [ "$LIBREPLAN_DBPORT" ]; then
  if [ -z "$LIBREPLAN_DBHOST" ]; then
    LIBREPLAN_DBHOST=libreplan
  fi

  LIBREPLAN_DBHOST=$LIBREPLAN_DBHOST:$LIBREPLAN_DBPORT
fi

if [ "$LIBREPLAN_DBHOST" ]; then
  sed -i "s/\/\/.*\/libreplan/\/\/$LIBREPLAN_DBHOST\/libreplan/" $LIBREPLAN_XML
fi

if [ "$LIBREPLAN_DBNAME" ]; then
  sed -i "s/\/libreplan\"/\/$LIBREPLAN_DBNAME\"/" $LIBREPLAN_XML
fi

if [ "$LIBREPLAN_DBPASSWORD" ]; then
  sed -i "s/password=\"[^\"]*\"/password=\"$LIBREPLAN_DBPASSWORD\"/" $LIBREPLAN_XML
fi

if [ "$LIBREPLAN_CONTEXT" ]; then
    mv $CATALINA_HOME/conf/Catalina/localhost/libreplan.xml \
       $CATALINA_HOME/conf/Catalina/localhost/$LIBREPLAN_CONTEXT.xml

    mv $CATALINA_HOME/webapps/libreplan.war \
       $CATALINA_HOME/webapps/$LIBREPLAN_CONTEXT.war
fi
