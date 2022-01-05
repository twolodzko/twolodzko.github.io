TOTAL := 0
HEAD := $(firstword $(LIST))
TAIL := $(wordlist 2, $(words $(LIST)), $(LIST))

sum:
ifeq ($(LIST), )
	@ echo $(TOTAL)
else
	$(MAKE) -f sum.mk LIST="$(TAIL)" TOTAL=$(shell expr $(TOTAL) + $(HEAD))
endif
