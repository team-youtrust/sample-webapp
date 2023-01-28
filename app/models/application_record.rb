class ApplicationRecord < ActiveRecord::Base
  include IdEncryptable

  self.abstract_class = true
end
