module HelpRequestsHelper
  def problem_picture_default(help_request)
    problem = help_request.problem_picture
    return url_for(problem) if problem.attached?
    asset_pack_path "media/images/avatar.svg"
  end
end
