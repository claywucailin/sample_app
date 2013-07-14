class SportEvent < Event
  # attr_accessible :title, :body
  has_many :sport_team_relationships, class_name: "ModelRelationship", as: :refer_from, dependent: :destroy
  has_many :sport_teams, through: :sport_team_relationships, source: :refer_to, source_type: "Performer", conditions: { type: "SportTeam" }

  scope :team_initial_in, lambda {|initial|
    initial = Array(initial)
    initial.empty? ? scoped : scoped.joins{sport_teams}.where{sport_teams.id.in(SportTeam.where{left(aka,1).in(initial)}.select{id})}
  }

  def self.method_missing(id,*args,&block)
    # catch class_methods like SportEvent.team_initial_between_A_and_E
    return __send__("team_initial_in", ($1..$2).to_a.map(&:upcase)) if id.to_s =~ /team_initial_between_([A-Za-z])_and_([A-Za-z])/
    super
  end

end
