class DbSchema
  def self.apply
    new.apply
  end

  def self.export
    new.export
  end

  def apply
    success = ridgepole('--apply', "--file #{@schema_file}")

    if Rails.env.development? && success
      ridgepole('--export', "--output #{@schema_file}")
      annotate_models
    end
  end

  def export
    ridgepole('--export', "--output #{@schema_file}")
  end

  private

  def initialize
    @schema_file = Rails.root.join('db', 'Schemafile')
    @config_file = Rails.root.join('config', 'database.yml')
  end

  def ridgepole(*options)
    command = ['bundle', 'exec', 'ridgepole', "--config #{@config_file}", "--env #{Rails.env}"]
    system (command + options).join(' ')
  end

  def annotate_models
    Rake::Task['annotate_models'].invoke
  end
end
