require 'lib/lesson'

class Topic < MiddlemanContentResource
  attr_reader :middleman_resource, :source_file
  def initialize(resource)
    super(resource)
    @lessons = resource.children.select{|r| r.path =~ /#{@dirname}\/.+?\/index.html/}.map{|r| Lesson.new(r)}
  end

  def content_size
    File.size(@source_file)
  end

  def stub?
    content_size < 1024
  end

  def lessons
    @lessons
  end
end
