require 'capybara/dsl'
require 'spreadsheet'

Capybara.run_server = false
Capybara.default_driver = :selenium
Capybara.default_selector = :xpath

class Rakuten
	include Capybara::DSL

	def go                                                   
		book = Spreadsheet::Workbook.new
		sheet = book.create_worksheet
		red = 0
		paginatori = ["http://global.rakuten.com/en/search/?f=2&k=&p=2&sid=crouka",
					        "http://global.rakuten.com/en/search/?f=2&k=&p=3&sid=crouka"]
		paginatori.each do |pag|
			visit pag 


			ime_linka = []
			all(:xpath, '//div[@class="b-content b-fix-2lines"]/a').each do |link|         
				ime_linka << link[:href]                                                   
			end

			ime_linka[0..2].each do |link|
				visit link

			 	if page.has_selector?(:xpath, '//*[@itemprop="name"]')
					sheet[red,0] = find(:xpath, '//*[@itemprop="name"]').text
				end
				if page.has_selector?(:xpath, '//*[@itemprop="price"]')
					sheet[red,1] = find(:xpath, '//*[@itemprop="price"]').text
			  end
				if page.has_selector?(:xpath, '//*[@class="b-product-label b-color-safe"]/div')
					sheet[red,2] = find(:xpath, '//*[@class="b-product-label b-color-safe"]/div').text
				end
				if page.has_selector?(:xpath, '//*[@class="b-container-child b-form-horizontal"]/div[1]/div/ul')  
					sheet[red,3] = find(:xpath, '//*[@class="b-container-child b-form-horizontal"]/div[1]/div/ul').text
				end
				if page.has_selector?(:xpath, '//*[@class="b-container-child b-form-horizontal"]/div[2]/div/ul')  
					sheet[red,4] = find(:xpath, '//*[@class="b-container-child b-form-horizontal"]/div[2]/div/ul').text
				end
				if page.has_selector?(:xpath, '//span[@class="country"]')
					sheet[red,5] = find(:xpath, '//span[@class="country"]').text
				end 
				if page.has_selector?(:xpath, '//span[@class="fabric"]')
					sheet[red,6] = find(:xpath, '//span[@class="fabric"]').text
				end
				if page.has_selector?('//*[@id="main_image"]')
					url_slike = find('//*[@id="main_image"]')[:src]
						open(url_slike) do |f|
		  				File.open(url_slike,"wb") do |file|
			     			file.puts f.read
			  			end
						end
				end


				red += 1
			end
		end
		book.write "rak.xls"
	end

	def test
		stranice = ["http://global.rakuten.com/en/store/crouka/item/250672/",
								"http://global.rakuten.com/en/store/crouka/item/the_smock_shop_ss_8157_pl/"]
		brojac = 1						
		stranice.each do |stranica|
			visit stranica

			if page.has_selector?('//*[@class="b-main-image"]/a')
				url_slike = find('//*[@class="b-main-image"]/a')[:href]
				open(url_slike) do |f|
	  			File.open("test#{brojac}.jpg","wb") do |file|
		     		file.puts f.read
		  		end
				end
			end	

			brojac += 1	
		end


	end 
end
a = Rakuten.new
a.test