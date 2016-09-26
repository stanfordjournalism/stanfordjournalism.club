require 'pathname'
require 'fileutils'
desc "Just push it, via middleman s3_sync push"
task :shoop do |t, args|
  puts "Pushing it real good..."
  IO.popen("bundle exec middleman build && bundle exec middleman s3_sync").each do |line|
    p line.chomp
  end
end


desc "Create new page from legacy directory"
task :transfer, [:srcdir, :srcpath, :destdir, :quiet] do |t, args|
    args.with_defaults(:quiet => true)
    srcdir = Pathname.new(args.srcdir).expand_path
    srcpath = srcdir.join(args.srcpath)
    destdir = Pathname.new(args.destdir).expand_path
    destpath = destdir.join('index.html.md')
    themode = args.quiet == true ? 'quiet' : 'live'
    puts "In #{themode} mode"
    puts "Creating #{destpath}"
    puts "Basing on #{srcpath}"
    puts "\twith assets relative to  #{srcdir}"
    if themode == 'live'
        srcdir.mkpath
        destdir.mkpath
        s = srcpath.read.gsub(/(?<="|'|\()\/files\//, 'files/')
        destpath.write(s)
    end



    src = srcpath.expand_path().open().read()
    src_filenames = src.scan(/\/files\/.+?(?=\]|"|')/)
    src_filenames.each do |fname|
        rname = fname.sub(/^\//, '')
        srcname = srcdir.join rname
        dest_assetname = destdir.join(rname)
        puts "\tCopying #{srcname}\n\t\t to #{dest_assetname}"
        if themode == 'live'
            dest_assetname.parent.mkpath
            FileUtils.copy(srcname, dest_assetname)
        end
    end
end

"""
Sample:

rake transfer[\
~/stan/2015-2016/padjo-2015/source,\
tutorials/spreadsheets/basic-agg-pivot-tables.md.erb,\
source/curriculums/comm-273d-2015/spreadsheets/basic-agg-pivot-tables\
]
"""

# cat index.html.md | ack '(files/images/.+?\.\w{2,4})' --output '/tmp/$1'
