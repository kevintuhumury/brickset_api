module Brickset
  module Api
    module Auth

      def login(username, password)
        xml = call('/login', username: username, password: password)
        HappyMapper.parse(xml).content
      end

      def valid_api_key?
        xml = call('/checkKey')
        HappyMapper.parse(xml).content == 'OK'
      end

      def valid_token?
        xml = call('/checkUserHash')
        HappyMapper.parse(xml).content != 'INVALID'
      end

    end
  end
end
