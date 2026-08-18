password = "password"

harbor = Team.find_or_create_by!(name: "Harbor Cafe")
clinic = Team.find_or_create_by!(name: "Northside Clinic")

maya = User.find_or_initialize_by(email: "maya@harbor.test")
maya.assign_attributes(name: "Maya Chen", password: password, password_confirmation: password, team: harbor, manager: true)
maya.save!

jordan = User.find_or_initialize_by(email: "jordan@harbor.test")
jordan.assign_attributes(name: "Jordan Lee", password: password, password_confirmation: password, team: harbor, manager: false)
jordan.save!

sam = User.find_or_initialize_by(email: "sam@harbor.test")
sam.assign_attributes(name: "Sam Ortiz", password: password, password_confirmation: password, team: harbor, manager: false)
sam.save!

priya = User.find_or_initialize_by(email: "priya@clinic.test")
priya.assign_attributes(name: "Priya Nair", password: password, password_confirmation: password, team: clinic, manager: true)
priya.save!

devon = User.find_or_initialize_by(email: "devon@clinic.test")
devon.assign_attributes(name: "Devon Brooks", password: password, password_confirmation: password, team: clinic, manager: false)
devon.save!

[
  [jordan, harbor, "Morning open", 1.day.from_now.change(hour: 7, min: 0), 1.day.from_now.change(hour: 13, min: 0)],
  [jordan, harbor, "Evening close", 2.days.from_now.change(hour: 15, min: 0), 2.days.from_now.change(hour: 21, min: 0)],
  [sam, harbor, "Weekend brunch", 3.days.from_now.change(hour: 9, min: 0), 3.days.from_now.change(hour: 14, min: 0)],
  [maya, harbor, "Manager floor", 4.days.from_now.change(hour: 10, min: 0), 4.days.from_now.change(hour: 16, min: 0)],
  [devon, clinic, "Front desk AM", 1.day.from_now.change(hour: 8, min: 0), 1.day.from_now.change(hour: 12, min: 0)],
  [devon, clinic, "Front desk PM", 2.days.from_now.change(hour: 12, min: 0), 2.days.from_now.change(hour: 17, min: 0)],
  [priya, clinic, "Charge nurse", 3.days.from_now.change(hour: 7, min: 0), 3.days.from_now.change(hour: 15, min: 0)]
].each do |user, team, title, starts_at, ends_at|
  shift = Shift.find_or_initialize_by(user: user, team: team, title: title, starts_at: starts_at)
  shift.ends_at = ends_at
  shift.save!
end

puts "Seeded teams, users, and shifts."
puts "Demo logins (password: password):"
puts "  Manager Harbor: maya@harbor.test"
puts "  Staff Harbor:   jordan@harbor.test / sam@harbor.test"
puts "  Manager Clinic: priya@clinic.test"
puts "  Staff Clinic:   devon@clinic.test"
