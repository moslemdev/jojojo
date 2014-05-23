json.array!(@surahs) do |surah|
  json.extract! surah, :id, :name, :memory
  json.url surah_url(surah, format: :json)
end
