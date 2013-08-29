class CreateProviderAuthentications < ActiveRecord::Migration
  def self.up
    create_table :provider_authentications do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid

      t.timestamps
    end
  end

  def self.down
    drop_table :provider_authentications
  end
end