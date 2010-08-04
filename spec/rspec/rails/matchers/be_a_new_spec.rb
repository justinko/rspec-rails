require "spec_helper"

describe "be_a_new matcher" do
  context "new record" do
    let(:record) do
      Class.new do
        def new_record?; true; end
      end.new
    end
    context "right class" do
      it "passes" do
        record.should be_a_new(record.class)
      end
    end
    context "wrong class" do
      it "fails" do
        record.should_not be_a_new(String)
      end
    end
  end
  
  context "existing record" do
    let(:record) do
      Class.new do
        def new_record?; false; end
      end.new
    end
    context "right class" do
      it "fails" do
        record.should_not be_a_new(record.class)
      end
    end
    context "wrong class" do
      it "fails" do
        record.should_not be_a_new(String)
      end
    end
  end
  
  describe "#with" do
    let(:record) do
      class WidgetFoo < ActiveRecord::Base
        establish_connection :adapter => 'sqlite3',
                             :database => ':memory:'

        connection.execute <<-eosql
          CREATE TABLE widget_foos (
            foo_id integer,
            number integer
          )
        eosql
      end; WidgetFoo.new(:foo_id => 1, :number => 1)
    end
        
    context "all attributes same" do
      it "passes" do
        record.should be_a_new(record.class).with(:foo_id => 1, :number => 1)
      end
    end
    
    context "one attribute as same" do
      it "passes" do
        record.should be_a_new(record.class).with(:foo_id => 1)
      end
    end
    
    context "no attributes as same" do
      it "fails" do
        record.should_not be_a_new(record.class).with(:zoo => 'zoo', :car => 'car')
      end
    end
    
    context "one attribute value not the same" do
      it "fails" do
        record.should_not be_a_new(record.class).with(:foo_id => 2)
      end
    end
  end
end
