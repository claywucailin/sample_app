module EventsHelper

  def link_to_breadcrumb name, path, options = {}
    default_options = { :class => 'sub_menu' }
    link_to name, path, options.merge(default_options)
  end

  def breadcrumb_seperator
    content_tag(:span, image_tag("arraw-right-white.png"))
  end

end
