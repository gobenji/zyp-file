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

$2 == "Name" {
	name = $4
}

$10 ~ pattern && $2 ~ /([r-][w-][x-]){3}/ {
	print name ": " $10
}
