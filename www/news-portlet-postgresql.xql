<?xml version="1.0"?>

<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="select_subgroup_package_ids">
        <querytext>
            select package_id
            from apm_packages p right outer join
               ( WITH RECURSIVE site_node_tree AS (
                    select node_id, parent_id, object_id from site_nodes where node_id = :root_id
                 UNION ALL
                    select c.node_id, c.parent_id, c.object_id from site_node_tree tree, site_nodes as c
                    where  c.parent_id = tree.node_id
                 )
		 select * from site_node_tree n) site_map
            on site_map.object_id = p.package_id
            where package_key = 'news'
	    and (site_map.object_id is null or acs_permission__permission_p(site_map.object_id, :user_id, 'read') = 't')
        </querytext>
    </fullquery>

</queryset>
