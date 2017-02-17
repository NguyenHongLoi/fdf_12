module ChatworkHelper
  def send_message_chatwork message, user_id
    user_chatwork = User.find_by id: user_id
    send_to = ChatWork::Member.get(room_id: "65805237").find {|member|
      member["chatwork_id"] == user_chatwork.chatwork_id}
    if send_to.present?
      message_body = "[To:#{send_to["account_id"]}] #{send_to["name"]} \n#{message}!"
      ChatWork::Message.create room_id: "65805237", body: message_body
    end
  end
end