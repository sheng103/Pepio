namespace :bulk do
  
  task :import_data => :environment do
    file_path = ENV["path"]
    unzip_user(file_path)
    read_xlsx
    import_photos
  end

  def unzip_user(file_path)    
    zip_file_path = file_path
    if File.exists?( zip_file_path ) == false
      puts "Zip file #{zip_file_path} does not exist!"
      return
    end
  
    to_folder_name = Time.now.to_formatted_s(:number)
    to_folder_root_path = "Users"
    
    if File.exists?( to_folder_root_path ) == false
      FileUtils.mkdir( to_folder_root_path )
    end
    
    @to_folder_path = "#{to_folder_root_path}/#{to_folder_name}"
    if File.exists?( @to_folder_path ) == false
      FileUtils.mkdir( @to_folder_path )
    end
  
    zip_file = Zip::ZipFile.open( zip_file_path )
    Zip::ZipFile.foreach( zip_file_path ) do | entry |
      file_path = File.join( @to_folder_path, entry.to_s )
      if File.exists?( file_path )
        FileUtils.rm( file_path )
      end
    
      zip_file.extract( entry, file_path )
    end   
  end
  
  desc "read .xlsx file from unziped directory"
  def read_xlsx
    url = File.join(@to_folder_path, "users.xlsx")
 #   url="/home/ddd/Downloads/users/users.xlsx"
    s = SimpleSpreadsheet::Workbook.read(url)
    ((s.first_row)+1).upto(s.last_row) do |line|
      surname =     s.cell(line, 1, 1)
      first_name =  s.cell(line, 2, 1)
      second_name = s.cell(line, 3, 1)
      gender =      s.cell(line, 4, 1)
      phone =       s.cell(line, 5, 1)
      region =      s.cell(line, 6, 1)
      village =     s.cell(line, 7, 1)
      group =       s.cell(line, 8, 1)
      country_code =s.cell(line, 9, 1)
      company =     s.cell(line, 10, 1)
      voter_id =    s.cell(line, 11, 1)
      shopkeeper =  s.cell(line, 12, 1)
      language =    s.cell(line, 13, 1)
      role =        s.cell(line, 14, 1)  
   #   password =        s.cell(line, 15, 1)
      
      password = "password"
   #   country = Country.where(:code => country_code)
      country = Country.new(name: "USA", code: "US")
      role = Role.new(name: role, code: "00")  
   #  role = Role.where(:name => role)   
      email_address = "admin@gmail.com"
      
      user = User.new(:email_address => email_address, :surname => surname, :first_name => first_name, :second_name => second_name, :language => language, 
                  :village => village, :voter_id => voter_id, :gender => gender, :shopkepper => shopkeeper,
                   :country => country,:password => password, :role => role)
      user.save!
      puts User.last.surname
      user_id = User.last.id.to_i
      userPhone = UserPhone.new(:user_id => user_id, :phone_number => phone)
      userPhone.save!
    end
    
  end
  
  desc "bulk import user photos"
  def import_photos
    pics_dir = File.join( @to_folder_path, "users" )
  #  pics_dir = "/home/ddd/Downloads/users/users/"
    Dir.glob(File.join(pics_dir,'*')).each do |pic_path|
      if File.basename(pic_path)[0]!= '.' and !File.directory? pic_path
        puts pic_path
        phone_number = File.basename(pic_path, '.*').to_i 
        puts phone_number
        userPhone = UserPhone.where("phone_number like '%#{phone_number}%'")
        unless userPhone.empty?
          puts "saving"
          user_id = userPhone.first[:user_id]
          user = User.find(user_id)
          
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

end
