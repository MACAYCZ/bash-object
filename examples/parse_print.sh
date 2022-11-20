#!/bin/bash
source "object_io.sh"

object_parse_json root "$(cat 'test.json')"
object_print_json $root 0
