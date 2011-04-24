#!/bin/bash

echo -n -e "\n\nPlease type something (or nothing) and press Enter ---> "

read A_STRING

if test "$A_STRING" = ""; then A_STRING="Just the Enter key was pressed"
else A_STRING="You entered '$A_STRING'"
fi

echo -e "\n\n$A_STRING\n\n"
