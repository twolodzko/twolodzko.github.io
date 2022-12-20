less = $(shell test "$(1)" \< "$(2)"; echo $$?)

isless:
ifeq ($(call less, $(A), $(B)), 0)
	@ echo "$(A) < $(B)"
else
	@ echo "$(A) >= $(B)"
endif
