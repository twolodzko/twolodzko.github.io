LIST := 1 2 3 4

main:
	@ echo $(words $(LIST))
	@ echo $(firstword $(LIST))
	@ echo $(word 2, $(LIST))
	@ echo $(wordlist 2, 3, $(LIST))
