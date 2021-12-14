include decomposer.mk

MANAGED_DIRS ?= volume/htdocs volume/home volume/logs

${MANAGED_DIRS}:
	mkdir $@

facls:
	make STACK=web TASK=facls run

shell:
	make STACK=web TASK=shell run WORKING_DIR=/var/src