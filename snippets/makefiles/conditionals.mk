VARIABLE := 1

cond:
ifeq ($(VARIABLE), 1)
	echo 1
else
	echo 0
endif

# invalid:
# ifeq ($(shell $(MAKE) -f conditionals.mk cond), 1)
# 	echo "it's 1"
# else
# 	echo "it's not 1"
# endif

impl:
ifeq ($(CONDITION), 1)
	echo "it's 1"
else
	echo "it's not 1"
endif

valid:
	$(MAKE) -f conditionals.mk impl CONDITION="$(shell $(MAKE) -f conditionals.mk cond)"
