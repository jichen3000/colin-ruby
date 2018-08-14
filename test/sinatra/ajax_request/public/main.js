var show_msg = function(msg){
    $("#msg").html($("#msg").html()+"<br>"+msg);
};
var refresh_data = function(the_url){
    the_url = '/sleep/'+$("#input-sleep-seconds").val();
    $.ajax({
        url: the_url,
        type: 'get',
        success: function(return_data){
            console.log(return_data);
            show_msg(return_data);
        },
        error: function(xhr, ajaxOptions, thrownError){

            var error_msg = "Error";
            console.log(error_msg);
            show_msg(error_msg);
            show_msg(xhr.responseText());
            show_msg(thrownError);
        }
    });
};

$('#refresh').click(function() {
    refresh_data();
});
