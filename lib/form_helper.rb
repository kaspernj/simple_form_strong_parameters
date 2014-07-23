module SimpleFormStrongParameters::FormHelper
  def simple_form_strong_parameters_for(*args)
    sfsp = SimpleFormStrongParameters::FormProxy.new(object: args[0], first: true)

    session[:simple_form_strong_parameters_storage] ||= {}

    if session[:simple_form_strong_parameters_storage][sfsp.namespace]
      session_var = session[:simple_form_strong_parameters_storage][sfsp.namespace]
    else
      session_var = {}
      session[:simple_form_strong_parameters_storage][sfsp.namespace] = session_var
    end

    simple_form_for *args do |f|
      sfsp.session_var = session_var
      sfsp.simple_form = f
      yield sfsp
    end
  end
end

ActionView::Base.send :include, SimpleFormStrongParameters::FormHelper
