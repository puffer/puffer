class Puffer::SessionsController < Puffer::Sessions

  def new
    @record = User.new
  end

  def create
    record = User.new
    respond_with record
  end

  def destroy

  end

end
