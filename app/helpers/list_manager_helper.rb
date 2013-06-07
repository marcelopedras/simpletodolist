module ListManagerHelper
 def sanitize_html(partial, locals={})
   escape_javascript("#{render :partial => partial, :locals => locals}").html_safe
 end


  def image_button(text, image, options={})
     #id ||= options[:id]
     #class_css ||= options[:class]
     #alt ||= options[:alt]
     options.delete(:alt)
      ("<button #{options.map{|x,y| "#{x}='#{y}'"}.join(' ')}>#{image_tag("/assets/famfamfam/#{image}.png", :alt=>options[:alt], :style=>'padding-top: 1px;')}<span style='float: right; margin-top: 2px; font-size: 13px'>#{text}</span></button>").html_safe
  end

  def date_to_s(time)
    time.strftime('%d/%m/%Y %H:%M')
  end
end
