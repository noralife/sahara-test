require 'spec_helper'

describe 'SaharaOrderAPI' do
  before do
    @token = token('hoge1@ho.ge', 'hoge1')
  end
  context 'without new order' do
    it 'shows order list' do
      response = get SAHARA_OMS_URL, '/api/v1/orders', 'SAHARA-TOKEN' => @token
      expect(response.size).to be > 0
    end
  end

  context 'with new order' do
    before do
      @new_order = post(
        SAHARA_OMS_URL,
        '/api/v1/orders',
        { 'customer_id' => 1, 'product_id' => 1 },
        'SAHARA-TOKEN' => @token
      )
    end

    after do
      unless @new_order['order']['id'].nil?
        delete(
          SAHARA_OMS_URL,
          '/api/v1/orders/' + @new_order['order']['id'].to_s,
          '',
          'SAHARA-TOKEN' => @token
        )
      end
    end

    it 'adds new order' do
      expect(@new_order['status']).to eq('success')
      expect(@new_order['order']['id']).to be > 0
    end

    it 'shows order detail' do
      response = get(
        SAHARA_OMS_URL,
        '/api/v1/orders/' + @new_order['order']['id'].to_s,
        'SAHARA-TOKEN' => @token
      )
      expect(response['id']).to eq(@new_order['order']['id'])
      expect(response['customer_id']).to eq(@new_order['order']['customer_id'])
      expect(response['product_id']).to eq(@new_order['order']['product_id'])
    end

    it 'updates order' do
      response = put(
        SAHARA_OMS_URL,
        '/api/v1/orders/' + @new_order['order']['id'].to_s,
        { 'status' => 'ok' },
        'SAHARA-TOKEN' => @token
      )
      expect(response['order']['id']).to eq(@new_order['order']['id'])
      expect(response['status']).to eq('success')
    end

    it 'deletes order' do
      response = delete(
        SAHARA_OMS_URL,
        '/api/v1/orders/' + @new_order['order']['id'].to_s,
        '',
        'SAHARA-TOKEN' => @token
      )
      expect(response['status']).to eq('success')
      @new_order['order']['id'] = nil
    end
  end
end
