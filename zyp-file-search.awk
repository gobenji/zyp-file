# apt-file search clone for zypp

$2 == "Name" {
	name = $4
}

$10 ~ pattern && $2 ~ /([r-][w-][x-]){3}/ {
	print name ": " $10
}
