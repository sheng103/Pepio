#require 'paperclip'
#require File.expand_path('app/models/user.rb')
 
  task :read_xsl => :environment do
    require "simple-spreadsheet"
    url="/home/ddd/Downloads/users/users.xlsx"
    s = SimpleSpreadsheet::Workbook.read(url)
    puts s.cell(2,2,1)
 #   ((s.first_row)+1).upto(s.last_row) do |line|
    line = 2
    
      surname =     s.cell(line, 1, 1)
      first_name =  s.cell(line, 2, 1)
      second_name = s.cell(line, 3, 1)
      gender =      s.cell(line, 4, 1)
      phone =       s.cell(line, 5, 1)
      region =      s.cell(line, 6, 1)
      village =     s.cell(line, 7, 1)
      group =       s.cell(line, 8, 1)
      country =     s.cell(line, 9, 1)
      company =     s.cell(line, 10, 1)
      voter_id =    s.cell(line, 11, 1)
      shopkeeper =  s.cell(line, 12, 1)
      language =    s.cell(line, 13, 1)
      role =        s.cell(line, 14, 1)  
      User.create(:surname => surname, :first_name => first_name, :second_name => second_name, :language => language, 
                  :village => village, :voter_id => voter_id, :gender => gender, :shopkepper => shopkeeper)
   #   user_id = User.last.id.to_i
   #   UserPhone.new(:user_id => user_id, :phone_number => phone)
      
  #  end
    
  end
  