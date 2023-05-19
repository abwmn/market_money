class MarketVendor < ApplicationRecord
  belongs_to :market
  belongs_to :vendor

  validates :market, presence: true
  validates :vendor, presence: true
  validates_uniqueness_of :vendor_id, 
            scope: :market_id, 
            message: 'association between market and vendor already exists'
end