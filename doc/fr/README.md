![logo](http://planet.libreplan.org/images/libreplan-logo.png)

## Tags pris en charge et lien vers les fichiers Dockerfile correspondants

* [`latest`, `1.4.1`, `latest-postgresql`, `1.4.1-postgresql`, `postgresql`(*1.4.1/Dockerfile*)](https://github.com/LibrePlan/docker-images/blob/master/1.4.1/Dockerfile)
* [`latest-mysql`, `1.4.1-mysql`, `mysql`(*1.4.1-mysql/Dockerfile*)](https://github.com/LibrePlan/docker-images/blob/master/1.4.1-mysql/Dockerfile)

## Qu'est-ce que Libreplan ?

> [wikipedia.org/wiki/LibrePlan](https://en.wikipedia.org/wiki/LibrePlan)

LibrePlan est un outil Open source de gestion de projet qui vous permet de:

- définir des projets
- ajouter des tâches à ces projets dans une structure de découpage de projet (SDP ou WBS: Work Breakdown Structure en anglais)
- ranger ces tâches dans des conteneurs ou des sous-conteneurs
- définir des exigences pour ces tâches
- affecter des ressources à des tâches, soit manuellement, soit automatiquement en se basant sur ces exigences
- affecter des matériaux à ces tâches et saisir des dates prévisionnelles de livraison ou un nombre d'unités reçues
- suivre l'utilisation des ressources
- saisir des informations de temps de travail effectué dans des feuilles de temps
- ajouter des documents de contrôle qualité permettant de donner des informations d'avancement
- voir le montant financier déjà dépensé et le budget monétaire du projet
- être capable de planifier en détail l'affectation des ressources
- configurer un connecteur pour le programme de rapport de bugs Jira
- configurer un connecteur pour le programme d'enregistrement des temps néerlandais Tim Enterprise
- programmer la synchronisation avec Jira ou Tom en utilisant ces connecteurs et le planificateur de tâche embarqué
- saisir l'avancement d'une tâche
- voir les tâches affectées à une ressource et pourvoir saisir le temps qu'elle y a passé ou bien indiquer que la tâche est terminée
- générer des rapports relatifs à l'état actuel du projet
- utiliser un projet comme modèle de projet afin qu'il soit réutilisé
- sous-traiter des tâches à des sous-traitants ou, en tant que sous-traitant, rapporter les progrés réalisés ou une date de livraison prévue au client

Le projet est hébergé sur [github](https://github.com/LibrePlan/libreplan).

Pour obtenir un support commercial pour LibrePlan, allez sur http://www.libreplan.com.

## Comment utiliser cette image ?

Cette image doit être liée à une image [PostgreSQL](https://hub.docker.com/_/postgres/) ou une image [MariaDB](https://hub.docker.com/_/mariadb/) (ou [MySQL](https://hub.docker.com/_/mysql/)) ayant comme nom de machine par défaut 'db'. La base de données doit être initialisée avec le script SQL correspondant. Par défaut, la base de données et l'utilisateur sont nommés '*libreplan*' et le mot de passe associé est '*secret*'. Ces réglages peuvent être modifiés en utilisant des variables d'environnement.

Cette image est basée sur une image [Tomcat 7](https://hub.docker.com/_/tomcat/) et ([Java JRE 7](https://hub.docker.com/_/java/)).

### Postgresql

#### La manière (facile) docker-compose

Utilisez le [fichier docker-compose](https://github.com/LibrePlan/docker-images/blob/master/1.4.1/docker-compose.yml) et le [script d'installation sql](https://github.com/LibrePlan/docker-images/blob/master/1.4.1/sql/install.sql).

#### Créez manuellement 2 conteneurs

##### Lancez un conteneur PostgreSQL

```console
$ docker run \
   --name postgres \
   -v /absolute/path/to/folder/sql:/docker-entrypoint-initdb.d \
   -e POSTGRES_USER=libreplan \
   -e POSTGRES_PASSWORD=secret \
   -d postgres:9.4
```

##### Lancez et liez le conteneur LibrePlan

```console
$ docker run \
  --link postgres:db \
  -p 8080:8080 \
  libreplan/libreplan:latest
```

Puis, utilisez votre navigateur pour accéder à la page http://localhost:8080/libreplan.

### MySQL (ou MariaDB avec un connecteur JDBC MySQL)

#### La manière (facile) docker-compose

Utilisez le [fichier docker-compose](https://github.com/LibrePlan/docker-images/blob/master/1.4.1-mysql/docker-compose.yml) et le [script d'installation sql](https://github.com/LibrePlan/docker-images/blob/master/1.4.1-mysql/sql/1.4.1.sql)

#### Créez manuellement 2 conteneurs

##### Lancez un conteneur MariaDB (ou MySQL)

```console
$ docker run \
   --name mariadb \
   -v /absolute/path/to/folder/sql:/docker-entrypoint-initdb.d \
   -e MYSQL_ROOT_PASSWORD=my-secret-pw \
   -e MYSQL_DATABASE=libreplan \
   -e MYSQL_USER=libreplan \
   -e MYSQL_PASSWORD=secret \
   -d mariadb:latest
```

##### Lancez et liez le conteneur LibrePlan

```console
$ docker run \
  --link mariadb:db \
  -p 3306:3306 \
  libreplan/libreplan:mysql
```

Puis, utilisez votre navigateur pour accéder à la page http://localhost:8080/libreplan.

### Variables d'environnement optionnelles

- `LIBREPLAN_DBHOST`: nom différent pour le serveur de base de données (`db` par défaut)
- `LIBREPLAN_DBPORT`: port différent pour la base de données (5432 par défaut pour PostgreSQL ou 3306 pour MariaDB ou MySQL)
- `LIBREPLAN_DBNAME`: nom différent pour la base de données (`libreplan` par défaut)
- `LIBREPLAN_DBUSER`: nom de connexion à la base de données différent (`libreplan` par défaut)
- `LIBREPLAN_DBPASSWORD`: mot de passe de connexion à la base de données différent (`secret` par défaut). **Changez-le** en production.
