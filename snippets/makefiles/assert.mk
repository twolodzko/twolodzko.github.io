
testme:
	@ echo $(shell expr 2 + 2)

assert:
ifeq ($(RESULT), $(EXPECTED))
	$(info "OK!")
else
	$(error "Test failed")
endif

test-testme:
	$(MAKE) -f assert.mk assert RESULT="$(shell $(MAKE) -f assert.mk testme)" EXPECTED=4
