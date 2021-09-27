require "active_record"

class Todo < ActiveRecord::Base
  def due_today?
    due_date == Date.today
  end

  def to_displayable_string
    index = id
    display_status = completed ? "[X]" : "[ ]"
    display_date = due_today? ? nil : due_date
    "#{index}. #{display_status} #{todo_text} #{display_date}"
  end

  def self.overdue
    where("due_date < ?", Date.today)
  end

  def self.due_today
    where(due_date: Date.today)
  end

  def self.due_later
    where("due_date > ?", Date.today)
  end

  def self.to_displayable_list
    all.map { |todo| todo.to_displayable_string }
  end

  def self.add_task(task)
    Todo.create!(todo_text: task[:todo_text], due_date: Date.today + task[:due_in_days], completed: false)
  end

  def self.mark_as_complete(id)
    item = self.find_by(id: id)
    item.completed = true
    item.save
    item
  end

  def self.show_list
    puts "My Todo-list\n\n"
    puts "Overdue\n"
    puts self.overdue.map { |todo| todo.to_displayable_string }
    puts "\n\n"
    puts "Due Today\n"
    puts self.due_today.map { |todo| todo.to_displayable_string }
    puts "\n\n"
    puts "Due Later\n"
    puts self.due_later.map { |todo| todo.to_displayable_string }
    puts "\n\n"
  end
end
