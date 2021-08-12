# Makefile basic env setting
.DEFAULT_GOAL := deploy_verbose


# Hyperconverged Infrastructure
ENV_ANSIBLE          ?= ansible -i $(PROJECT_INVENTORY)
ENV_ANSIBLE_PLAYBOOK ?= ansible-playbook $(PROJECT_PLAYBOOK) -i $(PROJECT_INVENTORY)


# Project setting
DEFAULT_PROJECT_INVENTORY ?= hosts_local.ini
DEFAULT_PROJECT_PLAYBOOK  ?= default.yml
PROJECT_INVENTORY         ?= $(ANSIBLE_INVENTORY)/$(DEFAULT_PROJECT_INVENTORY)
PROJECT_PLAYBOOK          ?= $(ANSIBLE_PLAYBOOK_DIR)/$(DEFAULT_PROJECT_PLAYBOOK)


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


### deploy : Exec ansible-playbook
.PHONY: deploy
deploy:
	@$(ENV_ANSIBLE_PLAYBOOK)


### deploy_verbose : Exec ansible-playbook with verbose mode
.PHONY: deploy_verbose
deploy_verbose:
	@$(ENV_ANSIBLE_PLAYBOOK) -v


### role_% : Create new role with default template
.PHONY: role
role_%:
	$(eval ANSIBLE_ROLES_PATH = $(shell printf $${ANSIBLE_ROLES_PATH%%:*}))
	@$(call func_echo_status, "create role -> $*")
	@mkdir -p $(ANSIBLE_ROLES_PATH)/$*/{defaults,files,handlers,meta,tasks,templates,vars}
	@touch $(ANSIBLE_ROLES_PATH)/$*/{defaults,handlers,meta,tasks,vars}/main.yml
	@printf -- '---\n' | tee $(ANSIBLE_ROLES_PATH)/$*/{defaults,handlers,meta,tasks,vars}/main.yml
	@touch $(ANSIBLE_ROLES_PATH)/$*/tasks/{init.env.yml,init.fetch.yml,init.firewall.yml}
	@printf -- '---\n' | tee $(ANSIBLE_ROLES_PATH)/$*/tasks/{init.env.yml,init.fetch.yml,init.firewall.yml}
	@printf -- '- import_tasks: %s\n\n' {init.env.yml,init.fetch.yml,init.firewall.yml} >> $(ANSIBLE_ROLES_PATH)/$*/tasks/main.yml
	@$(call func_echo_success_status, "create role -> $* [ Done ]")


### list: List all playbook tag
.PHONY: list
list:
	@$(ENV_ANSIBLE_PLAYBOOK) --list-tags


### ping : Check hosts status
.PHONY: ping
ping:
	@$(ENV_ANSIBLE) -m ping target -vvv


### help : Show Makefile rules
.PHONY: help
help:
	@$(call func_echo_success_status, "Makefile rules:")
	@echo
	@awk '{ if(match($$0, /^\s*#{3}\s*(.*)\s*:\s*(.*)$$/, res)){ printf("    make %-15s : %-10s\n", res[1], res[2]) } }' Makefile
	@echo
