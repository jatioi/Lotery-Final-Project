class Client::InviteController < ApplicationController
  before_action :authenticate_client_user!


  require "rqrcode"

  def index
    qrcode = RQRCode::QRCode.new("http://github.com/")

    # NOTE: showing with default options specified explicitly
    @as_svg = qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 11,
      standalone: true,
      use_path: true
    )
  end

  def sign_up
    promoter_email = params[:promoter]
    @as_svg = generate_qr_code(promoter_email)
    puts "@as_svg: #{@as_svg.inspect}"
  end

  private

  def generate_as_svg(promoter_email)
    # Your logic to generate @as_png based on promoter_email
    # Return the generated content or nil if not available
  end
end


