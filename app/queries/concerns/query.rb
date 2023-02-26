module Query
  extend ActiveSupport::Concern

  module ClassMethods
    def run(**args)
      new(**args).run
    end
  end

  def initialize
    raise NotImplementedError
  end

  def run
    raise NotImplementedError
  end
end
