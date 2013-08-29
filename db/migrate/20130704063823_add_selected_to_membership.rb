class AddSelectedToMembership < ActiveRecord::Migration
  def change
    add_column :memberships, :selected, :boolean
  end
end
