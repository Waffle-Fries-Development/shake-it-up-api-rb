def slugify(some_text)
  some_text.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
end
