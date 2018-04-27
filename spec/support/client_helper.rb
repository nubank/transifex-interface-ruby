module ClientHelper
  def reset_transifex_configuration
    Transifex.configure do |c|
      c.client_login = ENV['TRANSIFEX_CLIENT_LOGIN'] || ''
      c.client_secret = ENV['TRANSIFEX_CLIENT_SECRET'] || ''
      c.organization = ENV['TRANSIFEX_ORGANIZATION'] || ''
    end
  end
end
