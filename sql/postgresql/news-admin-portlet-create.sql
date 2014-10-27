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
-- /news-portlet/sql/postgresql/news-admin-portlet-create.sql
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
-- PostGreSQL port samir@symphinity.com 10 July 2002
--




--
-- procedure inline_0/0
--
CREATE OR REPLACE FUNCTION inline_0(

) RETURNS integer AS $$
DECLARE
  ds_id portal_datasources.datasource_id%TYPE;
BEGIN

  ds_id  = portal_datasource__new( 'news_admin_portlet', 'News Admin portlet');


  --  the standard 4 params

  -- shadeable_p 
  perform portal_datasource__set_def_param (
	ds_id,
	't',
	't',
	'shadeable_p',
	'f'
);	


  -- hideable_p 
  perform portal_datasource__set_def_param (
	ds_id,
	't',
	't',
	'hideable_p',
	'f'
);	

  -- user_editable_p 
  perform portal_datasource__set_def_param (
	ds_id,
	't',
	't',
	'user_editable_p',
	'f'
);	

  -- shaded_p 
  perform portal_datasource__set_def_param (
	ds_id,
	't',
	't',
	'shaded_p',
	'f'
);	

  -- link_hideable_p 
  perform portal_datasource__set_def_param (
	ds_id,
	't',
	't',
	'link_hideable_p',
	't'
);  

-- news_admin-specific params

  -- package_id must be configured
  perform portal_datasource__set_def_param (
	ds_id,
	't',
	'f',
	'package_id',
	''
);

  return 0;

END;
$$ LANGUAGE plpgsql;

select inline_0();
drop function inline_0();


CREATE OR REPLACE FUNCTION inline_1() RETURNS integer AS $$
BEGIN

	-- create the implementation
	perform acs_sc_impl__new (
		'portal_datasource',
		'news_admin_portlet',
		'news_admin_portlet'
	);

	-- add all the hooks
	perform acs_sc_impl_alias__new(
	       'portal_datasource',
	       'news_admin_portlet',
	       'GetMyName',
	       'news_admin_portlet::get_my_name',
	       'TCL'
	);

	perform acs_sc_impl_alias__new (
	       'portal_datasource',
	       'news_admin_portlet',
	       'GetPrettyName',
	       'news_admin_portlet::get_pretty_name',
	       'TCL'
	);

	perform acs_sc_impl_alias__new (
	       'portal_datasource',
	       'news_admin_portlet',
	       'Link',
	       'news_admin_portlet::link',
	       'TCL'
	);

	perform acs_sc_impl_alias__new (
	       'portal_datasource',
	       'news_admin_portlet',
	       'AddSelfToPage',
	       'news_admin_portlet::add_self_to_page',
	       'TCL'
	);

	perform acs_sc_impl_alias__new (
	       'portal_datasource',
	       'news_admin_portlet',
	       'Show',
	       'news_admin_portlet::show',
	       'TCL'
	);

	perform acs_sc_impl_alias__new (
	       'portal_datasource',
	       'news_admin_portlet',
	       'Edit',
	       'news_admin_portlet::edit',
	       'TCL'
	);

	perform acs_sc_impl_alias__new (
	       'portal_datasource',
	       'news_admin_portlet',
	       'RemoveSelfFromPage',
	       'news_admin_portlet::remove_self_from_page',
	       'TCL'
	);

	-- Add the binding
	perform acs_sc_binding__new (
	    'portal_datasource',
	    'news_admin_portlet'
	);

	return 0;
END;
$$ LANGUAGE plpgsql;

select inline_1();
drop function inline_1();


