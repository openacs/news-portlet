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

    <if @news_items:rowcount@ eq 1>

      <multiple name="news_items">
	<include src="summary" 
	item_id="@news_items.item_id@"
	url="@news_items.view_url@">
      </multiple>

    </if>
    <else>

      <multiple name="news_items">

<if @one_instance_p@ false>@news_items.parent_name@</if>
<ul>
<group column="package_id">
  <li>
    <a href="@news_items.url@item?item_id=@news_items.item_id@">@news_items.publish_title@</a>
    <small>(@news_items.publish_date@)</small>
  </li>
</group>
</ul>

      </multiple>

    </else>

  </if>
  <else>
    <small>#news-portlet.No_News#</small>
  </else>

</if>
<else>
&nbsp;
</else>
<if @inside_comm_p@ ><br><a href="@news_url@news/item-create">#news-portlet.Add_a_News_Item#</a></if>

