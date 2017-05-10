$(document).ready(function(){
  $('#id_shops_list').find('input.checkbox').each(function(index, input){
    $(input).on('change', function(){
      if($(input).is(':checked')){
        console.log("def")
        $.ajax({
          url: '/dashboard/shops/' + $(this).attr('value'),
          type: 'PUT',
          dataType: 'script',
          data:{
            'checked': true
          },
        });
      }
      else {
        console.log("abc")
        $.ajax({
          url: '/dashboard/shops/' + $(this).attr('value'),
          type: 'PUT',
          dataType: 'script',
          data:{
            'checked': false
          },
        });
      }
    })
  })
});
