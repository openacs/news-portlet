<% # This is the default template to render news items in admin/. Comments are not shown here %>
<h3>@publish_title@ - <small>@publish_date@</small></h3>
<blockquote>
@publish_body;noquote@
@more_link;noquote@
<p>Contributed by <a href="@creator_url@">@item_creator@</a>
</blockquote>
