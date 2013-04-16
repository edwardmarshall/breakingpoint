# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register_alias "text/html", :iphone

Rack::Mime::MIME_TYPES['.eot'] = 'application/vnd.ms-fontobject'
Rack::Mime::MIME_TYPES['.ttf'] = 'application/x-font-ttf'
Rack::Mime::MIME_TYPES['.woff'] = 'application/font-woff'