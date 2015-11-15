#!/bin/sh
SAHARA_CMS_URL=http://localhost:30301 SAHARA_PMS_URL=http://localhost:30302 SAHARA_OMS_URL=http://localhost:30303 rspec spec/spec_order.rb spec/spec_product.rb spec/spec_customer.rb
SAHARA_URL=http://localhost:8000 rspec spec/spec_webui.rb
