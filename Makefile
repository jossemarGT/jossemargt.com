THEME_NAME:=diary
THEME_GITURL:=https://github.com/AmazingRise/hugo-theme-diary.git

# https://png-pixel.com/
ASSET_OG_BG:=iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk0Db7DwAB9gFidmn2qgAAAABJRU5ErkJggg==

.PHONY: site
site: themes/$(THEME_NAME) layouts/partials/head.html assets/images/og-bg.png
	hugo -d public

# Shallow clone hugo theme
themes/$(THEME_NAME):
	git clone --depth 1 $(THEME_GITURL) themes/$(THEME_NAME)

# Override opengraph template from theme
layouts/partials/head.html: themes/$(THEME_NAME)/layouts/partials/head.html
	sed 's%template "_internal/opengraph.html"%partial "opengraph.html"%' $< >$@

# Generate og:image 1px background
assets/images/og-bg.png:
	@echo $(ASSET_OG_BG) | base64 -d >$@
