module LessonHelpers
    def curriculums
        sitemap.resources.select{|r| r.path =~ /^curriculums\/[^\/]+?\/index/}
    end
end
