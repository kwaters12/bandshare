# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

DEFAULT_INSECURE_PASSWORD = '11111111'

User.create({
  first_name: "Eddie",
  last_name: "Murphy",
  profile_name: "eddie",
  email: "eddie@gigsurfing.com",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD
})

User.create({
  first_name: "Dave",
  last_name: "Chappelle",
  profile_name: "dave",
  email: "dave@gigsurfing.com",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD
})

User.create({
  first_name: "Bill",
  last_name: "Burr",
  profile_name: "bill",
  email: "bill@gigsurfing.com",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD
})

User.create({
  first_name: "Louis",
  last_name: "C.K.",
  profile_name: "louis",
  email: "louis@gigsurfing.com",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD
})

User.create({
  first_name: "Kelly",
  last_name: "Waters",
  profile_name: "kwatts",
  email: "kelly@gigsurfing.com",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD
})

eddie = User.find_by_email('eddie@gigsurfing.com')
dave   = User.find_by_email('dave@gigsurfing.com')
bill  = User.find_by_email('bill@gigsurfing.com')
louis  = User.find_by_email('louis@gigsurfing.com')
kelly  = User.find_by_email('kelly@gigsurfing.com')

seed_user = eddie

seed_user.bands.create(name: "RickRockers", links: "www.youtube.com, www.soundcloud.com", address: "1000 Main Street")
kelly.bands.create(name: "FunkBasters", links: "www.youtube.com, www.soundcloud.com", address: "1000 Main Street")
dave.bands.create(name: "BadNuts", links: "www.youtube.com, www.soundcloud.com", address: "1000 Main Street")
bill.bands.create(name: "Festicatas", links: "www.youtube.com, www.soundcloud.com", address: "1000 Main Street")
louis.bands.create(name: "Louis Hewis and the Olds", links: "www.youtube.com, www.soundcloud.com", address: "1000 Main Street")

UserFriendship.request(seed_user, kelly).accept!
UserFriendship.request(seed_user, dave).block!
UserFriendship.request(seed_user, bill)
UserFriendship.request(louis, seed_user)
