--
--  Copyright (C) 2001, 2002 MIT
--
--  This file is part of dotLRN.
--
--  dotLRN is free software; you can redistribute it and/or modify it under the
--  terms of the GNU General Public License as published by the Free Software
--  Foundation; either version 2 of the License, or (at your option) any later
--  version.
--
--  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
--  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
--  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
--  details.
--

--
-- /news-portlet/sql/oracle/news-admin-portlet-create.sql
--

-- Creates news admin portlet

-- Copyright (C) 2001 MIT
-- @author Arjun Sanyal (arjun@openforce.net)
-- @author Ben Adida (Ben@openforce.net)
-- @creation-date 2002-01-19

-- $Id$

-- This is free software distributed under the terms of the GNU Public
-- License version 2 or higher.  Full text of the license is available
-- from the GNU Project: http://www.fsf.org/copyleft/gpl.html
--
-- Postgresql port adarsh@symphinity.com
--  
-- 10 July 2002

create function inline_0 ()
returns integer as '
declare  
  ds_id portal_datasources.datasource_id%TYPE;
begin

  select datasource_id into ds_id
    from portal_datasources
    where name = ''news_admin_portlet'';

    if not found then
        raise exception ''No datasource_id found here '',ds_id ;
	ds_id := null;        
    end if;

      
  if ds_id is NOT null then
    perform portal_datasource__delete(ds_id);
  end if;

return 0;

end;' language 'plpgsql';

select inline_0 ();

drop function inline_0 ();

-- create the implementation
select acs_sc_impl__delete (
		'portal_datasource',
		'news_admin_portlet'
);

-- delete all the hooks
select acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'news_admin_portlet',
	       'GetMyName'
);

select acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'news_admin_portlet',
	       'GetPrettyName'
);

select acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'news_admin_portlet',
	       'Link'
);

select acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'news_admin_portlet',
	       'AddSelfToPage'
);

select acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'news_admin_portlet',
	       'Show'
);

select acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'news_admin_portlet',
	       'Edit'
);

select acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'news_admin_portlet',
	       'RemoveSelfFromPage'
);

-- Add the binding
select acs_sc_binding__delete (
		'portal_datasource',
		'news_admin_portlet'
);
