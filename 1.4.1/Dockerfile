FROM tomcat:7
MAINTAINER Philippe Poumaroux <poum@cpan.org>

ENV LIBREPLAN_VERSION 1.4.1

ENV PG_JDBC_URL https://jdbc.postgresql.org/download/postgresql-9.4.1208.jre7.jar 
ENV LIBREPLAN_WAR_URL http://downloads.sourceforge.net/project/libreplan/LibrePlan/libreplan_$LIBREPLAN_VERSION.war 

ADD "$PG_JDBC_URL" $CATALINA_HOME/lib/
COPY assets/libreplan.xml $CATALINA_HOME/conf/Catalina/localhost/
COPY assets/catalina.policy $CATALINA_HOME/conf/
ADD $LIBREPLAN_WAR_URL $CATALINA_HOME/webapps/libreplan.war

RUN apt-get update && apt-get install -y \
    cutycapt \
    xvfb

