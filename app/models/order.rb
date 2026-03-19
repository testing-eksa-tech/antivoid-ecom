require_relative '../utils/database'

class Order
  COLLECTION = :orders

  attr_accessor :id, :customer_name, :address, :contact, :customer_email, :items, :total_price, :status, :created_at, :resi, :user_id

  def self.all(filter = {}, limit: nil, skip: nil)
    query = Database.collection(COLLECTION).find(filter).sort(created_at: -1)
    query = query.limit(limit) if limit
    query = query.skip(skip) if skip
    query.map { |o| from_hash(o) }
  end

  def self.count(filter = {})
    Database.collection(COLLECTION).count_documents(filter)
  end

  def self.find(id)
    return nil unless id && !id.empty?
    begin
      hash = Database.collection(COLLECTION).find({ _id: BSON::ObjectId.from_string(id) }).first
      from_hash(hash) if hash
    rescue BSON::Error::InvalidObjectId
      nil
    end
  end

  def self.create(attrs)
    attrs[:status] ||= 'Pending'
    attrs[:created_at] = Time.now
    Database.collection(COLLECTION).insert_one(attrs)
  end

  def self.update_status(id, status, resi = nil)
    update_data = { status: status }
    update_data[:resi] = resi if resi
    begin
      Database.collection(COLLECTION).update_one({ _id: BSON::ObjectId.from_string(id) }, { '$set' => update_data })
    rescue BSON::Error::InvalidObjectId
      false
    end
  end

  def self.from_hash(hash)
    order = new
    order.id = hash['_id']
    order.customer_name = hash['customer_name']
    order.address = hash['address']
    order.contact = hash['contact']
    order.customer_email = hash['customer_email']
    
    # Hydrate items with Product objects
    order.items = (hash['items'] || []).map do |item|
      product = Product.find(item['product_id'].to_s)
      {
        product: product,
        quantity: item['quantity'],
        price: item['price']
      }
    end
    
    order.total_price = hash['total_price']
    order.status = hash['status']
    order.created_at = hash['created_at']
    order.resi = hash['resi']
    order.user_id = hash['user_id']
    order
  end
end
