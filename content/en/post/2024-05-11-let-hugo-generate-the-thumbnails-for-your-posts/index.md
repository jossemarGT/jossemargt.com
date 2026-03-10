---

date: 2024-05-11
title: Let Hugo generate the thumbnails for your posts

---

Not so long ago, I realized that whenever I shared my posts on social media or
WhatsApp, no thumbnail was shown as happened with entries from other websites. A
quick search on the Hugo documentation showed me that this behavior is supported
by default _as long as the content had an image_ which: a) wasn't my case and b)
meant more chores when publishing.

<!--more-->

First, I want to elaborate why I haven't "just added" images into my posts. As
you may already know, all the content that you read over here is mainly stored
within a git repository, and because of that, I don't want to store any kind of
binary within it, that applies to images as well. Also, the chore part is true,
I don't want to look for images every single time I want to share something in a
post, instead, I need a plain simple way to render a thumbnail.

With that in mind, I went through the Hugo documentation that briefly shared how
thumbnails for social media are added through the [built-in opengraph partial template](https://gohugo.io/templates/embedded/#open-graph).
Then moved on into the default overridable "internal" template, and it hit me,
what if I use Hugo's [image manipulation helpers](https://gohugo.io/content-management/image-processing/)
and generate the thumbnails right there and then?

And turns out it works! But I need to warn you depending on your perspective, it
kind of feels over-engineering and clearly there are alternatives but I stuck
with this one since it is fun.

## The solution

> If you are in a hurry you can see everything condensed on [this commit](https://github.com/jossemarGT/jossemargt.com/commit/369bf0b51ca417b1a726e28adeefa3c4ae8239a7).

Although the solution mainly relies on Hugo capabilities, there was a minor
detail that pushed me to move part of the logic out of the templates. So, the
final solution could be broken down into:

1. Generating the thumbnail base assets
2. Customizing the `opengraph.html` template to generate thumbnails at build
   time
3. Orchestrating all together

### Generating the thumbnail base assets

Alright Hugo [image processing helpers](https://gohugo.io/content-management/image-processing/)
sounded like the path to go, but those can only manipulate pre-existing images.
So instead of going back to the not storing binaries on git conundrum, I made
use of some almost forgotten web development techniques: good old 1px image and
png's as base64 strings.


```shell
# Source: https://png-pixel.com/
$ ASSET_OG_BG='iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk0Db7DwAB9gFidmn2qgAAAABJRU5ErkJggg=='
$ echo "${ASSET_OG_BG}" | base64 -d >og-bg.png
$ file og-bg.png
og-bg.png: PNG image data, 1 x 1, 8-bit/color RGBA, non-interlaced
```

Still, there's a catch, this image must exist prior to `hugo build` invocation.
But we'll look into the orchestration part later.

### Customizing the `opengraph.html` template to generate thumbnails at build time

You can delve into the [implementation details yourself](https://github.com/jossemarGT/jossemargt.com/commit/369bf0b51ca417b1a726e28adeefa3c4ae8239a7),
but in a nutshell, what I needed the current `opengraph.html` partial template
to do is:

1. Take the single pixel we pre-generated and fill the "thumbnail canvas" with
   it
2. Take the "thumbnail canvas" and add the website's tagline on top
3. Use the resulting image local path and set it as the `og:image` metadata path

```go-template
{{- $image := resources.Get "images/og-bg.png" }}
{{- $image := $image.Process "fill 1200x400" }}
<!-- ... -->
{{- $opts := dict
  "color" "#93a1a1"
  "font" $font
  "size" 30
  "x" 10
  "y" 10
}}
{{- $text := "thumbnail text" }}
{{- $filter := images.Text $text $opts }}
{{- with $image | images.Filter $filter }}
  <meta property="og:image" content="{{ .RelPermalink }}">
{{- end }}
```

{{< details summary="UPDATE: No longer needed for themes that support Hugo v0.146.0+" >}}

Although the code was sound, there was yet another thing we needed to
workaround. Prior to Hugo v0.146.0, you "shouldn't" override the
`opengraph.html` partial template and refer to the internal one within the Hugo
binary, so most themes don't offer an extension point for it.

So to fix that, what I did is to copy the `head.html` partial template from my
theme and only replace that single line. With that patch, everything worked, and
again I'm going to orchestrate everything together in the next section.

```shell
sed \
	's%template "_internal/opengraph.html"%partial "opengraph.html"%' \
	"themes/$THEME_NAME/layouts/partials/head.html" >layouts/partials/head.html
```

{{< /details >}}

### Orchestrating all together

Alright, so now we have a solution, a working solution for regenerating the
thumbnail canvas and another one to fill in the details for that canvas and
publish it as part of the OpenGraph metadata. Now the missing part is to
orchestrate all together.

Since my "app deployment platform" of choice comes with `make` support I stick
with my old-fashioned but trusty Makefile, which reads as follows:

- When _making_ `site`, first _make_ the 1px image and head patch, then
  `hugo -d public`
- When _making_ the 1px image, decode the image and persist it to the filesystem
- When _making_ the head template patch, sed replace the theme's template and
  write the result on our overrides directory

```Makefile
# https://png-pixel.com/
ASSET_OG_BG:=iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk0Db7DwAB9gFidmn2qgAAAABJRU5ErkJggg==

# Generate site
.PHONY: site
site: layouts/partials/head.html assets/images/og-bg.png
	hugo -d public

# Override opengraph template from theme
layouts/partials/head.html: themes/$(THEME_NAME)/layouts/partials/head.html
	sed 's%template "_internal/opengraph.html"%partial "opengraph.html"%' $< >$@

# Generate og:image 1px background
assets/images/og-bg.png:
	@echo $(ASSET_OG_BG) | base64 -d >$@
```

In that way, the "deployment" is only a matter of shallow cloning the repository
and executing `make site` command.

## Final thoughts

- I must admit that I could have dropped an image globally as stated by Hugo
  documentation instead of going this laborious path. Still, I'm happy I did it
  either way, because that gave me the opportunity to learn more about how Hugo
  works internally.
- That said, if you are like me and you stubbornly want simple thumbnails for
  your posts, give this approach a try. It's fun, I promise!

PS: Although most social media websites prefer the `1.91:1` ratio for the
`og:image`, WhatsApp doesn't like it and you must provide an alternative with
the `1:1` ratio instead.

PPS: Two years have passed since this post was _created_, although I published
it later, and I had to update the partial templates mentioned on this post to
comply with the changes introduced in the latest Hugo release. So, I took the
opportunity to _delegate_ to an AI agent the last detail the thumbnails were
missing: dynamically adding the post's title. So, you can [review the summarized prompt that enhanced this behavior](./2026-03-07-prompt.md.txt).
