# Kernel API

The kernel API can be called using the interrupt `0x30`, with the function number in `ax`

## ax=0x0001 - print string

Parameters: si = pointer to string

Prints the given string to the screen
