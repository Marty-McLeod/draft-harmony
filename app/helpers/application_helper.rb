require "commonmarker"

module ApplicationHelper
  # CommmonMarker helper to handle Markdown text
  def markdown(text)
    # NOTE: "CommonMarker" syntax was wrong; correct class name to use is "Classmarker." Previous spelling cause
    # error/failure
    # Options below are default example ones.
    Commonmarker.to_html(text.to_s, options: { parse: { smart: true }, render: { hardbreaks: true } }).html_safe
  end

end
