require 'spec_helper'

describe Admin::CategoriesController do
  render_views

  before(:each) do
    Factory(:blog)
    #TODO Delete after removing fixtures
    Profile.delete_all
    henri = Factory(:user, :login => 'henri', :profile => Factory(:profile_admin, :label => Profile::ADMIN))
    request.session = { :user => henri.id }
  end

  it "test_index" do
    get :index
    assert_response :redirect, :action => 'index'
  end

  describe "test_edit" do
    before(:each) do
      get :edit, :id => Factory(:category).id
    end

    it 'should render template new' do
      assert_template 'new'
      assert_tag :tag => "table",
        :attributes => { :id => "category_container" }
    end

    it 'should have valid category' do
      assigns(:category).should_not be_nil
      assert assigns(:category).valid?
      assigns(:categories).should_not be_nil
    end
  end

  it "test_update" do
    post :edit, :id => Factory(:category).id
    assert_response :redirect, :action => 'index'
  end

  describe "test_destroy with GET" do
    before(:each) do
      test_id = Factory(:category).id
      assert_not_nil Category.find(test_id)
      get :destroy, :id => test_id
    end

    it 'should render destroy template' do
      assert_response :success
      assert_template 'destroy'      
    end
  end

  it "test_destroy with POST" do
    test_id = Factory(:category).id
    assert_not_nil Category.find(test_id)
    get :destroy, :id => test_id

    post :destroy, :id => test_id
    assert_response :redirect, :action => 'index'

    assert_raise(ActiveRecord::RecordNotFound) { Category.find(test_id) }
  end
  
  describe "test editing of categories with nil id" do
    it 'passing nil id' do
      category = Factory(:category, :id => 12, :name => "Category123", :keywords => "Keyword123", :permalink => 'Permalink123', :description => 'Description123')
      get :edit, :id => nil
      Category.should_receive(:find).with(:all).and_return([])
      Category.should_receive(:new).and_return(category)
      category.should_receive(:save!).and_return(true)
      post :edit, :category => {:name => 'Category123', :keywords => 'Keyword123', :permalink => 'Permalink123', :description => 'Description123'}
      expect(flash[:notice]).to eq("Category was successfully saved.")
      assert_response :redirect
      assert_redirected_to :action => 'new'
    end
  end
  describe "test editing of categories" do
    before(:each) do
      get :edit, :id => Factory(:category).id
    end
    
    it 'passing some valid id' do
      post :edit, :category => {:name => 'Category test', :keywords => 'Keyword test', :permalink => 'Permalink test', :description => 'Description test'}
      assert_response :redirect
      assert_redirected_to :action => 'new'
      expect(response).to redirect_to('/admin/categories/new')
      expect(flash[:notice]).to eq("Category was successfully saved.")
    end
  end
  
end