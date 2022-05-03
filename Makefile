include make/general/Makefile
STACK           := matrix
SERVER_NAME     := matrix.traefik.me
NETWORK         := proxylampy
SYNAPSE_VERSION := v1.57.1
include make/docker/Makefile

SUPPORTED_COMMANDS := linter
SUPPORTS_MAKE_ARGS := $(findstring $(firstword $(MAKECMDGOALS)), $(SUPPORTED_COMMANDS))
ifneq "$(SUPPORTS_MAKE_ARGS)" ""
  COMMANDS_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(COMMANDS_ARGS):;@:)
endif

install: node_modules ## Installation application

linter: node_modules ### Scripts Linter
ifeq ($(COMMANDS_ARGS),all)
	@make linter readme -i
else ifeq ($(COMMANDS_ARGS),readme)
	@npm run linter-markdown README.md
else
	@printf "${MISSING_ARGUMENTS}" "linter"
	$(call array_arguments, \
		["all"]="Launch all linter" \
		["readme"]="linter README.md" \
	)
endif

generate:
	docker run -it --rm -v $(PWD)/synapse:/data -e SYNAPSE_SERVER_NAME=$(SERVER_NAME) -e SYNAPSE_REPORT_STATS=yes -e UID=1000 -e GID=1000 matrixdotorg/synapse:$(SYNAPSE_VERSION) generate

bddset: ## Set bdd
	@cp database_init/01_matrix.sql lampy/postgresql_init/01_matrix.sql