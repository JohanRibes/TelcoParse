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
				
		def self.banners(eqt)
				@eqt=eqt
				@eqt[:conf].each_with_index { |v, i|			
					if v.strip=~/banner\s/
						case v.split(" ")[1] 		#Sometimes indented, sometimes not.
						
						when /exec/
							@j=i+1
							puts "Banner EXEC #{i}: #{v.split(" ")[2]}"
							@a="#{Regexp.escape(v.split(" ")[2][0..1])}"
							@eqt[:banner_exec] = []
							while @eqt[:conf][@j] !~ /#{@a}/
									@eqt[:banner_exec] << @eqt[:conf][@j].delete("\n")
									@j+=1
							end		
							if @eqt[:conf][@j].split(@a)[0][0..1] != @a[1..2] 
								@eqt[:exec] << @eqt[:conf][@j].split(@a)[0].delete("\n") 
							end
							@eqt[:conf][i..@j-1]=nil
						
						when /login/
							@j=i+1
							puts "Banner LOGIN #{i}: #{v.split(" ")[2]}"
							@a="#{Regexp.escape(v.split(" ")[2][0..1])}"
							@eqt[:banner_login] = []
							while @eqt[:conf][@j] !~ /#{@a}/
									@eqt[:banner_login] << @eqt[:conf][@j].delete("\n")
									@j+=1
							end		
							if @eqt[:conf][@j].split(@a)[0][0..1] != @a[1..2] 
								@eqt[:login] << @eqt[:conf][@j].split(@a)[0].delete("\n") 
							end
							@eqt[:conf][i..@j-1]=nil
						end
					end
				}
			@eqt[:conf].compact!
			return @eqt			
			end		
	
	end
end
