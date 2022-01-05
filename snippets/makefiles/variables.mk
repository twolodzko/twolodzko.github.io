GREET = $(MESSAGE)
MESSAGE := Hi

main:
	echo $(GREET) World

invalid:
	MESSAGE := Hello
	echo $(MESSAGE) World

valid:
	export MSG=Hello
	echo ${MSG} World


