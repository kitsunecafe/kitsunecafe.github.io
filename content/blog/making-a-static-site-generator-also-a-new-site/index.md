{% extends "../../../layouts/index.html" %}

{% block content %}
# Making a Static Site Generator (Also a New Site)
I decided to give my site a much-needed redesign, so in the spirit of making things harder than they need to be, I decided to make a static site generator. You might see "Made with Roxy" at the bottom of this page (unless you're reading this so far in the future that I've changed it again). Roxy is what I've decided to call this generator. I wanted to write a little about my experiences creating it.

## The Plan

Initially, I planned to create *everything* from scratch -- the file reader, the markdown parser, the syntax highlighter, everything. After a few attempts, I decided that this was entirely silly and scrapped that idea. I also toyed with the idea of using a compile-time layout system but I didn't want to have to recompile a Rust executable every time I made changes to the layouts.

I finally settled on using [Tera](https://tera.netlify.app) as my templating engine. It's Jinja-like and made for Rust with a lot of really useful features. It's significantly slower than compile-time engines but also much more flexible. In addition to a templating engine, I also needed something to parse Markdown files which would be the basis for the content of each page. For this, I used [pulldown-cmark](https://docs.rs/highlight-pulldown/latest/highlight_pulldown/).

With these two things decided on, my idea was simple: layouts would be defined in one location and content would be defined in another. Most fancy layout stuff would be handled by Tera (includes, extensions, etc) and the data would live in the Markdown. This created two distinct types of data: `layouts` and `content`. I also had the idea that the `content` directory structure should define the site's structure as well. (eg. `content/blog/my-post.md` becomes `domain.com/blog/my-post`).

## The "Implementation"

Creating it was straightforward -- in fact, it was so simple that I accidentally deleted the project while trying to push it to git and had to rewrite it. I did it in a few hours (and stayed up until 6 am doing it).

It only performs a few steps.

1) Compile the content from the `content` directory
    1) If this filename is prefixed with `.` (dot), skip it
    2) Read front matter
    3) Parse the rest as markdown
    4) Parse the previous result as a one-off Tera template
2) Assemble the content into a `HashMap` 
    * This is so it can be easily accessed later
    * There is a limitation in my implementation -- Roxy only compiles a map out of the root `content` directory. This will become relevant later.
3) Create Tera context
    * This is where the content map becomes relevant. This `HashMap` is serialized and given to each layout. One major use would be to iterate their contents, eg. a blog index that displays all posts. Subdirectories can't be accessed if they aren't recognized as content themselves).
4) Create output files
    1) Iterate each content file
    2) Create a matching directory structure in the output folder (eg. `content/blog/my-post.md` becomes `output/blog/my-post/index.md`)
    3) If it has a `layout` frontmatter field, try to use that layout, otherwise, use `index.html` as a default
    4) Render the template using the context made earlier
    5) Write out the file
5) Copy static files to the output folder

There were a few things I didn't consider in my original plan. Most notably, syntax highlighting and command-line argument parsing. I ended up adding `syntect` for syntax highlighting and `clap` for argument parsing. Additionally, there's a quirk based on my decision to tie `content` to page layout: to create a page, even if it's entirely layout driven, it requires a content file as a placeholder. 

There's a bunch of things Roxy *doesn't* do

* Create a development web server
* Create new content files from a template
* Initialize a project to give the user an idea of how to use it

I ended up making bash files to do all that though and they're available in the repository for this website if you'd like to see or use them.

The code is a disaster and needs to be refactored. I'll do that the minute I have a really good reason to. For now, it works well enough for me, and I *really* like using it. This is one of the times I'm very happy I decided to make something superfluous for myself.
{% endblock content %}

