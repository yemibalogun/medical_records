#!/usr/bin/env bash
# Use this script to test if a given TCP host/port are available

TIMEOUT=15
QUIET=0
HOST=""
PORT=""

echoerr() { if [[ $QUIET -ne 1 ]]; then echo "$@" 1>&2; fi }

usage()
{
    exitcode="$1"
    cat << USAGE >&2
Usage:
    $0 host:port [-t timeout] [-- command args]
    -q | --quiet                        Do not output any status messages
    -t TIMEOUT | --timeout=timeout      Timeout in seconds, zero for no timeout
    -- COMMAND ARGS                     Execute command with args after the test finishes
USAGE
    exit "$exitcode"
}

wait_for()
{
    if [[ "$TIMEOUT" -gt 0 ]]; then
        echoerr "$0: waiting $TIMEOUT seconds for $HOST:$PORT"
    else
        echoerr "$0: waiting for $HOST:$PORT without a timeout"
    fi
    start_ts=$(date +%s)
    while :
    do
        if [[ "$ISBUSY" -eq 1 ]]; then
            nc -z "$HOST" "$PORT"
            result=$?
        else
            (echo > /dev/tcp/"$HOST"/"$PORT") >/dev/null 2>&1
            result=$?
        fi
        if [[ $result -eq 0 ]]; then
            end_ts=$(date +%s)
            echoerr "$0: $HOST:$PORT is available after $((end_ts - start_ts)) seconds"
            break
        fi
        sleep 1
    done
    return $result
}

wait_for_wrapper()
{
    # In busybox, nc uses the openbsd version
    if nc -h 2>&1 | grep -q "openbsd"; then
        ISBUSY=1
    else
        ISBUSY=0
    fi
    wait_for
}

while [[ $# -gt 0 ]]
do
    case "$1" in
        *:* )
        HOST=$(printf "%s\n" "$1"| cut -d : -f 1)
        PORT=$(printf "%s\n" "$1"| cut -d : -f 2)
        shift 1
        ;;
        -q | --quiet)
        QUIET=1
        shift 1
        ;;
        -t)
        TIMEOUT="$2"
        if [[ "$TIMEOUT" = "" ]]; then break; fi
        shift 2
        ;;
        --timeout=*)
        TIMEOUT="${1#*=}"
        shift 1
        ;;
        --)
        shift
        break
        ;;
        --help)
        usage 0
        ;;
        *)
        echoerr "Unknown argument: $1"
        usage 1
        ;;
    esac
done

if [[ "$HOST" = "" || "$PORT" = "" ]]; then
    echoerr "Error: you need to provide a host and port to test."
    usage 2
fi

wait_for_wrapper "$@"
