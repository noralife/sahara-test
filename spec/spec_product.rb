require 'spec_helper'

describe 'SaharaProductAPI' do
  context 'without new product' do
    it 'shows product list' do
      response = get SAHARA_PMS_URL, '/api/v1/products'
      expect(response.size).to be > 0
    end
  end

  context 'with new product' do
    before do
      @admin_token = token('admin@ho.ge', 'admin')
      @new_product = post(
        SAHARA_PMS_URL,
        '/api/v1/products',
        {'name' => 'test product', 'desc' => 'test'},
	'SAHARA-TOKEN' => @admin_token
      )
    end

    after do
      unless @new_product['product']['id'].nil?
        delete(
          SAHARA_PMS_URL,
	  '/api/v1/products/' + @new_product['product']['id'].to_s,
	  '',
	  'SAHARA-TOKEN' => @admin_token
	)
      end
    end

    it 'adds new product' do
      expect(@new_product['product']['id']).to be > 0
      expect(@new_product['product']['name']).to eq('test product')
      expect(@new_product['product']['desc']).to eq('test')
      expect(@new_product['product']['created_at']).not_to be_empty
    end

    it 'shows product detail' do
      response = get SAHARA_PMS_URL, '/api/v1/products/' + @new_product['product']['id'].to_s
      expect(response['id']).to eq(@new_product['product']['id'])
      expect(response['name']).to eq(@new_product['product']['name'])
      expect(response['desc']).to eq(@new_product['product']['desc'])
    end

    it 'updates product' do
      response = put(
        SAHARA_PMS_URL,
        '/api/v1/products/' + @new_product['product']['id'].to_s,
        {'name' => 'NEW test product', 'desc' => 'NEW test'},
	'SAHARA-TOKEN' => @admin_token
      )
      expect(response['product']['id']).to eq(@new_product['product']['id'])
      expect(response['product']['name']).to eq('NEW ' + @new_product['product']['name'])
      expect(response['product']['desc']).to eq('NEW ' + @new_product['product']['desc'])
    end

    it 'deletes product' do
      response = delete SAHARA_PMS_URL, '/api/v1/products/' + @new_product['product']['id'].to_s, '', 'SAHARA-TOKEN' => @admin_token
      expect(response['status']).to eq('success')
      @new_product['product']['id'] = nil
    end
  end
end
