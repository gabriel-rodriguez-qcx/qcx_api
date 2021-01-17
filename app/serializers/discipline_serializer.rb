class DisciplineSerializer < ApplicationSerializer
  attributes :name, :times_accessed

  type :discipline
end
