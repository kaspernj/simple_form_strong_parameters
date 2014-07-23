require "string-cases"

class SimpleFormStrongParameters::FormProxy
  attr_accessor :simple_form

  def initialize args
    @args = args
    @object = args[:object]
  end

  def session_var=(session_var)
    @session_var = session_var
    @session_var[:attributes] = []
    @session_var[:write_namespace] = write_namespace
    @session_var[:subs] = {}
  end

  def method_missing name, *args, &blk
    if name == :input
      attribute_name = args[0]
      register_parameter(attribute_name)
    end

    @simple_form.__send__(name, *args, &blk)
  end

  def simple_fields_for *args
    fields_namespace = args[0]
    fields_session_var = {}

    @simple_form.simple_fields_for *args do |fields_simple_form|
      proxy = SimpleFormStrongParameters::FormProxy.new(object: fields_namespace)
      proxy.simple_form = fields_simple_form
      proxy.session_var = fields_session_var

      begin
        yield proxy
      ensure
        @session_var[:subs][proxy.namespace] = fields_session_var
      end
    end
  end

  def namespace
    if @object.is_a? ActiveRecord::Base
      return StringCases.camel_to_snake(@object.class.name).to_sym
    elsif @object.is_a? Symbol
      return @object
    else
      raise "Doesn't know how to handle: #{@object.class.name}"
    end
  end

  def write_namespace
    if @object.is_a? ActiveRecord::Base
      if @args[:first]
        return StringCases.camel_to_snake(@object.class.name).to_sym
      end

      class_name = StringCases.camel_to_snake(@object.class.name).pluralize
      namespace = "#{class_name}_attributes".to_sym
      return namespace
    elsif @object.is_a? Symbol
      return @object
    else
      raise "Doesn't know how to handle: #{@object.class.name}"
    end
  end

private

  def register_parameter name
    @session_var[:attributes] << name
  end
end
