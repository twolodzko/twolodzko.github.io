
define date
	$(shell date)
endef

sum = $(shell expr $(1) + $(2))

main:
	@ echo "Today is" "$(date)"
	@ echo "2 + 2 =" $(call sum,2,2)
