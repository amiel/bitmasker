

module HasBitmaskAttributes
  class Engine < ::Rails::Engine
    config.after_initialize do
      ActiveRecord::Base.send :extend, HasBitmaskAttributes
    end
  end
end
