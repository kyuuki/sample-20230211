FactoryBot.define do
  factory :task do
    # 下記の内容は実際に作成するカラム名に合わせて変更してください
    title { 'test_title' }
    content { 'test_content' }
    deadline { '2020-01-01' }
    status { 1 }
    priority { 1 }
    user
  end
end
