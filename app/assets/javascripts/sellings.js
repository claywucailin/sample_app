$(document).ready(function(){
  // selling page index
  var output;
  $(".content_index #concert a, .content_index #sports a").click(function(e){
    e.preventDefault();
    var url = $(this).attr("href");
    var text_content = $(this).text().slice(7,10);
    $.getJSON(url,function(results){
      output = results;
      $(".content_index").css("display","none");
      $(".display_content").append("<span style = 'display:block'>请选择艺术家/球队 "+text_content+"</span>");
      $(".display_content").append("<ul style = 'list-style:none;float:left;width:800px;'>");
      var times = 0;
      $.each(results,function(key,value){
        times = times + 1;
        if(times > 4){
           $(".display_content ul").append("<div style = 'float:left;'></div>");
        }
        $(".display_content ul").append("<li style = 'margin-bottom:15px; float:left;margin-right:60px;cursor:pointer;'><a style = 'display:inline-block;width:150px;' href='/events?performer_id="+value['id']+"'>"+value['name']+"</a></li>");
      });
      $(".display_content").append("</ul>");
      $(".display_content").append("<a id = 'mylink' style = 'cursor:pointer;' onclick='history.go(0)'> 返回上一级</a>");
    });
  });
   
  $('#mylink').click(function(e){
    e.preventDefault()
    alert('hi there')
    $(".display_content").html("");
    $(".content_index").css("display", "block");
  });
  /*function backToMain() {
    
  }*/

  $("input[name = 'listing[seat_type]']").each(function() {
    $(this).hide()
    if ($(this).attr('checked')) {
      $(this).after($("<img src='/assets/radio-checked-01.png' style ='width:17px;height:18px;margin-left:40px;'name = 'seat_bt'/>"));
    } else {
      $(this).after($("<img src='/assets/radio-unchecked.png' style ='width:17px;height:18px;margin-left:40px;'name = 'seat_bt'/>"));
    }
  })
  $("img[name='seat_bt']").click(function(){
    $("img[name = 'seat_bt']").attr("src","/assets/radio-unchecked.png");
    $("img[name = 'seat_bt']").prev().attr('checked',false);
    $(this).attr("src","/assets/radio-checked-01.png").prev()
    $(this).prev().attr('checked',true);
  });

  $("input[name = 'listing[split_type]']").each(function() {
    if ($(this).attr('checked')) {
      $(this).hide();
      $(this).after($("<img src='/assets/radio-checked-01.png' style ='width:17px;height:18px;margin-left:40px;'name = 'division_bt'/>"));
    } else {
      $(this).hide();
      $(this).after($("<img src='/assets/radio-unchecked.png' style ='width:17px;height:18px;margin-left:40px;'name = 'division_bt'/>"));
    }
  })
  $("img[name='division_bt']").click(function(){
    $("img[name = 'division_bt']").attr("src","/assets/radio-unchecked.png");
    $("img[name = 'division_bt']").prev().attr('checked',false);
    $(this).attr("src","/assets/radio-checked-01.png").prev()
    $(this).prev().attr('checked',true);
  });

  $("img[name='seat_bt']").click(function(){
    var ticket_no = $("#listing_tickets_count").val();
    if($(this).prev().attr("value") == "1"){
    $("row-no .common_left").remove();
    $("#warm_tips").hide();
    for(i = 0; i < ticket_no; i++){
      $("#seat-no").append("<input class = 'common_left' type = 'text' id = seat_no"+i+" name = seat_no/>");
      $("#warm_tips").show();
    }
    }
    else{
      $(".common_left").remove();
      $("#warm_tips").hide();
    }
  });
  
  $("#listing_tickets_count").blur(function(){
    if ($("input[name = 'listing[seat_type]']:checked").val() == "1") {
      var ticket_no = $(this).val();  
      $(".common_left").remove();
      $("#warm_tips").hide();
      for(i = 0; i < ticket_no; i++){
        $("#seat-no").append("<input class = 'common_left' type = 'text' id = seat_no"+i+" name = seat_no/>");
        $("#warm_tips").show()
      }
    }
  });

  $("#to_5step").click(function(e){
    e.preventDefault();
    $("#step4").hide();
    $("#step5").show();
  });

  $("#sold_label").click(function(){
    $(this).css("color","red");
    $("#unsold_label").css("color","#b1b1b1");
    $(".sold_detail").show();
    $(".unsold_detail").hide();
  });
  $("#unsold_label").click(function(){
    $(this).css("color","red");
    $("#sold_label").css("color","#b1b1b1");
    $(".unsold_detail").show();
    $(".sold_detail").hide();
  });

  // selling payment step: users cannot edit field, unless clicking the 'edit' button
  $("#contact_edit").click(function(e){
    e.preventDefault();
    $("input[name = 'name']").removeAttr("readonly");
    $(this).parent('.readonly').removeClass('readonly')
  });
  $("#pay_edit").click(function(e){
    e.preventDefault();
    $("input[name = 'pay']").removeAttr("readonly");
    $(this).parent('.readonly').removeClass('readonly')
  });
})