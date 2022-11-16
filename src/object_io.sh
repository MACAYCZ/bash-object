#!/bin/bash

source object.sh

object_parse_json() {
	local -n _object_io_out_=$1
	local _object_io_text_=$2
	local _object_io_temp_=""
	local _object_io_name_=""
	local -i _object_io_flags_=0
	local -a _object_io_stack_=()
	for (( _object_io_i_=0; _object_io_i_<${#_object_io_text_}; _object_io_i_++ )); do
		_object_io_char_=${_object_io_text_:$_object_io_i_:1}
		if [[ $_object_io_char_ == '"' ]]; then
			_object_io_flags_=$(( $_object_io_flags_ ^ 1 | 2 ))
		elif [[ $(( $_object_io_flags_ & 1 )) == 1 ]] || [[ "$_object_io_char_" =~ ^[0-9]+$ ]]; then
			_object_io_temp_=$_object_io_temp_$_object_io_char_
		elif [[ $_object_io_char_ == '{' ]]; then
			if [[ ${#_object_io_stack_[@]} > 0 ]]; then
				if [[ $(unique_type ${_object_io_stack_[-1]}) == 'A' ]]; then
					object_set ${_object_io_stack_[-1]} "$_object_io_name_$OBJECT_PATH_DELIMITER_STRING" _object_io_object_ -A
					_object_io_stack_+=( $_object_io_object_ )
					_object_io_name_=""
				else
					local -n _object_io_ptr_=${_object_io_stack_[-1]}
					unique_new _object_io_object_ -A
					_object_io_ptr_+=( $_object_io_object_ )
					_object_io_stack_+=( $_object_io_object_ )
				fi
			else
				unique_new _object_io_object_ -A
				_object_io_out_=$_object_io_object_
				_object_io_stack_=( $_object_io_object_ )
			fi
		elif [[ $_object_io_char_ == '}' ]]; then
			if [[ $_object_io_name_ != "" ]]; then
				if [[ $(( $_object_io_flags_ & 2 )) == 2 ]]; then
					object_set ${_object_io_stack_[-1]} "$_object_io_name_$OBJECT_PATH_DELIMITER_STRING" _object_io_object_ --
			 		local -n _object_io_ptr_=$_object_io_object_;
					_object_io_ptr_=$_object_io_temp_
					_object_io_flags_=0
				else
					object_set ${_object_io_stack_[-1]} "$_object_io_name_$OBJECT_PATH_DELIMITER_STRING" _object_io_object_ -i
					local -n _object_io_ptr_=$_object_io_object_
					_object_io_ptr_=$(( $_object_io_temp_ ))
				fi
				_object_io_temp_=""
				_object_io_name_=""
			fi
			unset _object_io_stack_[-1]
		elif [[ $_object_io_char_ == '[' ]]; then
			if [[ ${#_object_io_stack_[@]} > 0 ]]; then
				if [[ $(unique_type ${_object_io_stack_[-1]}) == 'A' ]]; then
					object_set ${_object_io_stack_[-1]} "$_object_io_name_$OBJECT_PATH_DELIMITER_STRING" _object_io_object_ -a
					_object_io_stack_+=( $_object_io_object_ )
					_object_io_name_=""
				else
					local -n _object_io_ptr_=${_object_io_stack_[-1]}
					unique_new _object_io_object_ -a
					_object_io_ptr_+=( $_object_io_object_ )
					_object_io_stack_+=( $_object_io_object_ )
				fi
			else
				unique_new _object_io_object_ -a
				_object_io_out_=$_object_io_object_
				_object_io_stack_=( $_object_io_object_ )
			fi
		elif [[ $_object_io_char_ == ']' ]]; then
			if [[ $(( $_object_io_flags_ & 2 )) == 2 ]]; then
				unique_new _object_io_object_ --
				local -n _object_io_ptr_=$_object_io_object_
				_object_io_ptr_=$_object_io_temp_
				local -n _object_io_ptr_=${_object_io_stack_[-1]}
				_object_io_ptr_+=( $_object_io_object_ )
			elif [[ $_object_io_temp_ != "" ]]; then
				unique_new _object_io_object_ -i
				local -n _object_io_ptr_=$_object_io_object_
				_object_io_ptr_=$(( $_object_io_temp_ ))
				local -n _object_io_ptr_=${_object_io_stack_[-1]}
				_object_io_ptr_+=( $_object_io_object_ )
			fi
			_object_io_temp_=""
			unset _object_io_stack_[-1]
		elif [[ $_object_io_char_ == ':' ]]; then
			_object_io_name_=$_object_io_temp_
			_object_io_flags_=0
			_object_io_temp_=""
		elif [[ $_object_io_char_ == ',' ]]; then
			if [[ $(unique_type ${_object_io_stack_[-1]}) == 'A' ]]; then
				if [[ $_object_io_name_ != "" ]]; then
					if [[ $(( $_object_io_flags_ & 2 )) == 2 ]]; then
						object_set ${_object_io_stack_[-1]} "$_object_io_name_:" _object_io_object_ --
						local -n _object_io_ptr_=$_object_io_object_;
						_object_io_ptr_=$_object_io_temp_
						_object_io_flags_=0
					else
						object_set ${_object_io_stack_[-1]} "$_object_io_name_:" _object_io_object_ -i
						local -n _object_io_ptr_=$_object_io_object_
						_object_io_ptr_=$(( $_object_io_temp_ ))
					fi
					_object_io_temp_=""
					_object_io_name_=""
				fi
			else
				if [[ $(( $_object_io_flags_ & 2 )) == 2 ]]; then
					unique_new _object_io_object_ --
					local -n _object_io_ptr_=$_object_io_object_
					_object_io_ptr_=$_object_io_temp_
					local -n _object_io_ptr_=${_object_io_stack_[-1]}
					_object_io_ptr_+=( $_object_io_object_ )
				elif [[ $_object_io_temp_ != "" ]]; then
					unique_new _object_io_object_ -i
					local -n _object_io_ptr_=$_object_io_object_
					_object_io_ptr_=$(( $_object_io_temp_ ))
					local -n _object_io_ptr_=${_object_io_stack_[-1]}
					_object_io_ptr_+=( $_object_io_object_ )
				fi
				_object_io_temp_=""
			fi
		fi
	done
}

object_print_json() {
	local -n _object_io_root_=$1
	case $( unique_type $1 ) in
		'a')
			echo '[';
			if [[ ${#_object_io_root_[@]} > 0 ]]; then
				for (( _object_io_i_=0; _object_io_i_<$(( ${#_object_io_root_[@]} - 1 )); _object_io_i_++ )); do
					for (( _object_io_j_=0; _object_io_j_<$(( $2 + 1 )); _object_io_j_++ )); do echo -ne \\t ;done
					echo "$(object_print_json ${_object_io_root_[$_object_io_i_]} $(( $2 + 1 ))),"
				done
				for (( _object_io_i_=0; _object_io_i_<$(( $2 + 1 )); _object_io_i_++ )); do echo -ne \\t ;done
				echo "$(object_print_json ${_object_io_root_[-1]} $(( $2 + 1 )))"
			fi
			for (( _object_io_i_=0; _object_io_i_<$2; _object_io_i_++ )); do echo -ne \\t ;done; echo ']'
			;;
		'A')
			echo "{"
			if [[ ${#_object_io_root_[@]} > 0 ]]; then
				_object_io_temp_=("${!_object_io_root_[@]}")
				for (( _object_io_i_=0; _object_io_i_<$(( ${#_object_io_temp_[@]} - 1 )); _object_io_i_++ )); do
					_object_io_key_=${_object_io_temp_[$_object_io_i_]}
					for (( _object_io_j_=0; _object_io_j_<$(( $2 + 1 )); _object_io_j_++ )); do echo -ne \\t ;done
					echo "\"$_object_io_key_\":$(object_print_json ${_object_io_root_[$_object_io_key_]} $(( $2 + 1 ))),"
				done
				_object_io_key_=${_object_io_temp_[-1]}
				for (( _object_io_i_=0; _object_io_i_<$(( $2 + 1 )); _object_io_i_++ )); do echo -ne \\t ;done
				echo "\"$_object_io_key_\":$(object_print_json ${_object_io_root_[$_object_io_key_]} $(( $2 + 1 )))"
			fi
			for (( _object_io_i_=0; _object_io_i_<$2; _object_io_i_++ )); do echo -ne \\t ;done; echo '}'
			;;
		'i')
			echo "$_object_io_root_"
			;;
		*)
			echo "\"$_object_io_root_\""
			;;
	esac
}
