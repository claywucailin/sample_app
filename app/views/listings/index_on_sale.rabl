collection @listings, :object_root => false

attributes :list_price, :row, :tickets_count
node(:start_time){|listing| listing.event.start_time}
