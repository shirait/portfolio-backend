require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(255) }
    it { should validate_length_of(:description).is_at_most(10000) }
    it { should validate_presence_of(:status) }
    it { should validate_inclusion_of(:status).in_array(Task.statuses.keys) }
    it { should validate_presence_of(:user_id) }
  end

  describe '#update_snapshot' do
    it 'returns status, due_date, and user_id in a comparable format' do
      task = create(:task, status: :in_progress, due_date: Date.new(2026, 5, 20))

      expect(task.update_snapshot).to eq(
        status: "in_progress",
        due_date: "2026-05-20",
        user_id: task.user_id
      )
    end
  end

  describe '#build_task_update_info' do
    it 'returns the default message when nothing changed' do
      task = create(:task)
      before_update = task.update_snapshot

      expect(task.build_task_update_info(before_update)).to eq("コメントしました")
    end

    it 'describes a status change' do
      task = create(:task, status: :not_started)
      before_update = task.update_snapshot
      task.update!(status: :in_progress)

      expect(task.build_task_update_info(before_update)).to eq("ステータス: not_started → in_progress")
    end

    it 'describes a due date change' do
      task = create(:task, due_date: nil)
      before_update = task.update_snapshot
      task.update!(due_date: Date.new(2026, 6, 1))

      expect(task.build_task_update_info(before_update)).to eq("期日: - → 2026-06-01")
    end
  end

  describe 'scopes' do
    describe '.search_by_title' do
      it 'returns tasks whose title partially matches the keyword' do
        matching_task = create(:task, title: "バグ修正タスク")
        create(:task, title: "機能追加タスク")

        expect(Task.search_by_title("バグ修正")).to contain_exactly(matching_task)
      end

      it 'does not filter when the keyword is blank' do
        tasks = [ create(:task, title: "タスクA"), create(:task, title: "タスクB", user: create(:user, email: "other@example.com")) ]

        expect(Task.search_by_title(nil)).to match_array(tasks)
        expect(Task.search_by_title("")).to match_array(tasks)
      end

      it 'treats percent and underscore as literal characters' do
        matching_task = create(:task, title: "100%完了")
        create(:task, title: "100X完了")

        expect(Task.search_by_title("100%")).to contain_exactly(matching_task)
      end
    end

    describe '.search_by_status' do
      it 'returns tasks with the given status' do
        matching_task = create(:task, status: :in_progress)
        create(:task, status: :completed)

        expect(Task.search_by_status("in_progress")).to contain_exactly(matching_task)
      end

      it 'does not filter when status is blank' do
        tasks = [ create(:task, status: :not_started), create(:task, status: :completed, user: create(:user, email: "other@example.com")) ]

        expect(Task.search_by_status(nil)).to match_array(tasks)
        expect(Task.search_by_status("")).to match_array(tasks)
      end
    end

    describe '.search_by_due_date_from' do
      it 'returns tasks due on or after the beginning of the given date' do
        from_date = Date.new(2026, 6, 10)
        matching_task = create(:task, due_date: from_date.beginning_of_day)
        create(:task, due_date: from_date.yesterday.end_of_day)

        expect(Task.search_by_due_date_from(from_date)).to contain_exactly(matching_task)
      end

      it 'does not filter when due_date_from is blank' do
        tasks = [
          create(:task, due_date: Date.new(2026, 6, 1)),
          create(:task, due_date: Date.new(2026, 6, 2), user: create(:user, email: "other@example.com"))
        ]

        expect(Task.search_by_due_date_from(nil)).to match_array(tasks)
      end
    end

    describe '.search_by_due_date_to' do
      it 'returns tasks due on or before the end of the given date' do
        to_date = Date.new(2026, 6, 10)
        matching_task = create(:task, due_date: to_date.end_of_day)
        create(:task, due_date: to_date.tomorrow.beginning_of_day)

        expect(Task.search_by_due_date_to(to_date)).to contain_exactly(matching_task)
      end

      it 'does not filter when due_date_to is blank' do
        tasks = [
          create(:task, due_date: Date.new(2026, 6, 1)),
          create(:task, due_date: Date.new(2026, 6, 2), user: create(:user, email: "other2@example.com"))
        ]

        expect(Task.search_by_due_date_to(nil)).to match_array(tasks)
      end
    end

    describe '.search_by_user_id' do
      it 'returns tasks assigned to the given user' do
        user = create(:user, email: "assignee@example.com")
        other_user = create(:user, email: "other@example.com")
        matching_task = create(:task, user: user)
        create(:task, user: other_user)

        expect(Task.search_by_user_id(user.id)).to contain_exactly(matching_task)
      end

      it 'does not filter when user_id is blank' do
        tasks = [ create(:task), create(:task, user: create(:user, email: "other3@example.com")) ]

        expect(Task.search_by_user_id(nil)).to match_array(tasks)
        expect(Task.search_by_user_id("")).to match_array(tasks)
      end
    end
  end

  describe '#record_update!' do
    it 'updates the task and creates a comment within a transaction' do
      task = create(:task, status: :not_started)
      comment_user = create(:user, email: "commenter@example.com")

      expect {
        task.record_update!(
          attributes: { status: "in_progress" },
          comment_content: "進行中にしました",
          user: comment_user
        )
      }.to change { task.comments.count }.by(1)

      task.reload
      expect(task.status).to eq("in_progress")

      comment = task.comments.last
      expect(comment.content).to eq("進行中にしました")
      expect(comment.user).to eq(comment_user)
      expect(comment.task_update_info).to eq("ステータス: not_started → in_progress")
    end

    it 'rolls back the task update when the comment is invalid' do
      task = create(:task, status: :not_started)
      comment_user = create(:user, email: "commenter2@example.com")

      expect {
        task.record_update!(
          attributes: { status: "in_progress" },
          comment_content: "",
          user: comment_user
        )
      }.to raise_error(ActiveRecord::RecordInvalid)

      task.reload
      expect(task.status).to eq("not_started")
      expect(task.comments.count).to eq(0)
    end
  end
end
