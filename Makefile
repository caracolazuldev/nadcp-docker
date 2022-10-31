-include conf/project.env
include decomposer.mk

MANAGED_DIRS ?= volume/htdocs volume/home volume/logs

${MANAGED_DIRS}:
	mkdir $@

facls:
	TASK=shell WORKING_DIR=/var/src/nadcp-stage make run RUN_CMD='make -f src/facls.mk dev'

shell:
	docker-compose exec --workdir /var/www/html shell /bin/bash

sql-cli:
	make run TASK=mysql8-cli STACK=sql-cli

#
# DEV Utils
#

deploy-theme:
	WORKING_DIR=/var/src/rise-twenty-two $(MAKE) exec TASK=shell RUN_CMD=make CMD_ARGS='-f dev-deploy.mk deploy compile'

deploy-api-plugin:
	WORKING_DIR=/var/src/manifold-checkout $(MAKE) exec TASK=shell RUN_CMD=make CMD_ARGS='-f dev-deploy.mk deploy'

watch-vue:
	STACK=dev WORKING_DIR=/var/src/rise-twenty-two make run TASK=shell RUN_CMD='npm run watch-vue'

flush:
	STACK=dev WORKING_DIR=/var/www/html make run TASK=shell RUN_CMD='wp cache flush'

build-containers:
	$(MAKE) activate STACK=build-image dkc-build
