# SimpleFormStrongParameters

By inspecting which `input`'s you call on `simple_form_for`, a session variable is generated in order to automatically do strong parameters for the next posted content, making it even more simple and easy to write controllers, because you can leave out the maintenence of `*_params`-methods completely!

Simply call `simple_form_strong_parameters_for` instead of `simple_form_for` and `simple_form_strong_parameters(:model_name)` instead of `model_params`.

This project uses MIT-LICENSE.

# Install

Add to Gemfile:
```ruby
gem 'simple_form_strong_parameters'
```

# Usage

In your form use `simple_form_strong_parameters_for` instead of `simple_form_for` (but use it as normally):
```erb
<%= simple_form_strong_parameters_for @user do |f| %>
 <%= f.input :name %>
<% end %>
```

In your controller do like this:
```ruby
class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(simple_form_strong_parameters(:user))
    @user.save!
    redirect_to users_ptah(@user)
  end
end
```

If a field that hasn't been defined as an input is present in the params, then a `ActiveModel::ForbiddenAttributesError` error will be raised as normally.

You no longer have to maintain a `user_params`-method every time you change your form!
