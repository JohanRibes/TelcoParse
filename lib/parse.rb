module Parse
	module Print

		def self.interface_print(interfaces_desc)
			puts "#{interfaces_desc.size} Interfaces:"
			customer_count=0
			interfaces_desc.each {|v|
				if v.split("~")[1] != nil 
					 desc,customer = Detect.desc_mod(v.split("~")[1])					# 0 = text, 1 = customer or not
				else 
					desc="" 
					customer=false 																																			
				end
				puts "["+(v.split("~")[2]=="true" ? " " : "X".green.bold)+"] "+v.split("~")[0]+(v.split("~")[1]==nil ? " ": desc).rjust(150-v.split("~")[0].size+desc.size-desc.gsub(/\e\[(\d+)m/, '').size)
				if customer==true && v.split("~")[2]=="false"
					 customer_count=customer_count+1
				end
			}
			customer2="Customers: ".concat(customer_count.to_s.red.bold)
			puts customer2.rjust(172)
		end
	end

	module Detect
		def self.desc_mod(desc)
			customer=["customer","cpe"]
			customer_count=false
			customer.each {|w|
				if desc =~ /.*#{w}.*/ 
					desc=(desc.split(w)[0]!=nil ? desc.split(w)[0]:"")+w.green+(desc.split(w)[1]!=nil ? desc.split(w)[1]:"") 
					customer_count=true
				end
			}
			return desc, customer_count
		end
	end

end
