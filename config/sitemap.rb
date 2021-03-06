# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://app.lairoflith.com"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
  User.find_each do |user|
    add user_path(user), :lastmod => user.updated_at, :changefreq => 'daily'
    user.characters.each do |character|
      if character.status != 'HIDE'
        add character_path(user, character), :lastmod => character.updated_at, :changefreq => 'daily'
      end
    end
  end

  add characters_path, :changefreq => 'daily'
  add character_help_path, :changefreq => 'weekly'
  add character_walkthrough_path, :changefreq => 'weekly'
  add character_guide_path, :changefreq => 'weekly'

  add codex_path, :changefreq => 'weekly'
  OfficialCharacter.select(:name).distinct.each do |character|
    add codex_character_path(character.name), :changefreq => 'weekly'
  end
end
