{% extends "../../../layouts/index.html" %}

{% block content %}
# A Roxy Update

I released a new version of Roxy over at [fem.mint.lgbt](https://fem.mint.lgbt/kitsunecafe/roxy-cli). I've been working on it for a few months now, one part because it's more complex than the original, and another part because I had to learn a lot. I want to make a quick rundown of the changes.

## Philosophy
My philosophy about how Roxy should be structured changed as I built V1. The original was focused on simplicity and ease of implementation. Unfortunately, because I didn't account for every feature I wanted from the very beginning, it quickly went from easy to difficult and required a bunch of hacks to finish. 

Roxy's new philosophy is about pluggable behavior. The core is effectively a reducer for anything which `impl Read`. It's still not the most elegant and there's a *lot* I've learned from this exercise, I think it's a lot better. It's now possible to easily add new functions to Roxy by adding a new `Parser`.

```rs
    let parser = Parser::new();
    
    let md_parser = MarkdownParser::new();
    parser.push(md_parser);

    let html_parser = HtmlParser::new();
    parser.push(html_parser);

    Roxy::process_file("input-file.md", "output-file.html", &mut parser);
```

Hopefully this lets me manage the complexity for whenever I want to add a new feature or parsing ability to the library. A lot of the comlexity still exists in one place, `roxy-cli`, but I'll hopefully break that down over time.

## What's left
There's a bunch of stuff I didn't get to do. Two things I really want are an RSS feed generator, and streaming file inputs. Right now, the library loads the entire file into memory and works on it when it should be streaming it and processing it in chunks. I didn't have the time or energy to work on that, but maybe later.
{% endblock content %}

