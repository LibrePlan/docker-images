FROM tomcat:7
MAINTAINER Philippe Poumaroux <poum@cpan.org>

ENV LIBREPLAN_VERSION 1.4.1

ENV MYSQL_JAR_VERSION 5.1.38
ENV MYSQL_JAR mysql-connector-java-$MYSQL_JAR_VERSION
ENV MYSQL_JDBC_URL http://dev.mysql.com/get/Downloads/Connector-J/$MYSQL_JAR.tar.gz

ENV LIBREPLAN_MYSQL_WAR_URL http://downloads.sourceforge.net/project/libreplan/LibrePlan/libreplan_mysql_$LIBREPLAN_VERSION.war 

RUN curl -SL $MYSQL_JDBC_URL \
    | tar -xzC $CATALINA_HOME/lib/ $MYSQL_JAR/$MYSQL_JAR-bin.jar \
    && mv $CATALINA_HOME/lib/$MYSQL_JAR/$MYSQL_JAR-bin.jar $CATALINA_HOME/lib/ \
    && rm -rf $CATALINA_HOME/lib/$MYSQL_JAR

COPY assets/libreplan.xml $CATALINA_HOME/conf/Catalina/localhost/
COPY assets/catalina.policy $CATALINA_HOME/conf/
ADD $LIBREPLAN_MYSQL_WAR_URL $CATALINA_HOME/webapps/libreplan.war

RUN apt-get update && apt-get install -y \
    cutycapt \
    xvfb

