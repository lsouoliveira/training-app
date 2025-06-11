class FormBuilder < ActionView::Helpers::FormBuilder
  %w[text_field email_field password_field date_field].each do |field_type|
    define_method(field_type) do |method, options = {}|
      options[:class] = "form-control #{options[:class]}"
      add_error_classes(method, options)
      super(method, options)
    end
  end

  def select(method, choices = nil, options = {}, html_options = {}, &block)
    html_options[:class] = "form-control #{html_options[:class]}"
    add_error_classes(method, html_options)
    super(method, choices, options, html_options, &block)
  end

  def submit(value, options)
    options[:class] = "btn btn-primary #{options[:class]}"
    super(value, options)
  end

  private

  def errors_for?(name)
    return false unless @object.respond_to?(:errors)

    @object.errors[name].any?
  end

  def add_error_classes(name, options)
    return unless errors_for?(name)
    options[:class] = "is-invalid #{options[:class]}"
  end
end
