module SimpleFormStrongParameters::ControllerHelper
  def simple_form_strong_params namespace
    hash = params.require(namespace)

    if !session[:simple_form_strong_parameters_storage] || !session[:simple_form_strong_parameters_storage][namespace]
      raise "No such key given in params: #{namespace}"
    end

    hash = permit_from_simple_form(hash, session[:simple_form_strong_parameters_storage][namespace])
    hash.permit!

    return hash
  end

private

  def permit_from_simple_form hash_params, allowed_params
    raise "'hash_params' was not set?" unless hash_params

    # Add allowed attributes.
    allowed_attributes = allowed_params[:attributes].map(&:to_s)

    allowed_params[:subs].each do |key, val|
      # Scan rest of hash recursive.
      permit_key = val[:write_namespace]
      sub_hash_params = hash_params[permit_key]
      raise "'#{permit_key}' did not exist in '#{hash_params}'." unless sub_hash_params

      if sub_hash_params.is_a?(Array) && permit_key.to_s.match(/_attributes\Z/)
        sub_hash_params.each do |sub_hash_attributes|
          permit_from_simple_form(sub_hash_attributes, val)
        end
      else
        permit_from_simple_form(sub_hash_params, val)
      end

      # Add namespace to allowed attributes.
      allowed_attributes << val[:write_namespace].to_s
    end

    # Check if the given keys are allowed.
    check_hash_for_illegal_attributes(hash_params, allowed_attributes)
  end

  def check_hash_for_illegal_attributes hash, allowed_attributes
    hash.each do |key, val|
      if !allowed_attributes.include?(key.to_s)
        raise ActiveModel::ForbiddenAttributesError, "Illegal attribute: '#{key}' for allowed '#{allowed_attributes}'."
      end
    end
  end
end

ActionController::Base.send :include, SimpleFormStrongParameters::ControllerHelper
