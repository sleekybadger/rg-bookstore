# require 'rails_helper'

# RSpec.describe Settings::HistoriesController, type: :controller do
#   let(:user) { FactoryGirl.create :user }

#   before { sign_in user }

#   describe '#in_queue' do
#     context 'user logged' do
#       let(:order) { FactoryGirl.create :order, state: 1 }

#       before { allow(Order).to receive_message_chain(:in_queue, :page) { [order] } }

#       it 'should receive in_queue.page for Order' do
#         expect(Order).to receive_message_chain(:in_queue, :page)
#         get :in_queue
#       end

#       it 'should assigns @orders' do
#         get :in_queue
#         expect(assigns(:orders)).not_to be_nil
#       end
#     end

#     context 'user not logged' do
#       before { sign_out user }

#       it { expect(get :in_queue).to redirect_to(new_user_session_path) }
#     end
#   end

#   describe '#in_delivery' do
#     context 'user logged' do
#       let(:order) { FactoryGirl.create :order, state: 2 }

#       before { allow(Order).to receive_message_chain(:in_delivery, :page) { [order] } }

#       it 'should receive in_delivery.page for Order' do
#         expect(Order).to receive_message_chain(:in_delivery, :page)
#         get :in_delivery
#       end

#       it 'should assigns @orders' do
#         get :in_delivery
#         expect(assigns(:orders)).not_to be_nil
#       end
#     end

#     context 'user not logged' do
#       before { sign_out user }

#       it { expect(get :in_delivery).to redirect_to(new_user_session_path) }
#     end
#   end

#   describe '#delivered' do
#     context 'user logged' do
#       let(:order) { FactoryGirl.create :order, state: 3 }

#       before { allow(Order).to receive_message_chain(:delivered, :page) { [order] } }

#       it 'should receive delivered.page for Order' do
#         expect(Order).to receive_message_chain(:delivered, :page)
#         get :delivered
#       end

#       it 'should assigns @orders' do
#         get :delivered
#         expect(assigns(:orders)).not_to be_nil
#       end
#     end

#     context 'user not logged' do
#       before { sign_out user }

#       it { expect(get :delivered).to redirect_to(new_user_session_path) }
#     end
#   end

#   describe '#canceled' do
#     context 'user logged' do
#       let(:order) { FactoryGirl.create :order, state: 4 }

#       before { allow(Order).to receive_message_chain(:canceled, :page) { [order] } }

#       it 'should receive canceled.page for Order' do
#         expect(Order).to receive_message_chain(:canceled, :page)
#         get :canceled
#       end

#       it 'should assigns @orders' do
#         get :canceled
#         expect(assigns(:orders)).not_to be_nil
#       end
#     end

#     context 'user not logged' do
#       before { sign_out user }

#       it { expect(get :canceled).to redirect_to(new_user_session_path) }
#     end
#   end
# end
