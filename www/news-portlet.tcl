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
ad_include_contract {
    News Portlet
}

array set config $cf
set shaded_p $config(shaded_p)
if { $config(shaded_p)=="t" } {
   return
}

set news_url [ad_conn package_url]
set comm_id [dotlrn_community::get_community_id_from_url -url $news_url]
if {$comm_id ne ""} {
    set root_id [ad_conn node_id]
    set user_id [ad_conn user_id]
    set inside_comm_p 1
} else {
    set inside_comm_p 0
}

# Should be a list already! XXX rename me!
set list_of_package_ids $config(package_id)
set one_instance_p [expr {[llength $list_of_package_ids] == 1}]

set display_item_content_p [parameter::get_from_package_key \
    -package_key news-portlet \
    -parameter display_item_content_p \
    -default 0]
set display_item_lead_p [parameter::get_from_package_key \
    -package_key news-portlet \
    -parameter display_item_lead_p \
    -default 1]
set display_subgroup_items_p [parameter::get_from_package_key \
    -package_key news-portlet \
    -parameter display_subgroup_items_p \
    -default 0]
set display_item_attribution_p [parameter::get_from_package_key \
    -package_key news-portlet \
    -parameter display_item_attribution_p \
    -default 1]


if { $inside_comm_p } {
    set package_id $config(package_id)
    #
    # Check if RSS generation is active and a subscription exists
    #
    if {[parameter::get_global_value -package_key rss-support -parameter RssGenActiveP]} {
        set rss_exists_p [rss_support::subscription_exists -summary_context_id $package_id -impl_name news]
        set rss_url "[news_util_get_url $package_id]rss/rss.xml"
    } else {
        set rss_exists_p 0
    }

    set news_url [news_util_get_url $package_id]

    if { $display_subgroup_items_p } {
        set subgroup_package_ids [db_list select_subgroup_package_ids {
            select package_id
            from apm_packages p right outer join
               ( WITH RECURSIVE site_node_tree AS (
                    select node_id, parent_id, object_id from site_nodes where node_id = :root_id
                 UNION ALL
                    select c.node_id, c.parent_id, c.object_id from site_node_tree tree, site_nodes as c
                    where  c.parent_id = tree.node_id
                 )
		 select * from site_node_tree n) site_map
            on site_map.object_id = p.package_id
            where package_key = 'news'
	    and (site_map.object_id is null or acs_permission.permission_p(site_map.object_id, :user_id, 'read') = 't')
        }]
        if {[llength $subgroup_package_ids] > 0} {
            set one_instance_p 0
            lappend list_of_package_ids {*}$subgroup_package_ids
        }
    }
}

set content_column ""

if { $display_item_content_p } {
    lappend content_column publish_body publish_format
}
if { $display_item_lead_p }  {
    lappend content_column publish_lead
}

if {[llength $content_column] > 0 } {
    set content_column ,[join $content_column ,]
}

db_multirow -extend { publish_date view_url creator_url } news_items select_news_items [subst {
      select news_items_approved.package_id,
             (select instance_name
                from apm_packages pp,
                     site_nodes pn
               where pp.package_id = pn.object_id
                 and pn.node_id = n.parent_id) as parent_name,
             n.node_id,
             item_id,
             publish_title,
             to_char(news_items_approved.publish_date, 'YYYY-MM-DD HH24:MI:SS') as publish_date_ansi,
             item_creator,
             creation_user
             $content_column
      from news_items_approved
           left join site_nodes n on n.object_id = news_items_approved.package_id
      where publish_date < current_timestamp
      and (archive_date >= current_timestamp or archive_date is null)
      and package_id in ([join $list_of_package_ids ", "])
      order by package_id,
               parent_name,
               publish_date desc,
               publish_title
}] {
    set publish_date [lc_time_fmt $publish_date_ansi "%q"]
    set url [expr {[info exists ipackages($package_id)] ?
                   $ipackages($package_id) : [site_node::get_url -node_id $node_id]}]
    set view_url [export_vars -base "${url}item" { item_id }]

    # text-only body
    if {$display_item_content_p } {
        set publish_body \
            [ad_html_text_convert -from $publish_format -to text/html -- $publish_body]
    }
    set creator_url [expr {$display_item_attribution_p ?
                           [acs_community_member_url -user_id $creation_user] : ""}]
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
