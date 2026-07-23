# Rack 3 represents a second (or later) Set-Cookie header as an Array of
# strings (Rack::Utils.set_cookie_header!, rack-3.2.6 lib/rack/utils.rb).
# Rack 2 always used a single "\n"-joined String instead.
#
# unicorn 6.1.0 (the latest gem release as of this fix, no 6.2+ exists yet)
# never learned the Array form: Unicorn::HttpResponse#http_response_write
# only checks `value =~ /\n/`, a String-only check, and raises
# `NoMethodError: undefined method '=~' for an instance of Array` on any
# response carrying 2+ Set-Cookie headers (e.g. session cookie + Clearance's
# remember_token cookie, both set on sign-in). The crash happens inside
# Unicorn's own response-serialization code after Rails has already
# finished the request, so it never appears in production.log, and the
# client gets a bare 500 with no cookies at all.
#
# The real fix exists upstream, merged but unreleased in any unicorn gem:
# https://github.com/Shopify/unicorn/pull/5. This reproduces it verbatim
# until a unicorn release ships it (or the app moves off Unicorn to Puma,
# which already handles Rack 3 correctly).
if defined?(Unicorn::HttpResponse)
  module UnicornRack3CookieFix
    def http_response_write(socket, status, headers, body,
                            req = Unicorn::HttpRequest.new)
      hijack = nil

      if headers
        code = status.to_i
        msg = Unicorn::HttpResponse::STATUS_CODES[code]
        start = req.response_start_sent ? ''.freeze : 'HTTP/1.1 '.freeze
        buf = "#{start}#{msg ? %Q(#{code} #{msg}) : status}\r\n" \
              "Date: #{httpdate}\r\n" \
              "Connection: close\r\n"
        headers.each do |key, value|
          case key
          when %r{\A(?:Date|Connection)\z}i
            next
          when "rack.hijack"
            hijack = value
          else
            case value
            when Array # Rack 3
              value.each { |v| buf << "#{key}: #{v}\r\n" }
            when /\n/ # Rack 2
              value.split(/\n+/).each { |v| buf << "#{key}: #{v}\r\n" }
            else
              buf << "#{key}: #{value}\r\n"
            end
          end
        end
        socket.write(buf << "\r\n".freeze)
      end

      if hijack
        req.hijacked!
        hijack.call(socket)
      else
        body.each { |chunk| socket.write(chunk) }
      end
    end
  end

  Unicorn::HttpResponse.prepend(UnicornRack3CookieFix)
end
