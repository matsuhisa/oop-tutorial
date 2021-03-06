class ArticleForm
  include ActiveModel::Model
  attr_accessor :title, :body, :category1, :category2, :article
  validates :title, article_length: { attribute: :body, minimum: 100 }

  delegate :persisted?, to: :article

  def save
    @article = Article.new(title: title, body: body)
    @article.categories << Category.find_by(id: category1) if category1
    @article.categories << Category.find_by(id: category2) if category2
    if valid?
      create_article_and_send_mail = CreateArticleAndSendMail.new(article)
      create_article_and_send_mail.save
    else
      false
    end
  end

  def update
    @article.categories.clear
    @article.categories << Category.find_by(id: category1) if category1
    @article.categories << Category.find_by(id: category2) if category2
    # article.update(article_parms.article)
    update_article_and_send_mail = UpdateArticleAndSendMail.new(article)
    update_article_and_send_mail.update(params)
  end

  def params
    {
      title: title,
      body: body
    }
  end
end
