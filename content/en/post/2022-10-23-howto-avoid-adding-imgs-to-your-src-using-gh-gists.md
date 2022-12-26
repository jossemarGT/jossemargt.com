---

date: 2022-10-23
title: "HowTo: Avoid adding images to your source code with GH gists"

---

<!--more-->

While working on GH Candle's documentation, I thought it would be nice to have a
slick animation with a gif. However, I genuinely didn't want to add images to
the tool's git history, so I looked for alternatives, and luckily I found some.
This entry elaborates on how I used GH gist for this.

First, I'll share the approaches that did not work:

- Adding PNGs as base64 data is not supported by the GH Markdown parser.
- Adding non-SVG images to the git history will always be handled as binary.
- Technically, you could force git to take images as plain text through
  gitattibutes, but it does not make sense since most of those are bitmaps, ergo
  binaries.

## Step-by-step solution

1. Generate a Personal Access Token with "gist" permission
2. Clone the gist using its HTTPS URL
   - Yes, each GH gist is a git repository
3. Add the image to the gist repository.
4. Push these changes using your GH username and the GH PAT you generated at the
   beginning
5. You are done. Now you only need to copy the image URL and use it on the
   documentation.

You can see it working in
[GH Candle's README.md file](https://github.com/jossemargt/gh-candle), whose
images are published on
[this gist](https://gist.github.com/jossemarGT/04f6590ad9771de163a50c79214cd544).
