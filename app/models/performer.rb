class Performer < ActiveRecord::Base
  attr_accessible :aka, :description, :name, :profiles, :type

  has_many :event_relationships, class_name: "ModelRelationship", as: :refer_to, dependent: :destroy
  has_many :events, through: :event_relationships, source: :refer_from, source_type: "Event"

  scope :aka_initial, lambda {|initial|
    initial = Array(initial).map(&:first).map(&:upcase)
    initial.empty? ? scoped : scoped.where{left(aka,1).in(initial)}
  }

  scope :search, lambda {|params|
    performers = scoped
    if [params[:aka_initial_start],params[:aka_initial_end]].reject(&:nil?).size == 2
      alpha_serial = (params[:aka_initial_start].first..params[:aka_initial_end].first).to_a
      performers   = performers.aka_initial(alpha_serial)
    end
    performers = performers.where{type == params[:type]} if params[:type].present?

    performers
  }

end