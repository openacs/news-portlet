<%

    #
    #  Copyright (C) 2001, 2002 OpenForce, Inc.
    #
    #  This file is part of dotLRN.
    #
    #  dotLRN is free software; you can redistribute it and/or modify it under the
    #  terms of the GNU General Public License as published by the Free Software
    #  Foundation; either version 2 of the License, or (at your option) any later
    #  version.
    #
    #  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
    #  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
    #  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
    #  details.
    #

%>

<if @shaded_p@ ne "t">

  <if @no_news_p@ ne "t">

    <if @one_instance_p@ eq 0>
      <ul>
    </if>

      @data@

  <if @one_instance_p@ eq 0>
    </ul>
  </if>

  </if>
  <else>
    @data@
  </else>

</if>
<else>
&nbsp;
</else>
