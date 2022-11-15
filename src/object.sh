#!/bin/bash

source "unique.sh"

declare OBJECT_PATH_DELIMITER_STRING=":"
declare OBJECT_PATH_DELIMITER_NUMBER=";"

object_set() {
	local -n _object_ptr_=$1; local _object_path_=$2; local _object_temp_=""; local _object_last_key_=""
	for (( _object_i_=0; _object_i_<${#_object_path_}; _object_i_++ )); do
		_object_char_=${_object_path_:$_object_i_:1}
		case $_object_char_ in
			$OBJECT_PATH_DELIMITER_STRING)
				if [[ $_object_last_key_ != "" ]]; then
					if [[ ${_object_ptr_[$_object_last_key_]} == "" ]]; then
						unique_new _object__ptr_ -A
						_object_ptr_[$_object_last_key_]=$_object__ptr_
						local -n _object_ptr_=$_object__ptr_
					else
						local -n _object_ptr_=${_object_ptr_[$_object_last_key_]}
					fi	
				fi
				_object_last_key_=$_object_temp_
				_object_temp_="" ;;
			$OBJECT_PATH_DELIMITER_NUMBER)
				if [[ ${_object_ptr_[$_object_last_key_]} == "" ]]; then
					unique_new _object__ptr_ -a
					_object_ptr_[$_object_last_key_]=$_object__ptr_
					local -n _object_ptr_=$_object__ptr_
				else
					local -n _object_ptr_=${_object_ptr_[$_object_last_key_]}
				fi	
				_object_last_key_=$_object_temp_
				_object_temp_="" ;;
			*)
				_object_temp_+=$_object_char_ ;;
		esac
	done
	unique_new _object__ptr_ $4
	_object_ptr_[$_object_last_key_]=$_object__ptr_
	local -n _object_out_=$3
	_object_out_=$_object__ptr_
}

object_get() {
	local -n _object_ptr_=$1; local _object_path_=$2; local _object_temp_=""
	for (( _object_i_=0; _object_i_<${#_object_path_}; _object_i_++ )); do
		_object_char_=${_object_path_:$_object_i_:1}
		if [[ $_object_char_ == $OBJECT_PATH_DELIMITER_STRING ]]; then
			local -n _object_ptr_=${_object_ptr_[$_object_temp_]}; _object_temp_=""
		elif [[ $_object_char_ == $OBJECT_PATH_DELIMITER_NUMBER ]]; then
			local -n _object_ptr_=${_object_ptr_[$(( $_object_temp_ ))]}; _object_temp_=""
		else
			_object_temp_+=$_object_char_
		fi
	done
	echo ${!_object_ptr_}
}
