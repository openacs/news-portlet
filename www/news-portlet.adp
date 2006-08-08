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
        <if @one_instance_p@ false><h3>@news_items.parent_name@</h3></if>
        <ul>
          <group column="package_id">
            <if @display_item_content_p@ eq "1">
              <p>@news_items.publish_body;noquote@</p>
                 <if @display_item_attribution_p@ eq "1">
                   <p>Contributed by <a href="@news_items.creator_url@">@news_items.item_creator@</a>
                 </if>
            </if><else>
              <li>
              <a href="@news_items.url@item?item_id=@news_items.item_id@">@news_items.publish_title@</a>
              <small>(@news_items.publish_date@)</small>
              </li>
            </else>
           </group>
          </ul>
        <br/>@news_items.notification_chunk;noquote@
        <if @news_items.rss_exists@ eq 1>
	  <br/><a href="@news_items.rss_url;noquote@">#rss-support.Syndication_Feed#&nbsp;<img src="/resources/xml.gif" alt="Subscribe via RSS" width="26" height="10" border=0 /></a><hr/><br/>
        </if>
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
