#!/usr/bin/env bash

declare -A _SH_ARGUMENTS
declare -A _SH_SHORTS
declare -A _SH_LONGS
declare -A _SH_TYPES
declare -A _SH_AUTOS

shArgs.arg(){   
    local variableName=$1
    local shortName=$2
    local longName=$3
    local argType=$4
    local auto=$5

    if [ ! -z "$shortName" ]; then
        _SH_SHORTS[$shortName]=$variableName
    fi

    if [ ! -z "$longName" ]; then
        _SH_SHORTS[$longName]=$variableName
    fi

    if [ ! -z "$argType" ]; then
        _SH_TYPES[$variableName]=$argType
    fi
    
    if [ "$argType" == "FLAG" ]; then
        _SH_ARGUMENTS[$variableName]=false
    else
        _SH_ARGUMENTS[$variableName]="" 
    fi

    if [ "$auto" == true ]; then
        _SH_AUTOS[$variableName]=true
    else
        _SH_AUTOS[$variableName]=false
    fi
}

shArgs.parse(){
    local _varName
    local argType
    local autoExport
    while [[ "$#" -gt 0 ]]
    do
        case $1 in
            *)   
                _varName=${_SH_LONGS[$1]}
                if [ -z "$_varName" ]; then
                    _varName=${_SH_SHORTS[$1]}
                fi       
         
                if [ ! -z "$_varName" ]; then
                    argType=${_SH_TYPES[$_varName]}
                    autoExport=${_SH_AUTOS[$_varName]}
                    if [ "$argType" == "FLAG" ]; then
                        _SH_ARGUMENTS[$_varName]=true
                        if [ "$autoExport" == true ]; then
                            eval "$_varName=true"
                        fi
                    else
                        _SH_ARGUMENTS[$_varName]=$2
                        if [ "$autoExport" == true ]; then
                            eval "$_varName=$2"
                        fi
                        shift
                    fi
                fi                
                ;; 
        esac
        shift
    done

}
shArgs.val(){
   echo ${_SH_ARGUMENTS[$1]}
}