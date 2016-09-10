(function() {
  $(function() {
    $(".login--container").removeClass("preload");
    this.timer = window.setTimeout((function(_this) {
      return function() {
        return $(".login--container").toggleClass("login--active");
      };
    })(this), 3000);
    return $(".js-toggle-login").click((function(_this) {
      return function() {
        window.clearTimeout(_this.timer);
        $(".login--container").toggleClass("login--active");
        return $(".login--username-container input").focus();
      };
    })(this));
  });

}).call(this);




$(function () {
    $('div#j--hide').hide();
    $('a#add-log').click(function (event) {
        event.preventDefault();
        $('div#j--hide').animate({
            height: 'toggle'
        }, 'fast');
    });
});



$(function () {
    $('.notice').hide();
    $(".notice").animate({
        width:'toggle'
    },300);
});


