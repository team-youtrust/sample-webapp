class Notification::ApplicationNotification
  def self.run(**args)
    new(**args).tap(&:run)
  end

  def run
    raise NotImplementedError
  end

  private

  def initialize(**args)
    raise NotImplementedError
  end
end
