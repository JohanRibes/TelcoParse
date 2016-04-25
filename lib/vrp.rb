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
					if v=~ /^\w/ && v!= /#/ &&
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
		
		
		def self.banners(eqt)
			@eqt=eqt
			@eqt[:conf].each_with_index{ |v, i|			
				if v =~ /^\sheader/
				#puts "#{i}: #{v}"
					case v.split(" ")[1]
					
					when /shell/
						@eqt[:conf][i]=nil
						@j=i+1
						#puts "###Banner EXEC #{i}: #{v.split(" ")[2]}"
						@a="#{Regexp.escape(v.split(" ")[2][0..1])}"
						#puts "###Delimiteur :"+ @a
						if  v.count(@a)==2 # if banner on one line
							@eqt[:banner_exec] << v.split(@a)[1].strip!
							@eqt[:conf][@j]=nil
						else
							@eqt[:banner_exec] = []
							while @eqt[:conf][@j] !~ /#{@a}$/
									@eqt[:banner_exec] << @eqt[:conf][@j].delete("\n")
									#puts @eqt[:conf][@j].delete("\n")
									@eqt[:conf][@j]=nil
									@j+=1
							end
							if @eqt[:conf][@j].delete("\n")!=@a
								@eqt[:banner_exec] << @eqt[:conf][@j].delete("\n").split(@a)[0]
								@eqt[:conf][@j]=nil
							end
													
						end
					
					when /login/
					@eqt[:conf][i]=nil
						@j=i+1
						#puts "###Banner LOGIN #{i}: #{v.split(" ")[2]}"
						@a="#{Regexp.escape(v.split(" ")[2][0..1])}"
						#puts "###Delimiteur :"+ @a
						if  v.count(@a)==2
							@eqt[:banner_login] << v.split(@a)[1].strip!
							@eqt[:conf][@j]=nil
						else
							@eqt[:banner_login] = []
							while @eqt[:conf][@j] !~ /#{@a}$/
									@eqt[:banner_login] << @eqt[:conf][@j].delete("\n")
									#puts @eqt[:conf][@j].delete("\n")
									@eqt[:conf][@j]=nil
									@j+=1
							end
							if @eqt[:conf][@j].delete("\n")!=@a
								@eqt[:banner_login] << @eqt[:conf][@j].delete("\n").split(@a)[0]
								@eqt[:conf][@j]=nil
							end
													
						end	
					
					
					end
					
				end
			}
		@eqt[:conf].compact!
		return @eqt			
		end	
		
		
		def self.hostname(eqt)
			@eqt=eqt
			@eqt[:conf].each_with_index{ |v, i|
				if v=~ /^\ssysname/
					@eqt[:hostname]=[]
					@eqt[:hostname] << v.split(" ")[1]
					@eqt[:conf][i]=nil
				end
			}
		@eqt[:conf].compact!
		return @eqt
		end
		
		def self.domain_name(eqt)
			@eqt=eqt
			@eqt[:conf].each_with_index{ |v, i|
				if v=~ /^\sdns domain/
					@eqt[:"domain-name"]=[]
					@eqt[:"domain-name"] << v.split(" ")[2]
					@eqt[:conf][i]=nil
				end
			}
		@eqt[:conf].compact!
		return @eqt
		end
		
		
	
		
		def self.interfaces_desc(eqt)
			@eqt=eqt
			@eqt[:"interfaces-desc"]=[]
			@eqt.each_key {|key| 
				if key=~/^interface/ 
					@if=key.to_s.split("interface ")[1]
					@eqt[key].each_with_index{ |v|
						if v=~/^\sdescription\s/ then @desc=v.split("description ")[1] else nil end
					}
					@eqt[:"interfaces-desc"]<< [ @if, @desc ].join('~')
				end
			}
		@eqt[:"interfaces-desc"].pop
		return @eqt
		end
		
	end
end