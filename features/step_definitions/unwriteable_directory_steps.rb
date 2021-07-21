# frozen_string_literal: true

Then('a folder that is not writeable') do
  setup_aruba
  FileUtils.chmod(0o500, 'tmp/aruba')
end
