publish:
	quarto publish --no-prompt --no-browser gh-pages
	rm -rf _site

preview:
	quarto preview
