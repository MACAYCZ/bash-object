#!/bin/bash
source "object.sh"

unique_new root -A
object_set $root "array:0;object:" _ptr --
declare -n ptr=$_ptr; ptr="Hello, world!"
declare -n ptr=$(object_get $root "array:0;object:")
echo $ptr
