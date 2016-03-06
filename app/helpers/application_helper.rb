module ApplicationHelper

  def auth_token
    <<-HTML.html_safe
      <input type="hidden" name="authenticity_token" value="#{ form_authenticity_token }">
    HTML
  end

  def my_delete_button(url)
    <<-HTML.html_safe
      <form action="#{ url }" method="POST">
        <input type="hidden" name="_method" value="DELETE">
        #{ auth_token }
        <input type="submit" value="DELETE">
      </form
    HTML
  end
end
