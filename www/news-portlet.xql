<?xml version="1.0"?>

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

