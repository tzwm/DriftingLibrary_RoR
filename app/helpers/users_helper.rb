module UsersHelper
  def gravatar_for(id)
    @current=User.find(id);
    gravatar_id = Digest::MD5::hexdigest(@current.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: @current.name, class: "user_photo")
  end
  def name_for(id)
    @current=User.find(id);
    @current.name
  end
end
