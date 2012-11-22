# encoding: UTF-8

#This is not a very general script
#I ran it from the parent directory  of text that is now in the original_files directory

#it just throws out any xml references, replaces indesign xml classes with html5 ones
#the goal is to have html files in the end which then can be edited with your favourite IDE, or Open/LibreOffice

dir_list = Dir.entries "text"
dir_list.reject! {|entry| entry !~ /\.xml/}

def convertFile(name)
  root_expr = %r{<Root.*?>}
  end_root_expr = %r{</Root>}
  body_expr = %r{Body}
  class_expr = %r{aid:pstyle|aid:cstyle}
  xml_expr = %r{<\?xml}

  ind_file = File.open("text/"+name)
  file_array = ind_file.readlines()
  ind_file.close

  file_array.reject! {|line| line =~ xml_expr}
  file_array.map! { |line|

    line.gsub!(root_expr,"") if line =~ root_expr
    line.gsub!(end_root_expr,"") if line =~ end_root_expr
    line.gsub!(body_expr,"body") if line =~body_expr
    line.gsub!(class_expr,"class") if line =~class_expr
    line
  }

  file_array.unshift "<html><head><meta http-equiv=\"Content-Type\" content=\"text/html\" charset=\"utf-8\"></head><body>"
  file_array.push "</body></html>"

  htmL_name = name.gsub ".xml",".html"
  html_file = File.new  "text/"+htmL_name, "w"
  file_array.each {|line| html_file.puts line}
  html_file.close
end

dir_list.each {|file| convertFile file}