<?xml version="1.0"?>

<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="select_news_items">
        <querytext>
            select news_items_approved.package_id,
                   acs_object.name(apm_package.parent_id(news_items_approved.package_id)) as parent_name,
                   (select site_node.url(site_nodes.node_id)
                    from site_nodes
                    where site_nodes.object_id = news_items_approved.package_id) as url,
                   news_items_approved.item_id,
                   news_items_approved.publish_title,
                   news_items_approved.publish_date
            from news_items_approved
            where news_items_approved.publish_date < sysdate
            and (news_items_approved.archive_date >= sysdate or news_items_approved.archive_date is null)
            and news_items_approved.package_id in ([join $list_of_package_ids ", "])
            order by parent_name,
                     news_items_approved.publish_date desc,
                     news_items_approved.publish_title			

        </querytext>
    </fullquery>

</queryset>
