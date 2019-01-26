.PHONY: html

default: html

html: clean
	mkdir html
	# copy all folders
	for dir in $$(find . -maxdepth 1 -type d | sed 's#./##;' | grep -v '^\.' | grep -v html ); do \
		cp -r "$$dir" "html/$$dir"; \
	done
	# generate HTML from markdown
	for md in $$(find html -name '*.md'); do \
		output="$$(echo "$$md" | sed 's/md$$/html/;')"; \
		cmark "$$md" > "$$output"; \
	done
	# create index
	echo '<!DOCTYPE html>' >> html/index.html
	echo '<html>' >> html/index.html
	echo '    <head>' >> html/index.html
	echo '        <meta content="text/html; charset=utf-8" http-equiv="Content-Type">' >> html/index.html
	echo '        <title>Miscellaneous Links and Information</title>' >> html/index.html
	echo '        <meta name="viewport" content="width=device-width, initial-scale=1.0">' >> html/index.html
	echo '    </head>' >> html/index.html
	echo '    <body>' >> html/index.html
	echo '    <body>' >> html/index.html
	echo '        <p>Maintained by <a href="http://www.oxy.edu/faculty/justin-li">Justin Li</a>.</p>' >> html/index.html
	echo '        <ul>' >> html/index.html
	for dir in $$(find html -mindepth 1 -maxdepth 1 -type d | sort); do \
		dir="$$(echo "$$dir" | sed 's#^html/##;')"; \
		echo "            <li><a href=\"$$dir\">$$dir</a></li>" >> html/index.html; \
	done
	echo '        </ul>' >> html/index.html
	echo '    </body>' >> html/index.html
	echo '</html>' >> html/index.html
	# remove markdown sources
	find html -name '*.md' -exec rm -f {} ';'


publish: html
	find html -name '.*.un~' -exec rm -f {} +
	find html -name '.*.swp' -exec rm -f {} +
	rsync --archive --progress --rsh=ssh html/ justinnh@ftp.justinnhli.oxycreates.org:/home/justinnh/public_html

clean:
	rm -rf html
