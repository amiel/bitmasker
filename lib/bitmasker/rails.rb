module Bitmasker
  class Railtie < ::Rails::Railtie
    initializer 'bitmasker.activerecord_extensions' do |app|
      ActiveRecord::Base.send :extend, Bitmasker::Model
    end
  end
end
