options = { id: publisher.id, title: publisher.title }
country = publisher.country
options[:country] = country.header if !country.nil?
xml.publisher(options)
