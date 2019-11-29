class ProductAddWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  require 'csv'
  def perform(csv_path)
    CSV.foreach((csv_path), headers: true) do |product|
      Product.create(
        name: product[0],
        price: product[1],
        description: product[2],
        user_id: product[3]
      )
    end
  end
end
