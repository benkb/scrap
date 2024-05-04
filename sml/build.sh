set -u

prn(){ printf "%s\n" "$*"; }
die(){ echo "$@" >&2; exit 1; }
fail(){ echo "Fail: $@" >&2;  }

if [ -f 'build-vars.sh' ] ; then
    . './build-vars.sh' || die "Err: could not load 'build-vars.sh'"
else
    die "Err: 'build-vars.sh' missing"
fi


[ -z ${COMPILER_NAME+x} ] && die 'Err: var COMPILER_NAME unset'

[ -z ${INTERP_NAME+x} ] && die 'Err: var INTERP_NAME unset'

BUILD__FILE="build-${COMPILER_NAME}".sh

calculate_homedir(){
    local name="${1:-}"
    if [ -z "$name" ]; then 
        fail "no name"
        return 1
    fi
    local basedir="${2:-}"
    local altdir="${3:-}"
    local version="${4:-}"
    local minor="${5:-}"

    local rootdir=
    if [ -z "$basedir" ] ; then
        if [ -z "$altdir" ] ; then
            fail 'cannot set root dir'
            return 1
        else
            rootdir="$altdir"
        fi
    else
        rootdir="$basedir"
    fi

    if ! [ -d "$rootdir" ] ; then
        fail "rootdir '$rootdir' doesn't exists"
        return 1
    fi

    local homedir=
    for d in "${rootdir}/${name}@${version}/$minor" "${rootdir}/${name}/${version}/$minor" "${rootdir}/${name}@${version}" "${rootdir}/${name}/${version}" "${rootdir}/${name}" "${rootdir}"; do
        if [ -d "$d" ] ; then
            homedir="$d"
            break
        fi
    done

    if [ -d "$homedir" ] ; then
        prn "$homedir"
    else
        fail "could not find bin for '$homedir'"
        return 1
    fi
}


calculate_bin(){
    local name="${1:-}"
    if [ -z "$name" ]; then
        fail "no name"
        return 1
    fi

    local homedir="${2:-}"
    if [ -z "$homedir" ]; then
        fail "no homedir"
        return 1
    fi

    local bin=
    if [ -f "$homedir/bin/$name" ] ; then
        bin="$homedir/bin/$name"
    elif [ -f "$homedir/$name" ] ; then
        bin="$homedir/$name"
    fi

    if [ -f "$bin" ] ; then
        prn "$bin"
    else
        fail "could not find bin for '$bin'"
        return 1
    fi
}

calculate_lib(){
    local libname="${1:-}"
    if [ -z "$libname" ]; then
        fail "no name"
        return 1
    fi

    local homedir="${2:-}"
    if [ -z "$homedir" ]; then
        fail "no homedir"
        return 1
    fi

    local lib=
    if [ -d "$homedir/$libname" ] ; then
        prn "$homedir/$libname"
    else
        fail "could not find lib for '$bin'"
        return 1
    fi

}


BUILD__COMPILER_HOME=
if [ -n "${COMPILER_VERS_BASEDIR:-}" ] ; then
    BUILD__COMPILER_HOME="$(calculate_homedir "$COMPILER_NAME" "${COMPILER_VERS_BASEDIR:-}" "" "${COMPILER_VERS:-}" "${COMPILER_VERS_MINOR:-}")"
elif [ -n "${COMPILER_HOME:-}" ] ; then
    BUILD__COMPILER_HOME="$(calculate_homedir "$COMPILER_NAME" "${COMPILER_HOME:-}" "${COMPILER_HOME_DEFAULT:-}" "${COMPILER_VERS:-}" "${COMPILER_VERS_MINOR:-}")"
fi

[ -d "$BUILD__COMPILER_HOME" ] || die "Err: could not set compiler_homedir under '$BUILD__COMPILER_HOME'"

BUILD__COMPILER_BIN="$(calculate_bin "${COMPILER_NAME:-}" "$BUILD__COMPILER_HOME")" || die "Err: could not calculate compiler bin"

BUILD__COMPILER_LIB=
if [ -n "${COMPILER_LIB:-}" ] ; then
    BUILD__COMPILER_LIB="$(calculate_lib "${COMPILER_LIB:-}" "$BUILD__COMPILER_HOME")" || die "Err: could not calculate compiler lib"
fi


BUILD__INTERP_HOME=
if [ -n "${INTERP_VERS_BASEDIR:-}" ] ; then
    BUILD__INTERP_HOME="$(calculate_homedir "$INTERP_NAME" "${INTERP_VERS_BASEDIR:-}" "" "${INTERP_VERS:-}" "${INTERP_VERS_MINOR:-}")"
elif [ -n "${INTERP_HOME:-}" ] ; then
    BUILD__INTERP_HOME="$(calculate_homedir "$INTERP_NAME" "${INTERP_HOME:-}" "${INTERP_HOME_DEFAULT:-}" "${INTERP_VERS:-}" "${INTERP_VERS_MINOR:-}")"
fi

[ -d "$BUILD__INTERP_HOME" ] || die "Err: could not set compiler_homedir under '$BUILD__INTERP_HOME'"

BUILD__INTERP_BIN="$(calculate_bin "${INTERP_NAME:-}" "$BUILD__INTERP_HOME")" || die "Err: could not calculate"


BUILD__INTERP_LIB=
if [ -n "${INTERP_LIB:-}" ] ; then
    BUILD__INTERP_LIB="$(calculate_lib "${INTERP_LIB:-}" "$BUILD__INTERP_HOME")" || die "Err: could not calculate interp lib"
fi


#echo BUILD__COMPILER_HOME $BUILD__COMPILER_HOME
#echo BUILD__COMPILER_BIN $BUILD__COMPILER_BIN
#echo BUILD__COMPILER_LIB $BUILD__COMPILER_LIB
#
#echo BUILD__INTERP_HOME $BUILD__INTERP_HOME
#echo BUILD__INTERP_BIN $BUILD__INTERP_BIN
#echo BUILD__INTERP_LIB $BUILD__INTERP_LIB


if [ -f "$BUILD__FILE" ] ; then
    source  "$BUILD__FILE"
else
    die "Err: buildfile not exists '$BUILD__FILE'"
fi