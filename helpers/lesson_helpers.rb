module LessonHelpers
    def curriculums
        cx = sitemap_resources.select{|r|
            r.path =~ /^curriculums\/[^\/]+?\/index/

        }.map{|r| Curriculum.new(r) }

        # cx.each do |c|
        #     cpath = Pathname.new(r.path).dirname
        #     tx = sitemap_resources.select{|x| x.path =~}
        # end



        # .map{|r|
        #     rpath = Pathname.new(r.path).dirname
        #     rxl =  sitemap_resources.select{|x| x.path !~ /\/common\// && x.path =~ /#{rpath}\/.+?index/ }
        #     lessons = rxl.map{|y| contentresource(y) }
        #     Curriculum.new(r, lessons)
        # }
    end
end
