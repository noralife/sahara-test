require 'spec_helper'

describe 'SaharaCustomerAPI' do
  before do
    @admin_token = token('admin@ho.ge', 'admin')
    @user_token = token('hoge1@ho.ge', 'hoge1')
  end
  context 'without new customer' do
    it 'shows customer list' do
      response = get SAHARA_CMS_URL, '/api/v1/customers', 'SAHARA-TOKEN' => @admin_token
      expect(response.size).to be > 3
    end
  end

  context 'with new customer' do
    before do
      id = rand(10000) + 1
      @admin_token  = token('admin@ho.ge', 'admin')
      @new_customer = post(
        SAHARA_CMS_URL,
        '/api/v1/customers',
        { 'email' => "api#{id}@ho.ge", name: 'api', password: 'api', token: 'api', role: 'user'},
        'SAHARA-TOKEN' => @admin_token
      )
      @new_customer_token = post(
        SAHARA_CMS_URL,
        '/api/v1/login',
	{email:"api#{id}@ho.ge", password: 'api'}
      )["token"]
    end

    after do
      unless @new_customer['customer']['id'].nil?
        delete(
	  SAHARA_CMS_URL,
          '/api/v1/customers/' + @new_customer['customer']['id'].to_s,
          '',
          'SAHARA-TOKEN' => @new_customer_token
        )
      end
    end

    it 'adds new customer' do
      expect(@new_customer['status']).to eq('success')
      expect(@new_customer['customer']['id']).to be > 0
    end

    it 'shows customer detail' do
      response = get(
        SAHARA_CMS_URL,
        '/api/v1/customers/' + @new_customer['customer']['id'].to_s,
        'SAHARA-TOKEN' => @new_customer_token
      )
      expect(response['id']).to eq(@new_customer['customer']['id'])
      expect(response['email']).to eq(@new_customer['customer']['email'])
      expect(response['password']).to eq(@new_customer['customer']['password'])
    end

    it 'updates customer' do
      response = put(
        SAHARA_CMS_URL,
        '/api/v1/customers/' + @new_customer['customer']['id'].to_s,
        { 'name' => 'new api' },
        'SAHARA-TOKEN' => @new_customer_token
      )
      expect(response['status']).to eq('success')
      expect(response['customer']['id']).to eq(@new_customer['customer']['id'])
      expect(response['customer']['name']).to eq('new api')
    end

    it 'deletes customer' do
      response = delete(
        SAHARA_CMS_URL,
        '/api/v1/customers/' + @new_customer['customer']['id'].to_s,
        '',
        'SAHARA-TOKEN' => @new_customer_token
      )
      expect(response['status']).to eq('success')
      expect(response['customer']['id']).to eq(@new_customer['customer']['id'])
      @new_customer['customer']['id'] = nil
    end
  end
end
