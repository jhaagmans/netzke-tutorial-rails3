module Netzke
  module Data     
    WIDGETS = %w{ bosses clerks bosses_custom_columns bosses_with_permissions configurable_clerks }
    
    def self.regenerate_test_data
      number_of_bosses = 50
     
      Boss.delete_all
      bosses_ids = []
      number_of_bosses.times do
        first_name = Faker::Name.first_name
        email = "#{first_name.downcase}@#{Faker::Internet.email.split("@").last}"
        a_boss = Boss.create({
          :first_name => first_name,
          :last_name => Faker::Name.last_name,
          :email => email,
          :salary => (rand(10)+1)*10000
        })
        bosses_ids << a_boss.id
      end
     
     
      Clerk.delete_all
      200.times do
        first_name = Faker::Name.first_name
        email = "#{first_name.downcase}@#{Faker::Internet.email.split("@").last}"
        Clerk.create({
          :boss_id => bosses_ids[rand(number_of_bosses)],
          :first_name => first_name,
          :last_name => Faker::Name.last_name,
          :email => email,
          :salary => (rand(10)+1)*1000,
          :subject_to_lay_off => rand > 0.8,
          :created_at => 15.minutes.ago,
          :updated_at => 15.minutes.ago
        })
      end
    end
     
    def self.reset_configs
      # only delete preferences for the grid demo
      WIDGETS.each do |widget| 
        NetzkePreference.delete_all("widget_name LIKE '#{widget}%'")
        NetzkeFieldList.delete_all(:name => widget)
      end
      redirect_to :action => "demo"
    end
  end
end