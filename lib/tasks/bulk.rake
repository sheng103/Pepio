namespace :bulk do

  desc "bulk import user photos"
  task :import_pics => :environment do

pics_dir = "/home/realp/Sm-Money/bulk_upload/"
Dir.glob(File.join(pics_dir,'*')).each do |pic_path|
  if File.basename(pic_path)[0]!= '.' and !File.directory? pic_path

    user_code = File.basename(pic_path, '.*') 
    user = User.find(user_code) #you could use the ids, too
    print "could not find user for user_code #{user_code}" if user.nil?


    File.open(pic_path) do |f|
    print pic_path + "\n"
    print user.surname + "\n"
     user.avatar = f # just assign the pic attribute to a file
     user.save!
    end 
  end
end


  end

end
