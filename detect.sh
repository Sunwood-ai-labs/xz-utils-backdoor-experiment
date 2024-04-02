#! /bin/bash

set -eu

path="$(ldd $(which sshd) | grep liblzma | grep -o '/[^ ]*')"

if [ "$path" == "" ]
then
    echo probably not vulnerable
    exit
fi

if hexdump -ve '1/1 "%.2x"' "$path" | grep -q f30f1efa554889f54c89ce5389fb81e7000000804883ec28488954241848894c2410
then
    echo probably vulnerable
else
    echo probably not vulnerable
fi