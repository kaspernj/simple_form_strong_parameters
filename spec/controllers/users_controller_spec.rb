require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:valid_attributes) {
    {name: "Kasper", age: 29, roles_attributes: [{role: "Trala"}]}
  }

  let(:invalid_attributes) {
    {name: "", age: 29, roles_attributes: [{role: "Trala"}]}
  }

  let(:forbidden_attributes) {
    {name: "Kasper", age: 29, roles_attributes: [{role: "Trala", illegal_value: "Test"}]}
  }

  let(:new_attributes) { valid_attributes }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # UsersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  render_views

  describe "GET index" do
    it "assigns all users as @users" do
      User.find_each do |user|
        user.destroy!
      end

      user = User.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:users)).to eq([user])
    end
  end

  describe "GET show" do
    it "assigns the requested user as @user" do
      user = User.create! valid_attributes
      get :show, {:id => user.to_param}, valid_session
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "GET new" do
    it "assigns a new user as @user" do
      get :new, {}, valid_session
      expect(assigns(:user)).to be_a_new(User)
      session[:simple_form_strong_parameters_storage][users_path][:user].should eq(:attributes=>[:name, :age], :write_namespace=>:user, :subs=>{:role=>{:attributes=>[:role], :write_namespace=>:roles_attributes, :subs=>{}}})
    end
  end

  describe "GET edit" do
    it "assigns the requested user as @user" do
      user = User.create! valid_attributes
      get :edit, {:id => user.to_param}, valid_session
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "POST create" do
    before do
      session[:simple_form_strong_parameters_storage] = {users_path => {
        user: {
          :attributes => [:name, :age],
          :write_namespace => :user,
          :subs => {
            :role => {
              :write_namespace => :roles_attributes,
              :subs => {},
              :attributes => [:role]
            }
          }
        }
      }}
    end

    describe "with valid params" do
      it "creates a new User" do
        expect {
          post :create, {user: valid_attributes}, valid_session
          assigns(:user).errors.to_a.should eq []
        }.to change(User, :count).by(1)

        User.last.roles.count.should eq 1
        User.last.roles.first.role.should eq("Trala")
      end

      it "assigns a newly created user as @user" do
        post :create, {:user => valid_attributes}, valid_session
        expect(assigns(:user)).to be_a(User)
        expect(assigns(:user)).to be_persisted
      end

      it "redirects to the created user" do
        post :create, {:user => valid_attributes}, valid_session
        expect(response).to redirect_to(User.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved user as @user" do
        post :create, {:user => invalid_attributes}, valid_session
        expect(assigns(:user)).to be_a_new(User)
      end

      it "re-renders the 'new' template" do
        post :create, {:user => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end

    describe "with forbidden params" do
      it "raises forbidden attributes error" do
        expect {
          post :create, {:user => forbidden_attributes}, valid_session
        }.to raise_error(ActiveModel::ForbiddenAttributesError)
      end
    end
  end

  describe "PUT update" do
    before do
      User.all.map(&:destroy!)
      session[:simple_form_strong_parameters_storage] = {user_path(169) => {
        user: {
          :attributes => [:name, :age],
          :write_namespace => :user,
          :subs => {
            :role => {
              :write_namespace => :roles_attributes,
              :subs => {},
              :attributes => [:role]
            }
          }
        }
      }}
    end

    describe "with valid params" do
      it "updates the requested user" do
        user = User.create! valid_attributes.merge(id: 169)
        put :update, {:id => user.to_param, :user => new_attributes}, valid_session
        user.reload
        user.roles.count.should eq 2
        user.name.should eq "Kasper"
        user.age.should eq 29
      end

      it "assigns the requested user as @user" do
        user = User.create! valid_attributes.merge(id: 169)
        put :update, {:id => user.to_param, :user => valid_attributes}, valid_session
        expect(assigns(:user)).to eq(user)
      end

      it "redirects to the user" do
        user = User.create! valid_attributes.merge(id: 169)
        put :update, {:id => user.to_param, :user => valid_attributes}, valid_session
        expect(response).to redirect_to(user)
      end
    end

    describe "with invalid params" do
      it "assigns the user as @user" do
        user = User.create! valid_attributes.merge(id: 169)
        put :update, {:id => user.to_param, :user => invalid_attributes}, valid_session
        expect(assigns(:user)).to eq(user)
      end

      it "re-renders the 'edit' template" do
        user = User.create! valid_attributes.merge(id: 169)
        put :update, {:id => user.to_param, :user => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested user" do
      user = User.create! valid_attributes
      expect {
        delete :destroy, {:id => user.to_param}, valid_session
      }.to change(User, :count).by(-1)
    end

    it "redirects to the users list" do
      user = User.create! valid_attributes
      delete :destroy, {:id => user.to_param}, valid_session
      expect(response).to redirect_to(users_url)
    end
  end

  describe "GET new_recursive" do
    it "#new_recursive" do
      get :new_recursive
      response.should be_success
      controller.session[:simple_form_strong_parameters_storage]["/users/post_recursive"][:user].should eq({
        :attributes => [],
        :write_namespace => :user,
        :subs => {
          :test => {
            :attributes => [:test_value],
            :write_namespace => :test,
            :subs => {
              :another_test => {
                :attributes => [:another_test_value],
                :write_namespace => :another_test,
                :subs => {}
              }
            }
          }
        }
      })
    end
  end

  describe "POST post_redursive" do
    it "works with allowed attributes" do
      user_params = {
        :attributes => [],
        :write_namespace => "user",
        :subs => {
          :test => {
            :attributes => [:test_value],
            :write_namespace => "test",
            :subs => {
              :another_test => {
                :attributes => [:another_test_value],
                :write_namespace => "another_test",
                :subs => {}
              }
            }
          }
        }
      }

      session[:simple_form_strong_parameters_storage] = {"/users/post_recursive" => {:user => user_params}}
      post :post_recursive, {
        :user => {
          :test => {
            :test_value => "test_value_value",
            :another_test => {
              :another_test_value => "another_test_value_value"
            }
          }
        }
      }
      response.should be_success
    end

    it "doesnt work with illegal attributes" do
      user_params = {
        :attributes => [],
        :write_namespace => "user",
        :subs => {
          :test => {
            :attributes => [:test_value],
            :write_namespace => "test",
            :subs => {
              :another_test => {
                :attributes => [:another_test_value],
                :write_namespace => "another_test",
                :subs => {}
              }
            }
          }
        }
      }

      session[:simple_form_strong_parameters_storage] = {:user => user_params}

      expect {
        post :post_recursive, {
          :user => {
            :test => {
              :test_value => "test_value_value",
              :another_test => {
                :another_test_value => "another_test_value_value",
                :illegal => "test"
              }
            }
          }
        }
      }.to raise_error(ActiveModel::ForbiddenAttributesError)

      response.should be_success
    end
  end
end
