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


      <table border="0" bgcolor="white" cellpadding="2" cellspacing="0" width="100%">
        <tr class="table-header">
          <td><strong class="table-header">#news.Title#</strong></td>
          <td><strong class="table-header">#dotlrn.clubs_pretty_name#</strong></td>
        </tr>


<multiple name="news_items">

<% set new_package_id $news_items(package_id) %>

      <if @news_items.rownum@ odd>
        <tr class="odd">
      </if>
      <else>
        <tr class="even">
      </else>
        <td><a href="@news_items.url@item?item_id=@news_items.item_id@">@news_items.publish_title@</a>
        <small>(@news_items.publish_date@)</small></td>
        <td>@news_items.parent_name@</td>
      </tr>

<% set old_package_id $new_package_id %>

    <if @one_instance_p@ false and @new_package_id@ ne @old_package_id@>
      </tr>
    </if>
</multiple>

      </table>


  </if>
  <else>
    <small>#news-portlet.No_News#</small>
  </else>

</if>
<else>
&nbsp;
</else>

