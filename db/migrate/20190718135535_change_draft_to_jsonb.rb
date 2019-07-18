class ChangeDraftToJsonb < ActiveRecord::Migration[5.2]
  def up
    %i[static_page article subtle_system_node].each do |table|
      change_column "#{table}_translations", :draft, :jsonb
    end
  end

  def down
    %i[static_page article subtle_system_node].each do |table|
      change_column "#{table}_translations", :draft, :json
    end
  end
end
