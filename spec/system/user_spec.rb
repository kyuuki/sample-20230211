require 'rails_helper'
RSpec.describe 'ユーザー管理機能', type: :system do
  describe 'ユーザー登録のテスト' do
    context 'ユーザーを新規登録した場合' do
      it '作成したユーザーのマイページ表示される' do
        visit new_user_path

        fill_in "Name", with: "name1"
        fill_in "Email", with: "email1@a.com"
        fill_in "Password", with: "xxxxxx"
        fill_in "Password confirmation", with: "xxxxxx"

        click_button "Create my account"

        expect(page).to have_content 'name1'
        expect(page).to have_content 'email1@a.com'
      end
    end

    context 'ログインせずにタスク一覧画面を表示した場合' do
      it 'ログイン画面が表示される' do
        visit tasks_path

        expect(current_path).to eq new_session_path
      end
    end
  end

  describe 'セッション機能のテスト' do
    let!(:user1) { FactoryBot.create(:user, name: "user1", email: "user1@a.com", password: "aaaaaa") }
    let!(:user2) { FactoryBot.create(:user, name: "user2", email: "user2@a.com", password: "bbbbbb") }
    context '登録ユーザーでログインした場合' do
      it 'ログインして、自分の詳細画面 (マイページ) が表示される' do
        visit new_session_path
        fill_in "Email", with: "user1@a.com"
        fill_in "Password", with: "aaaaaa"
        click_button "Log in"

        expect(page).to have_content 'user1'
        expect(page).to have_content 'user1@a.com'
      end
    end

    context '一般ユーザーが他人の詳細画面を表示した場合' do
      it 'タスク一覧画面に遷移する' do
        visit new_session_path
        fill_in "Email", with: "user1@a.com"
        fill_in "Password", with: "aaaaaa"
        click_button "Log in"

        # 他人の詳細画面を表示
        visit user_path(user2)

        expect(current_path).to eq tasks_path
      end
    end

    context 'ログアウトした場合' do
      it 'ログアウトされる' do
        visit new_session_path
        fill_in "Email", with: "user1@a.com"
        fill_in "Password", with: "aaaaaa"
        click_button "Log in"

        click_on "Logout"

        expect(page).to have_content 'ログアウトしました'
      end
    end
  end

  describe '管理画面のテスト' do
    let!(:admin_user) { FactoryBot.create(:user, email: "admin@a.com", password: "adminadmin", admin: true) }
    let!(:user1) { FactoryBot.create(:user, email: "user1@a.com", password: "aaaaaa", admin: false) }
    context '管理ユーザーが管理画面にアクセスする' do
      it '管理画面が表示される' do
        visit new_session_path
        fill_in "Email", with: "admin@a.com"
        fill_in "Password", with: "adminadmin"
        click_button "Log in"

        visit admin_users_path

        expect(current_path).to eq admin_users_path
      end
    end

    context '一般ユーザーが管理画面にアクセスする' do
      it '管理画面が表示されない' do
        visit new_session_path
        fill_in "Email", with: "user1@a.com"
        fill_in "Password", with: "aaaaaa"
        click_button "Log in"

        visit admin_users_path

        expect(current_path).to eq tasks_path
      end
    end

    context '管理ユーザーがユーザーを新規登録した場合' do
      it 'ユーザー詳細画面が表示される' do
        visit new_session_path
        fill_in "Email", with: "admin@a.com"
        fill_in "Password", with: "adminadmin"
        click_button "Log in"

        # 新規登録画面
        visit new_admin_user_path

        fill_in "名前", with: "name"
        fill_in "メールアドレス", with: "mail@a.com"
        fill_in "パスワード", with: "bbbbbb"
        fill_in "パスワード (確認)", with: "bbbbbb"
        click_button "保存"

        expect(page).to have_content '管理画面 - ユーザー詳細'
        expect(page).to have_content 'name'
        expect(page).to have_content 'mail@a.com'
      end
    end

    context '管理ユーザーがユーザーを編集した場合' do
      it 'ユーザーが更新され、ユーザー詳細画面が表示される' do
        visit new_session_path
        fill_in "Email", with: "admin@a.com"
        fill_in "Password", with: "adminadmin"
        click_button "Log in"

        # 編集画面
        visit edit_admin_user_path(user1.id)

        fill_in "名前", with: "name"
        fill_in "メールアドレス", with: "mail@a.com"
        fill_in "パスワード", with: "bbbbbb"
        fill_in "パスワード (確認)", with: "bbbbbb"
        click_button "保存"

        expect(page).to have_content '管理画面 - ユーザー詳細'
        expect(page).to have_content 'name'
        expect(page).to have_content 'mail@a.com'
      end
    end

    context '管理ユーザーがユーザーを削除した場合' do
      it 'ユーザーが削除され、ユーザー一覧画面から消える' do
        visit new_session_path
        fill_in "Email", with: "admin@a.com"
        fill_in "Password", with: "adminadmin"
        click_button "Log in"

        # 一覧画面
        visit admin_users_path

        # 削除ボタン
        click_on "delete-#{user1.id}"

        # 一覧画面から削除したユーザーが消えている
        expect(current_path).to eq admin_users_path
        expect(page).to have_content 'admin@a.com'
        expect(page).not_to have_content 'user1@a.com'
      end
    end
  end
end
