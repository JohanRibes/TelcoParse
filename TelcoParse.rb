#!/usr/bin/env ruby
# ####################################################################################
# ####################################################################################
# Version 0.1 
# https://github.com/claudijd/c7decrypt is hardcoded as a library but can be usde as a ruby gem.
# ####################################################################################
# ####################################################################################
# ####################################################################################
#require 'optparse'		Will be used for CLI interface later
#require 'ostruct'		Will be used for hash  constrution later.	



$:.unshift File.join(File.dirname(__FILE__), '..', 'lib') # Ajoute ./lib dans le PATH ruby
require 'optparse'
require 'ostruct'
require_relative 'lib/ios.rb'
require_relative 'lib/vrp.rb'
require_relative 'lib/seos.rb'
require_relative 'lib/timos.rb'
require_relative 'lib/c7decrypt.rb'


options = OpenStruct.new
file=nil
options.type= nil


opt_parser = OptionParser.new do |opts|
	opts.banner = "Usage: TelcoParse file_to_parse [options]\n"
	opts.on("-t", "--type [STRING]", "A single string describing the configuration type (ex: \"Cisco IOS\")") do |v|
		options.type = v
	 end
	opts.on_tail("-h", "--help", "Show this message") do
		print "\n#{opts}\n"
		exit
	 end
end

opt_parser.parse!
file=ARGV[0]

if file.nil?
	print "Err => Missing \"file_to_parse\" arg.\n\n#{opt_parser}\n\n"
	exit
	elsif !File.exists?(file)
		print "Err => \"#{file}\" does not exist.\n\n#{opt_parser}\n\n"
		exit

	# Type will be mandatory for the moment,
	# but will be optionnal by rancid or config analysis.
	elsif options.type.nil?
		print "Err => Type is missing.\n\n#{opt_parser}\n\n"
		exit
	else
		# ..:: MOTD ::..
		system 'clear'
		puts "**************************************************************"
		puts "Simple TelcoParser."
		puts "**************************************************************"
		puts "I'm Going to parse #{file} as an  \"#{options.type.downcase}\" structure."
	
	
	eqt={}	
		
	#####################################################################
	#####################################################################
	# File import and hash returning
	def import(file)
		@eqt={}
		@eqt[:conf] = IO.readlines(file)
		return @eqt
	end

	eqt= import(file) 
	puts "Tableau config: #{eqt[:conf].size}"
	#####################################################################
	#####################################################################
	
		
	end
	


	if options.type == "ios"
	
		eqt=Ios::Get.rancid(eqt)
		
		puts "Tableau rancid: #{eqt[:rancid].size}"
		puts "Tableau config: #{eqt[:conf].size}"
		
		
		
		eqt=Ios::Get.section(eqt)
		#puts eqt.keys
		#puts "Tableau config: #{eqt[:conf].size}"

		
		
		#puts "Tableau config: #{eqt[:conf].size}"
		eqt=Ios::Get.banners(eqt)
		#puts eqt[:conf]
		puts eqt[:banner_exec]
		puts eqt[:banner_motd]
		puts eqt[:banner_login]
		#puts eqt[:"interface GigabitEthernet0/1"]
		#puts "INT: #{eqt[:"interface GigabitEthernet0/1"]}"	
		
		puts C7Decrypt::Type7.decrypt("040202120E2D584B05")
			
	end
	
	
	
	
	if options.type == "vrp"
	# Les banners sont dans le :rancid
		eqt=Vrp::Get.rancid(eqt)
		puts "Tableau config: #{eqt[:conf].size}"
		puts "Tableau rancid: #{eqt[:rancid].size}"
		
		#puts eqt[:rancid]
		#puts "Tableau config: #{eqt[:conf].size}"
		#puts "Tableau rancid: #{eqt[:rancid].size}"
		puts "Tableau config: #{eqt[:conf].size}"
		eqt=Vrp::Get.banners(eqt)
		
	
		#puts "Tableau config: #{eqt[:conf].size}"
		#puts eqt[:"G2R      : 693348"]
		#puts eqt[:banner_login]
		eqt=Vrp::Get.section(eqt)
		puts eqt.keys
		
	
	

	
	end
	
	 
	if options.type == "seos"
		eqt=Seos::Get.rancid(eqt)
		#puts "Tableau config: #{eqt[:conf].size}"
		#puts "Tableau rancid: #{eqt[:rancid].size}"
		eqt=Seos::Get.section(eqt)
		#puts eqt.keys
		#puts eqt[:"port ethernet 14/5"]
		#puts "Tableau config: #{eqt[:conf].size}"
		eqt=Seos::Get.context(eqt)
		#puts eqt.keys
		puts "Tableau config: #{eqt[:conf].size}"
		#puts eqt[:"context local"]
		#puts "Context local: #{eqt[:"context local"].size}"
		#puts "Context L2TP: #{eqt[:"rancid"]}"
		eqt=Seos::Get.banners(eqt)
		puts "Tableau config: #{eqt[:conf].size}"
		puts eqt.keys
		puts eqt[:banner_exec]
		puts eqt[:banner_login]
		
	
	end
	
	if options.type == "timos"
		puts "Tableau config: #{eqt[:conf].size}"
		eqt=TimOs::Get.rancid(eqt)
		puts "Tableau config: #{eqt[:conf].size}"
		puts "Tableau rancid: #{eqt[:rancid].size}"
		eqt=TimOs::Get.section(eqt)
		puts eqt.keys
		puts "Tableau config: #{eqt[:conf].size}"
		puts "Tableau SYS: #{eqt[:system].size}"
		eqt=TimOs::Get.banners(eqt)
		puts "Tableau SYS: #{eqt[:system].size}"
		puts eqt[:banner_exec]
	end
	
	




