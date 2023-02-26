class Api::SessionController < Api::ApplicationController
  # NOTE: 以下のログイン処理には重大な脆弱性があります。
  # 本クラスはあくまでサンプルです。絶対に真似しないでください。
  def create
    user = User.find_by(name: params[:name])

    if user.present?
      session[:user_id] = user.encrypted_id
    else
      head :unauthorized
    end
  end
end
