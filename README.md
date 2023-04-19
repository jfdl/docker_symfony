# Symfony development environment with Docker

This is a complete stack for running Symfony 6 in Docker containers.
You need to install your sources to the root of this project and they will be available under `/var/www` of the Apache container.
**:warning: For development only :warning:**

## Features

It consists of five containers:

* `MySQL` (latest)
  * Volume : `db-data:/var/lib/mysql`
* `PhpMyAdmin` (latest)
* `Maildev` (latest)
* `RabbitMq` (3.8.17-management)
* `PHP 8.1 - Apache`
  * **PHP Extensions :** locales, apt-utils, git, libicu-dev, g++, libpng-dev, libjpeg-dev, libxml2-dev, libzip-dev, libonig-dev, libxslt-dev, unzip, libmagickwand-dev, libmcrypt-dev, intl, pdo, pdo_mysql, gd, opcache, zip, calendar, dom, mbstring, xsl, exif, imagick, apcu
  * **Apache Modules :** rewrite, headers, env, http2
  * **Packages :**
    * nodejs (v18.x)
    * yarn (latest)
    * composer (latest)
    * symfony cli (Latest)
  * Your Apache root folder : `/var/www`
  * Your Apache public folder : `/var/www/public`
  * Volume : `.:/var/www`

## Options

All configurable options are stored in the [.env.template](.env.template) file

### Docker

* **Prefix for each Docker image name**
  * DOCKER_PREFIX=my

### Apache

* Apache http exposed port [http://localhost:8090](http://localhost:8090)
  * DOCKER_APACHE_PORT_80=***8090***
* Apache hostname
  * DOCKER_APACHE_HOSTNAME=***mysite.local***

### MySQL

* **Mysql exposed port**
  * DOCKER_MYSQL_PORT_3306=***8306***
* **Database Name**
  * DOCKER_MYSQL_DATABASE=***mydb***
* **MySQL default user**
  * DOCKER_MYSQL_USER=***user***
* **MySQL default password**
  * DOCKER_MYSQL_PASSWORD=***password***
* **MySQL root password**
  * DOCKER_MYSQL_ROOT_PASSWORD=***password***

### PHPMyAdmin

* **PhpMyAdmin GUI exposed port** [http://localhost:8093](http://localhost:8093)
  * DOCKER_PMA_PORT_80=***8093***

### Maildev

* **Maildev GUI exposed port** [http://localhost:8092](http://localhost:8092)
  * DOCKER_MAILDEV_PORT_80=***8092***

### RabitMQ

* **RabbitMQ 5672 exposed port**
  * DOCKER_RABBITMQ_PORT_5672=***5672***
* **RabbitMQ GUI exposed port** [http://localhost:15672](http://localhost:15672)
  * DOCKER_RABBITMQ_PORT_15672=***15672***
* **RabbitMQ default user**
  * DOCKER_RABBITMQ_USER=***user***
* **RabbitMQ default password**
  * DOCKER_RABBITMQ_PASSWORD=***password***

## Getting started

1. If not already done, [install Docker Compose](https://docs.docker.com/compose/install/) (v2.10+)
2. Install **Make** `sudo apt-get install make`
3. Clone this repository `git clone git@github.com:jfdl/docker_symfony.git <your_project_folder>`
4. Go to your project folder `cd <your_project_folder>`
5. Rename .env.template to .env `mv .env.template .env`
6. Change options according to your needs in `.env` file
7. Build and start the containers `make start`
8. Copy your sources at the root of the projet
9. Install the sources according to your composer.json and composer.lock `make composer-install`
10. Install yarn dependencies `make yarn-install`
11. If needed, execute the migrations `make migrate`
12. Compile and install the assets `make yarn-dev`

## How to use those containers with Symfony

In your .env.local file

### Using Messenger with RabbitMq

`MESSENGER_TRANSPORT_DSN=amqp://${DOCKER_RABBITMQ_USER}:${DOCKER_RABBITMQ_PASSWORD}@rabbitmq:${DOCKER_RABBITMQ_PORT_5672}/%2f/messages`

### Using MySQL

`DATABASE_URL="mysql://${DOCKER_MYSQL_USER}:${DOCKER_MYSQL_PASSWORD}@db_mysql/${DOCKER_MYSQL_DATABASE}?serverVersion=5.7"`

### Using Maildev to test emails

`MAILER_DSN=smtp://maildev:1025`

## A Makefile for your convenience

From your project root, you can use commands listed below like this `make` followed by the command you need

For example : `make composer-install` to install your composer dependencies

### docker

* `docker start` Build and start the containers
* `docker build` Build the containers
* `docker up` Start the containers
* `docker down` Stop the containers
* `docker logs` Show live logs
* `docker sh` Connect to the PHP-Apache container

### composer

* `composer-install` Install vendors according to the current composer.lock file
* `composer-install-dev` Install vendors according to the current composer.lock file for development environment
* `composer c=whatever options you need to` Execute composer with the options you need to

### yarn

* `yarn-add c=whatever package you need to` Add yarn package according to arguments passed with c=''
* `yarn-install` Install yarn packages listed under your yarn.lock file
* `yarn-dev` Run yarn dev command to build your assets
* `yarn c='your command'` Run yarn command with the options you need to

### sf

* `sf` List all Symfony commands or pass the parameter "c='your commands'" to run a given command, example: make sf c=about
* `migration` execute `symfony make:migration`
* `migrate` execute `symfony doctrine:migrations:migrate`
* `cc` execute `symfony clear:clache`
