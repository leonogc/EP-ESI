 require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/markers", type: :request do
  
  # Marker. As you add validations to Marker, be sure to
  # adjust the attributes here as well.
  describe "GET /markers/:id" do
    before :each do
      @u = User.new(name: "Rog", username:"roger",email:"roger@mail.com",birth_date: Date.parse("10/10/1000"), password:"holyhowdy")
      @u.save
      @m = Marker.new(disaster_type: 'incendio', latitude: 26.1232, longitude: -23.3323, user_id: @u.id, verified: false, user_type: 0)
      @m.save
      allow_any_instance_of(MarkersController).to receive(:session).and_return({user_id: @u.id})
    end
    it "shows marker info" do
      get "/markers/" + @m.id.to_s
      expect(response).to have_http_status(:success)
    end
  end 

  describe "PATCH /markers/:id" do
    before :each do
      @u = User.new(name: "Rog", username:"roger",email:"roger@mail.com",birth_date: Date.parse("10/10/1000"), password:"holyhowdy")
      @u.save
      @m = Marker.new(disaster_type: 'incendio', latitude: 26.1232, longitude: -23.3323, user_id: @u.id, verified: false, user_type: 0)
      @m.save

      allow_any_instance_of(MarkersController).to receive(:session).and_return({user_id: @u.id})
    end
    it "update the marker" do
      expect(Marker.order("id").last.latitude).not_to eq(20)
      patch '/markers/' + @m.id.to_s, params: { id: @m.id , marker: { latitude: '20' } }
      expect(response).to redirect_to '/markers/' + @m.id.to_s
      expect(Marker.order("id").last.latitude).to eq(20)
    end
  end

  describe "GET /markers/:id/up" do
    before :each do
      @u = User.new(name: "Rog", username:"roger",email:"roger@mail.com",birth_date: Date.parse("10/10/1000"), password:"holyhowdy")
      @u.save
      @u2 = User.new(name: "Aleatory", username:"ale",email:"ale@mail.com",birth_date: Date.parse("10/10/1000"), password:"holyhowdy")
      @u2.save
      @m = Marker.new(disaster_type: 'incendio', latitude: 26.1232, longitude: -23.3323, user_id: (User.order("id").last).id, verified: false, user_type: 0)
      @m.save

      allow(Marker).to receive(:find).with("1").and_return(@m)
      allow_any_instance_of(MarkersController).to receive(:current_user).and_return(@u)
    end
    it "upvotes the marker" do
      get '/markers/1/up'
      expect( Voter.find_by(marker_id: @m.id) ).not_to be_nil 
      expect( Voter.find_by(marker_id: @m.id).upvote? ).to be_truthy
    end
    it "error - error when upvotes the  marker" do
      allow(Voter).to receive(:new).and_return(double('new', :save => false))
      get '/markers/1/up'
      expect( Voter.find_by(marker_id: @m.id) ).to be_nil 
    end

    context "already upvoted" do
      before :each do
        get '/markers/1/up'
        expect( Voter.find_by(marker_id: @m.id) ).not_to be_nil
      end
      it "removes the upvote" do
        get '/markers/1/up'
        expect( Voter.find_by(marker_id: @m.id) ).to be_nil
      end
    end

    context "already downvoted" do
      before :each do
        get '/markers/1/down'
        expect( Voter.find_by(marker_id: @m.id).downvote? ).to be_truthy
      end
      it "changes the downvote to a upvote" do
        get '/markers/1/up'
        expect( Voter.find_by(marker_id: @m.id).upvote? ).to be_truthy
      end
    end
  end

  describe "GET /markers/:id/down" do
    before :each do
      @u = User.new(name: "Rog", username:"roger",email:"roger@mail.com",birth_date: Date.parse("10/10/1000"), password:"holyhowdy")
      @u.save
      @u2 = User.new(name: "Aleatory", username:"ale",email:"ale@mail.com",birth_date: Date.parse("10/10/1000"), password:"holyhowdy")
      @u2.save
      @m = Marker.new(disaster_type: 'incendio', latitude: 26.1232, longitude: -23.3323, user_id: (User.order("id").last).id, verified: false, user_type: 0)
      @m.save

      allow(Marker).to receive(:find).with("1").and_return(@m)
      allow_any_instance_of(MarkersController).to receive(:current_user).and_return(@u)
    end
    it "downvotes the marker" do
      get '/markers/1/down'
      expect( Voter.find_by(marker_id: @m.id) ).not_to be_nil 
      expect( Voter.find_by(marker_id: @m.id).downvote? ).to be_truthy
    end
    it "error - error when downvotes the  marker" do
      allow(Voter).to receive(:new).and_return(double('new', :save => false))
      get '/markers/1/down'
      expect( Voter.find_by(marker_id: @m.id) ).to be_nil 
    end

    context "already upvoted" do
      before :each do
        get '/markers/1/up'
        expect( Voter.find_by(marker_id: @m.id).upvote? ).to be_truthy
      end
      it "changes the upvote to a downvote" do
        get '/markers/1/down'
        expect( Voter.find_by(marker_id: @m.id).downvote? ).to be_truthy
      end
    end

    context "already downvoted" do
      before :each do
        get '/markers/1/down'
        expect( Voter.find_by(marker_id: @m.id) ).not_to be_nil
      end
      it "removes the downvote" do
        get '/markers/1/down'
        expect( Voter.find_by(marker_id: @m.id) ).to be_nil
      end
    end
  end

  describe "GET /markers/:id/verify" do
    before :each do
      @u = User.new(name: "Rog", username:"roger",email:"roger@mail.com",birth_date: Date.parse("10/10/1000"), password:"holyhowdy")
      @u.save
      @m = Marker.new(disaster_type: 'incendio', latitude: 26.1232, longitude: -23.3323, user_id: (User.order("id").last).id, verified: false, user_type: 0)
      @m.save

      allow(Marker).to receive(:find).with("1").and_return(@m)
      allow_any_instance_of(MarkersController).to receive(:current_user).and_return(@u)
    end
    it "verify the marker" do
      allow_any_instance_of(MarkersController).to receive(:authority_logged_in?).and_return(true)
      get '/markers/1/verify'
      expect( Marker.find_by(id: @m.id) ).not_to be_nil 
      expect( Marker.find_by(id: @m.id).verified? ).to be_truthy
    end
    it "error - error verifing the marker" do
      allow_any_instance_of(MarkersController).to receive(:authority_logged_in?).and_return(true)
      allow(@m).to receive(:update).and_return(false)
      get '/markers/1/verify'
      expect( Marker.find_by(id: @m.id) ).not_to be_nil 
      expect( Marker.find_by(id: @m.id).verified? ).to be_falsey
    end
  end
  
end
