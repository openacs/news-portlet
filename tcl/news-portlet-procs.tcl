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
	portal_id 
	instance_id
    } {
	Adds a news PE to the given page with the community_id.
    
	@return element_id The new element's id
	@param portal_id The page to add self to
	@param community_id The community with the folder
	@author arjun@openforce.net
	@creation-date Sept 2001
    } {
	# Add some smarts to only add one portlet for now when it's added multiple times (ben)
	# Find out if bboard already exists
	set element_id_list [portal::get_element_ids_by_ds $portal_id [my_name]]

	if {[llength $element_id_list] == 0} {
	    # Tell portal to add this element to the page
	    set element_id [portal::add_element $portal_id [my_name]]
	    # There is already a value for the param which must be overwritten
	    portal::set_element_param $element_id community_id $instance_id
	    set package_id_list [list]
	} else {
	    set element_id [lindex $element_id_list 0]
	    # There are existing values which should NOT be overwritten
	    portal::add_element_param_value \
                    -element_id $element_id \
                    -key community_id \
                    -value $instance_id
	}

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
	and    package_id = :instance_id
	order  by publish_date desc, item_id desc"
	
	set data "<table border=0 cellpadding=2 cellspacing=2 width=100%>"
	set rowcount 0

	if { $config(shaded_p) == "f" } {
            
            # Should be a list already! XXX rename me!
            set list_of_instance_ids $config(community_id)

            foreach instance_id $list_of_instance_ids {

            # aks fold into site_nodes:: or dotlrn_community
            set comm_object_id [db_string select_name "select object_id from site_nodes where node_id= (select parent_id from site_nodes where object_id=:instance_id)" ]

            set name [db_string select_pretty_name "
                select instance_name 
                from apm_packages
                where package_id= :comm_object_id "]

                append data "<tr colspan=2><td><a href=[dotlrn_community::get_url_from_package_id -package_id $instance_id]><b>$name</b> News</a></td></tr>"
                db_foreach select_news_items $query {
                    append data "<tr><td>&nbsp;&nbsp;<a href=[dotlrn_community::get_url_from_package_id -package_id $instance_id]item?item_id=$item_id>$publish_title</a></td><td><small>$publish_date</small></td></tr>"
                    incr rowcount
                } 

                set template "$data</table>"
	    
                if {!$rowcount} {
                    set template "<table border=0 cellpadding=2 cellspacing=2 width=100%><tr><td><small>No news items available</small></td></tr></table>"
                } 
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
    
	  @param portal_id The page to remove self from
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
 	portal_id 
    } {
 	Wrapper for the portal:: proc
 	
 	@param portal_id
 	@author arjun@openforce.net
 	@creation-date Nov 2001
    } {
 	portal::make_datasource_available \
 		$portal_id [portal::get_datasource_id [my_name]]
    }

    ad_proc -public make_self_unavailable { 
	portal_id 
    } {
	Wrapper for the portal:: proc
	
	@param portal_id
	@author arjun@openforce.net
	@creation-date Nov 2001
    } {
	portal::make_datasource_unavailable \
		$portal_id [portal::get_datasource_id [my_name]]
    }
}

 

