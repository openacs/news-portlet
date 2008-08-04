<% # This is the default template to render news items in admin/. Comments are not shown here %>
<h3>@publish_title@ - <small>@publish_date@</small></h3>
<blockquote>
@publish_body;noquote@
@more_link;noquote@
</blockquote>
<if @display_item_attribution_p@ eq "1">
<p>#news-portlet.Contributed_by# <a href="@creator_url@" title="#news-portlet.goto_item_creator_commpage#">@item_creator@</a></p>
</if>
