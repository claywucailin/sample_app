#encoding: utf-8

# Clear all seed data
User.delete_all
Venue.delete_all
Region.delete_all
Category.delete_all
Event.delete_all
Listing.delete_all
Ticket.delete_all

# Users
puts 'ROLES'
YAML.load(ENV['ROLES']).each do |role|
  Role.find_or_create_by_name({ :name => role }, :without_protection => true)
  puts 'role: ' << role
end
puts 'DEFAULT USERS'
user = User.find_or_create_by_email :name => ENV['ADMIN_NAME'].dup, :email => ENV['ADMIN_EMAIL'].dup, \
  :password => ENV['ADMIN_PASSWORD'].dup, :password_confirmation => ENV['ADMIN_PASSWORD'].dup
puts 'user: ' << user.name
user.confirm!
user.add_role :admin

buyer = User.find_or_create_by_name :name => 'buyer', :email => 'buyer@gogopiao.com', \
  :password => 'buyer', :password_confirmation => 'buyer'
puts 'buyer: ' << buyer.name
buyer.confirm!
buyer.add_role :buyer

seller = User.find_or_create_by_name :name => 'seller', :email => 'seller@gogopiao.com', \
  :password => 'seller', :password_confirmation => 'seller'
puts 'seller: ' << seller.name
seller.confirm!
seller.add_role :seller

users = User.all
users.each do |user|
  user.address = Address.create street_address: "广东省广州市天河区华强路3号", \
    tel: '1234567890', zipcode: '123456', recipient: '张三'
  user.tel = '1234567890'
  user.save!
end

# Venue
venue_file = Roo::Excel.new('files/venue.xls')
(venue_file.first_row + 1).upto(venue_file.last_row) do |line|
  name = (venue_file.cell(line, 'A') || '').strip
  description = (venue_file.cell(line, 'B') || '').strip
  if name.blank?
    next
  else
    Venue.create({name: name, description: description})
  end
end

# Regions
region_file = Roo::Excel.new('files/regions.xls')
root = Region.create({name: "中国", description: "中华人民共和国"})
(region_file.first_row + 2).upto(region_file.last_row) do |line|
  name = (region_file.cell(line,'A') || '').strip
  description = (region_file.cell(line, 'B') || '').strip
  parent_name = (region_file.cell(line, 'C') || '').strip
  if name.blank?
    next
  else
    parent = Region.find_by_name(parent_name)
    Region.create({name: name, description: description, parent_id: parent.id})
  end
end

guangzhou = Region.find_by_name("广州")
shenzhen = Region.find_by_name("深圳")

# Categories
root = Category.create({name: 'root', description: "This is root"})

sport = Category.create(name: '体育', description: 'this is sport', parent_id: root.id)
[['篮球', 'Basketball'], ['排球', 'Volleyball'], ['其他', 'Others']].each do |c|
  sport.sub_categories << Category.create(name: c[0], description: c[1])
end

concert = Category.create(name: '音乐会', description: 'this is concert', parent_id: root.id)
[['古典', 'Classical'], ['摇滚', 'Rock and Roll'], ['流行', 'Pop'], ['其他', 'Other']].each do |c|
  concert.sub_categories << Category.create(name: c[0], description: c[1])
end

other = Category.create(name: '其他', description: 'this is others', parent_id: root.id)
[['古典', 'Classical'], ['摇滚', 'Rock and Roll'], ['流行', 'Pop']].each do |c|
  other.sub_categories << Category.create(name: c[0], description: c[1])
end

# Event, Artist, Region, Venue

venue1 = Venue.find_by_name("天河体育中心")
venue2 = Venue.find_by_name("越秀山体育馆")
concert = Category.find_by_name("音乐会").sub_categories.first
sport = Category.find_by_name("体育").sub_categories.first

concert_file = Roo::Excelx.new('files/concerts.xlsx')

