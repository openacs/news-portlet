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
    set inside_comm_p 1
} else {
    set inside_comm_p 0
}

# Should be a list already! XXX rename me!
set list_of_package_ids $config(package_id)
set one_instance_p [ad_decode [llength $list_of_package_ids] 1 1 0]

db_multirow -extend { publish_date view_url rss_exists rss_url notification_chunk} news_items select_news_items {} {
    set publish_date [lc_time_fmt $publish_date_ansi "%x"]
    set view_url [export_vars -base "${url}item" { item_id }]
    set rss_exists [rss_support::subscription_exists -summary_context_id $package_id -impl_name news]
    set rss_url "[news_util_get_url $package_id]rss/rss.xml"
    # add news email notification
    set notification_chunk [notification::display::request_widget -type one_news_item_notif -object_id $package_id -pretty_name "News" -url [ad_return_url] ]
}