<?xml version="1.0"?>

<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="select_subgroup_package_ids">
        <querytext>
            select package_id
            from apm_packages p right outer join
                 (select n.object_id,
                  n.parent_id,
                  tree_level(n.tree_sortkey) as mylevel
                  from site_nodes n, site_nodes root
                  where (n.object_id is null
                    or acs_permission__permission_p(n.object_id, :user_id, 'read') = 't')
                  and root.node_id = :root_id
                  and n.tree_sortkey
                    between root.tree_sortkey and tree_right(root.tree_sortkey)) site_map
            on site_map.object_id = p.package_id
            where package_key = 'news'
        </querytext>
    </fullquery>

</queryset>
