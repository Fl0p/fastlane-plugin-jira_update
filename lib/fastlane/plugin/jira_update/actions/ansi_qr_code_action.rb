module Fastlane
  module Actions

    module SharedValues
      QR_CODE_ORIGINAL_TEXT = :QR_CODE_ORIGINAL_TEXT
      QR_CODE_ASCII_ART = :QR_CODE_ASCII_ART
      QR_CODE_IMAGE_LINK = :QR_CODE_IMAGE_LINK
    end

    class AnsiQrCodeAction < Action
      def self.run(params)
        Actions.verify_gem!('rqrcode')
        require 'rqrcode'
        text = params[:text]
        qrcode = RQRCode::QRCode.new(text)
        ascii_art = qrcode.as_ansi(
          light: "\033[47m", dark: "\033[40m",
          fill_character: "  ",
          quiet_zone_size: 4
        )
        UI.message("QR code:\n#{ascii_art}")

        urlencoded_text = URI.encode_www_form_component(text)
        link = "https://kissapi-qrcode.vercel.app/api/qrcode?chl=#{urlencoded_text}"
        UI.message("QR code link: #{link}")

        Actions.lane_context[SharedValues::QR_CODE_ORIGINAL_TEXT] = text
        Actions.lane_context[SharedValues::QR_CODE_ASCII_ART] = ascii_art
        Actions.lane_context[SharedValues::QR_CODE_IMAGE_LINK] = link        

        return link

      end

      def self.output
        [
            ['QR_CODE_ORIGINAL_TEXT', 'Original text for QR code'],
            ['QR_CODE_ASCII_ART', 'QR code ascii art'],
            ['QR_CODE_IMAGE_LINK', 'URL to QR code image']
        ]
      end

      def self.description
        "Generate QR code"
      end

      def self.details
        "Generate QR code"
      end

      def self.return_value
        "QR code link"
      end

      def self.return_type
        :string
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :text,
                                       description: "Text for QR code",
                                       env_name: "FL_QR_TEXT",
                                       type: String,
                                       default_value: "Hello, world!")
        ]
      end

      def self.authors
        ["Flop Butylkin"]
      end

      def self.is_supported?(platform)
        true
      end

      def self.example_code
        [
          '
          ansi_qr_code(
            text: "https://www.google.com"
          )
          '
        ]
      end

      def self.category
        :misc
      end
    end
  end
end
