# Mixin which serializes all instance variables to a hash. 
# Works with nested objects if they also include the mixin.
module Serializable
  def serialize
    hash = {}

    vars_to_include.each do |var|
      value = self.instance_variable_get(var)

      # Chop off "@" at the beginning and convert variable name to symbol
      var_as_symbol = var.to_s[1..-1].to_sym
      hash[var_as_symbol] = value.respond_to?(:serialize) ? value.serialize : value
    end

    hash
  end

  private

  def vars_to_include
    if self.respond_to?(:vars_to_serialize)
      # Serialize only variables specified in vars_to_serialize method
      return self.instance_variables.select do |var|
        self.vars_to_serialize.collect { |v| v.to_s }.include?(var.to_s[1..-1])
      end
    end

    # Serialize all variables
    self.instance_variables
  end
end