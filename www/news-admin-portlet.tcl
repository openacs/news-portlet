# www/news-portlet.tcl
ad_page_contract {
    The display logic for the news portlet

    @author Arjun Sanyal (arjun@openforce.net)
    @author Ben Adida (ben@openforce)
    @cvs_id $Id$
} -properties {
    
}

array set config $cf
set user_id [ad_conn user_id]

set list_of_package_ids $config(community_id)

if {[llength $list_of_package_ids] > 1} {
    # We have a problem!
    return -code error "There should be only one instance of news for admin purposes"
}        

set package_id [lindex $list_of_package_ids 0]        

set url [dotlrn_community::get_url_from_package_id -package_id $package_id]

ad_return_template 
