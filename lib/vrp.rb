# ####################################################################################
# ####################################################################################
# Lib VRP for Huawei eqt															 #
# ####################################################################################
# ####################################################################################





module Vrp
	module Get
	
		def self.rancid(eqt)
			@eqt=eqt
			@eqt2={}
			@eqt2[:conf]=[]
			@eqt2[:rancid]=[]
			eqt[:conf].each_with_index{ |v, i|
				if v=~ /^!/
					@eqt2[:rancid] << v.delete("\n")
				else
					@eqt2[:conf] << v.delete("\n")
				end
			}		
		return @eqt2
		end
		
		def self.section(eqt)
				@eqt, lines =eqt, [] 
				@eqt[:conf].each_with_index{ |v, i|
					if v=~ /^\w/ && v!= /#/
						w=v.delete("\n")
						#puts "#{i}: Section: " + w
						@eqt[:"#{w}"]=[]
						@j=i+1
						@eqt[:conf][i]=nil
						while (@eqt[:conf][@j]=~ /^\s/)
							@eqt[:"#{w}"] << @eqt[:conf][@j].delete("\n")
							#puts "#{@j}:" + @eqt[:conf][@j]
							@eqt[:conf][@j]=nil
							@j += 1
						end 
					end
				}	
				@eqt[:conf].compact!
				return @eqt	
		end
		
	end
end