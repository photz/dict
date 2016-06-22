module EntriesHelper
    def article_for_display(article)
      article.gsub(/[\r\n]/, '<br>').html_safe
    end
end
