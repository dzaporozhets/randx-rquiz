require "pstore"
require "yaml"

class MyProc
  def initialize(block)
    @block = block
    @proc  = nil
  end

  def _dump(depth)
    @block
  end

  def self._load(str)
    new(str)
  end

  def to_proc
    @proc ||= (eval "Proc.new { #{@block} }")
  end

  def method_missing(*args)
    to_proc.send(*args)
  end

  def to_yaml(*args)
    @proc = nil
    super(*args)
  end
end

code = MyProc.new %q{ p "hello" } # Build your SerializableProc here!

code.call

File.open("proc.marshalled", "w") { |file| Marshal.dump(code, file) }
code = File.open("proc.marshalled") { |file| Marshal.load(file) }

code.call

store = PStore.new("proc.pstore")
store.transaction do
    store["proc"] = code
end
store.transaction do
    code = store["proc"]
end

code.call

File.open("proc.yaml", "w") { |file| YAML.dump(code, file) }
code = File.open("proc.yaml") { |file| YAML.load(file) }

code.call
