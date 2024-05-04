
[ -n $LUNARML_HOME ] || LUNARML_HOME=$HOME/build/lunarml/lunarml.git

LUABIN=/usr/local/Cellar/lua@5.3/5.3.6/bin/lua5.3

if [ $# -gt 0 ] ; then
    file="$1"
    shift

    target=
    if [ -n "${1:-}" ] ; then
        case "$1" in
            lua|luajit|lua-continuations|nodejs|nodejs-cps) target="$1";;
            *) 
                echo "Err: invalid target '$2'" >&2 
                exit 1
                ;;
        esac
        shift
    else
        target=lua
    fi

    file_dir="$(dirname $file)"
    file_base="$(basename $file)"
    file_name="${file_base%.*}"
    file_ext="${file_base##*.}"

    file_out="$file_dir/$file_name.lua"

#    if ! [ "$file_dir" = "$file_base" ] ; then

    case "$file_ext" in
        sml) 
            rm -f "$file_out"
            lunarml -B$LUNARML_HOME/lib/lunarml --"$target" $@ compile "$file" && ${LUABIN} $file_out

            ;;
        *)
            echo 'no sml file ' $file >&2
            exit 1
            ;;
    esac
fi
