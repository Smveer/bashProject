#!/bin/bash

sudo find / -executable \( -perm -4000 -o -perm -2000 \) > list
