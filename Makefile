# Makefile basic env setting
.DEFAULT_GOAL := launch

#project ?= project/test
#project ?= project/ecs_hashicorp

# Project basic setting
project_name           ?= Ansible_Khala_Oracle
project_version        ?= 1.0.1
project_launch_utc     ?= $(shell date +%Y%m%d%H%M%S)
project_compose        ?= pod/docker-compose.yml
project_release_folder ?= release
project_release_name   ?= $(project_release_folder)/$(project_name)_release.v$(project_version).$(project_launch_utc).tar.gz


# Hyperconverged Infrastructure
ENV_DOCKER_COMPOSE ?= PROJECT_WORKBENCH_DIR=$(project) docker-compose --project-directory $(CURDIR) -p $(project_name) -f $(project_compose)


# Makefile basic extension function
_color_red    =\E[1;31m
_color_green  =\E[1;32m
_color_yellow =\E[1;33m
_color_blue   =\E[1;34m
_color_wipe   =\E[0m


define func_echo_status
	printf "[%b info %b] %s\n" "$(_color_blue)" "$(_color_wipe)" $(1)
endef


define func_echo_warn_status
	printf "[%b info %b] %s\n" "$(_color_yellow)" "$(_color_wipe)" $(1)
endef


define func_echo_success_status
	printf "[%b info %b] %s\n" "$(_color_green)" "$(_color_wipe)" $(1)
endef


define func_check_folder
	if [[ ! -d $(1) ]]; then \
		mkdir -p $(1); \
		$(call func_echo_status, 'folder check -> create `$(1)`'); \
	else \
		$(call func_echo_success_status, 'folder check -> found `$(1)`'); \
	fi
endef


# Makefile target
### help : Show Makefile rules
.PHONY: help
help:
	@$(call func_echo_success_status, "Makefile rules:")
	@echo
	@if [ '$(shell uname -s)' = 'Darwin' ]; then \
		awk '{ if(match($$0, /#{3}(.*):(.*)/)){ split($$0, res, ":"); printf("    make %-15s : %-10s\n", $$2, res[2]) } }' Makefile; \
	else \
		awk '{ if(match($$0, /^\s*#{3}\s*(.*)\s*:\s*(.*)$$/, res)){ printf("    make %-15s : %-10s\n", res[1], res[2]) } }' Makefile; \
	fi
	@echo


### launch : Launch $(PROJECT_NAME) ENV
.PHONY: launch _launch
launch: _launch clean


_launch:
	@$(call func_echo_status, "$@ -> [ Start ]")
	@-$(ENV_DOCKER_COMPOSE) run ansible
	@$(call func_echo_success_status, "$@ -> [ Done  ]")


### exec_% : Exec ansible container make command
.PHONY: exec_%
exec_%:
	@$(call func_echo_status, "exec make command -> $* -> [ Start ]")
	@-$(ENV_DOCKER_COMPOSE) run ansible make $*
	@$(call func_echo_success_status, "exec make command -> $* -> [ Done  ]")


### build : Build the docker image
.PHONY: build
build:
	@$(call func_echo_status, "$@ -> [ Start ]")
	@$(ENV_DOCKER_COMPOSE) build
	@$(call func_echo_success_status, "$@ -> [ Done  ]")


### clean : Clean up docker-compose ENV
.PHONY: clean
clean:
	@$(call func_echo_status, "$@ -> [ Start ]")
	@$(ENV_DOCKER_COMPOSE) down
	@$(call func_echo_success_status, "$@ -> [ Done  ]")


### show : Show docker-compose detail
.PHONY: show
show:
	@$(ENV_DOCKER_COMPOSE) config


### release : Release current project without version control
.PHONY: release
release:
	@$(call func_echo_status, "$@ -> [ Start ]")
	@$(call func_check_folder,$(project_release_folder))
	@if [[ ! -e $(project_release_name) ]]; then \
		touch $(project_release_name); \
	fi
	@tar -zcv \
		--exclude *._* \
		--exclude *.idea \
		--exclude *.git \
		--exclude *.DS_Store \
		--exclude *$(project_release_folder) \
		-f $(project_release_name) .
	@$(call func_echo_success_status, "$@ -> $(project_release_name)-> [ Done  ]")
