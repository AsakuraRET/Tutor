module ApplicationHelper
  def red_if_request_finished(state)
    return "red" if state == 'finished'
    ''
  end

  def active_link_by_controller_and_action controller, action = false
    if action
      return 'active' if controller_name == controller && action_name == action
    else
      return 'active' if controller_name == controller
    end
    ''
  end
end
