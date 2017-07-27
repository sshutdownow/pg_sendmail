# the extensions name
EXTENSION = pg_sendmail

# script files to install
DATA = pg_sendmail--0.0.1.sql

# our test script file (without extension)
REGRESS = pg_sendmail_test

MODULE_big = pg_sendmail
OBJS = pg_sendmail.o

# postgres build stuff
PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)
