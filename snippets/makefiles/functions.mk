GREET := Hello

hello:
	@ echo "$(GREET) World!"

date:
	@ echo $(shell date)

message:
	@ $(MAKE) -f functions.mk hello GREET=Hi
	@ echo "It's" "$(shell $(MAKE) -f functions.mk date)"
