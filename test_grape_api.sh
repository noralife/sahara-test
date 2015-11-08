#!/bin/sh
SAHARA_CMS_URL=http://localhost:9393 SAHARA_PMS_URL=http://localhost:9494 SAHARA_OMS_URL=http://localhost:9595 rspec spec/spec_order.rb spec/spec_product.rb spec/spec_customer.rb
