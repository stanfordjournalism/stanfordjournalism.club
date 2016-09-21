# General configuration
require 'hashie'
require 'pathname'
activate :pry
activate :directory_indexes
activate :sprockets
set :site_config, ::Hashie::Mash.new(YAML.load_file("./site_config.yaml"))


# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

# Build-specific configuration
configure :build do
  activate :minify_css
  activate :minify_javascript
end


##
# Page options, layouts, aliases and proxies
###

set :layout, :page_layout
# Per-page layout changes:
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false


set :js_dir, 'assets/javascripts'
set :css_dir, 'assets/stylesheets'
set :images_dir, 'assets/images'

###
# Helpers
###

# require 'helpers/lesson_helpers'#
# require 'helpers/media_helpers'
# require 'helpers/meta_helpers'
# require 'helpers/page_meta_helpers'
# require 'helpers/site_config_helpers'

# helpers LessonHelpers
# helpers MediaHelpers
# helpers MetaHelpers
# helpers PageMetaHelpers
# helpers SiteConfigHelpers



# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end
