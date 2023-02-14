require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  let!(:user1) { FactoryBot.create(:user, name: "user1", email: "user1@a.com", password: "aaaaaa") }

  before do
    visit tasks_path
    fill_in "Email", with: "user1@a.com"
    fill_in "Password", with: "aaaaaa"
    click_button "Log in"
  end

  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
        # 1. new_task_pathに遷移する（新規作成ページに遷移する）
        # ここにnew_task_pathにvisitする処理を書く
        visit new_task_path

        # 2. 新規登録内容を入力する
        #「タスク名」というラベル名の入力欄と、「タスク詳細」というラベル名の入力欄にタスクのタイトルと内容をそれぞれ入力する
        # ここに「タスク名」というラベル名の入力欄に内容をfill_in（入力）する処理を書く
        # ここに「タスク詳細」というラベル名の入力欄に内容をfill_in（入力）する処理を書く
        fill_in "タイトル", with: "title1"
        fill_in "内容", with: "content1"
        fill_in "終了期限", with: "2020-01-01"
        select "未着手", from: "task_status"
        select "高", from: "task_priority"

        # 3. 「登録する」というvalue（表記文字）のあるボタンをクリックする
        # ここに「登録する」というvalue（表記文字）のあるボタンをclick_onする（クリックする）する処理を書く
        click_button "保存"

        # 4. clickで登録されたはずの情報が、タスク詳細ページに表示されているかを確認する
        # （タスクが登録されたらタスク詳細画面に遷移されるという前提）
        # ここにタスク詳細ページに、テストコードで作成したデータがタスク詳細画面にhave_contentされているか（含まれているか）を確認（期待）するコードを書く
        expect(page).to have_content 'title1'
        expect(page).to have_content 'content1'
        expect(page).to have_content '2020-01-01'
        expect(page).to have_content '未着手'
        expect(page).to have_content '高'
      end
    end
  end

  describe '一覧表示機能' do
    let!(:task1) { FactoryBot.create(:task, title: 'task1', created_at: "2023-01-01", user: user1) }
    let!(:task2) { FactoryBot.create(:task, title: 'task2', created_at: "2023-01-02", user: user1) }
    let!(:task3) { FactoryBot.create(:task, title: 'task3', created_at: "2023-01-03", user: user1) }

    before do
      # 「一覧画面に遷移した場合」や「タスクが作成日時の降順に並んでいる場合」など、contextが実行されるタイミングで、before内のコードが実行される
      visit tasks_path
    end

    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        # visitした（遷移した）page（タスク一覧ページ）に「task」という文字列が
        # have_contentされているか（含まれているか）ということをexpectする（確認・期待する）
        expect(page).to have_content 'task1'
        # expectの結果が true ならテスト成功、false なら失敗として結果
      end
    end

    context 'タスクが作成日時の降順に並んでいる場合' do
      it '新しいタスクが一番上に表示される' do
        task_list = all(".task-title")
        expect(task_list.size).to eq 3
        expect(task_list[0]).to have_content "task3"
        expect(task_list[1]).to have_content "task2"
        expect(task_list[2]).to have_content "task1"
      end
    end
  end

  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it '該当タスクの内容が表示される' do
        task = FactoryBot.create(:task, title: "title2", content: "content2")

        visit task_path(task)

        expect(page).to have_content "title2"
        expect(page).to have_content "content2"
      end
    end
  end

  describe '検索機能' do
    before do
      # 必要に応じて、テストデータの内容を変更して構わない
      FactoryBot.create(:task, title: "task", status: 1, user: user1)
      FactoryBot.create(:task, title: "sample", status: 2, user: user1)
    end

    context 'タイトルであいまい検索をした場合' do
      it "検索キーワードを含むタスクで絞り込まれる" do
        visit tasks_path

        # タスクの検索欄に検索ワードを入力する (例: task)
        fill_in "タイトル", with: "ask"

        # 検索ボタンを押す
        click_button "検索"

        expect(page).to have_content 'task'
      end
    end

    context 'ステータス検索をした場合' do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        # ここに実装する
        # プルダウンを選択する「select」について調べてみること
        visit tasks_path
        select "着手中", from: "search_status"
        click_button "検索"

        expect(page).to have_content 'sample'
      end
    end

    context 'タイトルのあいまい検索とステータス検索をした場合' do
      it "検索キーワードをタイトルに含み、かつステータスに完全一致するタスク絞り込まれる" do
        # ここに実装する
        visit tasks_path
        fill_in "タイトル", with: "amp"
        select "着手中", from: "search_status"
        click_button "検索"

        expect(page).to have_content 'sample'
      end
    end
  end
end
