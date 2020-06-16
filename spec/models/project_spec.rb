require 'rails_helper'

RSpec.describe Project, type: :model do
  # プロジェクト名があれば有効な状態であること
  it "is valid with a name and user's id" do
    user = FactoryBot.create(:user)
    project = user.projects.build(name: 'Test Project')
    expect(project).to be_valid
  end

  # プロジェクト名がなければ無効な状態であること
  it 'is invalid without a name' do
    user = FactoryBot.create(:user)
    project = user.projects.build(name: nil)
    project.valid?
    expect(project.errors[:name]).to include("can't be blank")
  end

  # ユーザー単位では重複したプロジェクト名を許可しないこと
  it 'does not allow duplicate project names per user' do
    user = FactoryBot.create(:user)
    user.projects.create(name: 'Test Project')
    new_project = user.projects.build(name: 'Test Project')
    new_project.valid?
    expect(new_project.errors[:name]).to include('has already been taken')
  end

  # 二人のユーザーが同じプロジェクト名を使うことを許可すること
  it 'allows two users to share a project name' do
    user = FactoryBot.create(:user)
    user.projects.create(name: 'Test Project')

    other_user = FactoryBot.create(:user)
    other_project = other_user.projects.build(name: 'Test Project')

    expect(other_project).to be_valid
  end

  # たくさんのメモが付いていること
  it 'can have many notes' do
    project = FactoryBot.create(:project, :with_notes)
    expect(project.notes.length).to eq 5
  end

  describe 'late status' do
    # 締切日が過ぎていれば遅延していること
    it 'is late when the due date is past today' do
      project = FactoryBot.create(:project, :due_yesterday)
      expect(project).to be_late
    end

    # 締切日が今日ならスケジュール通りであること
    it 'is on time when due date is today' do
      project = FactoryBot.create(:project, :due_today)
      expect(project).to_not be_late
    end

    # 締切日が明日ならスケジュール通りであること
    it 'is on time when due date is tomorrow' do
      project = FactoryBot.create(:project, :due_tomorrow)
      expect(project).to_not be_late
    end
  end
end
