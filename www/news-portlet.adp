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
