require 'builder'
require 'databasedotcom'

#***********************************************
#*********** VARIABLES DE CONFIGURACION ********
@client_id = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
@client_secret = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
@username = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
@password = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
#************************************************


puts "Generando package.xml"
puts "======================"


@metadata_type = []

def get_metadata_types
	File.open("metadata.txt").each_line do |l|
		l.match("XMLName: (.*)")do |m|
			@metadata_type.push(m[1])
		end
	end	
	
	puts "Listado de Tipos de Metadatos de la ORG"
	puts @metadata_type
	puts ""
	
end

def get_folders
	$LOAD_PATH.each { |p|
		puts p
	}
	
	client = Databasedotcom::Client.new :client_id => @client_id, :client_secret => @client_secret
	client.ca_file = 'ca-bundle.cert'
	puts client.authenticate :username => @username, :password => @password
	
	folder = client.materialize('Folder')
	@folders_by_type = Hash.new
	
	folder.all.each{ |f|		
		#puts "#{f.DeveloperName}, #{f.Type}"
		unless @folders_by_type.has_key?(f.Type)
			@folders_by_type.store(f.Type, Array.new)
		end
		@folders_by_type.fetch(f.Type).push(f.DeveloperName)		
	}
	
	@folders_by_type.keys.each{ |tipo|
		puts "Folders del tipo #{tipo}"
		puts "-------------------------"
		@folders_by_type.fetch(tipo).each { |folder|
			puts folder
		}
		puts ""
	}
	
end


def generate_shell_script

	File.open("listMetadataScript.sh", "w") do |f|
		@metadata_type.each do |metadata|
			puts "Obteniendo metadatos del tipo: #{metadata}"
			if @folders_by_type.has_key?(metadata)
				puts "Metadato #{metadata} tiene folders"
				@folders_by_type.fetch(metadata).each do |folder|
					unless folder.to_s.empty?
						f.puts "ant listMetadataFolder -Dtipo=#{metadata} -Dfolder=#{folder}"
					end
				end
			else
				f.puts "ant listMetadata -Dtipo=#{metadata}"
			end
			
		end	
	end	
end


def generate_xml
	buffer = ""
	xml = Builder::XmlMarkup.new( :target => buffer, :indent => 4 )
	xml.instruct! 
	xml.Package("xmlns" => "http://soap.sforce.com/2006/04/metadata") do
		@metadata_type.each do |metadata|
			if File.exists?("listMetadata/#{metadata}.txt")
				xml.type do |node|
					File.open("listMetadata/#{metadata}.txt").each_line do |l|
						l.match("FullName\/Id: (.*)\/")do |m|
							node.members m[1]
						end
					end
					node.name metadata	
				end
			else
				puts "No existen metadatos para #{metadata}"
			end		
		end
		
		xml.version "23.0"
	end

	File.open("package.xml","w") do |f|
		f.puts buffer
	end
	
	
end

if ARGV[0] == "1"
	get_metadata_types
	get_folders	
	generate_shell_script
end

if ARGV[0] == "2"
	get_metadata_types
	generate_xml
end
