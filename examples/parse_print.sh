#!/bin/bash
source "object_io.sh"

object_parse_json code "$(cat 'test.json')"
object_print_json $code 0
