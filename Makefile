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

#
# DEV Utils
#

deploy-theme:
	STACK=web WORKING_DIR=/var/src/rise-twenty-two make run TASK=shell RUN_CMD='make -f dev-deploy.mk deploy compile'


deploy-api-plugin:
	STACK=web WORKING_DIR=/var/src/manifold-checkout make run TASK=shell RUN_CMD='make -f dev-deploy.mk deploy'

flush:
	STACK=web WORKING_DIR=/var/www/html make run TASK=shell RUN_CMD='wp cache flush'