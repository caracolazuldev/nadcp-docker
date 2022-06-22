include decomposer.mk

MANAGED_DIRS ?= volume/htdocs volume/home volume/logs

${MANAGED_DIRS}:
	mkdir $@

facls:
	TASK=shell WORKING_DIR=/var/src/nadcp-stage make run RUN_CMD='make -f src/facls.mk dev'

shell:
	WORKING_DIR=/var/src TASK=shell make run

db:
	STACK=db make run TASK=db

#
# DEV Utils
#

deploy-theme:
	STACK=dev WORKING_DIR=/var/src/rise-twenty-two make run TASK=shell RUN_CMD='make -f dev-deploy.mk deploy compile'


deploy-api-plugin:
	STACK=dev WORKING_DIR=/var/src/manifold-checkout make run TASK=shell RUN_CMD='make -f dev-deploy.mk deploy'

watch-vue:
	STACK=dev WORKING_DIR=/var/src/rise-twenty-two make run TASK=shell RUN_CMD='npm run watch-vue'

flush:
	STACK=dev WORKING_DIR=/var/www/html make run TASK=shell RUN_CMD='wp cache flush'