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

ad_library {

    Procedures to support the news portlet

    @creation-date Nov 2001
    @author arjun@openforce.net 
    @cvs-id $Id$

}

namespace eval news_portlet {

    ad_proc -private get_my_name {
    } {
        return "news_portlet"
    }

    ad_proc -private my_package_key {
    } {
        return "news-portlet"
    }

    ad_proc -public get_pretty_name {
    } {
	return [ad_parameter "news_portlet_pretty_name" [my_package_key]]
    }

    ad_proc -public link {
    } {
	return ""
    }

    ad_proc -public add_self_to_page { 
	portal_id 
	instance_id
    } {
	Adds a news PE to the given portal. 
    
	@param portal_id The page to add self to
	@param instance_id The community with the folder
	@return element_id The new element's id
    } {
        return [portal::add_element_or_append_id \
                      -portal_id $portal_id \
                      -portlet_name [get_my_name] \
                      -value_id $instance_id \
                      -force_region [ad_parameter "news_portlet_force_region" [my_package_key]] \
                      -pretty_name [get_pretty_name]
        ]
    }

    ad_proc -public remove_self_from_page { 
	portal_id 
	instance_id 
    } {
        Removes a news PE from the given page or the instance_id of the
        news pacakge from the portlet if there are others remaining
        
        @param portal_id The page to remove self from
        @param instance_id
    } {
        portal::remove_element_or_remove_id \
                -portal_id $portal_id \
                -portlet_name [get_my_name] \
                -value_id $instance_id
    }

    ad_proc -public show { 
	 cf 
    } {
    } {
        portal::show_proc_helper \
                -package_key [my_package_key] \
                -config_list $cf \
                -template_src "news-portlet"
    }

}
