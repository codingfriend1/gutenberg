#!/bin/bash

# Exit if any command fails
set -e

# Change to the expected directory
cd "$(dirname "$0")"
cd ..

# Make sure there are no changes in the working tree
changed=
if ! git diff --exit-code > /dev/null; then
	changed="file(s) modified"
elif ! git diff --cached --exit-code > /dev/null; then
	changed="file(s) staged"
fi
if [ ! -z "$changed" ]; then
	git status
	echo "ERROR: Cannot build plugin zip with dirty working tree."
	echo "       Commit your changes and try again."
	exit 1
fi

branch="$(git rev-parse --abbrev-ref HEAD)"
if [ "$branch" != 'master' ]; then
	echo "WARNING: You should probably be running this script against the"
	echo "         'master' branch (current: '$branch')"
	echo
	sleep 2
fi

# Download all vendor scripts
vendor_scripts=""
exec 3< <(
	# minified versions of vendor scripts
	php bin/get-vendor-scripts.php
	# non-minified versions of vendor scripts (for SCRIPT_DEBUG)
	php bin/get-vendor-scripts.php debug
)
while IFS='|' read -u 3 url filename; do
	wget -nv "$url" -O "vendor/$$.tmp.js"
	mv -v "vendor/$$.tmp.js" "vendor/$filename"
	vendor_scripts="$vendor_scripts vendor/$filename"
done

# Run the build
npm install
npm run build

# Remove any existing zip file
rm -f gutenberg.zip

# Temporarily modify `gutenberg.php` with production constants defined
php bin/generate-gutenberg-php.php > gutenberg.$$.php
mv gutenberg.$$.php gutenberg.php

# Generate the plugin zip file
zip -r gutenberg.zip \
	gutenberg.php \
	index.php \
	lib/*.php \
	post-content.js \
	$vendor_scripts \
	blocks/build/*.{js,map} \
	components/build/*.{js,map} \
	date/build/*.{js,map} \
	editor/build/*.{js,map} \
	element/build/*.{js,map} \
	i18n/build/*.{js,map} \
	utils/build/*.{js,map} \
	blocks/build/*.css \
	components/build/*.css \
	editor/build/*.css \
	README.md

# Reset `gutenberg.php`
git checkout gutenberg.php
