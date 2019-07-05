#!/bin/bash
# zyp-file - apt-file clone for zypp
#
# Written in 2013 by Benjamin Poirier benjamin.poirier@gmail.com
#
# To the extent possible under law, the author(s) have dedicated all copyright
# and related and neighboring rights to this software to the public domain
# worldwide. This software is distributed without any warranty. 
#
# You should have received a copy of the CC0 Public Domain Dedication along
# with this software. If not, see
# <http://creativecommons.org/publicdomain/zero/1.0/>.

progname=$(basename "$0")
libdir=$(dirname "$(readlink -f "$0")")

usage () {
	echo "Usage: $0 <command> [args]"
	echo ""
	echo "Available commands are:"
	echo "   search <extended regular expression>"
	echo "   show <package name regex>"
	echo "   update"
}

TEMP=$(getopt -o h --long help -n "$progname" -- "$@")

if [ $? != 0 ]; then
	echo "Error: getopt error" >&2
	exit 1
fi

# Note the quotes around `$TEMP': they are essential!
eval set -- "$TEMP"

while true ; do
        case "$1" in
		-h|--help)
			usage
			exit 0
			;;
		--)
			shift
			break
			;;
		*)
			echo "Error: could not parse arguments" >&2
			exit 1
			;;
        esac
	shift
done

if [ -z "$1" ]; then
	echo "Error: too few arguments" > /dev/stderr
	usage > /dev/stderr
	exit 1
fi

userarch="$HOME/.zyp-file/ARCHIVES.gz"
sysarch="/var/lib/pin/ARCHIVES.gz"
arch=

if [ -r "$userarch" -a -r "$sysarch" ]; then
	if [ "$userarch" -nt "$sysarch" ]; then
		arch=$userarch
	else
		arch=$sysarch
	fi
elif [ -r "$userarch" ]; then
	arch=$userarch
elif [ -r "$sysarch" ]; then
	arch=$sysarch
fi

action=$1
shift
case "$action" in
	update)
		. /etc/os-release
		dir=$(dirname "$userarch")
		mkdir -p "$dir"
		cd "$dir"
		wget -N "http://download.opensuse.org/distribution/leap/$VERSION_ID/repo/oss/ARCHIVES.gz"
		;;
	search | show)
		if [ -z "$arch" ]; then
			echo "Error: ARCHIVES.gz not found. Use the \"update\" command." > /dev/stderr
			exit 1
		fi
		pattern=$1
		shift
		zcat $arch | awk -v pattern="$pattern" -f $libdir/zyp-file-$action.awk | sort | uniq
		;;
	*)
		echo "Error: unknown command '$action'" > /dev/stderr
		usage > /dev/stderr
		exit 1
		;;
esac

if [ -n "$1" ]; then
	echo "Error: too many arguments" > /dev/stderr
	usage > /dev/stderr
	exit 1
fi
