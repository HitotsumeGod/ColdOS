CC=gcc
DBG=valgrind
SRC=src/main
DEPS=src/headers
BUILD=build
SRS=$(SRC)/pilot.c

$(BUILD)/pilot: $(SRS) $(BUILD)
	$(CC) -o $@ $(SRS) -I $(DEPS) -g 
prod: $(SRS) $(BUILD)
	$(CC) -o $(BUILD)/pilot $(SRS) -I $(DEPS)
debug: $(BUILD)/pilot
	$(DBG) --leak-check=full --show-leak-kinds=all --track-origins=yes -s $<
$(BUILD):
	if ! [ -d $@ ]; then		\
		mkdir $@;		\
	fi
clean:
	rm -rf $(BUILD)
	rm -f vgcore.*
