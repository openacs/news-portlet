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
        
        append data "$parent_name<P><ul>"
        
        db_foreach news_items_select {} {
            append data "<li><a href=${parent_url}item?item_id=$item_id>$publish_title</a> <small>($publish_date)</small><BR>"
        }

        append data "</ul>"
    }

}

# portlets shouldn't disappear anymore (ben)
if {[empty_string_p $data]} {
    set data "<small>No FAQs</small>"
}
