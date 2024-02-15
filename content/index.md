{% extends "../layouts/index.html" %}
{% block content %}
<div>
    {% include "../layouts/bio.html" %}
    <div class="has-quarter-padding">
        <p>my name is Rowan and welcome to my site :3</p>
        <p>i really like making games, art, stories, and music.</p>
    </div>
    <div>
        {% include "../layouts/about-info.html" %}
        {% include "../layouts/contact-info.html" %}
    </div>
</div>
{% endblock content %}

