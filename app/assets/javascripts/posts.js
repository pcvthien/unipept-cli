function initPosts() {
    $(window).scroll(function () {
        var url;
        url = $('.pagination .next_page').attr('href');
        if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 50) {
            $('.pagination').text("Fetching more news...");
            return $.getScript(url);
        }
    });
}