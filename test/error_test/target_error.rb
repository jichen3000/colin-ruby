class TargetNotExistError < StandardError
  def initialize(target_id,target_type)
    super()
    @target_id,@target_type = target_id,target_type
  end
  def message()
    "id:#{@target_id},target_type:#{@target_type} does not exist"+
          "id:#{@target_id},target_type:#{@target_type} does not exist"
  end
end

def perform(target_id,target_type)
  if target_type !="db"
    raise TargetNotExistError.new(target_id,target_type)
  end
end

begin
  perform(0,"mm")
rescue StandardError => e
  p e.message
end
p "ok"