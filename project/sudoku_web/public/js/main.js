function p(msg){
  $('#messages').text(msg);
}
$(function() {
  $(".cell").hover(
    function() {
      $(this).addClass("hover");
    },
    function(){
      $(this).removeClass("hover");
    }
  );

  var fixClass = 'fix';
  var updateElement = null;
  // Dialog Link
  $('#sudoku_99').find('.cell').click(function(e){
    $('#dialog').css('display','');
    var position = { top: e.pageY+5, left: e.pageX+5 }
    $('#dialog').offset(position);
    p(e.pageX+":"+e.pageY);
    updateElement = this;
  });
  $('#dialog').find('.cell').click(function(e){
    p(this.innerText);
    updateElement.innerText = this.innerText;
    $(updateElement).addClass(fixClass);
    $('#close').click();
  });
  
  $('#close').click(function(){
    $('#dialog').css('display','none');
  });
  $('#null').click(function(){
    updateElement.innerText = '';
    $(updateElement).removeClass(fixClass);
    $('#close').click();
  });
  function getFixedValues(){
    var fixedValues = {};
    $('.'+fixClass).each(function(){
      fixedValues[this.id] = this.innerText;
    });
    return fixedValues;
  }
  $('#compute').click(function(){
    $.get('/sudoku/sudokuresult',{fix_values:getFixedValues()},function(result){
      var dataHash = JSON.parse(result);
      p('get success!'+result+","+dataHash);
    });
  });
  $('#clear').click(function(){
    $('.'+fixClass).each(function(){
      this.innerText = "";
      $(this).removeClass(fixClass);
    });
  });
});
