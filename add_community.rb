[["Testing", ["""sarah@company.com", "bob@company.com", "tom@company.com", "dan@company.com", "john@company.com", "sherley@company.com", "mary@company.com","kristen@company.com", "susan@company.com", "jake@company.com", "jessie@company.com"], "Tested community"],
  ["Associate", ["jake@company.com", "jessie@company.com", "sherley@company.com"], "Exclusive community for testing"]].each do |community|
  @users = community[1].map{|u| User.find_by_email(u)}.compact
  Community.new(:name => community[0], :users => @users, :description => community[2], :approved => true).save!
end
