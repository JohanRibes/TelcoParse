# ####################################################################################
# ####################################################################################
# Lib IOS first version																 #
# ####################################################################################
# ####################################################################################

module Ios
	module Get
  	 			
		def self.rancid(eqt)
			# Récupération du contenu généré par Rancid.
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
				if v=~ /^(vlan [0-9]|interface|line con|ip access-list)/ &&  @eqt[:conf][i-1]=~ /^!/
					w=v.delete("\n")
					@eqt[:"#{w}"]=[]
					@j=i+1
					@eqt[:conf][i]=nil
					while (@eqt[:conf][@j]=~ /^\s/)
						@eqt[:"#{w}"] << @eqt[:conf][@j].delete("\n")
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
			@eqt[:conf].each_with_index{ |v, i|			
				if v.start_with?("banner ")
					case v.split(" ")[1]
					
					when /motd/
						@j=i+1
						#puts "Banner MOTD #{i}: #{v.split(" ")[2]}"
						@a="#{Regexp.escape(v.split(" ")[2][0..1])}"
						@eqt[:banner_motd] = []
						while @eqt[:conf][@j] !~ /#{@a}/
								@eqt[:banner_motd] << @eqt[:conf][@j].delete("\n")
								@j+=1
						end		
						if @eqt[:conf][@j].split(@a)[0][0..1] != @a[1..2] 
							@eqt[:login] << @eqt[:conf][@j].split(@a)[0].delete("\n") 
						end
						@eqt[:conf][i..@j-1]=nil
					
					when /login/
						@j=i+1
						#puts "Banner LOGIN #{i}: #{v.split(" ")[2]}"
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
						
					when /exec/
						@j=i+1
						#puts "Banner EXEC #{i}: #{v.split(" ")[2]}"
						@a="#{Regexp.escape(v.split(" ")[2][0..1])}"
						@eqt[:banner_exec] = []
						while @eqt[:conf][@j] !~ /#{@a}/
								@eqt[:banner_exec] << @eqt[:conf][@j].delete("\n")
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



