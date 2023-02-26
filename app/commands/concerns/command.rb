module Command
  extend ActiveSupport::Concern
  include ActiveModel::Model

  module ClassMethods
    def run(**args)
      new(**args).tap { |command| command.valid? && command.run }
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
end
