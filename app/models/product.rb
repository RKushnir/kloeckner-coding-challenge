class Product < ApplicationRecord
  def part_price_usd
    part_price_usd_cents / 100.0
  end
end
