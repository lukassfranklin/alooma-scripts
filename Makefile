TOP := $(dir $(lastword $(MAKEFILE_LIST)))
include $(TOP)/includes/main.mk

SKIP_CLEAN_PROMPT := yes
include $(TOP)/includes/clean.mk

PIP_REQUIREMENTS := requirements.txt
include $(TOP)/includes/virtualenv.mk

# Import alooma settings from file if it exist
ifneq ("$(wildcard .aloomarc)", "")
    include .aloomarc
    export $(shell sed 's/=.*//' .aloomarc)
endif

# Defaults
export ALOOMA_HOST := app.alooma.com
export ALOOMA_PORT := 443

check-env-vars: | _var_ALOOMA_USERNAME _var_ALOOMA_PASSWORD _var_ALOOMA_HOST _var_ALOOMA_PORT

#> Get the full info on a mapping
check-mapping: | check-env-vars env _var_MAPPING
	$(VIRTUALENV_DIR)/bin/python src/check-mapping.py $(MAPPING)

#> Check for missing consolidation queries for mappings
check-mapping-consolidations: | check-env-vars env
	$(VIRTUALENV_DIR)/bin/python src/check-mapping-consolidations.py

#> Fix table and consolidation for mapping
fix-mapping: | check-env-vars env _var_MAPPING _var_SCHEMA _var_TABLE
	$(VIRTUALENV_DIR)/bin/python src/fix-mapping.py $(MAPPING) $(SCHEMA) $(TABLE)

# Default Variable
NOTIFICATIONS_RAW := false

#> Get notifications from a certain amount of minutes ago until now
get-notifications: | check-env-vars env _var_MINUTES _var_NOTIFICATIONS_RAW
	$(VIRTUALENV_DIR)/bin/python src/get-notifications.py $(MINUTES) $(NOTIFICATIONS_RAW)

.PHONY: check-env-vars check-mapping check-mapping-consolidations fix-mapping get-notifications
