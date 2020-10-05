ad_library {
    Automated tests for the news-portlet package.

    @author Héctor Romojaro <hector.romojaro@gmail.com>
    @creation-date 2020-08-19
    @cvs-id $Id$
}

aa_register_case -procs {
        news_portlet::link
        news_portlet::get_pretty_name
        news_admin_portlet::link
        news_admin_portlet::get_pretty_name
    } -cats {
        api
        production_safe
    } news_portlet_links_names {
        Test diverse link and name procs.
} {
    set portlet_pretty_name [parameter::get_from_package_key \
                                -package_key [news_portlet::my_package_key] \
                                -parameter news_portlet_pretty_name]
    aa_equals "News portlet link"               "[news_portlet::link]" ""
    aa_equals "News portlet pretty_name"        "[news_portlet::get_pretty_name]" "$portlet_pretty_name"
    aa_equals "News admin portlet link"         "[news_admin_portlet::link]" ""
    aa_equals "News admin portlet pretty name"  "[news_admin_portlet::get_pretty_name]" "#news-portlet.admin_pretty_name#"
}

aa_register_case -procs {
        news_portlet::add_self_to_page
        news_portlet::remove_self_from_page
        news_admin_portlet::add_self_to_page
        news_admin_portlet::remove_self_from_page
    } -cats {
        api
    } news_portlet_add_remove_from_page {
        Test add/remove portlet procs.
} {
    #
    # Helper proc to check portal elements
    #
    proc portlet_exists_p {portal_id portlet_name} {
        return [db_0or1row portlet_in_portal {
            select 1 from dual where exists (
              select 1
                from portal_element_map pem,
                     portal_pages pp
               where pp.portal_id = :portal_id
                 and pp.page_id = pem.page_id
                 and pem.name = :portlet_name
            )
        }]
    }
    #
    # Start the tests
    #
    aa_run_with_teardown -rollback -test_code {
        #
        # Create a community.
        #
        # As this is running in a transaction, it should be cleaned up
        # automatically.
        #
        set community_id [dotlrn_community::new -community_type dotlrn_community -pretty_name foo]
        if {$community_id ne ""} {
            aa_log "Community created: $community_id"
            set portal_id [dotlrn_community::get_admin_portal_id -community_id $community_id]
            set package_id [dotlrn::instantiate_and_mount $community_id [news_portlet::my_package_key]]
            #
            # news_portlet
            #
            set portlet_name [news_portlet::get_my_name]
            #
            # Add portlet.
            #
            news_portlet::add_self_to_page -portal_id $portal_id -package_id $package_id -param_action ""
            aa_true "Portlet is in community portal after addition" "[portlet_exists_p $portal_id $portlet_name]"
            #
            # Remove portlet.
            #
            news_portlet::remove_self_from_page -portal_id $portal_id -package_id $package_id
            aa_false "Portlet is in community portal after removal" "[portlet_exists_p $portal_id $portlet_name]"
            #
            # Add portlet.
            #
            news_portlet::add_self_to_page -portal_id $portal_id -package_id $package_id -param_action ""
            aa_true "Portlet is in community portal after addition" "[portlet_exists_p $portal_id $portlet_name]"
            #
            # admin_portlet
            #
            set portlet_name [news_admin_portlet::get_my_name]
            #
            # Add portlet.
            #
            news_admin_portlet::add_self_to_page -portal_id $portal_id -package_id $package_id
            aa_true "Admin portlet is in community portal after addition" "[portlet_exists_p $portal_id $portlet_name]"
            #
            # Remove portlet.
            #
            news_admin_portlet::remove_self_from_page -portal_id $portal_id
            aa_false "Admin portlet is in community portal after removal" "[portlet_exists_p $portal_id $portlet_name]"
            #
            # Add portlet.
            #
            news_admin_portlet::add_self_to_page -portal_id $portal_id -package_id $package_id
            aa_true "Admin portlet is in community portal after addition" "[portlet_exists_p $portal_id $portlet_name]"
        } else {
            aa_error "Community creation failed"
        }
    }
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
