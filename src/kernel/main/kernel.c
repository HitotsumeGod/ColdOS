#include <kernel.h>

void main(void) {

	char a;
	char *welcome = "ColdOS kernel is booted! Welcome to the new system.";
	for (int i = 0; i < 10; i++)
		a = *(welcome + i);
	asm("cli");
	asm("hlt");

}
