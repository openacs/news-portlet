# news-portlet/tcl/news-portlet-procs.tcl

ad_library {

Procedures to support the news portlet

Copyright Openforce, Inc.
Licensed under GNU GPL v2 

@creation-date Nov 2001
@author arjun@openforce.net 
@cvs-id $Id$

}

namespace eval news_portlet {

    ad_proc -private my_name {
    } {
    return "news_portlet"
    }

    ad_proc -public get_pretty_name {
    } {
	return "News"
    }

    ad_proc -public link {
    } {
	return "news"
    }

    ad_proc -public add_self_to_page { 
	page_id 
	community_id
    } {
	Adds a news PE to the given page with the community_id.
    
	@return element_id The new element's id
	@param page_id The page to add self to
	@param community_id The community with the folder
	@author arjun@openforce.net
	@creation-date Sept 2001
    } {
	# Tell portal to add this element to the page
	set element_id [portal::add_element $page_id [my_name]]
	
	# The default param "community_id" must be configured
	set key "community_id"
	portal::set_element_param $element_id $key $community_id

	return $element_id
    }

    ad_proc -public show { 
	 cf 
    } {
	 Display the PE
    
	 @return HTML string
	 @param cf A config array
	 @author arjun@openforce.net
	 @creation-date Sept 2001
    } {

	array set config $cf	

	# things we need in the config 
	# community_id 

	# get user_id from the conn at this point
	set user_id [ad_conn user_id]

	# a modified query from news/www/index.tcl
	set query "
	select item_id,
	package_id,
	publish_title,
	publish_date
	from   news_items_approved
	where publish_date < sysdate 
	and (archive_date is null or archive_date > sysdate)      
	and    package_id = $config(community_id)
	order  by publish_date desc, item_id desc"
	
	set data ""
	set rowcount 0

	if { $config(shaded_p) == "f" } {

	    db_foreach select_news_items $query {
		append data "<li>$publish_date: <a href=news/item?item_id=$item_id>$publish_title</a>"
		incr rowcount
	    } 

	    set template "<ul>$data</ul>"
	    
	    if {!$rowcount} {
		set template "<i>No news items available</i><P><a href=\"news\">more...</a>"
	    } else {
		append template "<a href=\"news\">more...</a>"
	    }
	} else {
	    # shaded	
	    set template ""
	}

	
	set code [template::adp_compile -string $template]

	set output [template::adp_eval code]

	return $output
    
    }

    ad_proc -public edit { 
    } {
	return ""
    }

    ad_proc -public remove_self_from_page { 
	portal_id 
	community_id 
    } {
	  Removes a news PE from the given page 
    
	  @param page_id The page to remove self from
	  @param community_id
	  @author arjun@openforce.net
	  @creation-date Sept 2001
    } {
	# get the element IDs (could be more than one!)
	set element_ids [portal::get_element_ids_by_ds $portal_id [my_name]]

	# remove all elements
	db_transaction {
	    foreach element_id $element_ids {
		portal::remove_element $element_id
	    }
	}
    }

    ad_proc -public make_self_available { 
 	page_id 
    } {
 	Wrapper for the portal:: proc
 	
 	@param page_id
 	@author arjun@openforce.net
 	@creation-date Nov 2001
    } {
 	portal::make_datasource_available \
 		$page_id [portal::get_datasource_id [my_name]]
    }

    ad_proc -public make_self_unavailable { 
	page_id 
    } {
	Wrapper for the portal:: proc
	
	@param page_id
	@author arjun@openforce.net
	@creation-date Nov 2001
    } {
	portal::make_datasource_unavailable \
		$page_id [portal::get_datasource_id [my_name]]
    }
}

 

