class PasswordComponent < BaseComponent

  def index
    '*' * @record.call_chain(field.to_s).mb_chars.length
  end

end