require 'tempfile'

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def logged_in?
    cookies[:ade_cookies] != nil
  end
  
  def ade_save(ade_reader)
    ade_cookies = nil
    Tempfile.open('cookie') do |f|
      ade_reader.cookie_jar_dump f
      f.rewind
      ade_cookies = f.read
    end
    cookies[:ade_cookies] = ade_cookies
    cookies[:ade_reader_branch_level] = ade_reader.branch_level
    cookies[:ade_reader_category_id] = ade_reader.category_id
    cookies[:ade_reader_branch_id] = ade_reader.branch_id
    cookies[:ade_reader_leaf] = ade_reader.leaf?
  end
  
  def ade_load
    ade_reader = Ade::InteractiveReader.new Ade::Schools::Ujf.new
    if cookies[:ade_cookies]
      Tempfile.open('cookie') do |f|
        f << cookies[:ade_cookies]
        f.rewind
        ade_reader.cookie_jar_load f
      end
      ade_reader.branch_level = cookies[:ade_reader_branch_level].to_i
      ade_reader.set_category_id cookies[:ade_reader_category_id]
      ade_reader.set_branch_id cookies[:ade_reader_branch_id]
      ade_reader.leaf = cookies[:ade_reader_leaf] == "true"
      puts
      puts "cookies[:ade_reader_leaf] = #{cookies[:ade_reader_leaf]} (#{cookies[:ade_reader_leaf].class})"
      puts
    end
    ade_reader
  end
  
  def ade_clear
    [
      :ade_cookies,
      :ade_reader_branch_level,
      :ade_reader_category_id,
      :ade_reader_branch_id,
      :ade_reader_lea
    ].each do |cookie|
      cookies.delete cookie
    end
  end
  
end
