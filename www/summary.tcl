# /packages/news/www/item.tcl

ad_page_contract {
    
    Page to view one item (live or archived) in its active revision
    @author stefan@arsdigita.com
    @creation-date 2000-12-20
    @cvs-id $Id$
    
} {

} -properties {
    title:onevalue
    item_exist_p:onevalue
    publish_title:onevalue
    publish_date:onevalue
    publish_body:onevalue
    html_p:onevalue
    creator_link:onevalue
    comments:onevalue
    comment_link:onevalue
}

ad_require_permission [ad_conn package_id] news_read


# live view of a news item in its active revision
set item_exist_p [db_0or1row one_item "
select item_id,
       live_revision,
       publish_title,
       html_p,
       publish_date,
       '<a href=/shared/community-member?user_id=' || creation_user || '>' || item_creator ||  '</a>' as creator_link
from   news_items_live_or_submitted
where  item_id = :item_id"]


if { $item_exist_p } {

    # workaround to get blobs with >4000 chars into a var, content.blob_to_string fails! 
    # when this'll work, you get publish_body by selecting 'publish_body' directly from above view
    #
    # RAL: publish_body is already snagged in the 1st query above for postgres.
    # CERM: This work around is not used here, so this may not work for postgres.
    #

	set publish_body [db_string get_content "select  content
	from    cr_revisions
	where   revision_id = :live_revision"]


#currently not using comments in the summary but someone might want to change the template so they are available.    
    if { [ad_parameter SolicitCommentsP "news" 0] &&
         [ad_permission_p $item_id general_comments_create] } {
	set comment_link [general_comments_create_link $item_id "[ad_conn package_url]item?item_id=$item_id"]
	set comments [general_comments_get_comments -print_content_p 1 -print_attachments_p 1 \
		$item_id "[ad_conn package_url]item?item_id=$item_id"]
    } else {
	set comment_link ""
        set comments ""
    }


} else {
    set context_bar {}
    set title "Error"
}

#This is a summary in the portlet we don't want it to be too long.

set more_link ""
if { [string length $publish_body] > 1000 } {
    set publish_body "[string range $publish_body 0 1000]"
    set more_link "......<a href=$url>read more</a>"
}

set publish_body [ad_convert_to_html  -html_p $html_p $publish_body]




ad_return_template
















