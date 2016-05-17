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
		
		
		def self.hostname(eqt) # No domain information ??
			@eqt=eqt
			@eqt[:system].each_with_index{ |v, i|
				#puts v.strip!
				@vbis=v.strip!
				if @vbis =~ /^name/
					@eqt[:hostname]=[]
					@eqt[:hostname] << @vbis.split(" ")[1]
					@eqt[:system][i]=nil
				end
			}
		@eqt[:system].compact!
		return @eqt
		end
	
		def self.interfaces_desc(eqt)
			@eqt=eqt
			@eqt[:"interfaces-desc"]=[]
			@eqt.each_key {|key| 
				if key=~/^port/ 
					@if="port "+key.to_s.split("port ")[1]
					@eqt[key].each_with_index{ |v|
						if v=~/^\s*description\s/ then @desc=v.split("description ")[1] else nil end
						v=~/^\s*shutdown/ ?  @shut=true : (v=~/^\s*no shutdown/ ? @shut=false : nil)
					}
					@eqt[:"interfaces-desc"]<< [ @if, @desc, @shut ].join('~')
				end
				
				if key=~/^lag/ 
					@if="lag "+key.to_s.split("lag ")[1]
					@eqt[key].each_with_index{ |v|
						v=~/^\s*description\s/ ? @desc=v.split("description ")[1] : nil 
						v=~/^\s*shutdown/ ?  @shut=true : (v=~/^\s*no shutdown/ ? @shut=false : nil)
					}
					@eqt[:"interfaces-desc"]<< [ @if, @desc, @shut ].join('~')
					@shut=nil
					@desc=nil
				end
				@shut=nil
			}
		return @eqt
		end
	
	
	end
end