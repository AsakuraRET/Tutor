json.extract! help_request, :id, :description, :subject_id, :price, :student_id, :created_at, :updated_at
json.url help_request_url(help_request, format: :json)
