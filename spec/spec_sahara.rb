require 'spec_helper'

describe 'Sahara' do
  context 'without login' do
    before do
      visit '/'
      wait_for_ajax
    end

    it 'shows top page' do
      expect(page).to have_content('Sahara Marketplace')
    end

    it 'shows product line up' do
      expect(page).to have_content('Tajine Pot')
      expect(page).to have_content('Argan oil')
      expect(page).to have_content('Babouche')
    end

    it 'shows login modal' do
      find('#login-link').click
      expect(page).to have_content('Email')
      expect(page).to have_content('Password')
      expect(page).to have_content('Submit')
    end

    it 'shows order modal' do
      find(:xpath, '(//a[text()="Buy"])[1]').click
      expect(page).to have_content('Confirmation')
      expect(page).to have_content('Do you really want to buy?')
    end

    it 'cannot login with wrong credential' do
      find('#login-link').click

      expect(page).to have_content('Email')
      expect(page).to have_content('Password')

      fill_in 'email',    with: 'hoge1@ho.ge'
      fill_in 'password', with: 'hoge2'
      click_button 'Submit'
      expect(page).to have_content('Invalid email or password')
    end

    it 'cannot order without login' do
      find(:xpath, '(//a[text()="Buy"])[1]').click
      expect(page).to have_content('Confirmation')
      expect(page).to have_content('Do you really want to buy?')

      find('#buy').click
      expect(page).to have_content('Please login first.')
    end
  end

  context 'with login' do
    before do
      visit '/'
      find('#login-link').click
      expect(page).to have_content('Email')
      expect(page).to have_content('Password')
      fill_in 'email',    with: 'hoge1@ho.ge'
      fill_in 'password', with: 'hoge1'
      click_button 'Submit'
      wait_for_ajax
    end

    it 'can login' do
      expect(page).to have_content('Logout')
      expect(page).to have_content('Order')
    end

    it 'shows order list' do
      expect(page).to have_content('Order')
      sleep(0.5)
      find('#order-link').click
      expect(page).to have_content('Order list')
    end

    it 'can logout' do
      expect(page).to have_content('Logout')
      sleep(0.5)
      find('#logout-link').click
      expect(page).to have_no_content("Logout")
      expect(page).to have_content('Login')
    end

    it 'can order' do
      find(:xpath, '(//a[text()="Buy"])[1]').click
      find('#buy').click
      wait_for_ajax
      expect(page).to have_content('Successfully ordered.')
      expect(page).to have_content('Please close this window.')
    end
  end
end
