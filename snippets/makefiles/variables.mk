GREET = $(MESSAGE)
MESSAGE := Hi

main:
	@ echo $(GREET) World  # with @ the command is not printed

invalid:
	MESSAGE := Hello
	echo $(MESSAGE) World
