include decomposer.mk

MANAGED_DIRS ?= volume/htdocs volume/home volume/logs

${MANAGED_DIRS}:
	mkdir $@

facls:
	make STACK=web TASK=facls run

shell:
	STACK=web WORKING_DIR=/var/src make run TASK=shell

db:
	STACK=db make run TASK=db

