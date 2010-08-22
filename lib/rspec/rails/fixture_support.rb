if defined?(ActiveRecord)
  
  RSpec.configure do |c|
    c.add_setting :use_transactional_fixtures
    c.add_setting :use_transactional_examples, :alias => :use_transactional_fixtures
    c.add_setting :use_instantiated_fixtures
    c.add_setting :global_fixtures
    c.add_setting :fixture_path
  end
  
  module RSpec
    module Rails
      module FixtureSupport
        extend ActiveSupport::Concern

        include RSpec::Rails::SetupAndTeardownAdapter
        include RSpec::Rails::TestUnitAssertionAdapter

        
        if RSpec.configuration.use_transactional_fixtures
          include ActiveRecord::TestFixtures
          
          included do
            self.fixture_path = RSpec.configuration.fixture_path
            self.use_transactional_fixtures = RSpec.configuration.use_transactional_fixtures
            self.use_instantiated_fixtures  = RSpec.configuration.use_instantiated_fixtures
            fixtures RSpec.configuration.global_fixtures if RSpec.configuration.global_fixtures
          end
        end
      end
    end
  end
  
  RSpec.configure {|c| c.include RSpec::Rails::FixtureSupport }
end
