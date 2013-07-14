class MusicalEvent < Event
  has_many :artist_relationships, class_name: "ModelRelationship", as: :refer_from, dependent: :destroy
  has_many :artists, through: :artist_relationships, source: :refer_to, source_type: "Performer", conditions: { type: "Artist" }

  scope :artist_initial_in, lambda {|initial|
    initial = Array(initial)
    initial.empty? ? scoped : scoped.joins{artists}.where{artists.id.in(Artist.where{left(aka,1).in(initial)}.select{id})}
  }

  def self.method_missing(id,*args,&block)
    # catch class_methods like MusicalEvent.artist_initial_between_A_and_E
    return __send__("artist_initial_in", ($1..$2).to_a.map(&:upcase)) if id.to_s =~ /artist_initial_between_([A-Za-z])_and_([A-Za-z])/
    super
  end

end
