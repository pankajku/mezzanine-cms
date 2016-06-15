# This file is exec'd from settings.py, so it has access to and can
# modify all the variables in settings.py.

# If this file is changed in development, the development server will
# have to be manually restarted because changes will not be noticed
# immediately.

DEBUG = True

# Make these unique, and don't share it with anybody.
SECRET_KEY = "6*=6p8f8q_*l8za)=x#f3odx8fq$4agxdrl23ahq2at$_ygmf5"
NEVERCACHE_KEY = "gx*+it_vuuv-mqn4_%^fh@7$2er)kgqgcac05-kan(%n#6$g--"

DATABASES = {
    "default": {
        # Ends with "postgresql_psycopg2", "mysql", "sqlite3" or "oracle".
        "ENGINE": "django.db.backends.postgresql_psycopg2",
        # DB name or path to database file if using sqlite3.
        "NAME": "vhtest_db",
        # Not used with sqlite3.
        "USER": "vhtest_user",
        # Not used with sqlite3.
        "PASSWORD": "vhtest_pass",
        # Set to empty string for localhost. Not used with sqlite3.
        "HOST": "localhost",
        # Set to empty string for default. Not used with sqlite3.
        "PORT": "",
    }
}

