# frozen_string_literal: true

title 'rider archives profile'

control 'rider archive' do
  impact 1.0
  title 'should be installed'

  describe file('/etc/default/rider.sh') do
    it { should exist }
  end
  # describe file('/usr/local/jetbrains/rider-*/bin/rider.sh') do
  #    it { should exist }
  # end
  describe file('/usr/share/applications/rider.desktop') do
    it { should exist }
  end
end
