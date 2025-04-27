require_relative 'request'
require 'json'
require 'logger'

logger = Logger.new(STDOUT)
req = Request.new("http://localhost/api/auth")
res = req.headerRequest
  
if res.kind_of? Net::HTTPSuccess
  logger.info("[*] Requesting the sid auth token for main pihole instance")
  sidToken = JSON.parse(res.body)["session"]["sid"]
  resAuth = req.checkAuth(sidToken)

  checkResponse = JSON.parse(resAuth.body)["session"]["valid"]

  if checkResponse
    logger.info("[*] Authenticated successfully to main pihole instance")
  else
    logger.error("[*] Something went wrong: #{resAuth}")
  end
else
  logger.error("[*] Bad status code: #{res.code}")
  logger.error(res.body)
end


