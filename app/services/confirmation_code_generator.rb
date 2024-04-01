class ConfirmationCodeGenerator
  def self.generate
    6.times.map{ Kernel.rand(10) }.join
  end
end
