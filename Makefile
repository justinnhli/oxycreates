.PHONY: html

default: html

html: clean
	mkdir html
	cp index.html html/
	for dir in $$(find . -maxdepth 1 -type d | sed 's#./##;' | grep -v '^\.' | grep -v html ); do \
		cp -r "$$dir" "html/$$dir"; \
	done
	for md in $$(find html -name '*.md'); do \
		output="$$(echo "$$md" | sed 's/md$$/html/;')"; \
		cmark "$$md" > "$$output"; \
	done
	find html -name '*.md' -exec rm -f {} ';'

publish: html
	find html -name '.*.un~' -exec rm -f {} +
	find html -name '.*.swp' -exec rm -f {} +
	lftp -u justinnh, sftp://ftp.justinnhli.oxycreates.org -e "mirror -vvvR --only-newer --ignore-time html public_html ; quit"

clean:
	rm -rf html
