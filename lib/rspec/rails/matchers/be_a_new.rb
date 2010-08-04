RSpec::Matchers.define :be_a_new do |model_klass|
  def with(attributes)
    unless attributes.is_a?(Hash)
      raise ArgumentError.new("#{attributes.inspect} must be a Hash")
    end
    @attributes = attributes.stringify_keys.to_a
    self
  end
  
  match do |actual|
    is_model_klass_new_record = model_klass === actual && actual.new_record?
    
    if @attributes
      @attributes.all? do |key, value|
        actual.attributes[key].eql?(value)
      end and is_model_klass_new_record
    else
      is_model_klass_new_record
    end
  end
end
