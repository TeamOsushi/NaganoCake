class AddIsGenreStatusToGenres < ActiveRecord::Migration[5.2]
  def change
    add_column :genres, :is_genre_status, :boolean, default: true, null: false
  end
end
