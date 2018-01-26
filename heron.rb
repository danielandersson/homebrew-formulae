class Heron < Formula
  desc "A realtime, distributed, fault-tolerant stream processing engine from Twitter"
  homepage "https://twitter.github.io/heron/"
  url "https://github.com/twitter/heron/releases/download/0.17.4/heron-0.17.4-darwin.tar.gz"
  sha256 "b552d810bf8f77c560233b8daa625b28b14328c6718ee8d5e280b76cefd1aab9"
  version "0.17.4"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/heron"]
    bin.write_exec_script Dir["#{libexec}/bin/heron-explorer"]
    bin.write_exec_script Dir["#{libexec}/bin/heron-tracker"]
    bin.write_exec_script Dir["#{libexec}/bin/heron-apiserver"]
    bin.write_exec_script Dir["#{libexec}/bin/heron-ui"]

    (prefix/"homebrew.mxcl.heron-ui.plist").write heron_ui_plist
    (prefix/"homebrew.mxcl.heron-ui.plist").chmod 0644

  end

  def caveats; <<~EOS
    For starting tracker use the command
      brew services start heron
    To start ui first start tracker then use command
      launchctl load -w #{opt_prefix}/homebrew.mxcl.heron-ui.plist
    To stop ui or after version upgrade
      launchctl unload -w #{opt_prefix}/homebrew.mxcl.heron-ui.plist
    EOS
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <false/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/heron-tracker</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/heron-tracker.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/heron-tracker.log</string>
      </dict>
    </plist>
    EOS
  end

  def heron_ui_plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <false/>
        <key>Label</key>
        <string>homebrew.mxcl.heron-ui</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/heron-ui</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/heron-ui.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/heron-ui.log</string>
      </dict>
    </plist>
    EOS
  end
end