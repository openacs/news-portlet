<?xml version="1.0"?>
<!--

  Copyright (C) 2001, 2002 OpenForce, Inc.

  This file is part of dotLRN.

  dotLRN is free software; you can redistribute it and/or modify it under the
  terms of the GNU General Public License as published by the Free Software
  Foundation; either version 2 of the License, or (at your option) any later
  version.

  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
  details.

-->


<queryset>

  <fullquery name="news_items_select">
    <querytext>
     select item_id,
     package_id,
     publish_title,
     publish_date
     from   news_items_approved
     where publish_date < sysdate 
     and (archive_date is null or archive_date > sysdate)      
     and    package_id = :instance_id
     order  by publish_date desc, item_id desc      
    </querytext> 
  </fullquery>

  <fullquery name="news_items_count">
    <querytext>
     select count(*) 
     from   news_items_approved
     where publish_date < sysdate 
     and (archive_date is null or archive_date > sysdate)      
     and    package_id = :instance_id
    </querytext> 
  </fullquery>

</queryset>

