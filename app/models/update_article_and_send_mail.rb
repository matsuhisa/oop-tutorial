class UpdateArticleAndSendMail
  include ActiveModel::Model
  define_model_callbacks :update, only: :after
  attr_reader :article
  after_update :send_mail

  def initialize(article)
    @article = article
  end

  def update(params)
    run_callbacks :update do
      @article.update(params)
    end
  end

  private

  def send_mail
    ArticleMailer.update_article(article).deliver_now
  end
end
