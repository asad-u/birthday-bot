class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.update_or_create(args, attributes)
    obj = find_or_create_by(args)
    obj.update(attributes)
    obj
  end
end
