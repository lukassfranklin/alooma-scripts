# Sanitize PROJECT by removing leading paths or trailing slashes
override PROJECT := $(shell basename $(PROJECT) 2>/dev/null)

REGION ?= us-east-1

# Fail if REGION is set to anything other than us-east-1 or us-west-2
ifdef REGION
VALID_REGIONS := us-east-1 us-west-2
ifeq (,$(findstring $(REGION),$(VALID_REGIONS)))
$(error '$(REGION)' is an invalid region. Must be one of: $(VALID_REGIONS))
endif
endif

# Default ENV to production for mgmt* projects when not provided
ifneq (,$(findstring mgmt,$(PROJECT)))
ENV := $(or $(ENV),production)
endif

ifeq (hybrid-production-vpc,$(PROJECT)-$(ENV)-$(ROLE))
$(error The vpc for the production hybrid environment was not created using terraform. Do no attempt to update it)
endif
