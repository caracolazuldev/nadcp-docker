include decomposer.mk

MANAGED_DIRS ?= volume/htdocs volume/home volume/logs

${MANAGED_DIRS}:
	mkdir $@

