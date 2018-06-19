<?xml version="1.0"?>

<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="select_subgroup_package_ids">
        <querytext>
            select package_id
             from apm_packages p,
                  (select object_id,
                   parent_id
                   from site_nodes n
                   where (object_id is null
                     or acs_permission.permission_p(object_id, :user_id, 'read') = 't')               
                   start with node_id = :root_id
                   connect by prior node_id = parent_id)  site_map
             where site_map.object_id = p.package_id (+)
               and package_key = 'news'
        </querytext>
    </fullquery>

</queryset>
