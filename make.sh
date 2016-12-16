#!/bin/bash

rm -rf html
mkdir html
cp index.html html/
for dir in $(find . -maxdepth 1 -type d | sed 's#./##;' | grep -v '^\.' | grep -v html ); do
	cp -r "$dir" "html/$dir"
done
for md in $(find html -name '*.md'); do
	output="$(echo "$md" | sed 's/md$/html/;')"
	cmark "$md" > "$output"
done
find html -name '*.md' -exec rm -f {} ';'
