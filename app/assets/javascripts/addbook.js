$(document).ready(function(){
	$("#add_click").click(function(){
    var isbn_input = $("#isbn_input").val();
    var url = "https://api.douban.com/v2/book/isbn/"+isbn_input+"?apikey=05fda08443dc365f11f8e18ccb94a31d&callback=?";
    $.getJSON(url, function(data) {
            var tags=data.tags;
            var tags_str=JSON.stringify(tags);
            var title_str = data.title;
            var subtitle_str = data.subtitle;
            var author_str = data.author[0];
            var image_str = data.image;
            var authorIntro_str = data.author_intro;
            var summary_str = data.summary;
            summary_str = "<p>" +summary_str + "</p>";
            summary_str = summary_str.replace(/\n/g, "</p>\n<p>");
            var publisher_str = data.publisher;
            var pubdate_str = data.pubdate;;
            var isbn_str=isbn_input;
            var url_str=data.alt;
            $.post("addBook",{tag:tags_str,title:title_str,subtitle:subtitle_str,author:author_str,image:image_str,authorIntro:authorIntro_str,summary:summary_str
            ,publisher:publisher_str,pubdate:pubdate_str,isbn:isbn_str,url:url_str},function(result){
            	if(result=="success"){
            		location.reload();
            	}
            	if(result=="repeat"){
            		alert('repeat');
            	}
            });
    });
        });
});