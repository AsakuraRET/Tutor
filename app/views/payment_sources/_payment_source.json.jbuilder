json.extract! payment_source, :id, :last_4, :cvc, :exp_year, :exp_month, :student_id, :created_at, :updated_at
json.url payment_source_url(payment_source, format: :json)
