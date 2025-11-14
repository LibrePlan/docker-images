MAINTAINER "Jeroen Baten <jeroen@libreplan.dev>, Philippe Poumaroux <poum@cpan.org>"
FROM tomcat:8.5-jdk8-temurin

ARG LIBREPLAN_VERSION=1.4.1
ARG PG_JDBC_VERSION=42.7.4

ENV CATALINA_HOME=/usr/local/tomcat
WORKDIR $CATALINA_HOME

# Basic tools
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      curl xvfb cutycapt fonts-dejavu ca-certificates unzip zip \
 && rm -rf /var/lib/apt/lists/*

# JDBC driver
RUN curl -fsSL -o $CATALINA_HOME/lib/postgresql-jdbc.jar \
    "https://repo1.maven.org/maven2/org/postgresql/postgresql/${PG_JDBC_VERSION}/postgresql-${PG_JDBC_VERSION}.jar"

# LibrePlan WAR download
RUN curl -fL --retry 3 -o $CATALINA_HOME/webapps/libreplan.war \
    "https://downloads.sourceforge.net/project/libreplan/LibrePlan/libreplan_${LIBREPLAN_VERSION}.war"
#COPY ./libreplan.war $CATALINA_HOME/webapps/libreplan.war


# --- Patch Spring 2.5.x Java-versiedetection in both jars ---
# 1) unpack WAR
RUN mkdir -p /tmp/war \
 && unzip -q $CATALINA_HOME/webapps/libreplan.war -d /tmp/war

# 2) Get JdkVersion.class out of a newer spring-core (3.0.7 is safe)
RUN curl -fsSL -o /tmp/spring-core-3.0.7.RELEASE.jar \
      https://repo1.maven.org/maven2/org/springframework/spring-core/3.0.7.RELEASE/spring-core-3.0.7.RELEASE.jar \
 && mkdir -p /tmp/sc3 \
 && (cd /tmp/sc3 && jar xf ../spring-core-3.0.7.RELEASE.jar org/springframework/core/JdkVersion.class)

# 3) Patch spring-core-2.5.6.jar if present
RUN if [ -f /tmp/war/WEB-INF/lib/spring-core-2.5.6.jar ]; then \
       jar uf /tmp/war/WEB-INF/lib/spring-core-2.5.6.jar \
         -C /tmp/sc3 org/springframework/core/JdkVersion.class ; \
    fi

# 4) Also patch the "fat" spring-2.5.6.jar, because the classloader can use that one too
RUN if [ -f /tmp/war/WEB-INF/lib/spring-2.5.6.jar ]; then \
       jar uf /tmp/war/WEB-INF/lib/spring-2.5.6.jar \
         -C /tmp/sc3 org/springframework/core/JdkVersion.class ; \
    fi

# (optional) Throw away the fat-jar to prevent doubling:
# RUN rm -f /tmp/war/WEB-INF/lib/spring-2.5.6.jar

# 5) Pack the WAR back and in its place
RUN (cd /tmp/war && zip -qr /tmp/libreplan_patched.war .) \
 && mv /tmp/libreplan_patched.war $CATALINA_HOME/webapps/libreplan.war \
 && rm -rf /tmp/war /tmp/sc3 /tmp/spring-core-3.0.7.RELEASE.jar

COPY assets/libreplan.xml $CATALINA_HOME/conf/Catalina/localhost/
COPY assets/catalina.policy $CATALINA_HOME/conf/
COPY assets/setenv.sh $CATALINA_HOME/bin/

# (optione) somewat less aggresive JAR-scan for older WARs
#ENV JAVA_OPTS="-Xms512m -Xmx1024m -Djava.awt.headless=true -Dtomcat.util.scan.StandardJarScanFilter.jarsToSkip=*.jar"
ENV JAVA_OPTS="-Xms512m -Xmx1024m -Djava.awt.headless=true \
  -Djava.version=1.6.0 \
  -Djava.specification.version=1.6 \
  -Djava.runtime.version=1.6.0"

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=40s --retries=5 \
  CMD curl -fsS http://localhost:8080/libreplan/ || exit 1

