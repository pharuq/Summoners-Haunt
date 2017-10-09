class AddSharedWithToDiary < ActiveRecord::Migration[5.1]
  def change
    add_column :diaries, :shared_with, :integer, default: 0
  end
end
