# makefile config
.DEFAULT_GOAL := launch

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


.PHONY: launch
launch: _launch clean

.PHONY: _launch
_launch:
	@$(call func_echo_status, "$@ -> [ Start ]")
	@docker-compose run ansible
	@$(call func_echo_status_success, "$@ -> [ Done  ]")

.PHONY: build
build:
	@$(call func_echo_status, "$@ -> [ Start ]")
	@docker-compose build
	@$(call func_echo_status_success, "$@ -> [ Done  ]")

.PHONY: clean
clean:
	@$(call func_echo_status, "$@ -> [ Start ]")
	@docker-compose down
	@$(call func_echo_status_success, "$@ -> [ Done  ]")
