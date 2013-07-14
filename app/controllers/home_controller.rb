class HomeController < ApplicationController
  def index
    @root = Category.find_by_name('root')
    @sport = Category.find_by_name('sport')
    @concert = Category.find_by_name('concert')
  end
end
