require 'db_schema'

namespace :db do
  namespace :schema do
    task apply: :environment do
      DbSchema.apply
    end

    task export: :environment do
      DbSchema.export
    end
  end
end
