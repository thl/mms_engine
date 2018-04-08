options = { id: publisher.id, title: publisher.title, country_id: publisher.country_id }
country = publisher.country
options[:country] = country.header if !country.nil?
xml.publisher(options)
