#
#  Copyright (C) 2001, 2002 OpenForce, Inc.
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
# distributed under the terms of the GNU GPL version 2
#
# arjun@openforce.net
#
# The logic for the news portlet
#
# $Id$
# 


array set config $cf	
set shaded_p $config(shaded_p)

set data ""
    
# Should be a list already! XXX rename me!
set list_of_instance_ids $config(community_id)

if {[llength $list_of_instance_ids] == 1} {
    set one_instance_p 1
} else {
    set one_instance_p 0
}

foreach instance_id $list_of_instance_ids {
    
    if {[db_string news_items_count {} -default 0]} {
        set has_items_p 1
    } else {
        set has_items_p 0
    }
    
    if {$has_items_p} {
        set parent_name [site_nodes::get_parent_name -instance_id $instance_id]
        set parent_url [dotlrn_community::get_url_from_package_id -package_id $instance_id]
        
        if {!$one_instance_p} {
            append data "<li>$parent_name"
        }

        append data "<ul>"
        
        db_foreach news_items_select {} {
            append data "<li><a href=${parent_url}item?item_id=$item_id>$publish_title</a> <small>($publish_date)</small>"
        }

        append data "</ul>"
    }

}

# portlets shouldn't disappear anymore (ben)
if {[empty_string_p $data]} {
    set data "<small>No News</small>"
    set no_news_p "t"
} else {
    set no_news_p "f"
}
