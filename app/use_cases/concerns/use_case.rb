module UseCase
  extend ActiveSupport::Concern
  include ActiveModel::Model

  module ClassMethods
    def run(**args)
      new(**args).tap { |use_case| use_case.valid? && use_case.run }
    end
  end

  def run
    raise NotImplementedError
  end

  def initialize
    raise NotImplementedError
  end

  def success?
    errors.none?
  end

  def raise_rollback
    raise ActiveRecord::Rollback
  end
end
