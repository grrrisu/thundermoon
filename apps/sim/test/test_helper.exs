# as the sim application was not started (to prevent starting the
# whole supervision tree), we need now to start all sub applications
Application.load(:sim)

for app <- Application.spec(:sim, :applications) do
  Application.ensure_all_started(app)
end

ExUnit.start()
