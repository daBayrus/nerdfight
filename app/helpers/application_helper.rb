module ApplicationHelper
  def alert_box
    close_btn = content_tag(:button, "×", { class: "close", "data-dismiss" => "alert", "aria-hidden" => "true" }) if (alert || notice)
    if alert
      content_tag(:p, close_btn + alert, class: "alert alert-dismissable alert-danger")
    elsif notice
      content_tag(:p, close_btn + notice, class: "alert alert-dismissable alert-success")
    end
  end
end
