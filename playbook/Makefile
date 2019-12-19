# makefile config
.DEFAULT_GOAL := deploy_verbose

# common function
_color_red    =\E[1;31m
_color_green  =\E[1;32m
_color_yellow =\E[1;33m
_color_blue   =\E[1;34m
_color_wipe   =\E[0m

define func_echo_status
	printf "[$(_color_blue) info $(_color_wipe)] %s\n" $(1)
endef

define func_echo_status_warn
	printf "[$(_color_yellow) info $(_color_wipe)] %s\n" $(1)
endef

define func_echo_status_success
	printf "[$(_color_green) info $(_color_wipe)] %s\n" $(1)
endef

.PHONY: deploy
deploy:
	@ansible-playbook index.yml -u root -i hosts.ini

.PHONY: deploy_verbose
deploy_verbose:
	@ansible-playbook index.yml -u root -i hosts.ini -v

.PHONY: role
role_%:
	@$(call func_echo_status, "create role -> $*")
	@mkdir -p roles/$*/{defaults,files,handlers,meta,tasks,templates,vars}
	@touch roles/$*/{defaults,handlers,meta,tasks,vars}/main.yml
	@printf -- '---\n' | tee roles/$*/{defaults,handlers,meta,tasks,vars}/main.yml
	@touch roles/$*/tasks/{init.env.yml,init.fetch.yml}
	@printf -- '---\n' | tee roles/$*/tasks/{init.env.yml,init.fetch.yml}
	@printf -- '- import_tasks: %s\n\n' {init.env.yml,init.fetch.yml} >> roles/$*/tasks/main.yml
	@$(call func_echo_status_success, "create role -> $* [ Done ]")
