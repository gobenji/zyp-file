# apt-file show clone for zypp

$2 == "Name" {
	name = $4
}

$2 == "Name" && $4 ~ pattern, /^-----/ {
	if (match($2, "([r-][w-][x-]){3}")) {
		print name ": " $10
	}
}
