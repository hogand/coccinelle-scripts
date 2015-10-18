#!/bin/sh

# Run Coccinelle (port devel/coccinelle) jobs in parallel.
#
# Typical usage (defaults to /usr/src/):
# $ parallel_spatch.sh file.cocci

# Copyright (c) 2014,2015 Doug Hogan <doug@openbsd.org>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

if [ "$#" = "1" ]; then
	FILE="$1"
	DIR="/usr/src/"
elif [ "$#" = "2" ]; then
	FILE="$1"
	DIR="$2"
else
	echo "Usage: $0 <cocci file> <top level src>"
	exit 1
fi

if [ ! -f "$FILE" ]; then
	echo "Cannot find file \"$FILE\""
	exit 1
fi
if [ ! -d "$DIR" ]; then
	echo "Cannot find dir \"$DIR\""
	exit 1
fi

LOG="$(mktemp cocci_out_XXXXXXXXXXXX)"
echo "Logging parallel runs to $LOG"

# Skip the gnu directory since we usually don't fix GNU problems.
# With -patch and individual directories, the output is a diff that
# can be applied with 'patch -p1 < ${LOG}'
time /usr/local/bin/spatch.opt \
	-very-quiet \
	-sp_file "$FILE" \
	-j $(sysctl -n hw.ncpu) \
	-patch "${DIR}" \
	$(find "${DIR}" -type d -mindepth 1 -maxdepth 1 ! -name CVS ! -name gnu ! -name .git) \
	> "${LOG}"

