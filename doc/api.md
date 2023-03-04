# Kernel API

The Kernel API can be called using the interrupt `0x30`, with the function number in `ax`

Return values are stored in ax

| ax | params                 | what it does                  | returns    |
|----|------------------------|------------------------------ | ---------- |
| 1h | si - pointer to string | prints a string               |            |
| 2h | si - pointer to string | gets the length of the string | the length |
