class Rack::Attack
  throttle("warmup/ip", limit: 5, period: 5.minutes) do |req|
    req.ip if req.path == "/warmup"
  end
end
