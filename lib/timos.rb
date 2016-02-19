# ####################################################################################
# ####################################################################################
# Lib IOS first version																 #
# ####################################################################################
# ####################################################################################

module TimOs
	module Get
	
		def self.rancid(eqt)
				@eqt=eqt
				@eqt2={}
				@eqt2[:conf]=[]
				@eqt2[:rancid]=[]
				eqt[:conf].each_with_index{ |v, i|
					if v=~ /^#\w/
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
				if v=~/^\s\s\s\s(?!exit)\w/
				#if v=~/^\s\s\s\s\w/
					w=v.delete("\n").strip
					if (@eqt[:"#{w}"].nil?) then @eqt[:"#{w}"]=[] end
					@j=i+1
					@eqt[:conf][i]=nil
					while (@eqt[:conf][@j]!~ /^\s\s\s\sexit/)
						@eqt[:"#{w}"] << @eqt[:conf][@j].delete("\n")
						#puts eqt[:conf][@j]
						@eqt[:conf][@j]=nil
						@j += 1
					end 
				end
			}
		@eqt[:conf].compact!
		return @eqt
		end
		
		def self.banners(eqt)
			@eqt=eqt
			@eqt[:system].each_with_index{ |v, i|			
				case v
					when /\s{8}pre-login-message \"/
						@eqt[:system][i]=nil
						@j=i+1
						@eqt[:banner_login]=[]
						while(@eqt[:system][@j]!~/.*\"$/)
							@eqt[:banner_login] << @eqt[:system][@j].delete("\n")
							@eqt[:system][@j]=nil
							@j+=1
						end
						if @eqt[:system][@j]=~/.*\"$/ 
							@eqt[:banner_login] << @eqt[:system][@j].delete("\"\n") 
							@eqt[:system][@j]=nil
						end
						
					when /\s{8}motd text \"/
						@eqt[:system][i]=nil
						@j=i+1
						@eqt[:banner_exec]=[]
						while(@eqt[:system][@j]!~/.*\"$/)
							@eqt[:banner_exec] << @eqt[:system][@j].delete("\n")
							@eqt[:system][@j]=nil
							@j+=1
						end
						if @eqt[:system][@j]=~/.*\"$/ 
						@eqt[:banner_exec] << @eqt[:system][@j].delete("\"\n")
						@eqt[:system][@j]=nil
						end
									
				end
			}
		@eqt[:system].compact!
		return @eqt			
		end	
	
	
	
	end
end