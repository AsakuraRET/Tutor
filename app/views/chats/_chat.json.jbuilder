json.extract! chat, :id, :message_id, :student_id, :tutor_id, :created_at, :updated_at
json.url chat_url(chat, format: :json)
