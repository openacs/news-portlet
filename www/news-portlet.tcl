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

#
# /news-portlet/www/news-portlet.tcl
#
# arjun@openforce.net
#
# The logic for the news portlet
#
# $Id$
# 

array set config $cf	
set shaded_p $config(shaded_p)

set news_url [ad_conn package_url]
set comm_id [dotlrn_community::get_community_id_from_url -url $news_url]
if {[exists_and_not_null comm_id]} {
    set root_id [ad_conn node_id]
    set user_id [ad_conn user_id]
    set inside_comm_p 1
} else {
    set inside_comm_p 0
}

# Should be a list already! XXX rename me!
set list_of_package_ids $config(package_id)
set one_instance_p [ad_decode [llength $list_of_package_ids] 1 1 0]

set display_item_content_p [parameter::get_from_package_key -package_key news-portlet -parameter display_item_content_p -default 0]
set display_subgroup_items_p [parameter::get_from_package_key -package_key news-portlet -parameter display_subgroup_items_p -default 0]
set display_item_attribution_p [parameter::get_from_package_key -package_key news-portlet -parameter display_item_attribution_p -default 1]

if { $inside_comm_p && $display_subgroup_items_p } {
    db_foreach select_subgroup_package_ids {} {
        set one_instance_p 0
        lappend list_of_package_ids $package_id
    }
}

if { $display_item_content_p } {
    #Only pull out the full content if we have to.
    set content_column " , content as publish_body, html_p "
} else {
    set content_column ""
}

template::list::create -name news -multirow news_items -key item_id -pass_properties {
    display_item_content_p
    one_instance_p
} -elements {
    item {
	label ""
	display_template {
           <if @one_instance_p@ false><b>@news_items.parent_name@</b></if></br>
           <group column="package_id">
            <if @display_item_content_p@ eq "1">
	    <p>@news_items.publish_body;noquote@</p>
                 <if @display_item_attribution_p@ eq "1">
                   <p>#news-portlet.Contributed_by# <a href="@news_items.creator_url@">@news_items.item_creator@</a>
                 </if>
            </if><else>
	      &raquo; <a href="@news_items.url@item?item_id=@news_items.item_id@">@news_items.publish_title@</a> 
              <small>@news_items.publish_date@</small>
            </else>
                <if @news_items.rss_exists@ eq 1>
	        <a href="@news_items.rss_url;noquote@"><img src="/resources/xml.gif" alt="Subscribe via RSS" width="26" height="10" border=0 /></a>
                </if></br>
           </group>
	}
    }
    action {
	label ""
	display_template {
	    @news_items.notification_chunk;noquote@
	}
    }
}

db_multirow -extend { publish_date view_url rss_exists rss_url notification_chunk} news_items select_news_items {} {
    set publish_date [lc_time_fmt $publish_date_ansi "%x"]
    set view_url [export_vars -base "${url}item" { item_id }]
    set rss_exists [rss_support::subscription_exists -summary_context_id $package_id -impl_name news]
    set rss_url "[news_util_get_url $package_id]rss/rss.xml"
    # add news email notification
    set notification_chunk [notification::display::request_widget -style "short" -type one_news_item_notif -object_id $package_id -pretty_name "News" -url [ad_return_url] ]
    
    # text-only body
    if {$display_item_content_p && [string equal $html_p "f"]} {
        set publish_body "[ad_text_to_html $publish_body]"
    }
    if { $display_item_attribution_p } {
        set creator_url [acs_community_member_url -user_id $creation_user]
    }
}
