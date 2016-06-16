# mezzanine-cms
This packages [Mezzanine](http://mezzanine.jupo.org/), a [Django](https://www.djangoproject.com/) based Content Management Platform, in a stateful docker container to demonstrate Volume Hub capabilities. You can either build the container image from included [Dockerfile](Dockerfile) or use the [docker image](https://hub.docker.com/r/pankajku/mezzanine/) I have pushed to dockerhub. Rebuild the container image if you need to modify the Dockerfile or any of the scripts.

To run mezzanine-cms, ensure that docker is installed o your machine; clone this repo and `cd` to its base directory. We will be using script [`docker-mezz.sh`](docker-mezz.sh) as a convenient wrapper around `docker` command. Feel free to change this script if need be (say you are using a different port or image). Other scripts in the repo such as `runserver.sh`, `createdb.sh` etc. are used only when you create the container image from Dockerfile and hence changes made are not immediately applicable.

## Running mezznine-cms
Look at `docker-mezz.sh` commands and run the container:

```
$ ./docker-mezz.sh
Usage:: ./docker-mezz.sh [run|start|stop|rm|rmf|logs|list|psql|createdb|runserver|bash]
$ ./docker-mezz.sh run
1f27feaf1a3b3467d28936e1815e6377c70339eaa4cb85626884b2b79d10a962
$ ./docker-mezz.sh list
1f27feaf1a3b        pankajku/mezzanine   "/docker-entrypoint.s"   7 seconds ago       Up 7 seconds        5432/tcp, 0.0.0.0:80->8000/tcp   mezz-server
```
The container runs Postgres RDBMS with data and other static files on container internal directories which would get wiped out when the container terminates. To use directories on the host machine, set environment variables `PGDATA_DIR` and `STATIC_DIR` to point to corresponding directories on the host machine (note: this doesn't work with Docker on MacOSX due to a known issue).

```
$ mkdir -p /tmp/mezzanine/pgdata /tmp/mezzanine/static
$ export PGDATA_DIR=/tmp/mezzanine/pgdata
$ export STATIC_DIR=/tmp/mezzanine/static
$ ./docker-mezz.sh run
c8112181ba68627023b2b7671af45bb13effb728890806f8382139c21f5e7faa
$ ls -l /tmp/mezzanine/pgdata
ls: cannot open directory /tmp/pgdata: Permission denied
$ sudo ls -l /tmp/mezzanine/pgdata
total 56
drwx------. 6 systemd-bus-proxy ssh_keys    50 Jun 15 23:11 base
drwx------. 2 systemd-bus-proxy ssh_keys  4096 Jun 15 23:11 global
... snip ...
```

The next step is to create the DB schema for mezzanine-cms. You can choose default for most of the prompted inputs but the password.

```
$ ./docker-mezz.sh createdb
/usr/local/lib/python2.7/dist-packages/mezzanine/utils/conf.py:47: UserWarning: You haven't defined the ALLOWED_HOSTS settings, which Django requires. Will fall back to the domains configured as sites.
  warn("You haven't defined the ALLOWED_HOSTS settings, which "
Operations to perform:
  Apply all migrations: core, redirects, django_comments, sessions, admin, twitter, galleries, sites, auth, blog, generic, contenttypes, conf, forms, pages
Running migrations:
  Rendering model states... DONE
  Applying contenttypes.0001_initial... OK
  Applying auth.0001_initial... OK
  Applying admin.0001_initial... OK
  Applying admin.0002_logentry_remove_auto_add... OK
... snip ...
A site record is required.
Please enter the domain and optional port in the format 'domain:port'.
For example 'localhost:8000' or 'www.example.com'. 
Hit enter to use the default (127.0.0.1:8000): 

Creating default site record: 127.0.0.1:8000 ...


Creating default account ...

Username (leave blank to use 'root'): 
Email address: 
Password: 
Password (again): 
Superuser created successfully.
Installed 2 object(s) from 1 fixture(s)

Would you like to install some initial demo pages?
Eg: About us, Contact form, Gallery. (yes/no): yes

Creating demo pages: About us, Contact form, Gallery ...

Installed 16 object(s) from 3 fixture(s)
```

The above step is rquired ony first time you setup the database and is not required if you restart the container with an external host directory that has already been used.

The last step is to run the Web server in the container.

```
$ ./docker-mezz.sh runserver
/usr/local/lib/python2.7/dist-packages/mezzanine/utils/conf.py:47: UserWarning: You haven't defined the ALLOWED_HOSTS settings, which Django requires. Will fall back to the domains configured as sites.
  warn("You haven't defined the ALLOWED_HOSTS settings, which "
/usr/local/lib/python2.7/dist-packages/mezzanine/utils/conf.py:47: UserWarning: You haven't defined the ALLOWED_HOSTS settings, which Django requires. Will fall back to the domains configured as sites.
  warn("You haven't defined the ALLOWED_HOSTS settings, which "
              .....
          _d^^^^^^^^^b_
       .d''           ``b.
     .p'                `q.
    .d'                   `b.
   .d'                     `b.   * Mezzanine 4.1.0
   ::                       ::   * Django 1.9.7
  ::    M E Z Z A N I N E    ::  * Python 2.7.9
   ::                       ::   * PostgreSQL 9.5.3
   `p.                     .q'   * Linux 3.10.0-327.18.2.el7.x86_64
    `p.                   .q'
     `b.                 .d'
       `q..          ..p'
          ^q........p^
              ''''

Performing system checks...

System check identified no issues (0 silenced).
June 15, 2016 - 23:22:09
Django version 1.9.7, using settings 'myproject.settings'
Starting development server at http://0.0.0.0:8000/
Quit the server with CONTROL-C.
```

Now point your Browser to `http://servername/admin`, replacing `servername` with the actual FQDN of the server running the Mezzanine container. Note that although the Webserver within the container is listening at port 8000, we used the default HTTP port in the URL. This works because port 80 of the host machine is forwarded to port 8000 of the container.

To stop and remove the container, issue the command

```
$ ./docker-mezz.sh rmf
mezz-server
```


