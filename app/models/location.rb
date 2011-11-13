module Location
  # scope :by_name, self.order('name ASC')

  def children
    raise NoMethodError.new(%[You should over-ride #children.])
  end

  # Ensures that the walk is a proper descent; in return for higher time
  # complexity.
  def walk &blk
    self.children.each do |child|
      yield child
    end
    self.children.each do |child|
      child.walk &blk
    end
  end
end
