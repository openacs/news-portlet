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

# news-portlet/tcl/news-portlet-procs.tcl

ad_library {

Procedures to support the news admin portlet

Copyright Openforce, Inc.
Licensed under GNU GPL v2 

@creation-date Jan 2002
@author ben@openforce.net 
@cvs-id $Id$

}

namespace eval news_admin_portlet {

    ad_proc -private my_name {
    } {
    return "news_admin_portlet"
    }

    ad_proc -public get_pretty_name {
    } {
	return "News Administration"
    }

    ad_proc -private my_package_key {
    } {
    return "news-portlet"
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
	    set element_id [portal::add_element -force_region 2 $portal_id [my_name]]
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

        # no return call required with the helper proc
        portal::show_proc_helper \
                -package_key [my_package_key] \
                -config_list $cf \
                -template_src "news-admin-portlet"
    
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

 

