--
-- /news-portlet/sql/oracle/news-portlet-drop.sql
--

-- Drops news portlet

-- Copyright (C) 2001 Openforce, Inc. 
-- @author Arjun Sanyal (arjun@openforce.net)
-- @creation-date 2001-30-09

-- $Id$

-- This is free software distributed under the terms of the GNU Public
-- License version 2 or higher.  Full text of the license is available
-- from the GNU Project: http://www.fsf.org/copyleft/gpl.html

declare  
  ds_id portal_datasources.datasource_id%TYPE;
begin

  begin 
    select datasource_id into ds_id
      from portal_datasources
     where name = 'news_portlet';
   exception when no_data_found then
     ds_id := null;
  end;

  if ds_id is not null then
    portal_datasource.delete(ds_id);
  end if;

end;
/
show errors;

declare
	foo integer;
begin

	-- drop the hooks
	foo := acs_sc_impl.delete_alias (
	       'portal_datasource',
	       'news_portlet',
	       'MyName'
	);

	foo := acs_sc_impl.delete_alias (
	       'portal_datasource',
	       'news_portlet',
	       'GetPrettyName'
	);


	foo := acs_sc_impl.delete_alias (
	       'portal_datasource',
	       'news_portlet',
	       'Link'
	);

	foo := acs_sc_impl.delete_alias (
	       'portal_datasource',
	       'news_portlet',
	       'AddSelfToPage'
	);

	foo := acs_sc_impl.delete_alias (
	       'portal_datasource',
	       'news_portlet',
	       'Show'
	);

	foo := acs_sc_impl.delete_alias (
	       'portal_datasource',
	       'news_portlet',
	       'Edit'
	);

	foo := acs_sc_impl.delete_alias (
	       'portal_datasource',
	       'news_portlet',
	       'RemoveSelfFromPage'
	);

	foo := acs_sc_impl.delete_alias (
	       'portal_datasource',
	       'news_portlet',
	       'MakeSelfAvailable'
	);

	foo := acs_sc_impl.delete_alias (
	       'portal_datasource',
	       'news_portlet',
	       'MakeSelfUnavailable'
	);

	-- Drop the binding
	acs_sc_binding.delete (
	    contract_name => 'portal_datasource',
	    impl_name => 'news_portlet'
	);

	-- drop the impl
	foo := acs_sc_impl.delete (
		'portal_datasource',
		'news_portlet'
	);
end;
/
show errors

