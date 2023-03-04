# Kernel API

The Kernel API can be called using the interrupt `0x30`, with the function number in `ax`

| ax | params                 | what it does    |
|----|------------------------|-----------------|
| 1h | si - pointer to string | prints a string |