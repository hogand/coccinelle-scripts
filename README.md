# Coccinelle scripts for OpenBSD #

When I run coccinelle, I use this script to run the jobs in parallel
and output a patch that can be fed into a top level /usr/src directory.

Coccinelle as a tool is useful, but easily abused.  I typically use it
for discovery and finding fault patterns in code.  I rarely use it to
generate patches because reviewing tool diffs is annoying and error
prone.

## Usage ##

```sh
$ parallel_spatch.sh foo.cocci /usr/src/
```

and it will output a combined `cocci_out_*` file.

This script requires a recent Coccinelle version.  A few releases ago
they added native multi-core support which makes it much faster.

