<%

    #
    #  Copyright (C) 2001, 2002 MIT
    #
    #  This file is part of dotLRN.
    #
    #  dotLRN is free software; you can redistribute it and/or modify it under the
    #  terms of the GNU General Public License as published by the Free Software
    #  Foundation; either version 2 of the License, or (at your option) any later
    #  version.
    #
    #  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
    #  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
    #  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
    #  details.
    #

%>

<if @shaded_p@ ne "t">

  <if @news_items:rowcount@ gt 0>

<%
    set new_package_id ""
    set old_package_id ""
%>

<multiple name="news_items">

<% set new_package_id $news_items(package_id) %>

    <if @one_instance_p@ false and @new_package_id@ ne @old_package_id@ and @old_package_id@ ne "">
      </ul>
    </if>

    <if @one_instance_p@ false and @new_package_id@ ne @old_package_id@>
      @news_items.parent_name@
      <ul>
    </if>

<if @news_items:rowcount@ eq 1>
	<include src=summary 
	item_id=@news_items.item_id@ 
	url=@news_items.url@?item_id=@news_items.item_id@>
</if>
<else>
      <li>
        <a href="@news_items.url@item?item_id=@news_items.item_id@">@news_items.publish_title@</a>
        <small>(@news_items.publish_date@)</small>
      </li>

<%
    set old_package_id $new_package_id
%>
</else>
</multiple>

  </if>
  <else>
    <small>No News</small>
  </else>

</if>
<else>
&nbsp;
</else>