(concert_file.first_row + 1).upto(concert_file.last_row) do |i|
  #TODO: add 'average_price' for each event??
  artist_name = concert_file.cell(i, 'C')
  artist = Artist.find_or_create_by_name(name: artist_name, profiles: {name_zh: artist_name })

  region_name = concert_file.cell(i, 'E')
  region = Region.find_or_create_by_name(name: region_name)

  venue_name = concert_file.cell(i, 'F')
  venue = Venue.find_or_create_by_name(name: venue_name)

  event_name = concert_file.cell(i, 'B')

  if concert_file.cell(i,'D').kind_of? Float then
    time_array = concert_file.cell(i, 'D').to_s.split('.')
    event_time = Time::mktime(2013, time_array[0], time_array[1]).to_s
  end

  event = MusicalEvent.create({category_id: category1.id, venue_id: venue.id, region_id: region.id, title: event_name, description: event_name, start_time: event_time})

end

event1 = Event.create({category_id: concert.id, venue_id: venue1.id, region_id: guangzhou.id, title: "Eason陈奕迅演唱会", description: "3000元的黄牛票 我也会买了去听的 ", start_time: Time.now})
event2 = Event.create({category_id: sport.id, venue_id: venue2.id, region_id: guangzhou.id, title: "广州恒大对广州富力", description: "广州德比 埃里克森智斗里皮", start_time: Time.now})

# Listing & Tickets

SECTION = ['南下二区', '北三区', '南三区']
ROW = ['6排', '8排', '19排']

Event.all.each do |event|
  listings = []
  tickets = []

  3.times do |i|
    listing[i] = event.listings.create(seller_id: seller.id, split_type: 1, status: 1, section: SECTION[i], row: , split_type: 1, seat_type: 1, tickets_count: 0)
  end

  9.times do |j|
    t_status = (j%3 == 0)? 1 : 2
      tickets[j] = Ticket.create(event_id: event.id, list_price: 100 * (j+1), seat: j+1, status: tickets[j], buyer_id: buyer.id)
  end

  3.times do |i|
    (i*3).upto(i*3+2) do |j|
      listing[i].add_ticket(tickets[j])
    end
  end
end

jay = Artist.find_by_name("周杰伦")
jay.update_attributes(aka: "ZHOUJIELUN", profiles: { name_en: "Jay" })
Artist.create(name: "陈奕迅", aka: "CHENYIXUN", profiles: {name_zh: "陈奕迅", name_en: "Eason"})
SportTeam.create(name: "广东宏远", aka: "HONGYUAN", profiles: {name_zh: "广东宏远", name_en: ""})
SportTeam.create(name: "东莞马可波罗", aka: "MAKEBOLUO", profiles: {name_zh: "东莞马可波罗", name_en: ""})

# Orders

tickets_for_sale = Ticket.limit(9)
ticket_group[0] = tickets_for_sale[0..2]
ticket_group[1] = tickets_for_sale[3..5]
ticket_group[2] = tickets_for_sale[6..8]

3.times do |i|
  order = Order.create(buyer_id: buyer.id, seller_id: seller.id)
  ticket_group[i].each do |ticket|
    order.items.create(ticket_id: ticket.id)
  end
end


# Ready the artists
Artist.all.each do |artist|
  Event.where('title like ?', "%#{artist.name}%").each do |event|
    event.performers << artist
    event.save
  end
end

jay = Artist.find_by_name('周杰伦')
jay_events = Event.joins{performers}.where{performers.id == jay.id}
jay_listing = jay_events.each do |event| 
  (rand(10)+1).times {
    tickets_count = rand(5) + 1
    list_price    = (rand(5) + 1)*100
    seat_start    = rand(10) + 1
    listing = event.listings.build(seller_id: seller.id, split_type: 1, status: 1, section: "北二区", row: "5排", seat_type: 2, tickets_count: tickets_count, list_price: list_price)
    tickets_count.times {
      listing.tickets.build(event_id: listing.event_id, list_price: listing.list_price, seat: seat_start, status: (rand(2) + 1), seller_id: seller.id)
      seat_start += 1
    } 
    listing.save
  }
end
