# The "main" utility functions and helpers useful for the common case. Most
# ludicrous makefiles require this file, so it's sensible to `include` it first.

SHELL := /bin/bash

# Helper target for declaring an external executable as a recipe dependency.
#
# For example,
#   `my_target: | _program_awk`
#
# will fail before running the target named `my_target` if the command `awk` is
# not found on the system path.
_program_%: FORCE
	@_=$(or $(shell which $* 2> /dev/null),$(error `$*` command not found. Please install `$*` and try again))

# Helper target for declaring required environment variables.
#
# For example,
#   `my_target`: | _var_PARAMETER`
#
# will fail before running `my_target` if the variable `PARAMETER` is not declared.
_var_%: FORCE
	@_=$(or $($*),$(error `$*`is a required parameter))

# Helper for safely including other ludicrous makefiles, which must be eval'ed.
#
# For example,
#   `$(eval $(call import,ludicrous.mk))`
#
# NOTE: This helper is not intended for external use.
define import
ifneq ($(1),$$(findstring $(1),$$(MAKEFILE_LIST)))
include $$(dir $$(realpath $$(lastword $$(MAKEFILE_LIST))))/$(1).mk
endif
endef

# Miscellaneous helpers
lc = $(shell echo $(1) | tr A-Z a-z)
OS_NAME = ${call lc,$(shell uname -s)}
OS_ARCH = $(if $(findstring x86_64,$(shell uname -m)),amd64,386)

FORCE:
.PHONY: FORCE

# These are particularly useful in most makefiles
$(eval $(call import,log))
$(eval $(call import,help))
