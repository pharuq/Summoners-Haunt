class AddPicturesToDiaries < ActiveRecord::Migration[5.1]
  def change
    add_column :diaries, :pictures, :json
  end
end
