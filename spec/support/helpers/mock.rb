module Helpers
  module Mock
    def allow_to_receive_mocked_run(klass)
      allow(klass).to receive(:run) { |**args| klass.new(**args) }
    end
  end
end
