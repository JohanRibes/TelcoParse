#!/usr/bin/env ruby
# ####################################################################################
# ####################################################################################
# Version 0.1 
# https://github.com/claudijd/c7decrypt is hardcoded as a library but can be usde as a ruby gem.
# ####################################################################################
# ####################################################################################
# ####################################################################################




$:.unshift File.join(File.dirname(__FILE__), '..', 'lib') # Ajoute ./lib dans le PATH ruby
require 'optparse'
require 'ostruct'
require_relative 'lib/parse.rb'
require_relative 'lib/ios.rb'
require_relative 'lib/vrp.rb'
require_relative 'lib/seos.rb'
require_relative 'lib/timos.rb'
#require_relative 'lib/c7decrypt.rb'


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
	size=eqt[:conf].size
	#####################################################################
	#####################################################################
	
		
	end
	


	if options.type == "ios"
		
		eqt=Ios::Get.rancid(eqt)
		@conf_size=eqt[:conf].size
		@rancid_size=eqt[:rancid].size
		
		eqt=Ios::Get.section(eqt)
		eqt=Ios::Get.banners(eqt)
		eqt=Ios::Get.hostname(eqt)
		eqt=Ios::Get.domain_name(eqt)
		
		#puts C7Decrypt::Type7.decrypt("040202120E2D584B05")
		eqt=Ios::Get.interfaces_desc(eqt)
		
	end
	
	
	
	
	if options.type == "vrp"
		eqt=Vrp::Get.rancid(eqt)
		eqt=Vrp::Get.banners(eqt)
		eqt=Vrp::Get.section(eqt)
		eqt=Vrp::Get.hostname(eqt)
		eqt=Vrp::Get.domain_name(eqt)
		eqt=Vrp::Get.interfaces_desc(eqt)
	end
	
	 
	if options.type == "seos"
		eqt=Seos::Get.rancid(eqt)
		eqt=Seos::Get.section(eqt)
		eqt=Seos::Get.context(eqt)
		eqt=Seos::Get.banners(eqt)
		eqt=Seos::Get.hostname(eqt)
		eqt=Seos::Get.domain_name(eqt)
		eqt=Seos::Get.interfaces_desc(eqt)
	end
	
	if options.type == "timos"
		eqt=TimOs::Get.rancid(eqt)
		eqt=TimOs::Get.section(eqt)
		eqt=TimOs::Get.banners(eqt)
		eqt=TimOs::Get.hostname(eqt)
		eqt=TimOs::Get.interfaces_desc(eqt)
	end
	
### Color modes and functions
class String
	def black;          "\e[30m#{self}\e[0m" end
	def red;            "\e[31m#{self}\e[0m" end
	def green;          "\e[32m#{self}\e[0m" end
	def brown;          "\e[33m#{self}\e[0m" end
	def blue;           "\e[34m#{self}\e[0m" end
	def magenta;        "\e[35m#{self}\e[0m" end
	def cyan;           "\e[36m#{self}\e[0m" end
	def gray;           "\e[37m#{self}\e[0m" end

	def bg_black;       "\e[40m#{self}\e[0m" end
	def bg_red;         "\e[41m#{self}\e[0m" end
	def bg_green;       "\e[42m#{self}\e[0m" end
	def bg_brown;       "\e[43m#{self}\e[0m" end
	def bg_blue;        "\e[44m#{self}\e[0m" end
	def bg_magenta;     "\e[45m#{self}\e[0m" end
	def bg_cyan;        "\e[46m#{self}\e[0m" end
	def bg_gray;        "\e[47m#{self}\e[0m" end

	def bold;           "\e[1m#{self}\e[22m" end
	def italic;         "\e[3m#{self}\e[23m" end
	def underline;      "\e[4m#{self}\e[24m" end
	def blink;          "\e[5m#{self}\e[25m" end
	def reverse_color;  "\e[7m#{self}\e[27m" end
end
	
eqt[:hostname] ? host=eqt[:hostname][0] : host="JohnDoe" 
eqt[:"domain-name"] ? dom=eqt[:'domain-name'][0] : dom="NoConfiguredDomain" 

puts "**************************************************".center(150)
puts "**************************************************".center(150)
puts  "**    #{host}.#{dom}    **".center(150)
puts "**************************************************".center(150)
puts "**************************************************".center(150)
puts "Configuration has #{size} lines.".center(150)
puts "\n\n"
 
 

if eqt[:"banner_exec"] 
	eqt[:"banner_exec"].each {|v|
		v=~ /.*:.*/ ? (puts v) : nil		
	}
puts "\n\n"
end
	
eqt[:"interfaces-desc"] ? Parse::Print.interface_print(eqt[:"interfaces-desc" ]) : nil



