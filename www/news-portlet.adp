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
      <listtemplate name="news"></listtemplate>    
    </else>
  </if>
  <else>
    <small>#news-portlet.No_News#</small>
  </else>
  <if @inside_comm_p@ >
    <p><a href="@news_url@news/item-create" title="#news-portlet.Add_a_News_Item#">#news-portlet.Add_a_News_Item#</a></p>
  </if>
</if>
<else>
  <small>
    #new-portal.when_portlet_shaded#
  </small>
</else>
