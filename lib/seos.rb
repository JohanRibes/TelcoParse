# ####################################################################################
# ####################################################################################
# 	Lib SEOS for redback EQTs													 	#
# ####################################################################################
# ####################################################################################

module Seos
	module Get
		def self.rancid(eqt)
			@eqt=eqt
			@eqt2={}
			@eqt2[:conf]=[]
			@eqt2[:rancid]=[]
			eqt[:conf].each_with_index{ |v, i|
				if v=~ /^!\w/
					@eqt2[:rancid] << v.delete("\n")
				else
					@eqt2[:conf] << v.delete("\n")
				end
			}		
		return @eqt2
		end
	
		def self.section(eqt)
			@eqt=eqt
			@eqt[:conf].each_with_index{ |v, i|
				if v=~ /^\w/ &&  @eqt[:conf][i-1]=~ /^!/ && @eqt[:conf][i+1]=~ /^\s\w/
					w=v.delete("\n").strip
					@eqt[:"#{w}"]=[]
					@j=i+1
					@eqt[:conf][i]=nil
					while (@eqt[:conf][@j]=~ /^\s/)
						eqt[:"#{w}"] << @eqt[:conf][@j].delete("\n")
						@eqt[:conf][@j]=nil
						@j += 1	
					end 
				end
			}
		@eqt[:conf].compact!
		return @eqt
		end
		
		def self.context(eqt)
			@eqt=eqt
			@eqt[:conf].each_with_index{ |v, i|
				if v=~ /^context/ &&  (@eqt[:conf][i-1]=~ /^!/ || @eqt[:conf][i-1]==nil) 
					w=v.delete("\n").strip
					@eqt[:"#{w}"]=[]
					@j=i+1
					@eqt[:conf][i]=nil
					while (@eqt[:conf][@j]=~/^(!|\s)/ )
						@eqt[:"#{w}"] << @eqt[:conf][@j].delete("\n")
						#puts @eqt[:conf][@j]
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
