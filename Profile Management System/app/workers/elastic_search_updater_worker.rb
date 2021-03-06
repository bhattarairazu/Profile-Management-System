class ElasticSearchUpdaterWorker
  include Sidekiq::Worker

  def perform(action, id)
    if action == "create"
      User.get_user_info_by_id(id).__elasticsearch__.index_document
    elsif action == "update"
      User.get_user_info_by_id(id).__elasticsearch__.update_document
    else
      User.get_user_info_by_id(id).__elasticsearch__.delete_document
    end
    puts "Updated in Elastic Search Doc"
  end
end
