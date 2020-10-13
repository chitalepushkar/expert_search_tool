class ScrapeWebHeadingsWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(user_id)
    HeaderScraper.save_user_headings(user_id)
  end
end