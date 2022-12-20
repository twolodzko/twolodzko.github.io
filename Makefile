.PHONY: publish
publish:
	bash -c 'quarto publish --no-prompt gh-pages'
	rm -rf _site

.PHONY: preview
preview:
	bash -c 'quarto preview'
