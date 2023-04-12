-include conf/project.env
include decomposer.mk

DKC = docker compose

MANAGED_DIRS ?= volume/htdocs volume/home volume/logs

${MANAGED_DIRS}:
	mkdir $@

configure:
	# TODO: integrate the awk script to prompt user for config values
	# see interactive.md	

facls:
	TASK=shell WORKING_DIR=/var/src/nadcp-stage make run RUN_CMD='make -f src/facls.mk dev'

shell:
	$(DKC) exec --workdir /var/www/html shell /bin/bash

sql-cli:
	make run TASK=mysql8-cli STACK=sql-cli

#
# DEV Utils
#

flush:
	WORKING_DIR=/var/www/html make run TASK=shell RUN_CMD='wp cache flush'

watch:
	# TODO: see watch.md

tail-wp:
	WORKING_DIR=/var/www/html make run TASK=shell RUN_CMD='tail -f /var/www/html/wp-content/debug.log'

#
# Container Image Development
#

build-containers:
	$(MAKE) activate STACK=build-image dkc-build

release:
	${MAKE} deactivate
	${MAKE} activate STACK=build-image
	cp docker-compose.yml build-compose.yml
	${MAKE} deactivate
	${MAKE} activate STACK=dev-php7
	cp docker-compose.yml php7-compose.yml
	${MAKE} deactivate
	${MAKE} activate STACK=dev-php8
	cp docker-compose.yml php8-compose.yml
	sed -i 's#$(shell pwd)#.#g' *-compose.yml
	$(MAKE) deactivate
	$(info NB: replace environment vars in compose files.)	

