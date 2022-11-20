#!/bin/bash
source "object_io.sh"

unique_new root -A
object_set $root "array:0;" _ptr -i
declare -n ptr=$_ptr; ptr=50
object_print_json $root 0
