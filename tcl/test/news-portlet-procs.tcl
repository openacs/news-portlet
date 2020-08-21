ad_library {
    Automated tests for the news-portlet package.

    @author Héctor Romojaro <hector.romojaro@gmail.com>
    @creation-date 2020-08-19
    @cvs-id $Id$
}

aa_register_case -procs {
        news_admin_portlet::link
        news_portlet::link
        news_admin_portlet::get_pretty_name
    } -cats {
        api
        production_safe
    } news_portlet_links_names {
        Test diverse link and name procs.
} {
    aa_equals "News admin portlet link"         "[news_admin_portlet::link]" ""
    aa_equals "News portlet link"               "[news_portlet::link]" ""
    aa_equals "News admin portlet pretty name"  "[news_admin_portlet::get_pretty_name]" "#news-portlet.admin_pretty_name#"
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
