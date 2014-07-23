module SimpleFormStrongParameters::FormHelper
  def simple_form_strong_parameters_for(*args)
    sfsp = SimpleFormStrongParameters::FormProxy.new(object: args[0], first: true)
    storage = session[:simple_form_strong_parameters_storage] ||= {}

    simple_form_for *args do |f|
      url = f.options[:url]

      url_storage = storage[url] ||= {}
      ns_storage = url_storage[sfsp.namespace] ||= {}

      sfsp.simple_form = f
      sfsp.session_var = ns_storage

      yield sfsp
    end
  end
end

ActionView::Base.send :include, SimpleFormStrongParameters::FormHelper
