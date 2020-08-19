ad_library {
    Automated tests for the news-portlet package.

    @author Héctor Romojaro <hector.romojaro@gmail.com>
    @creation-date 2020-08-19
    @cvs-id $Id$
}

aa_register_case -procs {
        news_admin_portlet::link
        news_portlet::link
    } -cats {
        api
        production_safe
    } news_portlet_links {
        Test diverse link procs.
} {
    aa_equals "News admin portlet link" "[news_admin_portlet::link]" ""
    aa_equals "News portlet link"       "[news_portlet::link]" ""
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
