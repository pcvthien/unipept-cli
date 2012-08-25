# == Schema Information
#
# Table name: posts
#
#  id      :integer(4)      not null, primary key
#  title   :string(100)     not null
#  content :text            default(""), not null
#  date    :date            not null
#

class Post < ActiveRecord::Base
  attr_accessible :content, :date, :title
  
  validates :content, :presence => true
  validates :title,   :presence => true,
                      :length => { :maximum => 100 }
  validates :date,    :presence => true
end